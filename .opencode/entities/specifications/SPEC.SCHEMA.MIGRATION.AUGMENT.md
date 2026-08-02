**Schema Migration Augment** — all schema migrations add columns via `ALTER TABLE ADD COLUMN` only. Never drop or rebuild tables. Production databases contain data that must survive schema changes. A table rebuild risks data loss and breaks tooling assumptions.

## Rules

- `ALTER TABLE ADD COLUMN` only — all migrations add nullable TEXT or INTEGER columns. Column drops, table rebuilds, and type changes are excluded.
- DDL for new databases — `schemas/db.sql` contains the full `CREATE TABLE` with all current columns, including FK references.
- Migrate logic for existing databases — `ensure()` checks `PRAGMA table_info` and adds missing columns. Re-runnable.
- Each database connection sets `PRAGMA foreign_keys = ON` at open.
- Seed data guarantees every FK value that a reference names exists in existing databases.

## Limitations

SQLite does not support `ALTER TABLE ADD CONSTRAINT`. FK constraints in `CREATE TABLE` apply to new databases only. Existing databases rely on seed data for referential integrity.

## Applicability

Any SQLite project using additive-only schema evolution.

---
id: SPEC.SCHEMA.MIGRATION.AUGMENT
title: Schema Migration Augment — Additive-Only Migration
source: assembler
summary: "Add schema columns via ALTER TABLE ADD COLUMN only, never drop or rebuild. DDL covers new databases; migration logic handles existing."
specifies: Additive-only ALTER TABLE ADD COLUMN migration rules
tags: [migration, database, schema, sqlite, specification]
status: active
---
