# Schema split — complete

- [x] Split patlib.sql (259 lines) into 19 individual files by entity type
- [x] Files numbered 00-19, sorted by dependency order
- [x] ALTER TABLE terms ADD COLUMN type in 01-terms.sql (idempotent via try/catch)
- [x] Updated _lib/db.ts: reads SCHEMAS_DIR instead of single patlib.sql
- [x] Updated _lib/paths.ts: SCHEMAS_DIR replaces SCHEMA_PATH
- [x] Verified: all 22 entity tables present with correct row counts
- [x] Verified: journal_mode=WAL preserved

## Post-split
- [x] Old patlib.sql removed from _schemas/
- [x] initDB() reads SCHEMAS_DIR (all .sql files sorted)
- [x] All 17 entity tables verified (369 total entities)
- [ ] IPC tools (read-selection, write-sync) need opencode runtime restart to clear module cache
