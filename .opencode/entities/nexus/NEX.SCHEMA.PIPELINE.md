---
id: NEX.SCHEMA.PIPELINE
title: "Seed Data Pipeline Convention — Compute-Execute Layer Split"
source: assembler
summary: "Seed data insertion splits into a read-only compute layer and a write-only execute layer. Compute validates and generates SQL. Execute appends and runs. SQL string is the contract boundary."
composition: "Seed data insertion uses two layers: a read-only compute layer and a write-only execute layer. Compute layer validates input against DDL and generates INSERT SQL. Execute layer appends to seed file and runs against database. SQL string is the contract boundary between layers. Compute layer holds correctness responsibility. Execute layer holds safety responsibility. Layer overlap: excluded."
enforcement: Convention
status: active
priority: 3
tags: [schema, seed, pipeline, mcp, plugin, architecture]
---

Seed data insertion divides into two isolated layers. Compute generates; execute applies.

## Protocol

1. **Two-layer separation** — seed data insertion uses a read-only compute layer and a write-only execute layer.
2. **Compute layer scope** — compute layer validates input against DDL schema, inspects existing data structures, and generates `INSERT` SQL. Write operations: excluded.
3. **Execute layer scope** — execute layer appends to seed file and runs against the database. Input validation: excluded beyond basic safety checks.
4. **Contract boundary** — the `INSERT` SQL string is the contract boundary between compute and execute layers.
5. **Responsibility split** — compute layer holds correctness responsibility. Execute layer holds safety responsibility.
6. **Safety checks scope** — execute layer safety checks: seed-managed table, correct statement type, successful database execution.

## Rationale

- Two-layer split follows the read-only / write-only tier separation
- SQL string as contract boundary is explicit, testable, and language-agnostic
- Compute handles complexity (DDL parsing, validation); execute stays simple (append + run)
- Agent inspects compute output before calling execute — validation is visible and auditable

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Execute layer re-validates input already validated by compute layer | Duplicate validation logic in both layers | Remove duplicate — compute layer holds correctness responsibility |
| Compute layer writes to seed file or database | File write or DB mutation in compute layer | Delegate writes to execute layer |
| Execute layer receives a non-seed table | Table name absent from seed-managed list | Route to entity creation pipeline instead |
| Database constraint violation on execution | Table-level constraint failure error returned | Return error as operation result — indicates compute layer gap |

## Enforcement

Code review during pipeline setup. Each new implementation of the pipeline pattern is reviewed for layer separation: compute reads only, execute writes only. The compute layer is validated independently against DDL at startup.

## Applicability

Any AMANDA subproject that inserts seed data programmatically via MCP server and plugin.

## See also

- `ILL.SEED.PIPELINE.FLOW` — seed pipeline walkthrough — compute-execute with ludoteca platforms
- `PROT.SCHEMA.FORMAT` — seed file format conventions
- `REF.SCHEMA.SEED.MUTATION` — seed file mutation strategy
- `PAT.MCP.READONLY` — MCP read-only contract
- `PROT.PLUGIN.WRITE` — plugin write-only contract
