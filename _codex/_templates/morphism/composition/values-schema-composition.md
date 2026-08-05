---
id: MORPHISM.COMPOSITION.VALUES.SCHEMA
title: Values Schema Composition — DDL, Seed, Lookup
layer: morphism/composition/
purpose: "A values schema composes three files: 00-ddl.sql defines the table, seed.sql rows the constants, lookup.sh exports them as SCHEMA_* vars — the constants' single home."
naming: values-schema-composition.md
tags: [morphism, composition, schema, values, seed, lookup]
status: active
---
# VALUES-SCHEMA-COMPOSITION.md

**Layer:** morphism/composition/
**Naming:** `values-schema-composition.md` — code morphism, reusable structure.
**Composes with:** `morphism/schema-citation-chain.md` (base form); derived from `study/` + `fixture/` proof.

## Morphism

A values schema composes three files — `00-ddl.sql` (the table), `seed.sql` (the constants as INSERT rows), `lookup.sh` (the export bridge) — so every hardcoded value has one table, one seed, and one citation path.

## Composition

```text
step 1  define    00-ddl.sql   CREATE TABLE shell_values (key, value, description)
step 2  seed      seed.sql     INSERT OR IGNORE INTO shell_values ... VALUES (rows)
step 3  lookup    lookup.sh    parse seed.sql → export SCHEMA_{KEY} env vars
step 4  cite      tools        source lookup.sh, use $SCHEMA_* — never hardcode
```

Invariant: the DDL names the table; the seed rows the constants (9 in the romsfun schema); the lookup exports exactly the seeded keys; a value changes in one place — `seed.sql`.

## Verification

`00-ddl.sql` + `seed.sql` + `lookup.sh` exist under `schema/`; sourcing lookup.sh exports every seeded key as `SCHEMA_{KEY}`; editing a seed row changes the tool's behavior without a tool edit; a tool scanning for hardcoded constants finds only `$SCHEMA_*` references.

## Instance

`instantiator/romsfun/schema/` (2026-08-05) — 9 value rows (CDP ports, CONSOLE_VALID, timeouts, TRACE_HEAD, IMAGE_EXTS, LAUNCH_LOG, FETCH_SELECTOR); 7 tools cite it; committed `fc5feaf` following the `.opencode/_schemas/seeds/` pattern.
