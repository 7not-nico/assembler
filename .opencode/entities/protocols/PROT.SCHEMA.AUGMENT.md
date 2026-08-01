---
id: PROT.SCHEMA.AUGMENT
title: Additive-Only Migration — Add Columns, Never Drop or Rebuild
source: NEX.SCHEMA.PIPELINE
summary: Add schema columns via ALTER TABLE ADD COLUMN only. Never drop or rebuild tables. DDL covers new databases; migrate.ts handles existing.
protocol: Add schema columns via ALTER TABLE ADD COLUMN only, never drop or rebuild.
enforcement: Formality
related: []
tags: [migration, database, schema, sqlite]
status: active
priority: 3
---

Add schema columns via ALTER TABLE ADD COLUMN only. Production databases contain data that must survive schema changes. Rebuilding tables risks data loss and breaks tooling assumptions.

## Rules

1. **ALTER TABLE ADD COLUMN only** — all migrations add nullable TEXT or INTEGER columns. No column drops, table rebuilds, or type changes.
2. **DDL for new databases** — `schemas/db.sql` contains the full CREATE TABLE with all current columns, including FK references.
3. **migrate.ts for existing databases** — `ensure()` checks `PRAGMA table_info` and adds missing columns. Safe to re-run.
4. **Boolean PRAGMA required** — call `PRAGMA foreign_keys = ON` after opening each database connection.
5. **Seeds validate references** — seed data in `schemas/seeds/` guarantees all referenced FK values exist in existing databases.

## Limitations

SQLite does not support ALTER TABLE ADD CONSTRAINT. FK constraints in CREATE TABLE apply to new databases only. Existing databases rely on seed data for referential integrity.

## Applicability

Any SQLite project using additive-only schema evolution. Used in ludoteca for all table migrations.

## See also

- REF.SCHEMA.SEED.REFERENCE — lookup tables requiring migration
- PAT.SCHEMA.SEED.RELOAD — seed data for referential integrity
- PRE.SYNC.STALE.CLEANUP — stale row cleanup after sync
- TERM.LUDOTECA — migration in practice
