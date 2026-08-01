# TEST.CALCULATOR.VARIANT — test each calculator variant along three semantic axes

Every calculator variant expresses Subject, Object, and Action in a specific arrangement. Testing must verify that all three roles behave correctly across positive, edge, and error conditions.

## Testing axes

### 1. Subject — the storage location
- Subject initializes to user-provided value
- Subject persists across consecutive operations (accumulator behavior)
- Subject resets on clear/exit

### 2. Object — the typed value
- Object accepts integer and float input
- Object rejects non-numeric input with error message
- Object zero value (0, 0.0) propagates correctly

### 3. Action — the expression evaluation
- All operators produce correct results: +, -, *, /, **
- Division by zero returns error, accumulator unchanged
- Unknown operator rejected with error message

## Randomization rule

All positive-path tests use random operands with a deterministic seed. No hardcoded values for arithmetic verification.

Procedure per variant:
1. Generate random operands (rand(1..100))
2. Compute expected result in Ruby using the same operator
3. Feed input to Go binary via pipe
4. Extract numeric result from Go output
5. Compare with tolerance (float64 may produce scientific notation for large numbers)
6. Repeat for ITER iterations (default 3, configurable via ITER env var)

Error-path tests and exit tests use static inputs (they test specific conditions, not arithmetic).

## Test procedure per variant

```
1. Positive path (randomized, ITER times):
   generate random a, op, b
   expected = apply(op, a, b)
   feed a, op, b → verify expected (with float64 tolerance)

2. Accumulation (randomized, ITER times):
   generate random a, op1, b, op2, c
   feed a, op1, b, op2, c → verify chain result

3. Error handling (static):
   feed / 0 → verify error, accumulator unchanged
   feed unknown operator → verify error message

4. Exit (static):
   feed q / exit / quit → verify clean termination
```

## Composes with

- The variant's own semantic map (documents which role is Subject, Object, Action)
- GO.SUBJECT, GO.OBJECT, GO.ACTION definitions in code-semantics/semantic/
- WRITE.SCRIPT.RUBY — script conventions for test implementation

Run all tests before declaring any variant complete. Exit 0 = all pass.
