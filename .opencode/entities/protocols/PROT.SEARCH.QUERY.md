---
id: PROT.SEARCH.QUERY
title: "Vector Search Query — Cosine, FTS5 BM25, Hybrid RRF, Tool Invocations"
source: NEX.TOOL.CHOICE
related: [PROT.SEARCH.EMBEDDING]
summary: "Three search modes: vector (cosine similarity), keyword (FTS5 BM25), hybrid (RRF fusion). Two-phase result assembly: rank returns type/id/score tuples, entity-lookup fetches titles. Four MCP tools: search, similar, keyword, reindex. Reindex uses source_mtime change detection and stale row cleanup."
protocol: "Three search modes via mcp-patlib-vector MCP tools: vector (cosine similarity, pure JS Float32Array), keyword (FTS5 BM25 OR queries), hybrid (RRF fusion of both). Cosine in _lib/vector-query.ts (pure). FTS5 queries in _lib/vector-queries.ts (io). RRF in _lib/rank.ts (pure). Two-phase assembly via _lib/entity-lookup.ts (io). Reindex uses source file mtime for change detection and cleans stale rows. Four tools: patlib_vector_search, patlib_vector_similar, patlib_vector_keyword, patlib_vector_reindex."
enforcement: Formality
status: active
priority: 3
tags: [search, vector, query, cosine, fts5, hybrid, mcp, patlib, reindex]
---

Three search modes, four MCP tools, two-phase result assembly.

## Search modes

`patlib_vector_search` accepts a `mode` parameter with three options:

- **vector** uses cosine similarity (384-dim Float32Array). Strengths: semantic near-misses and cross-domain matching. Weakness: query/entity length mismatch dilutes scores.
- **keyword** uses FTS5 BM25 with OR token matching. Strengths: exact term find and high precision. Weakness: misses synonyms and returns zero results for out-of-vocabulary queries.
- **hybrid** uses RRF fusion of both (k=60). Strengths: best of both — exact and semantic. Weakness: higher latency from two queries per mode.

## Algorithms

### Cosine similarity

Implemented in `_lib/vector-query.ts` (pure, deterministic math):
```
Dot = sum(queryVec[i] * entityVec[i])
Score = dot / (sqrt(sum(queryVec[i]^2)) * sqrt(sum(entityVec[i]^2)))
```
Full scan over all entities completes in <200µs.

### FTS5 BM25 keyword search

Implemented in `_lib/vector-queries.ts` (io, DB query). FTS5 virtual table `entities_fts` with external content table `fts_entities`. Tokenizer: `porter unicode61`. Query transform: raw string split into OR-connected terms:
```
"mcp server stdio" → '"mcp" OR "server" OR "stdio"'
```
OR semantics prevent zero-result failures from AND matching.

### Hybrid RRF (Reciprocal Rank Fusion)

Implemented in `_lib/rank.ts` (pure, deterministic math):
```
For each entity:
  score = 1/(60 + rank_vector) + 1/(60 + rank_keyword)
```
`rank_vector` = position in cosine results. `rank_keyword` = position in BM25 results. Entities in both lists get a double boost. k=60 prevents high ranks from dominating.

### Two-phase result assembly

Phase 1 — rank returns `(entity_type, entity_id, score)` tuples from `patlib-vector.db`. Phase 2 — `_lib/entity-lookup.ts` queries `patlib.db` per entity for `title`. Keeps vector DB minimal and entity metadata authoritative.

## MCP tools

Four MCP tools expose search and indexing operations:

- **patlib_vector_search** (read, modes: vector/keyword/hybrid) — primary search tool. `mode` defaults to `hybrid`. `type` filters to a single entity type. Returns JSON with `query`, `model`, `mode`, `results[]`. DB: patlib-vector.db (SELECT), patlib.db (SELECT).
- **patlib_vector_similar** (read, mode: vector only) — entity-to-entity similarity. Finds the source entity's vector, runs cosine against all others. Returns JSON with `source`, `model`, `results[]`. DB: patlib-vector.db (SELECT), patlib.db (SELECT).
- **patlib_vector_keyword** (read, mode: keyword only) — standalone keyword search. Same FTS5 engine as hybrid mode, no vector embedding needed. Returns JSON with `query`, `model`, `results[]`. DB: patlib-vector.db (SELECT), patlib.db (SELECT).
- **patlib_vector_reindex** (write: upsert + delete) — incremental reindex using source file mtime. Processes one type at a time. After upserting changed entities, runs stale row cleanup. Accepts optional `type` parameter. DB: patlib.db (SELECT), patlib-vector.db (INSERT/DELETE).

## Reindex write exception

Reindex writes to `patlib-vector.db` are the sole write exception:
- Operation is idempotent (`INSERT OR REPLACE`, mtime gating)
- Cache is fully recomputable from source
- Vector DB is disposable — delete and reindex from scratch
- All other tools remain read-only
- Stale row cleanup removes orphaned data from deleted entities

## Output format

All tools return JSON via `{ type: "text" }` content:
- `search`/`similar` — `{ query?, source?, model, mode?, results: [{entity_type, entity_id, title, score}] }`
- `keyword` — `{ query, model: "bm25", results: [{entity_type, entity_id, title, bm25}] }`
- `reindex` — `{ text: "Reindex {type}: {inserted} updated, {skipped} unchanged" }`

## Gotchas

- First reindex slow (~30s): Run once, let complete. Subsequent runs skip unchanged entities. (ONNX model download + entity embedding)
- Vector search returns empty: Run `patlib_vector_reindex` to populate. (`embeddings` table empty or stale)
- Keyword search returns 0 for multi-word: Use hybrid mode instead. (FTS5 AND default — multi-word queries match few entities)
- Low cosine scores (5-20%): Normal for cross-type queries. Entity-to-entity similar scores are 60-80%. (Query short vs document-length entity text)
- Stale rows in vector DB: Reindex cleans stale rows automatically. (Entity deleted from patlib.db, reindex not run)
- FTS5 misses on `protocol` column: FTS text composition includes `protocol` column for protocols type. (Protocol entity body stored in `protocol` column, not `body`)

## Enforcement

`audit-tool` verifies `patlib_vector_search` and `patlib_vector_similar` are read-only (SELECT only). `patlib_vector_reindex` is the sole write exception. Verifies FTS5 queries use parameterized SQL. Verifies output is valid JSON.

## See also

- `PROT.SEARCH.EMBEDDING` — vector search registry, embedding model, text composition
- `REF.SEARCH.VECTOR.SCHEMA` — DB schema, columns, FTS5 tables
- `ILL.SEARCH.VECTOR.TOOLS` — walkthrough with all four tools
- `_lib/vector-query.ts` — cosineSearch, toFtsQuery, constants (pure)
- `_lib/vector-queries.ts` — queryEmbeddingVectors, queryFtsRank, queryEntityEmbedding (io)
- `_lib/rank.ts` — rrf (pure)
- `_lib/entity-lookup.ts` — getEntityTitle (io)
- `PROT.TOOL.AUTOMATON` — tool I/O classification for MCP tools
- `REF.LIB.DIRECTORY.LAYER` — lib extraction rules
