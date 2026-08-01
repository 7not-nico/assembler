---
id: REF.SCHEMA.OWNERSHIP
title: "DB Ownership — Queryable Domain Persistence"
source: PROT.SCHEMA.AUGMENT
related: []
summary: "A subproject receives its own .db when its domain produces information that requires queryable, persistent retrieval across sessions. The DB stores domain data; configuration and ephemeral state use other mechanisms."
ref: "A subproject receives its own .db when: (a) its domain produces information that survives longer than a single tool invocation, (b) the information needs structured querying (SELECT, JOIN, aggregation), and (c) the data is domain-specific — separate from cross-project infrastructure and reference data. The .db stores domain entities and their relationships. Patlib stores cross-project reference data, patterns, terms, and entity metadata. Patlib and project DBs complement each other: patlib describes the architecture; the project DB holds domain instances."
tags: [database, ownership, persistence, architecture, bootstrap, convention, domain]
---

A project's `.db` persists domain data. Patlib holds architecture; the project DB holds instances.

## Protocol

1. **DB criterion — retrievable domain persistence** — a subproject requires its own `.db` when three conditions hold together: (a) data survival across tool invocations, (b) structured query requirement (SELECT, JOIN, aggregation, filtering), (c) domain-specific data separate from cross-project infrastructure.

2. **DB stores domain entities and relations** — the `.db` file holds structured data produced by the subproject's domain. Data model, schema, and query patterns derive from domain analysis — tool convenience excluded.

3. **Patlib stores cross-project reference data** — entity definitions (patterns, terms, protocols), configuration values shared across projects, and architectural metadata belong in `patlib.db`. A project DB duplicates patlib data excluded.

4. **DB excluded for configuration** — project configuration (default paths, env vars, feature flags, constants) uses tool defaults, env variables, or rule files. Use domain data, config excluded from `.db`.

5. **DB excluded for ephemeral state** — intermediate computation results, single-invocation caches, and temporary aggregations stay in memory or temporary files. Use data outlasting the tool process in `.db`.

6. **DB created at project bootstrap** — when a subproject satisfies criterion 1, create its `.db` during initial `initDB()` call alongside schema tables. Additive migration per the additive-only migration convention.

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| DB as config store | `.db` table contains default paths, env values, or feature flags | Store in tool defaults, env vars, or rule files — `.db` for domain data, configuration excluded |
| DB for ephemeral cache | `.db` table created and dropped per invocation | Keep intermediate computation in memory or temp files — `.db` persists across invocations |
| DB when patlib owns the data | Project DB contains entity metadata or cross-project reference data | Create at `patlib.db` instead — entity metadata and reference data in patlib, project-local DB excluded |
| No DB when data needs querying | Subproject stores domain records in flat files with manual grep/sort | Create `.db` with schema tables — structured querying justifies persistence per criterion 1 |
| DB created without schema | Bare `new Database(path)` with no `CREATE TABLE` | Follow `PROT.SCHEMA.AUGMENT` — define schema tables at initDB(), add columns via ALTER TABLE |

## Enforcement

`audit-tool` and project bootstrap check: subprojects with domain data needing queryable persistence should have a `.db` file. Projects with `.db` hold domain data — config and cache excluded. Review at project creation and during audits.

## Applicability

Any AMANDA subproject under `assembler/one-timers/` whose domain produces persistent, queryable information. Also applies to new projects created via `bootstrap-db` or `scaffold-tools` workflow.

Excluded for:
- Root `patlib.db` — governed by patlib protocols, project DB ownership excluded
- Projects storing data in flat file formats (CSV, JSON) without query requirements
- Projects whose domain data consists entirely of configuration or ephemeral state

## See also

- `PROT.SCHEMA.AUGMENT` — additive-only schema migration; applies to all .db files
- `PROT.LIB.DIRECTORY.LAYER` — subproject `lib/db.ts` module; the DB init code lives here
- `PROT.LIB.MUTATION.STRATEGY` — append vs upsert; mutation patterns for project DB tables
- `PROT.LIB.PURITY.BOUNDARY` — DB access is impure; project lib/ separates DB from pure logic
- `PROT.META.ENTITY.ROOT` — entity definitions at root; project DB holds domain instances
- `bootstrap-db` skill — project bootstrap with DB creation workflow
