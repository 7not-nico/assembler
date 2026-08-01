**Vertical Partitioning (Projection)** — a database query pattern that returns all columns (attributes) for a single row, selected by primary key. In AMANDA, `read-details --id {ID}` performs vertical projection: given an entity ID, it returns every field for that single row — description, trigger, procedure, tags, related, timestamps. Contrasts with horizontal partitioning (selection), which filters rows by criteria. Named for the relational algebra operation π (projection).

---
id: CON.VERTICAL.PARTITIONING
mode: practical
title: Vertical Partitioning (Projection)
source: COG.COMPUTER.SCIENCE
tags: database,projection,partitioning,schema,query,architecture,relational-algebra,tool-pattern

---
