# Naming Audit — scan code against SPEC.CODE.ELEMENT.NAME

Audit Ruby and Rust code for naming convention violations per `reference/element-name.md`. Runs bootstrap scanner scripts against `fixtures/`, `script/`, and `bootstrap/` files.

## Triggers

- User asks to check naming conventions
- User asks to scan code for violations
- After writing `fixtures/` or `script/` code
- Pre-commit naming verification

## Workflow

1. **Select scanner** — subject determines scanner:
   - Ruby methods → `bootstrap/ruby-boot/check-method.pl` or `check-method-sao.pl`
   - Rust code → `bootstrap/rust-boot/scan-agentive.rb`, `scan-prohibitions.rb`, `scan-keywords.rb`, `scan-semantic.rb`, `scan-shadow.rb`, `scan-verbs.rb`
   - Mixed anchors → `bootstrap/mix-boot/scan-anchor.rb`

2. **Run scanner** — execute the perl or ruby scanner against target files:
   - `perl bootstrap/ruby-boot/check-method.pl`
   - `ruby bootstrap/rust-boot/scan-agentive.rb`

3. **Review violations** — each violation reports: `file:line: method name — description`
   - Verify each violation against `reference/element-name.md` rule definition
   - Exclude false positives by checking `reference/exception.md`

4. **Fix violations** — apply naming convention corrections per `reference/conventions.md`:
   - snake_case → camelCase
   - gerund (-ing) → agentive suffix (-er/-or)
   - derived noun (-tion, -ment) → agentive suffix
   - bare infinitive → add -er/-or
   - plural agentive → singular
   - article prefix → drop article
   - imperative verb-led → drop leading verb or restructure

5. **Rescan** — re-run scanner to confirm zero violations

## References

- `reference/element-name.md` — noun classes, agentive suffix rules, shadowing prevention
- `reference/conventions.md` — naming, structure, ring topology
- `bootstrap/ruby-boot/check-method.pl` — Ruby method scanner (SOA flow)
- `bootstrap/ruby-boot/check-method-sao.pl` — Ruby method scanner (SAO flow)
- `bootstrap/ruby-boot/verb.txt` — verb lexicon for name validation
- `bootstrap/ruby-boot/reserve.txt` — Ruby reserved keywords
- `bootstrap/rust-boot/` — Rust scanner scripts
- `reference/exception.md` — documented naming overrides
