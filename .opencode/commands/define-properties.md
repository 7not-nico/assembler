---
description: Define database schema via CREATE TABLE statements for a DB workflow project
subtask: true
---

Define properties for `$ARGUMENTS`

1. Review entity manifest from `/db-entities` (`.opencode/manifests/entities.md`)
2. Use question tool for each entity type: what columns go on the entries table? (id, title, summary, plus scalar columns)
3. Use question tool for each entity type: what array fields need their own normalized table?
4. Use question tool for each normalized table: what columns does it need? (id FK + value column + optional metadata)
5. Build CREATE TABLE statements — each entity gets entries table with `id TEXT PRIMARY KEY, title TEXT NOT NULL`. Array fields get normalized table with `id TEXT NOT NULL, value TEXT NOT NULL, PRIMARY KEY (id, value)`. Use `IF NOT EXISTS` for idempotent migration
6. Use question tool: what reference data needs seed rows? (lookup tables, controlled vocabularies, initial entries)
7. Output schema to `{project}/.opencode/schemas/db.sql` — use `--` for comments, include project name and `SQLite` marker
8. Output properties manifest to `{project}/.opencode/manifests/properties.md` with field-level metadata
9. Output seed data to `{project}/.opencode/schemas/seed.sql` — include `-- Seed Data` and `-- INSERT statements (run after schema DDL)` headers. Use `INSERT OR IGNORE` or `INSERT OR REPLACE` per context

**Output templates**

```
-- {Project Name} — Database Schema (DDL only)
-- SQLite

CREATE TABLE IF NOT EXISTS entity_name (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  summary TEXT,
  ...
);

CREATE TABLE IF NOT EXISTS entity_name_field (
  id TEXT NOT NULL,
  value TEXT NOT NULL,
  PRIMARY KEY (id, value)
);
```

```yaml
# properties.md
types:
  $ENTITY_NAME:
    fields:
      - name: $FIELD
        type: string|array
        required: true|false
        own-table: true|false
```

```sql
-- {Project Name} — Seed Data
-- INSERT statements (run after schema DDL)

-- Entity Type
INSERT OR IGNORE INTO table_name (col1, col2, col3) VALUES
  ('val1', 'val2', 'val3'),
  ('val1', 'val2', 'val3');
```
