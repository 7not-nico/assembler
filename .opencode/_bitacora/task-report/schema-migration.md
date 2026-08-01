# Schema Migration Report

## Problem
Monolithic `patlib.sql` (259 lines) caused `ALTER TABLE ADD COLUMN type` to fail on every initDB() call after the first, producing "duplicate column name: type" errors in MCP servers.

## Solution
Split into 19 individual SQL files in `_schemas/`, sorted by numeric prefix. Each file is self-contained and idempotent. `initDB()` iterates all `.sql` files in sorted order, catching "duplicate column name" errors per file.

## Files

| File | Tables |
|------|--------|
| 00-patterns.sql | patterns |
| 01-terms.sql | terms + ALTER type |
| 02-notes.sql | notes |
| 03-meta.sql | meta |
| 04-skills.sql | skills |
| 05-apologias.sql | apologias |
| 06-rules.sql | rules |
| 07-commands.sql | commands |
| 08-abstractions.sql | abstractions |
| 09-linguistics.sql | linguistics |
| 10-protocols.sql | protocols |
| 11-nexus.sql | nexus |
| 12-illustrations.sql | illustrations |
| 13-entity-junctions.sql | entity_terms, entity_patterns |
| 14-maxims.sql | maxims |
| 15-persons.sql | persons, events, person_events |
| 16-refs.sql | refs |
| 17-cognitions.sql | cognitions |
| 18-concepts.sql | concepts |
| 19-definitions.sql | definitions |

## Files Changed

- `_schemas/patlib.sql` — deleted (replaced by 19 files)
- `_lib/db.ts` — initDB() reads SCHEMAS_DIR instead of SCHEMA_PATH
- `_lib/paths.ts` — added SCHEMAS_DIR, removed SCHEMA_PATH

## Verification

All 22 entity tables present with correct row counts. journal_mode=WAL. MCP servers restart to pick up changes.
