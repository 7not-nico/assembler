---
id: ILL.SCHEMA.DECLARE
title: "Organelle Declare — Seed File Header Block"
source: PROT.SCHEMA.AUGMENT
summary: "Walkthrough of adding an organelle declaration block to a seed file — membrane type, registration identity, and channel dependencies."
illustration: "A mod-files seed file gets an organelle header block declaring shared-substrate membrane and a channel dependency on the mods seed file."
illustrates: [REF.SCHEMA.SEED.ORGANELLE]
tags: schema,seed,organelle,walkthrough,header,declaration
related: [PROT.SCHEMA.FORMAT, REF.META.COMPARTMENT.SPECIALIZATION, ILL.SCHEMA.SEED.LOADING]
---
## Rationale

Seed files in a shared SQLite substrate need explicit dependency ordering. The organelle header block makes membrane type, registration identity, and channel targets declarative at the top of each seed file — enabling visual scanning and future automated topo-sort. The `=====` delimiter provides a visual scanning anchor. Dependency ordering at a glance replaces manual prefix ordering; automated topo-sort becomes possible.

A seed file `02-mod-files.sql` inserts reference data for mod file manifests. It depends on `01-mods.sql` to have run first — the mod_files table has an FK to the mods table. The organelle block makes this dependency explicit.

## Walkthrough

1. Open the seed file `02-mod-files.sql` and add the organelle header block at the top, before any SQL statements.

```sql
-- ==========================================
-- membrane: shared-substrate
-- registration:
--   file: 02-mod-files.sql
--   title: Mod File Manifest Seed
--   membrane: shared-substrate
-- channel:
--   target: 01-mods.sql
-- ==========================================
```

2. Set the membrane type to `shared-substrate`. All seed files in a single SQLite database use this membrane — they share the same connection and schema.

3. Fill the registration tuple with exactly three fields: `file` (filename), `title` (human-readable description), `membrane` (type). This matches the registration field count requirement from `REF.META.COMPARTMENT.SPECIALIZATION`.

4. Declare the channel dependency. The `target:` field names the upstream seed file (`01-mods.sql`) that must run before this one. The channel mirrors the FK dependency direction.

5. The DDL file `00-ddl.sql` has no outgoing channel — it is the root. Files with no FK dependencies also omit the channel block or use `target: (none)`.

## Key insight

The organelle block documents intent where the numeric prefix only implies ordering. A reader sees the channel line and knows immediately that `02-mod-files.sql` depends on `01-mods.sql`. Future automated dependency resolution can read the block and topo-sort seeds by channel graph.

## See also

- `REF.SCHEMA.SEED.ORGANELLE` — seed organelle declaration pattern
- `PROT.SCHEMA.FORMAT` — seed file format convention
- `REF.META.COMPARTMENT.SPECIALIZATION` — compartment membrane types
- `ILL.SCHEMA.SEED.LOADING` — seed loading walkthrough
