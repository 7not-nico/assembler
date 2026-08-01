---
description: Scaffold operational tools for a bootstrapped DB project
subtask: true
---

Scaffold tools for `$ARGUMENTS`

1. Verify prerequisites — `/db-domain`, `/db-entities`, `/db-properties` must have run first; `.opencode/manifests/domain.md`, `entities.md`, `properties.md` must exist; `.opencode/schemas/db.sql` must exist
2. Read `.opencode/manifests/entities.md` — extract entity types, folders, ID prefix
3. Read `.opencode/manifests/properties.md` — extract field definitions per entity, noting own-table vs main-table columns
4. Read `.opencode/schemas/db.sql` — verify table structure matches entity definitions
5. For each entity, use `question` tool to confirm frontmatter fields (required vs optional) and tag field name

6. Generate `lib/paths.ts` — pure module with project path constants per `REF.LIB.PATH.RESOLUTION`:
   - `PROJECT_ROOT`, `DB_PATH`, `SCHEMA_PATH`
   - Contract block: `// exports:`, `// purity: pure`, `// depends-on: path`
   - Resolve via `join(import.meta.dir, "..", "..")`

7. Generate `lib/errors.ts` — io module with error guards per `REF.LIB.DIRECTORY.LAYER`:
   - `crashOnError()` — hooks `unhandledRejection` + `uncaughtException` → `process.exit(1)`
   - `exitWith(msg, code)` — prints error and exits
   - Contract block: `// exports:`, `// purity: io`, `// depends-on: none`

8. Generate `lib/db.ts` — impure DB module per `REF.LIB.DIRECTORY.LAYER` and `REF.SCHEMA.DATABASE.PRAGMA`:
   - `initDB()` — opens database, sets `PRAGMA journal_mode=WAL`, `PRAGMA foreign_keys=ON`, executes schema
   - `run(db, sql, params)`, `queryAll(db, sql, params)`, `queryOne(db, sql, params)`
   - Contract block: `// exports:`, `// purity: io`, `// depends-on: paths, bun:sqlite, fs`
   - Imports from `./paths` for `DB_PATH` and `SCHEMA_PATH`

9. Generate shebang CLI tools per `PROT.TOOL.MODEL` — one read tool per entity plus sync and note tools:
   - Shebang line `#!/usr/bin/env bun` on line 1
   - `import { crashOnError } from "../lib/errors"` then `crashOnError()` at entry point
   - Named imports from `../lib/` only — cross-tool imports excluded
   - Contract block in first 5 lines (`// exports:`, `// purity: io`, `// depends-on:`)
   - `read-*` / `write-*` prefix per I/O direction

   Generate at minimum:
   - `tools/read-{entities}.ts` — SELECT + `console.table`
   - `tools/write-sync.ts` — scan directories, upsert into DB
   - `tools/write-note.ts` — `process.argv[2]` + INSERT
   - `tools/audit-validate.ts` — scan, validate, report

10. Generate `.opencode/package.json` with `js-yaml` as dependency. Shebang CLI tools omit `@opencode-ai/plugin` at runtime — include it only when the project has root-level Custom IPC tools. Root canonical store is authoritative — skip `bun install`

11. Generate `.opencode/.gitignore`:
    ```
    node_modules/
    *.db-shm
    *.db-wal
    ```

12. Generate `.opencode/AGENTS.md` — project name and type, tool table with invocation style and import paths, entity reference table (table → PK → mutation), purity boundary notes per `REF.LIB.PURITY.BOUNDARY`, dependency note: `node_modules` symlink to root assembler

13. Create `node_modules` symlink: `ln -s ../../.opencode/node_modules .opencode/node_modules`

14. Generate `.opencode/manifests/logic.md` — data flow documentation derived from manifests and schema:
    - Pipeline: `filesystem → sync tool → SQLite DB → read tools → CLI output`
    - Direction: write tools (write-sync, write-note) vs read tools (read-*) vs audit tools (audit-validate)
    - Entity routing: entity type → ID prefix → folder → DB table
    - Mutation: append vs upsert per `REF.LIB.MUTATION.STRATEGY`
    - Migration: additive only, ALTER TABLE ADD COLUMN
    - Validation: audit-validate frontmatter + FK reference check

15. Follow conventions per protocol requirements:
    - All generated `.ts` files include contract blocks per `PROT.LIB.CONTRACT`
    - Tools use shebang CLI format per `PROT.TOOL.MODEL` — Custom IPC excluded for subproject tools
    - `crashOnError()` at every tool entry point per `REF.LIB.DIRECTORY.LAYER`
    - Standard PRAGMAs in every `initDB()` per `REF.SCHEMA.DATABASE.PRAGMA`
    - Pure modules import only from pure modules, builtins, or npm per `REF.LIB.PURITY.BOUNDARY`
    - `db.ts` imports only from `paths.ts` and `bun:sqlite` per `REF.LIB.CONTRACT.VIOLATIONS`
    - `node_modules` uses symlink to root per `REF.TOOL.NODE_MODULES.SHARED`
    - Schema evolves additively — DROP excluded
    - File naming: lowercase, hyphen-separated, max 2 segments
    - `syncDir` uses `INSERT OR REPLACE` — re-running produces identical state

**Generated files**

```
{project}/.opencode/
├── lib/paths.ts
├── lib/errors.ts
├── lib/db.ts
├── tools/read-{entities}.ts
├── tools/write-sync.ts
├── tools/write-note.ts
├── tools/audit-validate.ts
├── manifests/logic.md
├── package.json
├── .gitignore
└── AGENTS.md
```
