# Functional Programming in Ruby

scripts/ implements a **functional core / imperative shell** architecture using Ruby lambdas, no classes, and no mutable shared state.

## Principles

- Every `_rb/` module exports only **pure lambdas** — deterministic, no I/O, no side effects.
- Every `r*.rb` script is an **imperative shell** — owns I/O (file reads, stdout), calls pure core.
- **No classes, no instances, no `def` methods** — only lambdas assigned to constants.
- **No mutable shared state** — all data flows through function arguments and return values.

## Lambda syntax

```
name = ->(args) { body }
name.call(args)
```

The `->` stabby lambda is the only function definition form used.

```ruby
NormalizeTags = ->(fm) {
  return fm unless fm
  fm[:tags] ||= []
  fm
}
```

## Composition pattern

Functions compose by calling other lambdas. Data flows forward through `.call` chains.

```ruby
ParseFrontmatter = ->(text) {
  m = text.match(/\A---\s*\n(.*?)\n---\s*\n/m)
  m ? NormalizeTags.call(SafeLoad.call(m[1])) : nil
}
```

Pipeline: `text → SafeLoad → NormalizeTags → hash`.

## Core module structure

Each `_rb/*.rb` file:

1. **Declares exports** in header comment: `# exports: ParseFrontmatter, ParseAll`
2. **Declares ring**: `# ring: 1 (PURE)`
3. **Declares dependencies**: `# depends-on: ./loader`
4. **Defines lambdas** as constants.
5. **No I/O** — no `puts`, `File.read`, `Dir`, `print`.

```ruby
# exports: Table, List
# ring: 1 (PURE)

Table = ->(rows, headers) {
  widths = headers.map.with_index { |h, i| [h.size, *rows.map { |r| r[i].to_s.size }].max }
  head = headers.map.with_index { |h, i| h.ljust(widths[i]) }.join(" | ")
  sep = widths.map { |w| "-" * w }.join("-|-")
  body = rows.map { |r| r.map.with_index { |v, i| v.to_s.ljust(widths[i]) }.join(" | ") }.join("\n")
  "#{head}\n#{sep}\n#{body}"
}
```

## Imperative shell pattern

Every `r*.rb` script:

1. **Requires** `_rb/` modules.
2. **Reads** data (filesystem).
3. **Calls** pure lambdas.
4. **Writes** output (stdout, files).

Only the shell has side effects. The core never reads or writes.

```ruby
#!/usr/bin/env ruby
# ring: 1 (PURE) — foundational data integrity

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"

# IO: read files
files = EntityTypes.flat_map { |t|
  Dir[EntityGlob.call(t)].map { |p| { type: t, path: Pathname.new(p), name: File.basename(p, ".md") } }
}
texts = files.map { |f| f[:path].read }

# Pure: parse and analyze
entries = ParseAll.call(texts, files.map { |f| f[:name] })
by_id = entries.group_by { |e| e[:id] }
dupes = by_id.select { |_, g| g.size > 1 }

# IO: output
puts dupes.empty? ? "ok" : Table.call(...)
```

## Data transformation style

Use Ruby's `Enumerable` chain — `map`, `select`, `filter_map`, `group_by`, `flat_map`, `each_with_index`.

Avoid:
- `for` loops
- `while` / `until`
- Mutable accumulators (use `filter_map` instead of `results = []` + `results <<`)
- `break` / `next`

Prefer:
- `.each_with_index.filter_map { |item, i| condition ? result : nil }`
- `.group_by { |item| item[:key] }.select { |_, group| group.size > 1 }`
- `.flat_map { |item| item[:array].map { |sub| transform(sub) } }`

## Configuration as constants

Validation rules are constants at the top of the file:

```ruby
REQUIRED_FIELDS = %i[id title source summary principle enforcement tags status priority]
VALID_STATUSES = %w[active draft]
VALID_ENFORCEMENTS = %w[Convention Tool Review]
MAX_ID_PATTERN = /\AMAX\.[A-Z][A-Z0-9.]*(?:\.[A-Z][A-Z0-9.]+)*\z/
```

These are immutable, descriptive, and scoped.

## What we do not use

| Feature | Reason |
|---------|--------|
| Classes / `def` | Classes couple state and behavior. Def methods are not first-class. |
| Instance variables | Mutable state breaks referential transparency. |
| `global` / `$` variables | Side-effect data flow. |
| `||=` memoization | Hidden state. Use explicit pass-through. |
| Blocks with `yield` | Lambda passing is explicit and testable. |
| `attr_*` | Belongs to class pattern. |
| Exceptions for control flow | Use `nil` returns, `filter_map`, or `Maybe`-style patterns. |

## File boundary contracts

| Annotation | Purpose | Example |
|------------|---------|---------|
| `# exports:` | Documents public API | `# exports: Table, List` |
| `# ring: N (NAME)` | MAX.CODE.LAYERS ring | `# ring: 1 (PURE)` |
| `# depends-on:` | Module dependencies | `# depends-on: ./loader` |

Every file carries all three. They are machine-readable contract declarations.
