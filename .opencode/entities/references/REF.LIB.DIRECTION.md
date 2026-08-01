---
id: REF.LIB.DIRECTION
title: "Impure Depends on Pure — Unidirectional Dependency Across the Purity Boundary"
source: assembler
related: []
summary: "Dependencies flow impure to pure. Pure modules import only from other pure modules. Data crosses the boundary as function parameters; reverse imports excluded."
ref: "Dependencies flow unidirectionally from impure to pure. Pure modules are leaf nodes that import only from other pure modules. Impure modules handle I/O; pure modules handle logic and formatting. The import graph is a DAG."
tags: [lib, module, architecture, purity, dependency, convention, enforcement]
---

Every import edge in a lib tree has a direction: impure modules import from pure modules. Pure modules import only from other pure modules. The vector is always one way.

## Protocol

Three rules compose the dependency direction:

1. **Pure imports only pure** — a pure module imports exclusively from other pure modules, builtins, or npm packages. The `audit-lib` tool verifies this constraint per module.

2. **Impure imports any** — an impure module imports from any module regardless of purity level. No restrictions on impure import targets.

3. **Data crosses as parameters only** — when a pure module needs data from the database, the impure caller opens the DB, queries the data, and passes the result row as a parameter to a pure function. The pure function uses `db.query`: excluded. Use parameter passing instead.
4. **Type-only imports create no edges** — `import type { X }` is erased at compile time. A type-only import from an impure module keeps a pure module pure. The runtime import graph ignores type-only edges.

Allowance matrix documented in `PROT.LIB.DEPENDENCY`.

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Pure module imports from `db.ts` | Import graph scan: `format-*.ts` has `from "./db"` | Extract combined logic to a dedicated module; keep format modules pure |
| Tool imports from another tool | Cross-tool import in `tools/` directory | Extract shared logic to a new `lib/` module, import from there |
| Import cycle between lib modules | `A → B → A` cycle detected via DFS on import graph | Extract shared dependency to a third module (Martin's ADP strategy) |
| Star import from lib module | `import * from "./db"` pattern | List named imports explicitly — star imports hide the dependency surface |
| Interface re-exported as runtime value | `export { X } from './mod'` where X is an interface | Use `export type { X }` from — Bun rejects runtime interface re-exports |

## Enforcement

`audit-lib` enforces the direction rule in four steps:

1. **Parse** — read `// purity:` declarations from every `.opencode/lib/*.ts` module
2. **Build** — construct the directed import graph across all lib modules
3. **Check** — for every edge, verify the source module's purity level allows the destination
4. **Report** — list violations with module path and import target

## Applicability

Any `.opencode/lib/` directory where modules are declared with `// purity:` tags. The protocol applies to all lib modules — root `_lib/` and subproject `lib/` — per `PROT.LIB.DIRECTORY.LAYER`.

## See also

- `PROT.LIB.PURITY.BOUNDARY` — defines what pure and impure mean at the function level
- `PROT.LIB.CONTRACT.VIOLATIONS` — antipattern catalog with cross-region terminology
- `PROT.LIB.CONTRACT` — defines the module contract format (exports, purity, deps)
- `PROT.LIB.DIRECTORY.LAYER` — root `_lib/` and subproject `lib/` both follow this direction rule
- `PROT.LIB.DEPENDENCY` — allowance matrix and concrete examples
- `ILL.LIB.FORMAT.GAME` — pure format function walkthrough
