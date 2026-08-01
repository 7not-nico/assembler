---
id: PAT.MUTATION.PATTERN
title: "Mutation Pattern — Append vs Upsert"
source: assembler
summary: Every persistent data store chooses append or upsert — events use append, registries use upsert; the schema encodes the intent via primary key type.
principle: Append (INSERT-only, INTEGER PRIMARY KEY AUTOINCREMENT) for event/time-series data where history is sacred; Upsert (INSERT ... ON CONFLICT DO UPDATE, TEXT PRIMARY KEY) for sync-from-source registries where the file is authoritative.
enforcement: Convention
status: active
priority: 2
tags: data-flow, database, sqlite, architecture, schema, mutation, conventions
patterns: [PAT.PLUGIN.IPC.TOOL, PAT.SHARED.LIB, PAT.DRY]
terms: []
---

Every persistent data store chooses append or upsert — events use append, registries use upsert; the schema encodes the intent via primary key type.

## Rules

- Append uses `INTEGER PRIMARY KEY AUTOINCREMENT` — INSERT-only, updates are prohibited
- Upsert uses `TEXT PRIMARY KEY` with `ON CONFLICT(id) DO UPDATE SET ...`
- Schema evolves additively — `ALTER TABLE ADD COLUMN` only; removal requires a new migration
- Heuristic: "Would re-running produce a meaningful duplicate?" If yes, append. If no, upsert.
- `mcp-log-search` is canonical append; `write-sync` is canonical upsert
- Wrong choice loses history (upsert on events) or accumulates garbage (append on registries)

## Context

Two mutation patterns exist across AMANDA systems:

| Pattern | PK Type | SQL | Use Case |
|---------|---------|-----|----------|
| **Append** | `INTEGER PRIMARY KEY AUTOINCREMENT` | INSERT only | Event/time-series data |
| **Upsert** | `TEXT PRIMARY KEY` | `INSERT ... ON CONFLICT(id) DO UPDATE SET ...` | Sync-from-source registries |

Append preserves every occurrence as a distinct, meaningful record. Upsert keeps only the latest state, derived from an authoritative file source.

## Applicability

All AMANDA projects using `bun:sqlite` with persistent data stores — any tool that writes to a database.

## See also

- `bootstrap-db` skill — step 0 (mutation pattern decision)
- PAT.PLUGIN.IPC.TOOL — read/write separation
- PAT.SHARED.LIB — crashOnError, shared library convention
- PAT.DRY — single source of truth

