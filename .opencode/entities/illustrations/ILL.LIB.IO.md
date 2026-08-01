---
id: ILL.LIB.IO
title: "EnsureIO — Wrapping an Impure DB Call"
source: PROT.LIB.CONTRACT
summary: "Walkthrough of ensuring a database check function stays behind the purity boundary by wrapping it in an impure io module."
illustration: "An impure DB call wraps behind a thin io module, keeping pure callers free of side effects."
illustrates: [REF.LIB.PURITY.BOUNDARY]
tags: lib,module,purity,walkthrough,impure
related: [REF.LIB.DEPENDENCY, ILL.LIB.FORMAT.GAME]
---
## Rationale

A tool verifies its database file exists before performing operations. The database path depends on `import.meta.dir` based resolution. Filesystem reads stay in io modules; path construction stays in pure modules.

## Walkthrough

1. The pure `db-paths.ts` constructs the database file path from `import.meta.dir` and a relative path. Pure path joining only — no filesystem access.

2. The io `ensure.ts` imports the path from `db-paths.ts`, calls `Bun.file(dbPath).exists()` to check filesystem state, and returns a boolean or throws. Impure module owns all filesystem I/O.

3. The tool handler calls `ensureDBExists()` before opening the database. The tool delegates to the io module rather than performing the check inline.

```
// _lib/db-paths.ts — pure
// exports: getDBPath
// purity: pure
// depends-on: none
export function getDBPath(): string {
  return join(import.meta.dir, '..', 'patlib.db')
}

// _lib/ensure.ts — impure (io)
// exports: ensureDBExists
// purity: io
// depends-on: db-paths, fs
export function ensureDBExists(): void {
  const path = getDBPath()
  if (!Bun.file(path).exists()) throw new Error(`DB not found: ${path}`)
}

// tool handler calls ensureDBExists — impure orchestrator
```

4. When a pure format module needs DB existence information, the impure caller passes the boolean as a parameter. The pure function receives structured data only.

## Key insight

The wrapper pattern (`ensure.ts`) keeps the filesystem read behind a thin impure boundary. Three modules with one concern each: pure path construction, impure existence check, pure formatting. Every module above the impure boundary receives structured data — it calls functions, it opens DB connections.

## See also

- `REF.LIB.PURITY.BOUNDARY` — purity definitions, layer categorization, checklist
- `ILL.LIB.FORMAT.GAME` — pure formatting separated from I/O
- `REF.LIB.DEPENDENCY.DIRECTION` — data crossing as parameters
