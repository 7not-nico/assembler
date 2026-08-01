**Ludoteca** — personal video game catalog at `one-timers/ludoteca/`. Bun + TypeScript, `bun:sqlite`.

Entity types: game, hackrom, emulator, architecture, api, compat, note. Lookup tables: platforms, developers, franchises, licenses, languages, publishers, regions, engines.

MCP (`ludoteca-mcp`) exposes 8 tools:
- **ludoteca_search** / **ludoteca_get** — entity catalog (6 types)
- **ludoteca_refs** / **ludoteca_get_ref** — reference tables (8 types)
- **ludoteca_notes** / **ludoteca_get_note** — notes by text/tag/ref
- **ludoteca_stats** — aggregate counts + dimension tables
- **ludoteca_validate** — schema, frontmatter, FK validation

Shared lib handlers in `.opencode/lib/` — 8 total:

**Read handlers** (io → pure-formatter → transport):
- `entity-search.ts` — `searchEntities`, `getEntityDetail`
- `reference-search.ts` — `searchReference`, `getReference`
- `notes-search.ts` — `searchNotes`, `getNote`
- `entity-stats.ts` — `computeStats`
- `entity-validate.ts` — `runValidate`

**Write handlers** (normalize → serialize → write → sync → message):
- `entity-sync.ts` — `syncEntities` — syncs .md files to DB
- `entity-write.ts` — `createEntity` — creates entity .md with frontmatter and syncs
- `reference-write.ts` — `addReference` — appends seed file and inserts to DB

OpenCode plugins at `.opencode/plugins/` — 3 tools form the write layer:

| Plugin | Tool | Purpose | Handler |
|--------|------|---------|---------|
| `ludoteca-sync.ts` | `ludoteca_sync` | Sync .md → DB | `entity-sync.ts` |
| `ludoteca-add-reference.ts` | `ludoteca_add_reference` | Add seed data (FK prereq) | `reference-write.ts` |
| `ludoteca-create-entity.ts` | `ludoteca_create_entity` | Create entity .md + sync | `entity-write.ts` |

Entity lifecycle (plugin path): `ludoteca_add_reference` → `ludoteca_create_entity` → `ludoteca_validate`.

---

id: TERM.LUDOTECA
title: Ludoteca
source: CON.GAME.FRAMEWORK
tags: database, schema, entity, videogames
reference:
  - title: Ludoteca AGENTS.md
    url: https://github.com/eddyr/assembler/tree/main/one-timers/ludoteca/AGENTS.md
  - title: Ludoteca DB schema — db.sql
    url: https://github.com/eddyr/assembler/tree/main/one-timers/ludoteca/.opencode/schemas/db.sql
  - title: Bun SQLite documentation
    url: https://bun.sh/docs/api/sqlite
related: [CON.GAME.FRAMEWORK, TERM.PURITY.PROTOCOL, NEX.PLUGIN.WRITE.LAYER, NEX.LIB.HANDLER.STACK, REF.SCHEMA.SEED.REFERENCE, PAT.SCHEMA.SEED.RELOAD, PROT.SCHEMA.AUGMENT]
---
