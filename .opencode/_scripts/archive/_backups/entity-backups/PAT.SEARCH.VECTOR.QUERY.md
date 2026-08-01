---
id: PAT.SEARCH.VECTOR.QUERY
Title: "Vector Search Query — Cosine, FTS5 BM25, Hybrid RRF, Tool Invocations"
Source: assembler
Related: [PROT.SEARCH.EMBEDDING, PROT.SEARCH.VECTOR.SCHEMA, PROT.SEARCH.EMBEDDING, PAT.MCP.READONLY]
Summary: "Three search modes: vector (cosine similarity in pure JS via _lib/vector-query.ts), keyword (FTS5 BM25 via _lib/vector-queries.ts), hybrid (RRF fusion via _lib/rank.ts). Two-phase result assembly: rank returns type/id/score tuples, _lib/entity-lookup.ts fetches titles from patlib.db. Four MCP tools: search, similar, keyword, reindex. Reindex uses source_mtime change detection and stale row cleanup."
Protocol: "Three search modes via mcp-patlib-vector MCP tools: vector (cosine similarity, pure JS Float32Array), keyword (FTS5 BM25 OR queries), hybrid (RRF fusion of both). Cosine in _lib/vector-query.ts (pure). FTS5 queries in _lib/vector-queries.ts (io). RRF in _lib/rank.ts (pure). Two-phase assembly via _lib/entity-lookup.ts (io). Reindex uses source file mtime for change detection and cleans stale rows. Four tools: patlib_vector_search, patlib_vector_similar, patlib_vector_keyword, patlib_vector_reindex."
Enforcement: Convention
Status: active
Priority: 3
Tags: [search, vector, query, cosine, fts5, hybrid, mcp, patlib, reindex]
---

Three search modes, four MCP tools, two-phase result assembly.

## Search modes

`patlib_vector_search` accepts a `mode` parameter:

| Mode | Engine | Strengths | Weakness |
|------|--------|-----------|----------|
| `vector` | Cosine similarity (384-dim Float32Array) | Semantic near-misses, cross-domain | Query/entity length mismatch dilutes scores |
| `keyword` | FTS5 BM25 with OR token matching | Exact term find, high precision | Misses synonyms, zero results for out-of-vocab queries |
| `hybrid` | RRF fusion of both (k=60) | Best of both — exact + semantic | Higher latency (2 queries per mode) |

## Algorithms

### 1. Cosine similarity

Implemented in `_lib/vector-query.ts` (pure, deterministic math):

```
Dot = sum(queryVec[i] * entityVec[i])
Score = dot / (sqrt(sum(queryVec[i]^2)) * sqrt(sum(entityVec[i]^2)))
```

Full scan over all 331 entities completes in <200µs. No vector index (IVF/HNSW) needed at current scale.

### 2. FTS5 BM25 keyword search

Implemented in `_lib/vector-queries.ts` (io, DB query). FTS5 virtual table `entities_fts` with external content table `fts_entities`. Tokenizer: `porter unicode61`.

Query transform — raw query string split into OR-connected terms:

```
"mcp server stdio" → '"mcp" OR "server" OR "stdio"'
```

OR semantics prevent zero-result failures from AND matching. BM25 ranks by term frequency/inverse document frequency.

### 3. Hybrid RRF (Reciprocal Rank Fusion)

Implemented in `_lib/rank.ts` (pure, deterministic math):

```
For each entity:
  score = 1/(60 + rank_vector) + 1/(60 + rank_keyword)
```

`rank_vector` = position in cosine results (0-indexed). `rank_keyword` = position in BM25 results. Entities appearing in both lists get a double boost. The constant k=60 prevents high ranks from dominating.

### 4. Two-phase result assembly

Phase 1 — rank returns `(entity_type, entity_id, score)` tuples using only `patlib-vector.db`. Phase 2 — `_lib/entity-lookup.ts` queries `patlib.db` per entity for `title` metadata. Keeps vector DB minimal and entity metadata authoritative.

## MCP tools

| Tool | Mutation | Modes | DB connections |
|------|----------|-------|---------------|
| `patlib_vector_search` | Read | vector, keyword, hybrid | patlib-vector.db (SELECT), patlib.db (SELECT) |
| `patlib_vector_similar` | Read | vector only | patlib-vector.db (SELECT), patlib.db (SELECT) |
| `patlib_vector_keyword` | Read | keyword only | patlib-vector.db (SELECT), patlib.db (SELECT) |
| `patlib_vector_reindex` | Write (upsert + delete) | — | patlib.db (SELECT), patlib-vector.db (INSERT/DELETE) |

### Tool details

Primary search tool. `mode` defaults to `hybrid`. `type` filters to a single entity type. Returns JSON with `query`, `model`, `mode`, `results[]`.

Entity-to-entity similarity. Finds the source entity's vector, runs cosine against all others. Returns JSON with `source`, `model`, `results[]`.

Standalone keyword search. Same FTS5 engine as hybrid mode, but no vector embedding needed (instant, no model load). Returns JSON with `query`, `model`, `results[]`.

Incremental reindex using source file mtime. Processes one type at a time. After upserting changed entities, runs stale row cleanup: deletes `embeddings` and `fts_entities` rows for entities that no longer exist in `patlib.db`. Accepts optional `type` parameter to target a specific type; default scans for first type with pending changes.

## Reindex write exception

Reindex writes to `patlib-vector.db` are the sole exception to `PAT.MCP.READONLY`:
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

## Rationale

- **Three modes** cover complementary search use cases: exact match (keyword), semantic (vector), combined (hybrid)
- **RRF fusion** is parameter-free (no weight tuning), works well even when one method finds zero results
- **Two-phase assembly** separates ranking from metadata — vector DB schema stays lean
- **Source mtime** is more reliable than content hash — catches file moves, renames, permission changes
- **Stale cleanup** prevents ghost results from deleted entities
- **JS cosine** avoids sqlite-vec WASM dependency at current scale

## Gotchas

| Signal | Observation | Redirect |
|--------|-------------|----------|
| First reindex slow (~30s) | ONNX model download + entity embedding | Run once, let complete. Subsequent runs skip unchanged entities. |
| Vector search returns empty | `embeddings` table empty or stale | Run `patlib_vector_reindex` to populate. |
| Keyword search returns 0 for multi-word | FTS5 AND default — multi-word queries match few entities | Use hybrid mode instead — OR transform only in hybrid/keyword tools. |
| Low cosine scores (5-20%) | Query short vs document-length entity text | Normal for cross-type queries. Entity-to-entity similar scores are 60-80%. |
| Stale rows in vector DB | Entity deleted from patlib.db, reindex not run | Reindex cleans stale rows automatically. |
| FTS5 misses on `protocol` column | Protocol entity body stored in `protocol` column, not `body` | FTS text composition includes `protocol` column for protocols type. |

## Enforcement

`audit-tool` verifies `patlib_vector_search` and `patlib_vector_similar` are read-only (SELECT only). `patlib_vector_reindex` is the sole write exception. Verifies FTS5 queries use parameterized SQL. Verifies output is valid JSON.

## See also

- `PROT.SEARCH.EMBEDDING` — vector search registry
- `PROT.SEARCH.VECTOR.SCHEMA` — DB schema, columns, FTS5 tables
- `PROT.SEARCH.EMBEDDING` — embedding model, entity text composition, scoped embedding
- `ILL.SEARCH.VECTOR.TOOLS` — walkthrough with all four tools
- `_lib/vector-query.ts` — cosineSearch, toFtsQuery, constants (pure)
- `_lib/vector-queries.ts` — queryEmbeddingVectors, queryFtsRank, queryEntityEmbedding (io)
- `_lib/rank.ts` — rrf (pure)
- `_lib/entity-lookup.ts` — getEntityTitle (io)
- `PAT.MCP.READONLY` — read-only MCP contract
- `PROT.LIB.DIRECTORY.LAYER` — lib extraction rules
