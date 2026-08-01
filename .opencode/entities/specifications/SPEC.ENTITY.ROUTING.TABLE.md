**Entity Routing Table** — the first segment of a dot-separated ID determines the entity's storage directory and DB table. Each prefix maps to exactly one table. Frontmatter is the source of truth; the DB is a derived cache.

## Rules

1. **Controlled prefix vocabulary** — every ID's first segment maps to exactly one DB table and one directory. Each prefix is registered in `_rb/patlib.rb` (Ruby) and `_lib/mcp-types.ts` (TypeScript).
2. **One prefix maps to one table** — a single prefix routes to exactly one table. Multiple prefixes may share a table if they share the same schema and abstraction plane.
3. **Declare constants in frontmatter** — frontmatter is the authoritative source. The DB is a read-only derived cache; the file is the sole write target.
4. **Reference entities by full ID only** — `PER.EDSGER.W.DIJKSTRA`, not filename or title.

## Applicability

Use when a project manages two or more entity types that share a database and need consistent routing, type-based validation, and automated integrity checks.

Excluded when a project has a single entity type or uses no database.

---
id: SPEC.ENTITY.ROUTING.TABLE
title: Entity Routing Table — Prefix-to-Type Routing Convention
source: assembler
summary: "The first segment of a dot-separated ID determines the entity's storage directory and DB table. Prefix mapping lives in code registries. Frontmatter is authoritative; the DB is a derived cache."
specifies: Prefix-to-table-to-directory routing convention
tags: [routing, entity, prefix, directory, table, convention, specification]
status: active
---