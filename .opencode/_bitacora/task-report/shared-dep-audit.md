# Shared Dependency Audit

## MAX.DRY Compliance

All extracted shared deps follow the registry pattern (PROT.SEARCH.EMBEDDING) and purity rings (MAX.CODE.LAYERS).

## Shared Libs (16 modules)

| _lib/ module | Purity | Used by | Purpose |
|-------------|--------|---------|---------|
| `db.ts` | io | All tools | patlib.db init (WAL, schema, seeds) |
| `paths.ts` | io | All tools | File path constants |
| `read-entities.ts` | io | MCP server, CLI reindex | Entity text assembly for embedding |
| `vector-query.ts` | pure | MCP server, bench, reindex | Cosine search, FTS5 query, entity table map |
| `vector-queries.ts` | io | MCP server | Embedding DB queries |
| `entity-text.ts` | pure | read-entities, MCP server | Weighted text builders |
| `entity-lookup.ts` | io | MCP server | Title lookup from patlib.db |
| `embedder.ts` | io | Registry pattern | Embedder interface + setEmbedder() |
| `embedder-onnx.ts` | **io** | **CLI reindex, bench, MCP server** | **ONNX pipeline implementation (bge-small-en-v1.5) — extracted from mcp-patlib-vector/embedder.ts to eliminate cross-tool import** |
| `rank.ts` | pure | MCP server, bench | RRF fusion |
| `sync.ts` | io | write-sync | File→DB sync with stale cleanup |
| `vector-db.ts` | io | CLI reindex, bench, MCP server | Shared initVectorDB() |
| `vector-bench.ts` | io | bench-vectors CLI | Shared benchmark harness |
| `entity-paths.ts` | io | MCP server (reindex) | Entity source path resolution + mtime |
| `reindex-entity.ts` | io | MCP server + reindex-vectors CLI | Shared reindex logic (batch embed, FTS insert, stale cleanup) |

## Extractions This Session

| Module | Extracted from | LOC savings |
|--------|---------------|-------------|
| `_lib/embedder-onnx.ts` | tools/mcp-patlib-vector/embedder.ts | Eliminated 3 cross-tool imports; mcp-patlib-vector can be disabled without breaking CLI tools |
| `_lib/entity-paths.ts` | mcp-patlib-vector/index.ts (entitySourcePath, entityMtime) | ~35 LOC × potential 2 consumers = 70 |
| `_lib/reindex-entity.ts` | mcp-patlib-vector/index.ts + reindex-vectors.ts (duplicated reindex logic) | ~120 LOC × 2 tools = 240 saved |

## Before/After

| File | Before | After | Delta |
|------|--------|-------|-------|
| `mcp-patlib-vector/index.ts` | 398 LOC (monolith) | 215 LOC (server only) | −183 LOC |
| `mcp-patlib-vector/embedder.ts` | 49 LOC (full ONNX impl) | 7 LOC (thin re-export) | −42 LOC |
| `reindex-vectors.ts` | 120 LOC (inline reindex) | 42 LOC (thin CLI + embedder import) | −78 LOC |
| `bench-vectors.ts` | 77 LOC (cross-tool import) | 77 LOC (shared embedder import) | 0 LOC (fixed dep) |
| `_lib/embedder-onnx.ts` | — (new) | 49 LOC | +49 LOC (shared) |
| `_lib/entity-paths.ts` | — (new) | 58 LOC | +58 LOC (shared) |
| `_lib/reindex-entity.ts` | — (new) | 130 LOC | +130 LOC (shared) |
| **net** | **644 LOC across 3 files** | **578 LOC across 6 files** | **−66 LOC net, zero duplication, zero cross-tool imports** |
