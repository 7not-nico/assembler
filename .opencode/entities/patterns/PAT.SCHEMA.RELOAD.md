---
id: PAT.SCHEMA.RELOAD
title: Seed-Driven Init — Idempotent Reference Data Loading
source: NEX.SCHEMA.PIPELINE
summary: Load reference data via sorted SQL seed files on every initDB() call, ensuring idempotent and consistent initialization.
morphism: GENR — load reference data via sorted SQL files on every initDB() call.
enforcement: Convention
tags: [database, init, workflow, seed-data]
status: active
priority: 3
---

Load reference data via sorted SQL seed files on every `initDB()` call. Reference data must exist before entity creation; manual inserts cause drift across environments.

## Rules

1. **Seed files in `schemas/seeds/`** — each lookup table has a corresponding seed file with numeric prefix for sort order.
2. **Sorted alphabetical load** — `initDB()` reads all `.sql` files from the seeds directory sorted by name and executes them in order, ensuring platform seeds load before entity seeds.
3. **Idempotent inserts** — use `INSERT OR REPLACE` so re-running seeds updates existing rows without errors.
4. **Additive only** — removing a seed file does not delete its data. Clean rebuild requires deleting the DB file.
5. **DDL runs before seeds** — `initDB()` executes schema DDL first, then migrations, then seeds.

## Applicability

Projects using `initDB()` pattern with `bun:sqlite`. Used in ludoteca for 9 seed files (platforms, developers, franchises, mcp_features, licenses, languages, publishers, regions, engines).

## See also

- REF.SCHEMA.SEED.REFERENCE — lookup tables populated by seeds
- PROT.SCHEMA.AUGMENT — schema changes before seeds
- TERM.LUDOTECA — seed-driven init in practice
