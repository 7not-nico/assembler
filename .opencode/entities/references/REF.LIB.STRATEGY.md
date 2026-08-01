---
id: REF.LIB.STRATEGY
title: "Mutation Pattern — Append vs Upsert"
source: PROT.LIB.CONTRACT
related: []
summary: "Every persistent data store chooses append or upsert — events use append, registries use upsert; the schema encodes the intent via primary key type."
ref: "Append (INSERT-only, INTEGER PRIMARY KEY AUTOINCREMENT) for event and time-series data where history is sacred. Upsert (INSERT ... ON CONFLICT DO UPDATE, TEXT PRIMARY KEY) for sync-from-source registries where the file is authoritative."
tags: [data-flow, database, sqlite, architecture, schema, mutation, conventions]
---

Every persistent data store chooses append or upsert. Events use append. Registries use upsert. The schema encodes the intent via primary key type.

## Protocol

### Append strategy

Use for event and time-series data where history is sacred. Schema: `id INTEGER PRIMARY KEY AUTOINCREMENT`, `INSERT` only — `ON CONFLICT` clause excluded. Re-running the same tool adds a new row. Examples: `search_log`, `author_affiliations`.

### Upsert strategy

Use for sync-from-source registries where the file is authoritative. Schema: `id TEXT PRIMARY KEY`, `INSERT ... ON CONFLICT DO UPDATE`. Re-running the same tool updates in place without accumulating stale rows. Examples: `papers`, `patlib entity tables`.

### Heuristic

Run two tests to decide:
1. "Would re-running produce a meaningful duplicate?" Yes → append. No → upsert.
2. "Does the source have its own primary key?" Yes → upsert (use the source key as TEXT PK). No → append.

## Gotchas

| Signal | Observation | Redirect |
|--------|-------------|----------|
| Append table with no AUTOINCREMENT | `INTEGER PRIMARY KEY` without `AUTOINCREMENT` | Add `AUTOINCREMENT` — guarantees increasing IDs across transaction rollbacks |
| Upsert table with integer PK | Integer PK on upsert table collides on re-run | Use TEXT PK matching the source identifier |
| Upsert table uses ON CONFLICT REPLACE | `INSERT OR REPLACE` drops old row before insert | Use `ON CONFLICT DO UPDATE` — preserves data from columns not in the INSERT |
| Mixed strategy in same table | Table has both event-like and registry-like rows | Split into two tables — one append, one upsert |

## Applicability

Any `bun:sqlite` database across all assembler projects. Each table selects one strategy at schema design time. Strategy changes require a migration.

## See also

- `ILL.LIB.MUTATION.DECIDE` — walkthrough of the append-vs-upsert heuristic
- `PROT.SCHEMA.AUGMENT` — additive-only migration strategy
