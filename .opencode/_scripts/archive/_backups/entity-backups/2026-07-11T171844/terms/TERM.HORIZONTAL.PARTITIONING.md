**Horizontal Partitioning (Selection)** — a database query pattern that filters rows by criteria (tag, source, query text), returning a narrow set of columns (id, title, source, tags) for each matching row. In AMANDA, `read-list --type {entity} --tag {tag} --query {text}` performs horizontal selection: it chooses which rows to keep based on predicates, then projects a consistent subset of columns. Contrasts with vertical partitioning (projection), which returns all columns for a single row. Named for the relational algebra operation σ (selection).

---
id: TERM.HORIZONTAL.PARTITIONING
title: Horizontal Partitioning (Selection)
source: assembler
tags: [database, selection, partitioning, filter, query, architecture, relational-algebra, tool-pattern]
terms: [TERM.VERTICAL.PARTITIONING]
patterns: []
related: []
reference:
  - title: read-list tool — Filters rows by criteria, returns narrow projection
    url: https://opencode.ai/docs
  - title: PAT.ENTITY-TYPE-ROUTING — Entity type as selection criterion
    url: https://opencode.ai/docs
  - title: Selection (relational algebra) — Wikipedia
    url: https://en.wikipedia.org/wiki/Selection_(relational_algebra)
  - title: Relational Algebra — Stanford CS145
    url: https://cs145-files.stanford.edu/
---