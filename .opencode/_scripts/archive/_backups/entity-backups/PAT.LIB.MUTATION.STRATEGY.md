---
id: PAT.LIB.MUTATION.STRATEGY
Title: "Mutation Pattern — Append vs Upsert"
Source: assembler
Related: []
Summary: "Every persistent data store chooses append or upsert — events use append, registries use upsert; the schema encodes the intent via primary key type."
Protocol: "Append (INSERT-only, INTEGER PRIMARY KEY AUTOINCREMENT) for event and time-series data where history is sacred. Upsert (INSERT ... ON CONFLICT DO UPDATE, TEXT PRIMARY KEY) for sync-from-source registries where the file is authoritative."
Enforcement: Convention
Status: active
Priority: 2
Tags: [data-flow, database, sqlite, architecture, schema, mutation, conventions]
---

Every persistent data store chooses append or upsert. Events use append. Registries use upsert. The schema encodes the intent via primary key type.

## Protocol

1. **Use append for event and time-series data** — `INTEGER PRIMARY KEY AUTOINCREMENT`. INSERT only. Each occurrence is a distinct, meaningful record. Updates are excluded; use INSERT-only for append semantics.
2. **Use upsert for sync-from-source registries** — `TEXT PRIMARY KEY` with `ON CONFLICT(id) DO UPDATE SET ...`. Keeps only the latest state derived from an authoritative file source.
3. **Evolve schema additively** — `ALTER TABLE ADD COLUMN` only. Column removal requires a new migration file, distinct from ALTER.
4. **Apply the heuristic to choose** — "Would re-running produce a meaningful duplicate?" If yes, append. If no, upsert.

## Rationale

- Wrong choice loses history (upsert on events) or accumulates garbage rows (append on registries)
- Append preserves every occurrence — essential for audit trails, search logs, and time-series data where each entry is independently meaningful
- Upsert keeps the DB synchronized with a file source — re-running the sync updates in place without accumulating stale records
- Additive schema evolution prevents data loss — ALTER-only means old tools continue to work with new schemas

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Using upsert on event data | Re-running the same operation overwrites history instead of adding a new record | Switch to append with `INTEGER PRIMARY KEY AUTOINCREMENT` — each event is a distinct occurrence |
| Using append on registry data | Re-running a sync operation creates duplicate rows for the same entity | Switch to upsert with `TEXT PRIMARY KEY` and `ON CONFLICT(id) DO UPDATE SET ...` |
| Dropping a column from a live schema | Migration uses `ALTER TABLE ... DROP COLUMN` | Use additive-only migration — write a new migration that ignores the old column rather than removing it |
| Mixing append and upsert in the same table | Table has both `INTEGER PRIMARY KEY AUTOINCREMENT` and `ON CONFLICT` logic | Choose one mutation strategy per table — the PK type determines the strategy |

## Enforcement

Schema review on each migration. The PK type and mutation pattern are declared in the schema file and verified during code review. Audit tools flag tables that mix append and upsert behavior in the same schema.

## Applicability

All AMANDA projects using `bun:sqlite` with persistent data stores — any tool that writes to a database.

## See also

- `bootstrap-db` skill — step 0 (mutation pattern decision)
- `PROT.TOOL.DEFINITION` — read/write separation
- `PROT.LIB.DIRECTORY.LAYER` — crashOnError, shared library convention
- `MAX.DRY` — single source of truth
