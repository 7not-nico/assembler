**SQLite REFERENCES** — a declarative foreign key constraint in the `column-def` of `CREATE TABLE` or `ALTER TABLE`. Syntax: `REFERENCES foreign-table (column-name)` with optional `ON DELETE` / `ON UPDATE` actions (`SET NULL`, `SET DEFAULT`, `CASCADE`, `RESTRICT`, `NO ACTION`). Referenced column must be `PRIMARY KEY` or have a `UNIQUE` constraint. Supports composite and deferred foreign keys. Enforcement is **off by default** — each connection must run `PRAGMA foreign_keys = ON;`. `ALTER TABLE ... ADD COLUMN` with `REFERENCES` requires `DEFAULT NULL` in SQLite versions before 3.43.0.

---
id: CON.SQLITE.REFERENCES
mode: practical
title: SQLite REFERENCES
source: COG.COMPUTER.SCIENCE
tags: sqlite,foreign-key,constraint,schema,database

---
