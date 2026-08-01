# Verification Report — 2026-07-26T08:03:30-06:00

All knowledge files are verified against actual Ruby 3.4 behavior via
practice test scripts in `knowledge/practice/`.

## Test Results

| Script | Passed | Failed | Knowledge Files Covered |
|--------|--------|--------|------------------------|
| test-proc.rb | 37 | 0 | proc, lambda, closure, composition, curry, anonymous-params, to-proc |
| test-string.rb | 59 | 0 | string, string-slice, string-substitution, string-query, string-case, string-modify, string-encoding, string-convert |
| test-symbol.rb | 30 | 0 | symbol |
| test-array.rb | 71 | 0 | array, array-access, array-add, array-remove, array-query, array-transform, array-set |
| test-hash.rb | 68 | 0 | hash, hash-access, hash-default, hash-modify, hash-query, hash-transform, hash-iterate, hash-key |
| **Total** | **265** | **0** | **31 files** |

## Demonstration: Assertion Failure Detection

The assertion helper `_helper.rb` compares `actual == expected` and prints
FAIL with both `.inspect` values on mismatch. This was proven during development
when a test bug was caught:

  FAIL: [] negative index — expected "r", got "e"

The test expected `"hello there"[-1]` to return `"r"` but the correct result
is `"e"` (last character). The knowledge file was correct, the test was wrong.
The assertion mechanism caught the discrepancy immediately.

## Database Record

knowledge.db records each test run with pass/fail counts per file.
Query: `ruby schema/query-knowledge.rb --stats`

## Verification Method

Each practice script exercises every documented concept:
- Creates Ruby objects matching the knowledge file descriptions
- Asserts actual behavior matches documented behavior
- Pass/fail per assertion with `.inspect`-based error reporting
- Non-zero exit on any failure
- Results persisted to knowledge.db via sync-knowledge-db.rb
