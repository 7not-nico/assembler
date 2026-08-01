---
id: PAT.LIB.CONTRACT
title: Lib Module Contract — Shape the Module, Declare the Boundary
source: assembler
summary: Each lib module declares its exports, dependencies, and purity level. One concern per file. Import graph is a DAG. Validated across 7 regional software traditions.
principle: Single responsibility with explicit import boundary — every module states what it exports, what it depends on, and whether it touches the DB. 高内聚低耦合 (high cohesion, low coupling)
enforcement: Convention (audit-lib tool planned)
tags: [lib, module, architecture, convention, dependency, dry, orthogonal, cross-region]
patterns: [PAT.LIB.GOTCHA, PAT.SHARED.LIB, PAT.PURITY.BOUNDARY, PAT.DRY]
terms: [TERM.LIB.MODULE]
status: active
priority: 3
---

**Lib Module Contract** — each module in `.opencode/lib/` declares three things: its exports, its dependencies, and its purity level. The contract is the first thing a reader sees. The import graph is a DAG.

## Rules

1. **One concern per file** — 「高い凝集度」high cohesion (JP), 高内聚 (CN), haute cohésion (FR). A file named `format-*` must not execute DB queries. A file named `validate-*` whose functions are pure must not import `bun:sqlite`.

2. **Declare contract at module top** — « contrat d'interface clair » (FR). First 5 lines state what the module exports. Use a comment block or explicit type exports:
   ```ts
   // exports: formatGameDetail, formatEmulatorDetail, formatArchitectureDetail, formatHackromDetail, formatNoteDisplay
   // purity: pure
   // depends-on: none
   ```

3. **Import direction is strict** — Dependency Rule (US), Abhängigkeitsregel (DE). `tools/ → lib/`, `lib/ → lib/` (never `lib/ → tools/`). No circular dependencies between lib modules.

4. **Purity levels** inform dependency rules — Information hiding principle (Parnas 1972, all regions):
   - `pure` — deterministic, no I/O. May import only other pure modules plus builtins or npm packages.
   - `db` — may import `db.ts`, `db-paths.ts`, `ensure.ts`, `migrate.ts`, `bun:sqlite`.
   - `io` — may import `fs`, `path`, `db-paths.ts` (for file paths) but not `db.ts`.

5. **`db.ts` is the root dependency** — Stable Dependencies Principle (Martin 1994), 安定した依存関係 (JP). Depends on `db-paths.ts`, `ensure.ts` (path validation), `migrate.ts` (schema migrations), and `bun:sqlite`. No other lib imports.

6. **Explicit named imports** — « dépendances explicites » (FR), 明示的な依存関係 (JP). Each tool lists exactly the lib modules it needs. No star imports (`import * from "./db"`).

## Applicability

Any `.opencode/lib/` directory in any assembler subproject.

## See also

- TERM.LIB.MODULE — definition of a lib module
- PAT.LIB.GOTCHA — antipatterns to avoid
- PAT.SHARED.LIB — root _lib/ vs subproject lib/ convention
- PAT.PURITY.BOUNDARY — definition of pure vs impure
- PAT.DRY — every piece of knowledge has one authoritative representation
