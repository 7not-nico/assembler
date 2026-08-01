# REFACTOR.INCREMENTAL.VERIFY — refactor one concern per phase, verify after each

Refactoring proceeds in phases. Each phase changes exactly one concern. After each phase, build and test before moving to the next.

## Procedure

1. Identify one refactoring concern (imports, switch replacement, map removal)
2. Write a single-purpose Ruby script in `script/phaseN-description.rb`
3. Run the script
4. Run `go build ./...` to verify compilation
5. Run `ruby script/test_calc.rb` to verify all variants pass
6. Only then proceed to the next phase

## Phase examples

```
phase1-fix-imports.rb     — batch-fix import blocks
phase2-refactor-switch.rb — replace inlined switches with calc.Apply()
phase3-refactor-sao.rb    — refactor SAO evaluate switch
phase4-refactor-stk.rb    — refactor STK operator switch
phase5-refactor-imperative.rb — remove ops map, use calc.Apply()
```

## Principles

- One concern per phase — do not mix import fixes with switch replacements
- Scripts are idempotent — safe to re-run if pattern not matched
- Verify after each phase — never batch multiple phases without verification
- If a pattern is not found, the script reports and exits cleanly — no corruption
- Manual refactoring is reserved for complex variants (method dispatch, channels, thunks, defer)

## Composes with

- STUDY.SOURCE.BEFORE.CODE — study before writing refactoring scripts
- WRITE.SCRIPT.RUBY — script conventions for Ruby refactoring tools
- FIX.FAILURE.BEFORE.PROCEED — fix test failures before next phase
