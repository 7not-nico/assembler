---
id: PRE.SYNC.STALE.CLEANUP
title: Sync Stale Cleanup — UPSERT Alone Is Insufficient
source: assembler
summary: "Every sync operation must delete DB rows whose IDs no longer correspond to source files. INSERT ON CONFLICT only upserts. Stale rows accumulate silently and produce ghost results."
precept: "UPSERT adds and updates but never removes. After every sync pass, DELETE rows whose IDs are absent from the current source file set. Stale rows produce ghost results in search, broken cross-references, and false entity counts."
enforcement: Tool
tags: [database, sync, cleanup, staleness, consistency, migration]
status: active
priority: 2
---

**Sync Stale Cleanup** — UPSERT alone is insufficient. DELETE stale rows after every sync pass.

## Corollaries

- Every sync function that reads a directory of source files must delete DB rows whose IDs do not appear in the current directory
- The cleanup runs after the UPSERT loop, not before. This ensures the DELETE excludes rows that were just inserted or updated
- For empty directories, DELETE all rows in the corresponding table. An empty directory means no entities of that type exist
- Junction tables (entity_terms, entity_patterns) are cleaned by the source type's syncJunction — no additional cleanup needed
- During entity reclassification (TERM→COG, etc.), run stale cleanup on both the source table and the target table

## Applicability

All sync functions across all projects: `syncTable()` in `_lib/sync.ts`, subproject sync modules, and any code that mirrors a filesystem directory into a DB table.
