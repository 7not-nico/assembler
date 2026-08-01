# knowledge-ruby — Ruby Functional Programming Reference

**Purpose** — authoritative atomic knowledge files for Ruby functional programming.

## Procedure

1. Read relevant atomic file from `knowledge/ruby/` for the Ruby concept
2. Reference official Ruby docs: `docs.ruby-lang.org/en/3.4/{Class}.html`
3. Cross-reference with Playwright to fetch official docs when needed

## Knowledge Files

```text
proc.md              Creation, invocation, methods, arity
lambda.md            Lambda vs non-lambda — 5 differences
closure.md           Closures, scope capture, binding
composition.md       Function composition — >>/<<, pipelines
curry.md             Currying, partial application
to-proc.md           Conversion — Symbol, Method, Hash
string*.md           Creation, slice, sub, query, case, modify, encode, convert
symbol.md            Identity, querying, conversion
array*.md            Access, add, remove, query, transform, set ops
hash*.md             Access, defaults, modify, query, transform, iterate, keys
integer*.md          Arithmetic, bitwise, compare, convert, iterate
float*.md            Creation, conversion, parsing
enumerable*.md       Query, filter, group, map, slice, reduce, sort, lazy
file*.md             Open, read, write, path, query, meta, IO
regexp*.md           Match, capture, sub, scan, anchors, quantifiers
exception*.md        Hierarchy, raise, rescue, ensure, types
```

## Constraints

- `knowledge/ruby/` authoritative for atomic concepts — no guesswork
- Each file covers one concern per MAX.ATOMIC.CONCERN
