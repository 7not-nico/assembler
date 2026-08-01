# WRITE.SCRIPT.RUBY — write Ruby scripts after studying official reference

Scripts in `script/` use Ruby for testing, validation, and programmatic analysis of Go calculator variants.

## Procedure

1. Study the official reference first — Go Spec for behavior, Ruby docs for test logic
2. Write reference knowledge into `reference/ruby-refs/` when Ruby-specific semantics are needed
3. Write the Ruby script using functional style
4. Run with `ruby script/<name>.rb`
5. Exit 0 = all pass, non-zero = failure

## Conventions

- One script per testing concern
- Positive tests use random operands with deterministic seed
- Error tests use static inputs
- Expected values computed in Ruby, compared with float64 tolerance
- Print failures to stdout with variant name and expected/actual

## Testing axioms

- All positive-path tests use randomized operands (per TEST.CALCULATOR.VARIANT)
- Division by zero and exit tests are static (test specific conditions)
- Count and report both passed and failed
- Always randomize seed with `Time.now.to_i`

## Reference knowledge

Ruby-specific reference knowledge (regex patterns, IO patterns, process spawning) goes in `reference/ruby-refs/`. Generic Ruby language knowledge uses `code-semantics` knowledge-ruby skill.

## Composes with

- TEST.CALCULATOR.VARIANT — testing axes per variant
- STUDY.SOURCE.BEFORE.CODE — study before writing
- SOURCE.DOCS.PLAYWRIGHT — source Ruby docs when needed
- REFERENCE.ATOMIC.SOURCE — reference files are atomic
