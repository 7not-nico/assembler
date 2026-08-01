**Horizontal Partitioning (Selection)** — a database query pattern that filters rows by criteria (tag, source, query text), returning a narrow set of columns (id, title, source, tags) for each matching row. In AMANDA, `read-list --type {entity} --tag {tag} --query {text}` performs horizontal selection: it chooses which rows to keep based on predicates, then projects a consistent subset of columns. Contrasts with vertical partitioning (projection), which returns all columns for a single row. Named for the relational algebra operation σ (selection).

---
id: CON.HORIZONTAL.PARTITIONING
mode: practical
title: Horizontal Partitioning (Selection)
source: COG.COMPUTER.SCIENCE
tags: database,selection,partitioning,filter,query,architecture,relational-algebra,tool-pattern

---
