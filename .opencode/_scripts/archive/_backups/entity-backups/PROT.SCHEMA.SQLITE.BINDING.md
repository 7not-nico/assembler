---
id: PROT.SCHEMA.SQLITE.BINDING
title: SQLite Param Binding — Pass to Result Method, Not Query
source: tooling
summary: bun:sqlite query parameters pass to .all(), .get(), or .run() — never to db.query(), which silently ignores extra arguments.
protocol: Parameters bind to the result method, not to the query preparation call.
enforcement: Convention
related: []
tags: [sqlite, database, tooling, bun, convention, binding, query]
status: active
priority: 5
---

`db.query()` accepts only the SQL string — extra arguments are silently ignored. Parameters bind to the result method that executes the query: `.all()`, `.get()`, or `.run()`. Passing bindings to `.query()` leaves `?` placeholders unbound — produces empty results or runtime errors.

## Rules

- Pass bindings to `.all()`, `.get()`, or `.run()` — one argument per placeholder; `db.query()` takes only the SQL string
- Multiple placeholders take multiple arguments: `.all(val1, val2)`
- Spread array bindings: `.all(...arr)`
- Use `?` placeholders for value binding — avoids injection and type coercion issues from string interpolation

## Applicability

Every AMANDA project using `bun:sqlite` — all projects under `assembler/`.

## See also

- `ILL.SCHEMA.SQLITE.BINDING` — walkthrough of fixing misplaced parameters
- `TERM.SQLITE.REFERENCES`
- `TERM.SQLITE.STORAGE.CLASSES`
- MAX.DRY
- PROT.TOOL.DEFINITION
- PROT.LIB.MUTATION.STRATEGY
