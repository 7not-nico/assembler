# mcp-patlib-vector Dependencies

## Overview

MCP server providing vector search, similarity, keyword search, and reindex tools for patlib entities. Disabled 2026-07-23.

## npm Packages (`package.json`)

| Package | Version | Purpose |
|---------|---------|---------|
| `@modelcontextprotocol/sdk` | ^1.16.0 | MCP server framework (McpServer, StdioServerTransport) |
| `@xenova/transformers` | ^2.17.0 | ONNX inference runtime for embedding model |
| `zod` | ^3.24.0 | Runtime schema validation for tool arguments |

## Built-in (Node/Bun)

| Module | Source | Purpose |
|--------|--------|---------|
| `bun:sqlite` | Bun built-in | Database connections (patlib.db + patlib-vector.db) |

## Shared Libraries (`../../_lib/`)

| Module | Purity | Purpose |
|--------|--------|---------|
| `db` | io | `initDB()` — patlib.db connection with WAL, schema, seeds |
| `vector-db` | io | `initVectorDB()` — vector DB connection with schema migration |
| `entity-paths` | io | `entityMtime()`, `entitySourcePath()` — file path resolution |
| `reindex-entity` | io | `reindexEntityType()` — batch embed, FTS insert, stale cleanup |
| `vector-query` | pure | `cosineSearch()`, `toFtsQuery()`, `entityTable()`, type/scope constants |
| `vector-queries` | io | `queryEmbeddingVectors()`, `queryEntityEmbedding()`, `queryFtsRank()` |
| `rank` | pure | `rrf()` — reciprocal rank fusion for hybrid search |
| `entity-lookup` | io | `getEntityTitle()` — title lookup from patlib.db |
| `read-entities` | io | `readEntityTexts()` — entity text assembly for embedding |

## Local (`./embedder.ts`)

Thin re-export — 7 LOC:
```
export { embed, embedBatch, cosine, computeHashAsync, getModel } from "../../_lib/embedder-onnx"
```

## Transitive (via `_lib/embedder-onnx`)

| Dependency | Source | Purpose |
|-----------|--------|---------|
| `_lib/embedder` | Shared lib | Embedder registry (`setEmbedder`, `embed`, `embedBatch`, etc.) |
| `@xenova/transformers` | npm | Same as direct — loaded lazily on first `embed()` call |
| HuggingFace model | remote | `Xenova/bge-small-en-v1.5` — downloaded on first use (~269ms cold) |

## Dependency Tree

```
mcp-patlib-vector/index.ts
├── @modelcontextprotocol/sdk (npm)
├── zod (npm)
├── bun:sqlite (built-in)
├── ./embedder.ts (thin re-export)
│   └── _lib/embedder-onnx.ts
│       ├── _lib/embedder.ts (registry)
│       └── @xenova/transformers (npm, lazy)
│           └── Xenova/bge-small-en-v1.5 (HuggingFace, lazy)
├── _lib/db.ts
├── _lib/vector-db.ts
│   ├── _lib/paths.ts
│   └── _lib/ensure-vector-schema.ts
├── _lib/entity-paths.ts
├── _lib/reindex-entity.ts
│   ├── _lib/read-entities.ts
│   ├── _lib/vector-query.ts
│   └── _lib/entity-paths.ts
├── _lib/vector-query.ts
├── _lib/vector-queries.ts
├── _lib/rank.ts
├── _lib/entity-lookup.ts
│   └── _lib/vector-query.ts
└── _lib/read-entities.ts
    ├── _lib/entity-text.ts
    └── _lib/entity-paths.ts
```

## Notes

- All `_lib/` modules are shared — not exclusive to this MCP server. The CLI tools (`bench-vectors`, `reindex-vectors`, `search-vectors`, `similar-vectors`) also import from the same modules.
- `_lib/embedder-onnx.ts` registers the ONNX pipeline at module load time via `setEmbedder()` but defers model download/loading to the first `embed()` call.
- The `node_modules/` directory was originally a separate copy (~34MB) before being replaced with a symlink to the shared `.opencode/node_modules/`.
