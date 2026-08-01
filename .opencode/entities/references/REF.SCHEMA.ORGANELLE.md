---
id: REF.SCHEMA.ORGANELLE
title: Seed Organelle Declaration — Compartmentalized Seed Files
source: PROT.SCHEMA.FORMAT
summary: Seed files declare an organelle header block identifying membrane type, registration identity, and channel dependencies.
ref: Every seed file declares its compartment boundaries in an organelle header block, making dependency ordering explicit and enabling automated topo-sort.
related: []
tags: [schema, seed, organelle, compartment, dependency, ordering]
---

Seed files are compartments within the schema substrate. Each file declares its boundary in a header block.

## Rules

1. **Header block format** — seed files carry an organelle header delimited by `=====` comment lines. The block declares membrane type, registration tuple, and channel targets:

   ```sql
   -- ==========================================
   -- membrane: {type}
   -- registration:
   --   file: {filename}
   --   title: {human-readable title}
   --   membrane: {type}
   -- channel:
   --   target: {upstream-filename}
   -- ==========================================
   ```

   Lines use `--` SQL comment syntax. The `=====` delimiter visually separates the block from SQL body.

2. **Registration tuple** — exactly 3 fields: `file` (filename), `title` (description), `membrane` (type). Matches `PROT.META.COMPARTMENT.SPECIALIZATION` registration field count requirement.

3. **Membrane type** — always `shared-substrate` for seed files in a SQLite substrate. Values per `PROT.META.COMPARTMENT.SPECIALIZATION`: `autonomous` (double-membrane, own DB), `shared-substrate` (single-membrane, same DB), `infrastructure` (no membrane, ubiquitous).

4. **Channel targets** — each `target:` names an upstream seed file that this file depends on (typically via FK). The DDL file (`00-ddl.sql`) is the root — it has zero outgoing channels or uses `target: (none)`. Non-DDL seed files may have zero or one outgoing channel.

5. **Channel DAG** — the channel graph forms a directed acyclic graph. Circular channels are excluded. The graph mirrors FK dependency direction.

6. **Optionality** — the block is non-normative. Seeds without a block execute, validate, and correct identically. The block documents intent and enables future automated dependency resolution.

## See also

- `ILL.SCHEMA.ORGANELLE.DECLARE` — walkthrough of adding an organelle header block to a seed file
- `PROT.SCHEMA.FORMAT` — seed file format, references this pattern for organelle blocks
- `PROT.META.COMPARTMENT.SPECIALIZATION` — compartment membrane types and registration field count
- `PROT.SCHEMA.FOLDER` — schema folder structure governing seed file placement
- `PROT.SCHEMA.SEED.MUTATION` — prefix-based mutation strategy for seed files
