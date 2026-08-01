-- schema/calc-refactor.sql
-- Maps the current code structure before programmatic refactoring.
-- Complies with MAP.CODE.SCHEMA.BEFORE.REFACTOR precept.

-- ── File inventory ──────────────────────────────────────

-- 9 Go files: 1 entry point + 1 condensed positional engine
--             + 8 structural variants + 2 shared packages
-- Total: 11 Go files

-- ── Architecture ────────────────────────────────────────

-- calc_perm.go   — one engine for all 6 positional variants
--                  orders map:  variant name → []Role (subject/object/action)
--                  prompts map: Role → prompt text
--                  runPositional(name) loops roles in declared order
--                  6 wrappers: runSOA..runOAS delegate to runPositional
-- calc_method.go  — subject.action(object) method dispatch
--                  Accumulator struct (SUBJECT), MethodDispatch (scan + methods map)
-- calc_imperative.go — subject ← action(subject, object)
--                  plain float64 subject, imperative()/operator() readers
-- calc_stk.go     — stack-based (Forth-style) RPN
--                  []float64 stack, operator acts on top two
-- calc_chn.go     — channel-based concurrent
--                  cmd struct (OBJECT), actions map, worker goroutine
-- calc_ifc.go     — subject → action → object (interface{})
--                  operand interface{} (OBJECT) at top, Subject struct (SUBJECT) after
--                  parseObject → int64/float64, type-switch dispatch
-- calc_dfr.go     — deferred evaluation (defer LIFO)
--                  step struct (OBJECT) at top, accumulator type (SUBJECT) after
-- calc_evl.go     — lazy evaluation (thunks)
--                  thunk type (OBJECT), thunkBin dispatch map, EVL struct (SUBJECT)
-- calc_map.go     — functional reduce
--                  calc.Reduce over objects list and ops list
-- main.go         — variants dispatch map (no switch) + help

-- ── Shared packages ─────────────────────────────────────

-- calc/core.go    — Operators table, Apply, Compose, ParseValue,
--                  Scan, Evaluate, Reduce, IsOperator (pure, no I/O)
-- lib/            — ReadValue, ReadOp, ReadLine, IsExit, StripZero (I/O shell)

-- ── Dispatch patterns ───────────────────────────────────

-- Pattern A: role-order engine
--   File: calc_perm.go
--   orders[name] → []Role; prompts[role] → string
--   for _, role := range order { read; validate; assign }
--   result = calc.Apply(op, subject, object)

-- Pattern B: method dispatch
--   File: calc_method.go
--   func (s Accumulator) add(object float64) (Accumulator, error)
--   methods map[string]func(Accumulator, float64) (Accumulator, error)

-- Pattern C: function map
--   File: calc_imperative.go (ops map removed — calc.Apply is the sole evaluator)
--   File: calc_chn.go (actions map: op symbol → accumulator update)

-- Pattern D: type switch + dispatch
--   File: calc_ifc.go
--   switch v := raw.(type) { case int64: ... case float64: ... }
--   subject = Subject{value: float64(v)}; result = calc.Apply(op, subject.value, object)

-- Pattern E: thunk combinators
--   File: calc_evl.go
--   thunkBin map[string]func(a, b thunk) thunk built from calc.Operators

-- Pattern F: defer closures (LIFO)
--   File: calc_dfr.go
--   defer func() { acc = calc.Apply(s.op, acc, s.val) }() per step

-- Pattern G: channel worker
--   File: calc_chn.go
--   for c := range input { actions[c.op](&acc, c.value) }

-- ── Build / test status ─────────────────────────────────

-- go build ./...             — clean
-- ruby script/test_calc.rb   — all 14 variants pass (seed-based, ITER default 3)
