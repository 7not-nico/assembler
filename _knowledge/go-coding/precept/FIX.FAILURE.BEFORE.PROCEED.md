# FIX.FAILURE.BEFORE.PROCEED — fix test failures before implementing new variants

When a test fails, the failure must be diagnosed and fixed before any new variant implementation begins.

## Procedure

1. Read the failure output — variant name, expected value, actual value, raw output
2. Diagnose the root cause (variant logic, test generator, or float64 tolerance)
3. Fix the root cause, not the symptom
4. Run the full test suite to confirm the fix
5. Only then proceed to the next variant

## Failure categories

```
logic error  — variant produces wrong result → fix variant code
test error   — test generator computes wrong expected → fix test
precision    — float64 tolerance mismatch → adjust match_float
order error  — defer LIFO / evaluation order reversed → fix execution order
```

## Composes with

- TEST.CALCULATOR.VARIANT — tests must pass before variant is complete
- STUDY.SOURCE.BEFORE.CODE — study spec to understand correct behavior
- WRITE.SCRIPT.RUBY — test scripts verify correctness
