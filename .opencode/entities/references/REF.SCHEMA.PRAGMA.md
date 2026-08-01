---
id: REF.SCHEMA.PRAGMA
title: "SQLite PRAGMA Conventions — Standard Connection Settings"
source: PROT.SCHEMA.AUGMENT
related: [PROT.SCHEMA.DATABASE.OWNERSHIP, PROT.MCP.TRANSPORT]
summary: "Every subproject SQLite database sets WAL journal mode, busy timeout, and foreign keys at connection time. Additional PRAGMAs are additive and declared per project need."
ref: "Every initDB() call across all subproject SQLite databases sets a standard set of PRAGMAs. WAL journal mode enables concurrent readers. Busy timeout prevents SQLITE_BUSY errors under concurrent load. Foreign key enforcement maintains referential integrity. Additional PRAGMAs are additive and declared per project need. WAL-sidecar files are lifecycle-managed per project convention."
tags: [database, sqlite, pragma, connection, convention, bootstrap]
---

Standard connection settings applied to every subproject database at init time.

## Protocol

1. **Set WAL journal mode at connection** — `PRAGMA journal_mode=WAL` enables concurrent readers with serialized writes. Set during `initDB()` before schema execution. WAL mode is the standard for all subproject databases.

2. **Set busy timeout** — `PRAGMA busy_timeout=5000` prevents `SQLITE_BUSY` errors by waiting up to 5 seconds for the write lock. Set during `initDB()` after WAL mode, before foreign keys.

3. **Enable foreign key enforcement** — `PRAGMA foreign_keys=ON` guarantees referential integrity across tables. Set during `initDB()` after busy timeout. Foreign key enforcement applies per-connection.

4. **Additional PRAGMAs are additive** — project-specific PRAGMAs add to the standard set. Standard PRAGMAs remain first and in order: WAL → busy_timeout → foreign_keys. Project PRAGMAs follow.

5. **WAL sidecar files follow project lifecycle** — WAL mode creates `-shm` and `-wal` files alongside the `.db`. These files are transient and contain no durable state. Delete them when the database is idle. Add `*.db-shm` and `*.db-wal` to the project `.gitignore` when version control is in use.

6. **Enforcement via audit** — `audit-tool` or project-specific audit tools verify all three standard PRAGMAs are present in `initDB()` during review. Absence of any standard PRAGMA is a structural violation.

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Missing WAL mode in `initDB()` | `initDB()` function has no `PRAGMA journal_mode=WAL` call | Add WAL mode as first PRAGMA in `initDB()` — before `busy_timeout` and `foreign_keys` |
| Missing busy timeout | `initDB()` function has no `PRAGMA busy_timeout=5000` call | Add busy timeout after WAL mode — prevents SQLITE_BUSY under concurrent load |
| Missing foreign key enforcement | `initDB()` function has no `PRAGMA foreign_keys=ON` call | Add foreign key PRAGMA after busy timeout — referential integrity requires explicit per-connection enforcement |
| WAL sidecar files committed to version control | `.gitignore` lacks entries for `*.db-shm` and `*.db-wal` | Add sidecar patterns to `.gitignore` — these files are transient and contain no durable state |
| Non-standard PRAGMA before standard pair | A project-specific PRAGMA appears before `journal_mode` or `foreign_keys` | Reorder PRAGMAs — standard pair first, project-specific additions follow |
| PRAGMA set per-query instead of per-connection | `db.exec("PRAGMA ...")` repeated inside individual query functions | Set PRAGMAs once in `initDB()` — they persist per-connection until close |

## Enforcement

`audit-tool` verifies every subproject `.opencode/lib/db.ts` contains all three standard PRAGMAs in `initDB()` in order: `journal_mode=WAL` → `busy_timeout=5000` → `foreign_keys=ON`. Absence of any standard PRAGMA is a structural violation. WAL sidecar patterns in `.gitignore` are reviewed during project bootstrap.

## Applicability

Every AMANDA subproject with a SQLite database. MCP server databases follow separate guidance per `PROT.MCP.TRANSPORT` rule 4 (WAL mode required, concurrent reader pattern). Single-connection databases without concurrent read needs may still set WAL mode for consistency.

## See also

- `PROT.SCHEMA.DATABASE.OWNERSHIP` — determines when a subproject requires its own `.db`
- `PROT.MCP.TRANSPORT` — WAL mode requirement for MCP servers with concurrent dispatch
- `bootstrap-db` skill — generates `lib/db.ts` with standard PRAGMAs at project bootstrap
