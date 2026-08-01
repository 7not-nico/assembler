---
id: REF.SCHEMA.FOLDER
title: "Schema Folder Structure — DDL Root, Seed Subfolder"
source: PROT.SCHEMA.AUGMENT
related: []
summary: "_schemas/ contains DDL for tables sourced from .md entity files. _schemas/seeds/ contains DDL for tables lacking .md entities plus their data rows."
ref: "Root .sql files define DDL for tables populated via .md entity sync. Seeds/00-ddl.sql defines DDL for tables populated solely by seed files. Seeds/XX-name.sql files contain INSERT statements for those tables."
tags: [convention, schema, seed, data-model, database, storage, architecture]
---

`_schemas/` and `_schemas/seeds/` divide responsibility by data source. Root files hold DDL for tables whose rows come from `.md` entity files. Seed files hold DDL and data for tables without a corresponding entity file.

## Protocol

1. Root `_schemas/*.sql` files contain DDL for tables populated via entity `.md` files (synced by `write-sync`). Root files define the structural contract between the filesystem and the database.
2. `_schemas/seeds/00-ddl.sql` contains DDL for tables whose data is provided entirely by seed files — these tables have no corresponding `.md` entity directory and no `write-sync` source.
3. `_schemas/seeds/XX-name.sql` files contain data — `INSERT OR REPLACE` or `INSERT OR IGNORE` statements — for tables defined in `00-ddl.sql`. Each file covers one cohesive domain.
4. Seed files follow a two-digit numeric prefix (`00-`, `01-`) for deterministic execution order. The prefix is the only ordering mechanism. Dependencies within seeds resolve by prefix order — `00-ddl.sql` runs first, subsequent seeds build on its tables.
5. Tables with a corresponding `.opencode/` entity directory (patterns, terms, skills, protocols, persons, etc.) receive their data via `write-sync` from `.md` files. Seed files populate only tables that lack an entity file representation — these are controlled vocabularies, cross-reference junctions, and other non-entity data.

## Gotchas

| Pattern | Detection | Redirect |
|---------|-----------|----------|
| DDL for a seed-only table placed in root `_schemas/*.sql` | Root file contains CREATE TABLE for a table without a .md entity source | Move to seeds/00-ddl.sql |
| Seed file contains CREATE TABLE | Seed file has a DDL statement | Move DDL to 00-ddl.sql; keep only INSERT in the seed file |
| Table lacks both a root DDL and seeds DDL | Table missing from _schemas/ entirely | Add DDL in the appropriate location based on data source |
| Seed prefix collisions | Two seed files with same numeric prefix | Assign unique prefix per domain |

## Enforcement

By convention during code review. Root `_schemas/*.sql` files provide `CREATE TABLE` statements only — `INSERT` statements excluded from this layer. Seed files provide `INSERT` statements only — `CREATE` and `ALTER` statements excluded. Future audit tools may verify cross-references between entity directories and root schema files.

## Applicability

Every `.opencode/` project within the AMANDA assembler ecosystem.

## See also

- `PROT.TERM.SCHEMA` — entity reference data model built on this folder structure
- `PAT.META.ENTITY.LIFECYCLE` — entity lifecycle state machine
