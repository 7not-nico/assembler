---
id: PAT.SQLITE.PARAM.BINDING
title: SQLite Param Binding — Pass to Result Method, Not Query
source: tooling
summary: bun:sqlite query parameters pass to .all(), .get(), or .run() — never to db.query(), which silently ignores extra arguments.
principle: Parameters bind to the result method, not to the query preparation call.
enforcement: Convention
tags: [sqlite, database, tooling, bun, convention, binding, query]
patterns: [PAT.DRY, PAT.PLUGIN.IPC.TOOL, PAT.MUTATION.PATTERN]
terms: [TERM.SQLITE.REFERENCES, TERM.SQLITE.STORAGE.CLASSES]
status: active
priority: 5
---

`db.query()` accepts only the SQL string — extra arguments are silently ignored. Parameters bind to the result method that executes the query: `.all()`, `.get()`, or `.run()`. Passing bindings to `.query()` leaves `?` placeholders unbound — produces empty results or runtime errors.

## Context

`bun:sqlite` follows the prepared statement pattern. `db.query(sql)` returns a `Statement` object. Parameters bind when the statement *executes* — via `.all(bindings)`, `.get(bindings)`, or `.run(bindings)`. Passing parameters to `.query()` is a no-op: the API signature accepts `(sql: string, params?: never)` — extra arguments are silently discarded. This is unlike `better-sqlite3` where `.prepare(sql).all(params)` is the pattern.

## Rules

- Never pass a second argument to `db.query()` — ignored without error
- Pass bindings to `.all()`, `.get()`, or `.run()` — one argument per placeholder
- Multiple placeholders take multiple arguments: `.all(val1, val2)`
- Spread array bindings: `.all(...arr)`
- Never use string interpolation for value binding — always use `?` placeholders

## Applicability

Every AMANDA project using `bun:sqlite` — all projects under `assembler/`.

## See also

- TERM.SQLITE.REFERENCES
- TERM.SQLITE.STORAGE.CLASSES
- PAT.DRY
- PAT.PLUGIN.IPC.TOOL
- PAT.MUTATION.PATTERN
