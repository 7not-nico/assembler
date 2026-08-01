---
id: ILL.SCHEMA.LOADING
title: "Seed Loading — Idempotent Reference Data Init"
source: PROT.SCHEMA.AUGMENT
summary: "Walkthrough of seed-driven init — sorted SQL seed files load reference data on every initDB() call."
illustration: "A new platforms table needs reference data. A seed file with numeric prefix loads platform rows via INSERT OR REPLACE on every database init."
illustrates: [PAT.SCHEMA.SEED.RELOAD]
tags: schema,seed,loading,walkthrough,init,database
related: [REF.SCHEMA.SEED.REFERENCE, PROT.SCHEMA.FORMAT, PROT.SCHEMA.AUGMENT]
---
## Rationale

A new platforms lookup table needs reference data. The data must exist before entity creation. Manual inserts cause drift across environments. Seed files running on every `initDB()` call keep environments synchronized.

## Walkthrough

1. Define the platforms table DDL in `schemas/seeds/00-ddl.sql`. This is the DDL for a seed-only table — no corresponding entity `.md` directory.

```sql
CREATE TABLE IF NOT EXISTS platforms (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  release_year INTEGER
);
```

2. Create the seed file at `schemas/seeds/01-platforms.sql` with a numeric prefix that ensures it runs after `00-ddl.sql`.

```sql
INSERT OR REPLACE INTO platforms (id, name, release_year) VALUES
  ('nes', 'Nintendo Entertainment System', 1983),
  ('snes', 'Super Nintendo Entertainment System', 1990),
  ('genesis', 'Sega Genesis', 1988),
  ('psx', 'PlayStation', 1994);
```

3. `initDB()` executes DDL first (`00-ddl.sql`), then sorted seed files in order. Each seed uses `INSERT OR REPLACE` so re-running updates rows without errors.

4. An entity table like `games` references `platforms.id` via FK. The FK constraint guarantees referential integrity — every game.platform value exists in the platforms table.

5. When a new platform needs adding, insert a row into the seed file. The next `initDB()` call updates the table. Removing a platform from the seed file does not delete its row — additive-only.

## Key insight

The seed file IS the reference data source. No manual INSERT, no migration script, no environment-specific setup. Running `initDB()` produces the same state everywhere. The numeric prefix guarantees dependency ordering without a separate configuration file.

## See also

- `PAT.SCHEMA.SEED.RELOAD` — seed-driven init pattern
- `REF.SCHEMA.SEED.REFERENCE` — lookup table normalization
- `PROT.SCHEMA.FORMAT` — seed file format convention
- `PROT.SCHEMA.AUGMENT` — additive-only migration
- `ILL.SCHEMA.REFERENCE.NORMALIZE` — lookup table normalization walkthrough
