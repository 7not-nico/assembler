# STORE.REFERENCE.KNOWLEDGE — semantic knowledge specific to the project lives in `reference/`

Project-specific semantic knowledge, lookup tables, and contextual reference material belong in `reference/`. This directory stores knowledge that the calculator variants depend on but do not define themselves.

## What goes in `reference/`

- Semantic role summaries for Go (Subject, Object, Action)
- Operator precedence tables
- Type conversion rules between numeric types
- Go spec excerpts relevant to expression evaluation
- Cross-reference mappings between paradigms and variant acronyms

## How it is used

Reference files are consumed on demand — loaded when a variant's implementation requires confirming a semantic detail. They are not loaded at startup. The implementing file cites its reference source in a comment.

## Example

```
reference/go-semantics.md       — GO.SUBJECT, GO.OBJECT, GO.ACTION summaries
reference/operator-table.md     — operator symbols, arity, precedence
reference/paradigm-map.md       — 6 permutations → programming paradigms
```

## Composes with

- TEST.CALCULATOR.VARIANT — tests reference semantic claims
- WRITE.SCRIPT.RUBY — scripts may load reference data for validation
