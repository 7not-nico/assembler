**SQLite Storage Classes** — SQLite assigns each stored value one of five **storage classes** — **NULL**, **INTEGER**, **REAL**, **TEXT**, or **BLOB** — that determine how it is represented on disk. Unlike rigid SQL type systems, SQLite uses **manifest typing** — the storage class travels with the value, not the column — while **type affinity** guides how values coerce between classes during insertion and retrieval.

---
id: TERM.SQLITE.STORAGE.CLASSES
title: SQLite Storage Classes
source: sqlite.org
tags: [sqlite, database, storage-classes, manifest-typing, type-affinity, flexible-typing, data-types]
terms: []
patterns: [PAT.SQLITE.PARAM.BINDING, PAT.MUTATION.PATTERN]
related: []
reference:
  - title: Datatypes In SQLite (version 3)
    url: https://www.sqlite.org/datatype3.html
  - title: SQLite File Format — Record Format
    url: https://www.sqlite.org/fileformat2.html#record_format
  - title: Flexible Typing Is A Feature
    url: https://www.sqlite.org/flextyping.html
---