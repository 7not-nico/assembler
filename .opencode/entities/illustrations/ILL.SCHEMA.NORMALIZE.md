---
id: ILL.SCHEMA.NORMALIZE
title: "Reference Normalize — Lookup Table Creation"
source: PROT.SCHEMA.AUGMENT
summary: "Walkthrough of normalizing reference metadata into a lookup table — separating a repeated text field into a dedicated table with seed data."
illustration: "The games table has a free-text platform field. A new platforms lookup table normalizes it — TEXT PRIMARY KEY, seed data via INSERT OR REPLACE."
illustrates: [REF.SCHEMA.SEED.REFERENCE]
tags: schema,reference,normalize,walkthrough,lookup,table
related: [PAT.SCHEMA.SEED.RELOAD, ILL.SCHEMA.SEED.LOADING, PROT.SCHEMA.FORMAT]
---
## Rationale

The `games` table stores a `platform` field as free text. Values like `NES`, `Nintendo`, and `Nintendo Entertainment System` all refer to the same platform. Queries that group by platform produce inconsistent results. A lookup table normalizes the field.

## Walkthrough

1. Create the lookup table DDL. Each reference type gets its own table with `TEXT PRIMARY KEY`.

```sql
CREATE TABLE IF NOT EXISTS platforms (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  release_year INTEGER
);
```

2. Seed the reference data in `schemas/seeds/01-platforms.sql`. The seed loads on every `initDB()` call via `INSERT OR REPLACE`.

```sql
INSERT OR REPLACE INTO platforms (id, name, release_year) VALUES
  ('nes', 'Nintendo Entertainment System', 1983),
  ('snes', 'Super Nintendo Entertainment System', 1990);
```

3. Add a FK constraint in the DDL for new databases. The `games.platform` column references `platforms.id`.

```sql
CREATE TABLE IF NOT EXISTS games (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  platform TEXT NOT NULL REFERENCES platforms(id),
  year INTEGER
);
```

4. For existing databases, use additive-only migration. The FK constraint applies to new databases only; seed data guarantees referential integrity for existing ones.

5. When querying, JOIN the lookup table to get the display name:

```sql
SELECT g.title, p.name AS platform_name
FROM games g
JOIN platforms p ON g.platform = p.id
ORDER BY p.name;
```

## Key insight

The lookup table IS the controlled vocabulary. Every value in `games.platform` matches a row in `platforms`. The seed file keeps the vocabulary synchronized across environments. Multi-value fields use TEXT with comma-separated values — no FK constraint, the lookup table serves as documentation.

## See also

- `REF.SCHEMA.SEED.REFERENCE` — lookup table normalization pattern
- `PAT.SCHEMA.SEED.RELOAD` — seed-driven init
- `ILL.SCHEMA.SEED.LOADING` — seed loading walkthrough
- `PROT.SCHEMA.AUGMENT` — additive-only migration for existing databases
