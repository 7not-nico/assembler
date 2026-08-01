---
id: PROT.LIB.CONTRACT
title: "Lib Module Contract — Shape the Module, Declare the Boundary"
source: NEX.LIB.STACK
related: []
summary: "Each lib module declares exports, dependencies, and purity level. One concern per file. Import graph is a DAG. Validated across 7 regional software traditions."
protocol: "Every lib module declares exports, dependencies, and purity level in a contract block at module top. One concern per file. Import direction follows purity allowance matrix. Named imports only. Dependency graph is a DAG."
enforcement: Formality
status: active
priority: 3
tags: [lib, module, architecture, convention, dependency, dry, orthogonal, cross-region]
---

Each module in `.opencode/lib/` declares three things: its exports, its dependencies, and its purity level. The contract is the first thing a reader sees. The import graph is a DAG.

## Protocol

1. **One concern per file** — format modules handle formatting, DB modules handle queries, validate modules handle validation. Every file has one purpose.
2. **Declare contract at module top** — first 5 lines state exports, purity, and dependencies using a comment block. Format: `// exports:`, `// purity:`, `// depends-on:`. See `ILL.LIB.CONTRACT.BLOCK` for a concrete walkthrough.
3. **Pure modules import only from pure modules, builtins, or npm packages** — pure code depends on pure code. No I/O-layer imports in pure modules.
4. **`db.ts` imports only from `db-paths.ts`, `ensure.ts`, `migrate.ts`, and `bun:sqlite`** — the DB root depends on a controlled set. Format and validate modules import from `db.ts`: disabled. Extract combined logic to a dedicated module instead.
5. **List each import explicitly** — named imports over star imports. Every dependency visible in its import line.
6. **All imports cross-checkable against purity allowance matrix** — `pure` imports only pure; `db` imports DB-path modules; `io` imports filesystem modules.
7. **Interface types use `export type` instead of `export`** — interfaces compile to zero runtime code. A runtime re-export fails in Bun. Use `export type { X } from './mod'` for interfaces, `export { f } from './mod'` for functions.

### Contract block format

Every lib module starts with a contract block in the first 5 lines:

```
// exports: {comma-separated export names}
// purity: {pure | db | io}
// depends-on: {none | module names}
```

Three contract fields: `exports` (comma-separated exported names), `purity` (`pure`, `db`, or `io`), `depends-on` (`none` or comma-separated module names).

## Gotchas

- File mixes format + DB logic: Split into `format-*.ts` (pure) and `*-db.ts` (DB-dependent) (`bun:sqlite` import and pure formatting function in same file)
- Module missing contract block: Add contract block in first 5 lines declaring exports, purity level, and dependencies (No `// exports:`, `// purity:`, or `// depends-on:` comment in first 10 lines)
- Pure module imports impure module: Route data through impure caller — pure module receives structured data as a parameter (Import graph shows pure → impure edge)
- Star import from lib module: Use named imports — each dependency listed explicitly in the import statement (`import * from "./db"` pattern)
- Interface re-exported as runtime value: Use `export type { X }` from — Bun rejects runtime interface re-exports (`export { X } from './mod'` where X is an interface)

## Enforcement

`audit-lib` parses contract blocks, builds the directed import graph across all lib modules, checks every edge against the purity allowance matrix, and reports violations per module path. Run `audit-lib` on each push. Every root `_lib/` module currently has contract blocks — new modules must follow the same pattern.

## Applicability

Any `.opencode/lib/` directory in any assembler subproject. Excluded for single-file tools with no shared imports.

## See also

- `REF.LIB.DEPENDENCY.DIRECTION` — unidirectional dependency vector across the purity boundary
- `REF.LIB.PURITY.BOUNDARY` — purity definitions and side-effect classification
- `REF.LIB.CONTRACT.VIOLATIONS` — antipattern catalog with cross-region terminology
- `REF.LIB.DIRECTORY.LAYER` — root `_lib/` vs subproject `lib/` convention
- `ILL.LIB.CONTRACT.BLOCK` — module contract declaration walkthrough
