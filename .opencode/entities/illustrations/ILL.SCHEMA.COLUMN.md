---
id: ILL.SCHEMA.COLUMN
title: "Add Column — ALTER TABLE ADD COLUMN Walkthrough"
source: PROT.SCHEMA.AUGMENT
summary: "Walkthrough of adding a column to an existing schema table using additive-only migration — DDL for new databases and migrate.ts for existing."
illustration: "A new column needs to track a content hash on the terms table. DDL covers new databases; ensure() adds the column for existing databases."
illustrates: [PROT.SCHEMA.AUGMENT]
tags: schema,migration,column,walkthrough,database
related: [REF.SCHEMA.DATABASE.PRAGMA, PROT.SCHEMA.FORMAT]
---
## Rationale

The terms table needs a `content_hash TEXT` column to track entity changes for incremental reindexing. The database already exists for current users — a migration strategy is required that works for both new and existing databases.

## Walkthrough

1. Add the column to the DDL in `schemas/db.sql`. New databases created after this change include the column in the initial `CREATE TABLE`.

```sql
CREATE TABLE terms (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  term_id TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  body TEXT,
  content_hash TEXT  -- NEW: SHA-256 of concatenated source fields
);
```

2. Add an `ensure()` call for existing databases. The function checks `PRAGMA table_info(terms)` and runs `ALTER TABLE ADD COLUMN` if the column is absent.

```ts
export function ensureTermsSchema(db: Database): void {
  const columns = db.query("PRAGMA table_info(terms)").all() as ColumnInfo[]
  const hasHash = columns.some(c => c.name === "content_hash")
  if (!hasHash) {
    db.run("ALTER TABLE terms ADD COLUMN content_hash TEXT")
  }
}
```

3. Call `ensureTermsSchema()` in the initialization sequence, after opening the database and before any queries. The function is idempotent — subsequent runs find the column present and skip the ALTER TABLE.

4. Verify the migration by running `PRAGMA table_info(terms)` to confirm the column exists in both new and existing databases.

## Key insight

The additive-only strategy handles both scenarios with one code path. New databases get the column from DDL. Existing databases migrate via `ensure()`. No schema versioning, no migration chain, no data loss. The `ensure()` function is safe to run on every database open.

## See also

- `PROT.SCHEMA.AUGMENT` — additive-only migration pattern
- `REF.SCHEMA.DATABASE.PRAGMA` — PRAGMA conventions
- `PROT.SCHEMA.FORMAT` — seed file format
- `ILL.LIB.CONTRACT.BLOCK` — module contract declaration walkthrough
