# Shared Lib Usage by Active Tool

Which tools consume which `_lib/` modules.

## Usage Matrix

| `_lib/` module | Used by | Purity |
|----------------|---------|--------|
| `db` | all 17 tools | io |
| `paths` | 7 tools (read-validate, read-projection, audit-*) | io |
| `errors` | 6 tools (read-*, mcp-*, section-extract) | io |
| `audit` | 5 tools (audit-commands, audit-rules, audit-terms, audit-patterns, audit-skills) | io |
| `parse` | 7 tools (audit-*, read-projection) | io |
| `mcp-types` | 1 tool (read-validate) | pure |
| `validate-file` | 1 tool (read-validate) | io |
| `sync` | 1 tool (write-sync) | io |
| `save-session` | auto-discovered (MCP verify?) | io |
| `validate-refs` | auto-discovered | io |
| `validate-events` | auto-discovered | io |
| `validate-persons` | auto-discovered | io |
| `mcp-format` | auto-discovered | pure |
| `mcp-query` | auto-discovered | io |
| `mcp-types` | auto-discovered | pure |
| `vector-*` | **none (all consumers disabled)** | — |
| `embedder-*` | **none (all consumers disabled)** | — |
| `rank` | **none (all consumers disabled)** | — |
| `reindex-entity` | **none (all consumers disabled)** | — |
| `entity-*` | **none (all consumers disabled)** | — |
| `read-entities` | **none (all consumers disabled)** | — |
| `ensure-vector-schema` | **none (all consumers disabled)** | — |
| `vector-bench` | **none (all consumers disabled)** | — |
| `compartment-*` | 1 MCP server (mcp-compartment-audit) | mixed |
| `spec-*` | 1 MCP server (mcp-spec-audit) | mixed |
| `entity-audit`, `entity-format` | 1 MCP server (mcp-entity-audit) | mixed |

## Orphan `_lib/` Modules (All Consumers Disabled)

| Module | LOC | Former consumers |
|--------|-----|------------------|
| `embedder-onnx.ts` | 52 | bench-vectors, search-vectors, mcp-patlib-vector |
| `embedder.ts` | 45 | embedder-onnx (registry) |
| `vector-bench.ts` | 119 | bench-vectors |
| `reindex-entity.ts` | 130 | reindex-vectors, mcp-patlib-vector |
| `vector-db.ts` | 27 | bench-vectors, reindex-vectors, search-vectors, similar-vectors, mcp-patlib-vector |
| `vector-query.ts` | 52 | search-vectors, similar-vectors, mcp-patlib-vector |
| `vector-queries.ts` | 63 | search-vectors, similar-vectors, mcp-patlib-vector |
| `rank.ts` | 40 | search-vectors, mcp-patlib-vector |
| `entity-lookup.ts` | 13 | search-vectors, similar-vectors, mcp-patlib-vector |
| `read-entities.ts` | ~50 | reindex-entity, mcp-patlib-vector |
| `entity-paths.ts` | 58 | reindex-entity, mcp-patlib-vector |
| `ensure-vector-schema.ts` | 67 | vector-db |
| **Total orphan** | **~716 LOC** | |
