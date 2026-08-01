---
id: REF.LIB.LAYER
title: "Shared Library — _lib/ vs lib/ Architecture"
source: PROT.LIB.CONTRACT
related: []
summary: "Two-level shared library convention for .opencode/ — root gets _lib/ (underscore prefix), subprojects get lib/ (without underscore)."
ref: "Shared logic extracts to _lib/ at assembler root. Subprojects keep project-specific lib/ with same interface and local DB path. Underscore prefix signals infrastructure. Import graph flows tool→lib; lib→tool direction excluded."
tags: [tooling, architecture, convention, data-flow, libraries, modularity]
---

Two levels of shared logic. Root `_lib/` holds modules shared across all projects. Subproject `lib/` holds project-specific helpers with local DB path. The underscore prefix signals scope.

## Protocol

1. **Root `_lib/` holds infrastructure modules** — path constants (`paths.ts`), YAML/regex parsing (`parse.ts`), DB init (`db.ts`), sync (`sync.ts`), error handling (`errors.ts`), audit (`audit.ts`, `audit-format.ts`). Importable by all tools across all subprojects.
2. **Subproject `lib/` mirrors root interface with project-local DB path** — same `db.ts` API, different DB file path. Each subproject independent.
3. **Underscore prefix signals assembler infrastructure** — `_lib/` belongs to assembler root. Without underscore, `lib/` belongs to the subproject.
4. **Import path follows level** — root tools import from `../_lib/module`; subproject tools import from `../lib/module`.
5. **Logic shared by 2+ tools extracts to `_lib/`** — single-purpose logic stays in the tool file. Threshold is two tools: if a second tool needs it, extract.
6. **`_lib/` imports only from Node builtins or npm packages** — `_lib/` is a dependency leaf. Tool files and subproject `lib/` imports: disabled. Extract shared concern into a new `_lib/` module instead.
7. **Tools import from `_lib/` only** — cross-tool logic routes through shared lib. Tool imports route through shared lib, separate from other tools.
8. **Import graph is a DAG** — `_lib/` knows nothing about tools. Tools import from `_lib/`. Dependency direction is tool→lib only.
9. **Each module declares a contract block** — first 5 lines: `// exports:`, `// purity:`, `// depends-on:`. Per `PROT.LIB.CONTRACT`.

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Subproject tool imports from `../_lib/` | Import path from subproject tool uses `../_lib/` prefix | Use `../lib/` prefix — subproject imports from its own `lib/`, separate from root `_lib/` |
| Root `_lib/` module imports subproject `lib/` | Import graph shows `_lib/` depending on a subproject path | Extract shared concern into a new `_lib/` module — `_lib/` imports only builtins and npm |
| Tool imports from another tool | Import in `tools/` file targets another `tools/` file | Extract shared logic to a new `_lib/` module — both tools import from `_lib/` |
| Module in wrong level | `lib/` module used by 3+ subprojects while living in one subproject | Extract to root `_lib/` — logic shared across projects belongs at infrastructure level |
| Interface re-exported as runtime value | `export { X } from './mod'` where X is an interface | Use `export type { X }` — interfaces compile to zero runtime code |

## Enforcement

`audit-tool` scans import paths across all tools and lib modules. It verifies each import prefix matches the importer's level, flags cross-tool imports, and reports wrong-prefix paths. Run `audit-tool` on each push.

## Applicability

Any AMANDA project with `.opencode/tools/` and shared logic across two or more tools.

## See also

- `PROT.LIB.CONTRACT` — per-module contract declaration (exports, purity, deps)
- `PROT.TOOL.DEFINITION` — tool structure, uses lib import conventions
- `PROT.LIB.DEPENDENCY.DIRECTION` — unidirectional dependency vector within lib
- `PROT.TOOL.NODE_MODULES.SHARED` — shared node_modules across projects
- `verify-deps` tool — verify + repair shared dependency plane
