---
id: PROT.SEARCH.VECTOR.INDEX
title: "Vector Search Index — Semantic Search Layer for Patlib Entities"
source: assembler
related: [PROT.SEARCH.VECTOR.SCHEMA, PROT.SEARCH.EMBEDDING, PAT.SEARCH.VECTOR.QUERY, PROT.MCP.TRANSPORT, PAT.MCP.READONLY, PROT.LIB.DIRECTORY.LAYER]
summary: "mcp-patlib-vector provides semantic search over patlib entities. Architecture decomposes into three sub-protocols: schema (separate DB, columns, FTS5 tables), embedding (registry pattern, weighted composition, scopes), and query (cosine, FTS5 BM25, hybrid RRF, 4 tools)."
protocol: "mcp-patlib-vector runs as a local MCP server under .opencode/tools/mcp-patlib-vector/. Architecture divided into three sub-protocols: PROT.SEARCH.VECTOR.SCHEMA (DB schema, FTS5 tables, PRAGMAs, migration), PROT.SEARCH.EMBEDDING (registry pattern, model, weighted entity composition, scopes, source tracking), PAT.SEARCH.VECTOR.QUERY (cosine similarity, FTS5 BM25, hybrid RRF, stale cleanup, four tool invocations)."
enforcement: Convention
status: active
priority: 3
tags: [search, vector, embedding, mcp, patlib, index, semantic-search, fts5, hybrid]
---

Registry for the three sub-protocols that define the patlib vector search architecture.

## Architecture

The vector search system decomposes into three sub-protocols:

| Protocol | Scope |
|----------|-------|
| `PROT.SEARCH.VECTOR.SCHEMA` | Separate DB, embeddings table, fts_entities content table, entities_fts FTS5 virtual table, PRAGMAs, migration |
| `PROT.SEARCH.EMBEDDING` | Registry pattern (_lib/embedder.ts pure interface, tool registers impl), Xenova/bge-small-en-v1.5 model, weighted entity text, three embedding scopes (full/meta/body), source mtime tracking |
| `PAT.SEARCH.VECTOR.QUERY` | Three search modes (vector/keyword/hybrid) with RRF fusion, four MCP tools (search/similar/keyword/reindex), two-phase result assembly, stale row cleanup |

MCP server at `.opencode/tools/mcp-patlib-vector/` provides four tools:
- `patlib_vector_search` — natural language search with vector/keyword/hybrid modes
- `patlib_vector_similar` — entity-to-entity similarity
- `patlib_vector_keyword` — standalone keyword search via FTS5 BM25
- `patlib_vector_reindex` — incremental reindex with stale cleanup

## Lib architecture

| `_lib/` module | Purity | Purpose |
|----------------|--------|---------|
| `embedder.ts` | io | Registry interface + delegation |
| `vector-query.ts` | pure | cosineSearch, toFtsQuery, ENTITY_TYPES, SEARCH_MODES |
| `vector-queries.ts` | io | queryEmbeddingVectors, queryFtsRank, queryEntityEmbedding |
| `rank.ts` | pure | rrf (RRF fusion) |
| `entity-text.ts` | pure | buildEmbedText, buildFtsText, readEntityFields |
| `read-entities.ts` | io | readEntityTexts (DB + text assembly) |
| `entity-lookup.ts` | io | getEntityTitle |
| `ensure-vector-schema.ts` | io | Schema migration |

## Enforcement

`audit-tool` verifies `mcp-patlib-vector/index.ts` follows the `StdioServerTransport` pattern per `PROT.MCP.TRANSPORT`. Verifies `patlib_vector_search` and `patlib_vector_similar` are read-only. `patlib_vector_reindex` is the sole write exception per `PAT.MCP.READONLY`. Verifies lib modules have contract blocks per `PROT.LIB.CONTRACT`.

## Applicability

Root-level MCP server at `.opencode/tools/mcp-patlib-vector/`. Subprojects may derive their own servers following the same sub-protocols.

## See also

- `PROT.SEARCH.VECTOR.SCHEMA` — DB schema, FTS5 tables, PRAGMAs
- `PROT.SEARCH.EMBEDDING` — registry pattern, weighted composition, scopes
- `PAT.SEARCH.VECTOR.QUERY` — query modes, RRF, tool invocations
- `ILL.SEARCH.VECTOR.TOOLS` — vector search walkthrough
- `PROT.MCP.TRANSPORT` — stdio transport mechanics
- `PAT.MCP.READONLY` — read-only MCP contract
- `PROT.LIB.DIRECTORY.LAYER` — lib extraction threshold
