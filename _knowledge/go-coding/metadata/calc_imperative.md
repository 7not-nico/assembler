# calc_imperative.go — all comments

Total comments: 66

## Header

- L1: ── Variant: IMP ── subject ← action(subject, object) ────
- L2: 
- L3: Go semantic map:
- L4: subject: variable declared at function scope
- L5: var subject float64        — declaration: named storage location
- L6: GO.SUBJECT §Core definition: "A variable is a storage location"
- L7: subject = subject + object — assignment: write to mutable Subject
- L8: GO.ACTION §Assignment: "x = 42 — assignment: write to mutable Subject"
- L9: 
- L10: object: value parsed from input
- L11: GO.OBJECT: typed float64 quantity
- L12: 
- L13: action: assignment statement containing binary expression
- L14: GO.ACTION §Expressions: "An expression specifies the computation of
- L15: a value by applying operators and functions to operands."
- L16: GO.ACTION §Statements: "Assignment" — writes expression value to Subject
- L17: 
- L18: Combined:  subject = subject + object
- L19: ├─ assignment statement ─┤
- L20: │         └─ expression ─┘
- L21: │ writes to Subject    computes new Object
- L22: 
- L23: operator table: map of operator → function (GO.ACTION: function value)
- L24: ops["+"] = func(a, b float64) float64 { return a + b }
- L25: GO.OBJECT: functions are first-class values in Go
- L26: GO.ACTION: call expression ops[op](subject, object)
- L27: 
- L28: Flow:
- L29: var subject float64             — GO.SUBJECT: zero-value allocation
- L30: subject = getInput("subject? ") — GO.ACTION: assignment (initial)
- L31: for {                            — GO.ACTION: for statement (iteration)
- L32: op = getOperator()            — operator selection
- L33: object = getInput("object? ") — GO.OBJECT: read value
- L34: if object == 0 { error }      — GO.ACTION: if statement (guard)
- L35: subject = ops[op](s, o)       — GO.ACTION: assignment + expression
- L36: print subject                 — GO.ACTION: call expression
- L37: }
- L38: 
- L39: Usage:
- L40: go run . imperative
- L41: ─────────────────────────────────────────────────────────
- L64: imperative — reads a float64 value from input.
- L65: GO.OBJECT: produces a typed float64 value from string input.

## Body

- L85: operator — reads operator symbol from input.
- L86: Returns a key into the ops table (GO.ACTION: selects expression kind).
- L104: runImperative — main loop: subject ← action(subject, object).
- L112: GO.SUBJECT: variable declaration — storage allocation
- L113: subject is a float64 variable, initialized to zero value 0.0
- L114: GO.SUBJECT: "A variable is a storage location for holding a value."
- L115: GO.OBJECT §Zero value: uninitialized float64 → 0.0
- L118: GO.ACTION: assignment statement — initial value into Subject
- L119: subject = value writes to the storage location
- L126: GO.ACTION: for statement — iteration controlling evaluation flow
- L133: GO.OBJECT: operand value from input
- L139: GO.ACTION: if statement — conditional guard on division
- L145: GO.ACTION: assignment statement with embedded expression
- L146: Right side:   ops[op](subject, object) — call expression
- L147: evaluates to a float64 value (GO.OBJECT)
- L148: Left side:    subject — storage location (GO.SUBJECT)
- L149: Effect:       expression value written to variable
- L150: 
- L151: GO.SPEC §Statements: "Assignment"
- L152: "The value of the expression is assigned to the variable"
- L153: 
- L154: This is Go's canonical action — the assignment statement
- L155: combines expression evaluation with storage mutation.