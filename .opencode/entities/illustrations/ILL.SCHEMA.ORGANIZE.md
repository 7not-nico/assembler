---
id: ILL.SCHEMA.ORGANIZE
title: "Schema Folder Organize — DDL Root and Seed Subfolder"
source: PROT.SCHEMA.AUGMENT
summary: "Walkthrough of organizing schema files — root DDL for entity-backed tables, seeds/00-ddl.sql for seed-only tables, seeds/XX-name.sql for data."
illustration: "A new project needs schema organization. games table DDL in root schemas/. platforms table DDL in seeds/00-ddl.sql. platform seed data in seeds/01-platforms.sql."
illustrates: [REF.SCHEMA.FOLDER]
tags: schema,folder,walkthrough,organization,ddl,seed
related: [PAT.SCHEMA.SEED.RELOAD, PROT.SCHEMA.FORMAT, ILL.SCHEMA.SEED.LOADING]
---
## Context

A new project needs database schema organization. Some tables are populated by entity `.md` files (synced by `write-sync`). Other tables are populated solely by seed files. The folder structure separates these two data sources.

## Walkthrough

1. Place DDL for entity-backed tables in root `schemas/db.sql`. These tables have a corresponding `.opencode/` entity directory (patterns, terms, etc.). Their rows come from `.md` files via `write-sync`.

```sql
-- schemas/db.sql — entity-backed tables
CREATE TABLE IF NOT EXISTS terms (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  term_id TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  body TEXT
);
```

2. Place DDL for seed-only tables in `schemas/seeds/00-ddl.sql`. These tables have no entity `.md` files. Their data is provided entirely by seed files.

```sql
-- schemas/seeds/00-ddl.sql — seed-only table DDL
CREATE TABLE IF NOT EXISTS platforms (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  release_year INTEGER
);
```

3. Place seed data in `schemas/seeds/01-platforms.sql`. Each file covers one cohesive domain. The two-digit numeric prefix determines execution order.

```sql
INSERT OR REPLACE INTO platforms (id, name, release_year) VALUES
  ('nes', 'Nintendo Entertainment System', 1983),
  ('snes', 'Super Nintendo Entertainment System', 1990);
```

4. The root `schemas/db.sql` changes rarely. Seed files grow over time as controlled vocabularies expand.

## Key insight

The folder structure makes the origin of every row discoverable from the schema file it lives in. Root DDL = entity-sourced rows. `00-ddl.sql` = seed-only tables. `XX-name.sql` = seed data. No single file mixes structural and content concerns.

## See also

- `REF.SCHEMA.FOLDER` — abstract schema folder rules
- `PAT.SCHEMA.SEED.RELOAD` — seed-driven init
- `ILL.SCHEMA.SEED.LOADING` — seed loading walkthrough
- `PROT.SCHEMA.FORMAT` — seed file format convention
