**SQLite REFERENCES** — a declarative foreign key constraint in the `column-def` of `CREATE TABLE` or `ALTER TABLE`. Syntax: `REFERENCES foreign-table (column-name)` with optional `ON DELETE` / `ON UPDATE` actions (`SET NULL`, `SET DEFAULT`, `CASCADE`, `RESTRICT`, `NO ACTION`). Referenced column must be `PRIMARY KEY` or have a `UNIQUE` constraint. Supports composite and deferred foreign keys. Enforcement is **off by default** — each connection must run `PRAGMA foreign_keys = ON;`. `ALTER TABLE ... ADD COLUMN` with `REFERENCES` requires `DEFAULT NULL` in SQLite versions before 3.43.0.

---
id: TERM.SQLITE.REFERENCES
title: SQLite REFERENCES
source: sqlite.org
tags: [sqlite, foreign-key, constraint, schema, database]
terms: [TERM.SQLITE.STORAGE.CLASSES]
patterns: []
related: []
reference:
  - title: SQLite Foreign Key Support
    url: https://sqlite.org/foreignkeys.html
  - title: SQLite CREATE TABLE Syntax
    url: https://sqlite.org/lang_createtable.html
  - title: SQLite Language Reference Index
    url: https://sqlite.org/lang.html
---