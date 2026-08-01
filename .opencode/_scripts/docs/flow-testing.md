# Testing — `spec/`

Tests live in `spec/` and use Ruby stdlib-only (no RSpec, no Minitest). Each spec file is self-contained: requires modules, runs checks, prints results, exits with failure count.

## Running tests

```bash
ruby spec/frontmatter_spec.rb    # _rb/frontmatter.rb
ruby spec/validate_spec.rb       # _rb/validate.rb
ruby spec/schema_db_spec.rb      # _rb/schema_db.rb
```

Or run all at once:
```bash
for f in spec/*.rb; do ruby "$f" && echo "--- $f pass ---" || echo "--- $f FAIL ---"; done
```

## Writing tests

Pattern:
```ruby
require_relative "../_rb/loader"
require_relative "../_rb/validate"

failures = 0

check = ->(desc, actual, expected) {
  if actual == expected
    puts "  ✓ #{desc}"
  else
    puts "  ✗ #{desc}: expected #{expected.inspect}, got #{actual.inspect}"
    failures += 1
  end
}

# test
check.call("description", actual_value, expected_value)

exit(failures)
```

## Existing tests

| File | Tests | Tests |
|------|-------|-------|
| `spec/frontmatter_spec.rb` | ParseFrontmatter, ParseBackmatter, ParseAll, NormalizeTags | 6 |
| `spec/validate_spec.rb` | CheckField (string, int, array, enum, pattern), CheckRequired | 16 |
| `spec/schema_db_spec.rb` | SeedDB, QueryFields, LogRun | 7 |

## What to test

1. **Pure modules** (`_rb/`) — test edge cases: nil input, empty input, type mismatches
2. **Audit scripts** — tested by running them against the actual entity files (no mocks)
