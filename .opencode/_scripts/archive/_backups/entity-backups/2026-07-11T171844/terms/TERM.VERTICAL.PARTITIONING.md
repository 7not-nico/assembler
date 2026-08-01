**Vertical Partitioning (Projection)** — a database query pattern that returns all columns (attributes) for a single row, selected by primary key. In AMANDA, `read-details --id {ID}` performs vertical projection: given an entity ID, it returns every field for that single row — description, trigger, procedure, tags, related, timestamps. Contrasts with horizontal partitioning (selection), which filters rows by criteria. Named for the relational algebra operation π (projection).

---
id: TERM.VERTICAL.PARTITIONING
title: Vertical Partitioning (Projection)
source: assembler
tags: [database, projection, partitioning, schema, query, architecture, relational-algebra, tool-pattern]
terms: [TERM.HORIZONTAL.PARTITIONING]
patterns: []
related: []
reference:
  - title: read-details tool — Returns all columns for one entity
    url: https://opencode.ai/docs
  - title: PAT.ORTHOGONALITY — Read/Write tool separation
    url: https://opencode.ai/docs
  - title: Projection (relational algebra) — Wikipedia
    url: https://en.wikipedia.org/wiki/Projection_(relational_algebra)
  - title: PAT.ENTITY-TYPE-ROUTING — Entity ID as selection key
    url: https://opencode.ai/docs
---