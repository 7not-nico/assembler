---
id: ILL.LIB.DECIDE
title: "Lib Mutation Decide — Append vs Upsert Heuristic"
source: PROT.LIB.CONTRACT
summary: "Walkthrough of the append vs upsert mutation decision for a real table — INTEGER PRIMARY KEY vs TEXT PRIMARY KEY."
illustration: "An audit log table stores event history. Re-running produces meaningful duplicates — append wins with INTEGER PRIMARY KEY AUTOINCREMENT. A platforms registry stores synchronized reference data — upsert wins with TEXT PRIMARY KEY and ON CONFLICT DO UPDATE."
illustrates: [REF.LIB.MUTATION.STRATEGY]
tags: lib,mutation,append,upsert,walkthrough,decision,table
related: [REF.SCHEMA.SEED.MUTATION, PROT.SCHEMA.AUGMENT]
---
## Context

Two new tables need mutation strategy decisions. An audit log tracks every tool invocation. A platforms registry stores reference data synchronized from a seed file. Each table needs a different strategy.

## Walkthrough

1. Apply the heuristic to the audit log table: "Would re-running produce a meaningful duplicate?" Yes — each tool invocation is a distinct event. Re-running should add a new row, not overwrite the previous one.

2. Use append for the audit log. The primary key is `INTEGER PRIMARY KEY AUTOINCREMENT`. INSERT only — no ON CONFLICT clause.

```sql
CREATE TABLE IF NOT EXISTS audit_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tool_name TEXT NOT NULL,
  invoked_at TEXT NOT NULL,
  status TEXT NOT NULL
);
```

3. Apply the heuristic to the platforms registry: "Would re-running produce a meaningful duplicate?" No — the seed file is the authoritative source. Re-running should update in place without accumulating stale rows.

4. Use upsert for the platforms registry. The primary key is `TEXT PRIMARY KEY`. INSERT with `ON CONFLICT(id) DO UPDATE SET ...`.

```sql
CREATE TABLE IF NOT EXISTS platforms (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  release_year INTEGER
);
```

5. The seed file for the platforms table uses `INSERT OR REPLACE` — idempotent, re-runnable.

```sql
INSERT OR REPLACE INTO platforms (id, name, release_year) VALUES
  ('nes', 'Nintendo Entertainment System', 1983);
```

## Key insight

The choice encodes the data's semantics in the schema. Append preserves history — essential for audit trails, search logs, and time-series data. Upsert keeps the DB synchronized with a source file — re-running updates in place. The PK type declares the strategy: `INTEGER PRIMARY KEY AUTOINCREMENT` signals append; `TEXT PRIMARY KEY with ON CONFLICT` signals upsert.

## See also

- `REF.LIB.MUTATION.STRATEGY` — abstract mutation strategy rules
- `REF.SCHEMA.SEED.MUTATION` — seed file mutation convention
- `PROT.SCHEMA.AUGMENT` — additive-only migration
