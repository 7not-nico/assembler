---
id: ILL.SCHEMA.CONFIGURE
title: "Schema Pragma Configure — WAL and Foreign Keys Setup"
source: PROT.SCHEMA.AUGMENT
summary: "Walkthrough of configuring standard SQLite PRAGMAs — WAL mode for concurrent reads, foreign_keys for referential integrity."
illustration: "A new database connection sets PRAGMA journal_mode=WAL and PRAGMA foreign_keys=ON before any schema execution or query."
illustrates: [REF.SCHEMA.DATABASE.PRAGMA]
tags: schema,pragma,walkthrough,configure,sqlite,wal,foreign-keys
related: [REF.SCHEMA.DATABASE.PRAGMA, REF.SCHEMA.DATABASE.OWNERSHIP, PROT.SCHEMA.AUGMENT]
---
## Context

A new MCP server opens a SQLite database for entity search. The database needs WAL mode for concurrent read access and foreign key enforcement for referential integrity. Both PRAGMAs are set before any schema execution or query.

## Walkthrough

1. Open the database connection with `new Database(path)`.

2. Set `PRAGMA journal_mode=WAL` first. WAL (Write-Ahead Log) allows concurrent reads while a write is in progress — readers continue on the old snapshot instead of blocking.

3. Set `PRAGMA foreign_keys=ON`. Foreign key enforcement is off by default in SQLite. Without it, INSERT statements referencing nonexistent parent rows succeed silently.

4. Execute schema DDL and seed files after the PRAGMAs. The PRAGMAs apply to the current connection and persist for its lifetime.

```ts
import { Database } from "bun:sqlite"

export function initSearchDB(): Database {
  const db = new Database("search.db")
  db.exec("PRAGMA journal_mode=WAL")
  db.exec("PRAGMA foreign_keys=ON")
  db.exec(readFileSync("schemas/search.sql", "utf-8"))
  return db
}
```

5. The same pattern applies to every database connection across the project — root `patlib.db`, subproject databases, and MCP server databases.

## Key insight

Two PRAGMAs set before any operation define the database's operational contract. WAL makes concurrent reads safe — essential for MCP servers where multiple tools share the same process. Foreign keys catch referential violations at write time instead of accumulating orphaned rows.

## See also

- `REF.SCHEMA.DATABASE.PRAGMA` — abstract PRAGMA convention
- `REF.SCHEMA.DATABASE.OWNERSHIP` — DB ownership criterion
- `ILL.SCHEMA.OWNERSHIP.DECIDE` — DB ownership decision walkthrough
- `PROT.SCHEMA.AUGMENT` — additive-only migration
