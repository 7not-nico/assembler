---
id: PAT.SHARED.LIB
title: Shared Library — _lib/ vs lib/ Architecture
source: assembler
summary: Two-level shared library convention for .opencode/ — root gets _lib/ (underscore prefix), subprojects get lib/ (no underscore).
principle: Shared logic extracted to _lib/ at assembler root; subprojects have project-specific lib/ with same interface but local DB path.
enforcement: Convention
tags: [tooling, architecture, convention, data-flow, libraries, modularity]
patterns: [PAT.PLUGIN.IPC.TOOL, PAT.ORTHOGONALITY, PAT.DRY, PAT.MUTATION.PATTERN]
terms: []
status: active
priority: 4
---

Shared logic extracted to `_lib/` at assembler root; subprojects have project-specific `lib/` with same interface but local DB path.

## Context

AMANDA has two levels of shared logic. At the root level, `_lib/` holds modules shared across all projects — DB init, parsing, sync, error handling. At the subproject level, `lib/` holds project-specific helpers that mirror the root interface but point to a local `.db` file. The underscore prefix (`_lib/` vs `lib/`) signals the scope: underscore belongs to assembler infrastructure, no-underscore belongs to the subproject.

## Rules

- Two naming levels: root `.opencode/_lib/` (underscore prefix) vs subproject `.opencode/lib/` (no underscore)
- Underscore prefix signals "belongs to assembler infrastructure, not this subproject"
- Import path: root tools import from `../_lib/module`; subproject tools import from `../lib/module`
- Any logic shared by 2+ tools belongs in `_lib/` — single-purpose logic stays in the tool file
- `_lib/` modules import only from Node builtins or npm packages — `_lib/` modules are dependency leaves
- Tools import from `_lib/` only — no cross-tool imports, only shared lib
- Dependency graph is a DAG: `_lib/` → knows nothing about tools; tools → import from `_lib/`
- `crashOnError()` from `_lib/errors.ts` must appear at the top of every tool `execute()`

## Structure

Root `_lib/` modules across all root tools:

```
_opencode/_lib/
├── db.ts       — initDB(), initMCPDB(), queryAll(), queryOne() — DB paths + query helpers
├── errors.ts   — crashOnError() — global unhandled rejection/exception handler
├── parse.ts    — FRONTMATTER_RE, BACKMATTER_RE, normalizeArray, normalizeReferences
└── sync.ts     — parsePatternFile, parseTermFile, syncAll() — patlib .md → DB upsert
```

Subproject `lib/` (one module, local scope):

```
_opencode/lib/
└── db.ts       — DB_PATH, connect(), initDB(), queryAll(), queryOne() — project-local DB
```

Subproject `lib/db.ts` mirrors the root `db.ts` interface but points to the project's own `.db` file.

**`_backups/`** — mirrors `.opencode/` directory tree for pre-reduction snapshots and rejected drafts. Follows underscore-prefix convention: `_backups/rules/`, `_backups/commands/`, `_backups/tools/`, `_backups/terms/`.

## Applicability

Any AMANDA project with `.opencode/tools/` and shared logic across two or more tools.

## See also

- PAT.PLUGIN.IPC.TOOL
- PAT.ORTHOGONALITY
- PAT.DRY
- PAT.MUTATION.PATTERN
- `commands/data-flow.md`
- root `AGENTS.md` (Path pattern table)
