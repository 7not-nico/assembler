**Schema** — the hidden metadata stratum. Declared in DDL files under `_schemas/` and system registries in `_lib/` and `_rb/`. Schema defines what columns, types, and constraints an entity type has. Unlike YAML, schema is not entity-specific — it applies to all entities of a type. Schema is derived programmatically, never duplicated in YAML. When schema changes, every entity of that type implicitly inherits the change.

---
id: IDENTITY.SCHEMA
title: Schema — Hidden Metadata Stratum
source: PROT.METADATA.STRATUM.BOUNDARY
group: project-local
ring: ~
naming: '_schemas/{NN}-{name}.sql'
tags: schema,metadata,hidden,identity,ddl,convention
related: [IDENTITY.YAML, PROT.METADATA.STRATUM.BOUNDARY]
reference:
  - title: PROT.KNOWLEDGE.DIRECTORY.SCHEMA — knowledge directory protocol
    url: https://opencode.ai/docs
  - title: PROT.METADATA.STRATUM.BOUNDARY — superior vs hidden metadata principle
    url: https://opencode.ai/docs
  - title: SQLite DDL Reference
    url: https://sqlite.org/lang_createtable.html
---
