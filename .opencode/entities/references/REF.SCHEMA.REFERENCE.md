---
id: REF.SCHEMA.REFERENCE
title: Lookup Table — Normalize Reference Metadata
source: PROT.SCHEMA.FORMAT
summary: Normalize reference metadata into dedicated tables with PK and seed data, avoiding free-text inconsistency.
ref: Normalize reference metadata into dedicated tables with PK and seed data.
related: []
tags: [schema, database, normalization, reference-data]
---

Normalize reference metadata into dedicated tables with TEXT PRIMARY KEY. Entity fields that reference shared values (languages, licenses, publishers, regions) use free text by default, leading to inconsistency and missing metadata. Lookup tables centralize each reference type.

## Rules

1. **Separate table per reference type** — each reusable value set gets its own table with its own PK.
2. **Seed via sorted SQL files** — reference data lives in `schemas/seeds/` and loads on every `initDB()` call via `INSERT OR REPLACE`.
3. **FK constraint in DDL only** — new databases get FK references. Existing databases use additive-only migration; seed data guarantees referential integrity.
4. **Multi-value fields use TEXT** — when a field stores multiple values (comma-separated or normalized array), no FK constraint applies. The lookup table serves as documentation and seed reference.

## Applicability

Projects using `bun:sqlite` with shared reference values referenced across entities. Used in ludoteca for licenses, languages, publishers, regions, and engines.

## See also

- PAT.SCHEMA.SEED.RELOAD — seed loading mechanism
- PROT.SCHEMA.AUGMENT — column addition strategy for existing databases
- TERM.LUDOTECA — reference data in practice
