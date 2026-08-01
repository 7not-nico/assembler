---
id: PAT.LIB.GOTCHA
title: Lib Module Gotchas — Antipatterns in Module Design
source: assembler
summary: Common violations of lib module contracts — import cycles, mixed concerns, wrong-direction imports. Detection rules derived from Acyclic Dependencies Principle and universal modular design consensus.
principle: Prevent import cycles, mixed concerns, and boundary violations by detecting antipatterns before they propagate. The dependency graph must be a DAG (Martin 1994)
enforcement: Convention (audit-lib tool planned)
tags: [lib, module, architecture, antipattern, dependency, cycle, cross-region]
patterns: [PAT.LIB.CONTRACT, PAT.SHARED.LIB]
terms: [TERM.LIB.MODULE]
status: active
priority: 4
---

**Lib Module Gotchas** — antipatterns to avoid, paired with redirects. Each entry names the violation in multiple software traditions, describes the detection method, and gives the fix.

## Gotchas

| # | Antipattern | Local terms | Detection | Redirect |
|---|-------------|-------------|-----------|----------|
| 1 | Format module imports from `db.ts` | 依存関係の違反 (JP), violation de dépendance (FR), 依赖倒置违反 (CN) | Import graph scan: `format-*.ts` has `from "./db"` | Extract combined logic to a dedicated module; keep format modules pure |
| 2 | Tool imports from another tool | 結合度が高い (JP), couplage fort (FR), 紧耦合 (CN) | Cross-tool import in `tools/` directory | Extract shared logic to a new `lib/` module, import from there |
| 3 | `db.ts` imports non-path lib module | Abhängigkeitsregel-Verletzung (DE), 依赖倒置违反 (CN) | `db.ts` dependency list contains format/validate modules | `db.ts` depends only on `db-paths.ts` + `bun:sqlite` |
| 4 | Module mixes pure + DB concerns | 凝集度が低い (JP), faible cohésion (FR), 低内聚 (CN) | Same file has `bun:sqlite` import + pure formatting functions | Split into `format-*.ts` (pure) and `*-fk.ts` (DB-dependent) |
| 5 | Import cycle between lib modules | 循環依存 (JP), dépendance circulaire (FR), 循环依赖 (CN) | `A → B → A` cycle detected via DFS on import graph | Extract shared dependency to a third module (Martin's ADP strategy) |
| 6 | Star import from lib module | 不透明なインポート (JP), import opaque (FR) | `import * from "./db"` pattern | List named imports explicitly — star imports hide the dependency surface |

## Failure modes

- **Ignored** — antipatterns not detected until runtime or refactoring time
- **Escalated** — a single cycle today becomes a strongly-connected-component tomorrow, preventing independent testing of any module in the cycle
- **Multiplied** — one tool→tool import creates a precedent; within months no module boundary can be trusted

## Applicability

Any `.opencode/lib/` or `.opencode/tools/` directory where module boundaries must be enforced.

## See also

- TERM.LIB.MODULE — definition of a lib module
- PAT.LIB.CONTRACT — how to structure a lib module
- PAT.SHARED.LIB — root _lib/ vs subproject lib/ convention
- MANIFEST.MODULAR-LIB-ARCHITECTURE — cross-region research audit
