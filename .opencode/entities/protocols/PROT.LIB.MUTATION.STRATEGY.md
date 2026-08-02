---
id: PROT.LIB.MUTATION.STRATEGY
title: "Lib Mutation Strategy — Schema Changes Add Columns Only"
source: assembler
related: [PROT.SCHEMA.AUGMENT, REF.SCHEMA.MUTATION]
summary: "Database migrations add columns only; existing tables and rows persist. Schema evolution stays additive and non-destructive."
protocol: "Migrations add columns via ALTER TABLE ADD COLUMN. Existing tables and rows persist across changes. Destructive operations stay out of the migration path. Schema evolution proceeds one additive step at a time."
enforcement: Convention
status: active
priority: 2
tags: [schema, migration, mutation, database, additive]
---

Schema changes follow one strategy: add, never destroy. The database evolves by accretion — columns arrive, tables and rows remain.

## Protocol

1. **Migrations add columns only** — `ALTER TABLE ADD COLUMN` carries each change.
2. **Existing tables and rows persist** — no drops, renames, or destructive rewrites in the migration path.
3. **Additive steps sequence** — one column change per migration; steps compose.
4. **Backward compatibility holds** — readers tolerate the previous schema; new columns default safely.
5. **Schema evolution records in the bitacora** — each migration logs its column, table, and purpose.

## Gotchas

- Destructive change proposed: restate as an additive step that preserves existing rows.
- Column rename: add the new column, migrate values, retire the old column later.
- Table rewrite in a migration: split into additive steps that keep the old table readable.

## Enforcement

Convention — the `bun:sqlite` migration review flags destructive statements. The `schema/` seed files document the additive history.

## Applicability

Applies to every database schema change in the assembler and its subprojects. Excluded: brand-new databases, which may define initial tables freely.

## See also

- `PROT.SCHEMA.AUGMENT` — schema augmentation protocol
- `REF.SCHEMA.MUTATION` — mutation reference
- `AGENTS.md` — database migration statement
