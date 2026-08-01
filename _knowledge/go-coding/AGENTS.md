# go-coding — AGENTS.md

## Domain

Go calculator implementations exploring the Subject-Object-Action semantic triad across all 6 permutations and Go-native structural forms. Each variant annotates every operation with its GO.SUBJECT, GO.OBJECT, or GO.ACTION role, cross-referencing the Go Spec.

## Structure

```
calc/            — functional core (pure functions, no I/O)
lib/             — shared I/O utilities (imperative shell)
calc_*.go        — variant shells (one file per variant)
main.go          — variant selector + help
precept/         — rules for testing, scripting, doc sourcing
reference/       — Go Spec semantics sourced via Playwright
reference/spec/  — assembler specifications (naming, classification)
schema/          — code structure maps before refactoring
metadata/        — exported code comments (function docs, annotations)
script/          — Ruby test and refactoring scripts
docs/            — skill documentation
```

## Variants

```
6 positional permutations — one engine, orders map in calc_perm.go
SOA    subject → object → action                   calc_perm.go
SAO    subject → action → object (infix)            calc_perm.go
AOS    action → object → subject (Polish)           calc_perm.go
ASO    action → subject → object                    calc_perm.go
OSA    object → subject → action                    calc_perm.go
OAS    object → action → subject                    calc_perm.go

8 structural forms — one file per variant
MTH    subject.action(object) dispatch               calc_method.go
IMP    subject ← action(subject, object)             calc_imperative.go
STK    stack-based (Forth-style)                    calc_stk.go
CHN    channel-based concurrent                      calc_chn.go
IFC    subject → action → object (interface{})       calc_ifc.go
DFR    deferred evaluation (defer LIFO)              calc_dfr.go
EVL    lazy evaluation (thunks)                      calc_evl.go
MAP    functional reduce                             calc_map.go
```

## Refactoring status

```
calc.Apply() core:     all 14 variants delegate to calc.Apply
Condensed engine:      6 positional variants → calc_perm.go (orders/prompts maps, runPositional)
Struct-typed SUBJECT:  method (Accumulator), ifc (Subject)
Function maps:         imperative ops, chn actions, evl thunkBin, method dispatch
Type-switch dispatch:  ifc (operand interface{} → int64/float64)
```

## Refactored shells

8 variants stripped to pure I/O shells — no duplicate I/O logic. Each uses `lib.ReadValue`, `lib.ReadOp`, `lib.ReadLine`, `lib.IsExit`, `lib.StripZero`, and `calc.Apply`. The result is a clean file that clearly shows the Subject-Object-Action flow for that variant. Each structural variant declares its OBJECT semantics type at the top of the file, SUBJECT after (e.g. ifc: `operand interface{}` then `Subject struct`).

## Precepts (rules)

```
precept/TEST.CALCULATOR.VARIANT.md
precept/WRITE.SCRIPT.RUBY.md
precept/SOURCE.DOCS.PLAYWRIGHT.md
precept/STORE.REFERENCE.KNOWLEDGE.md
precept/STUDY.SOURCE.BEFORE.CODE.md
precept/FIX.FAILURE.BEFORE.PROCEED.md
precept/REFERENCE.ATOMIC.SOURCE.md
precept/BROWSE.AFTER.SEARCH.md
precept/REFACTOR.INCREMENTAL.VERIFY.md
precept/MAP.CODE.SCHEMA.BEFORE.REFACTOR.md
precept/SCRIPT.IGNORE.COMMENTS.md
precept/STORE.CODE.COMMENTS.METADATA.md
```

Load before writing or modifying any variant.

## Skills (docs)

```
docs/skill-compose-web.md
docs/skill-report-outcomes.md
docs/skill-use-playwright-core.md
docs/skill-knowledge-ruby.md
docs/skill-read-maxims-protocols.md
docs/skill-acquire-assets.md
docs/skill-declare-grounded-entity.md
```

Load on session start for workflow anchoring.

## Reference

```
reference/go-spec-semantics.md
```

Real Go Spec text sourced via Playwright from `https://go.dev/ref/spec`. Defines Subject (variable), Object (value), Action (statement + expression).

## Testing

```
ruby script/test_calc.rb
```

Randomized suite across all 14 variants (seed-based, ITER configurable, default 3). Exit 0 = all pass.

## Grounding

Semantic role definitions come from `code-semantics/semantic/Go-*.md`:
- GO.SUBJECT — variable as storage location
- GO.OBJECT — value as typed quantity
- GO.ACTION — statement and expression (evaluation, control flow, concurrency)
