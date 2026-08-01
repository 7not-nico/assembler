**SQLite** — the embedded database engine powering every AMANDA project's local storage. Accessible via Bun's built-in `bun:sqlite` module with no additional dependencies. Its migrations are additive-only — `ALTER TABLE ADD COLUMN`, never drops or destructive changes. Each project under `assembler/` gets its own SQLite database file, initialized by `initDB()` which reads a `db.sql` schema file.


---
reference:
---
