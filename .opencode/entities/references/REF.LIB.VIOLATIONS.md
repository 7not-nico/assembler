---
id: REF.LIB.VIOLATIONS
title: Lib Module Gotchas — Antipatterns in Module Design
source: PROT.LIB.CONTRACT
related: []
summary: Common violations of lib module contracts — import cycles, mixed concerns, wrong-direction imports. Detection rules derived from Acyclic Dependencies Principle.
ref: "Prevent import cycles, mixed concerns, and boundary violations by detecting antipatterns before they propagate. The dependency graph must be a DAG."
tags: [lib, module, architecture, antipattern, dependency, cycle, cross-region]
---

Antipatterns with paired redirects. Each entry names the violation in multiple software traditions, describes the detection method, and gives the fix.

## Protocol

Six rules prevent module design antipatterns:

1. **Keep format modules pure** — format and validation modules import only from other pure modules. Keep `from "./db"` outside format modules.
2. **Tools import from lib only** — shared logic lives in `lib/`. Tools are orchestrators; libraries hold shared logic.
3. **`db.ts` imports only path modules and `bun:sqlite`** — database modules depend on `db-paths.ts` alone, kept separate from format and validation modules.
4. **Separate pure from DB concerns per file** — a file contains either DB logic or pure formatting, one concern per file.
5. **Eliminate import cycles** — the import graph must remain a DAG. Any `A → B → A` pattern requires extraction of the shared dependency.
6. **Use named imports over star imports** — `import { query, run }` instead of `import * from "./db"`. Star imports hide the dependency surface.

## Gotchas

| # | Antipattern | Local terms | Detection | Redirect |
|---|-------------|-------------|-----------|----------|
| 1 | Format module imports from `db.ts` | 依存関係の違反 (JP), violation de dépendance (FR) | Import graph scan: `format-*.ts` has `from "./db"` | Extract combined logic to a dedicated module; keep format modules pure |
| 2 | Tool imports from another tool | 結合度が高い (JP), couplage fort (FR) | Cross-tool import in `tools/` directory | Extract shared logic to a new `lib/` module, import from there |
| 3 | `db.ts` imports non-path lib module | Abhängigkeitsregel-Verletzung (DE) | `db.ts` dependency list contains format/validate modules | `db.ts` depends only on `db-paths.ts` + `bun:sqlite` |
| 4 | Module mixes pure + DB concerns | 凝集度が低い (JP), faible cohésion (FR) | Same file has `bun:sqlite` import + pure formatting functions | Split into `format-*.ts` (pure) and `*-fk.ts` (DB-dependent) |
| 5 | Import cycle between lib modules | 循環依存 (JP), dépendance circulaire (FR) | `A → B → A` cycle detected via DFS on import graph | Extract shared dependency to a third module |
| 6 | Star import from lib module | 不透明なインポート (JP), import opaque (FR) | `import * from "./db"` pattern | List named imports explicitly — star imports hide the dependency surface |

## Enforcement

`audit-lib` performs four checks on each push:

1. **Import graph scan** — build the full directed graph across all lib modules
2. **Cycle detection** — DFS traversal flags any cycle
3. **Purity alignment** — verify every import complies with the allowance matrix in `PROT.LIB.DEPENDENCY.DIRECTION`
4. **Dependency surface audit** — flag star imports for replacement with named imports

## Applicability

Any `.opencode/lib/` or `.opencode/tools/` directory where module boundaries must be enforced. Both root `_lib/` and subproject `lib/` follow the same rules.

## See also

- `PROT.LIB.DEPENDENCY.DIRECTION` — unidirectional dependency vector
- `PROT.LIB.PURITY.BOUNDARY` — purity definitions and side-effect checklist
- `PROT.LIB.CONTRACT` — how to structure a lib module
- `PROT.LIB.DIRECTORY.LAYER` — root `_lib/` vs subproject `lib/` convention
- `TERM.LIB.MODULE` — definition of a lib module
