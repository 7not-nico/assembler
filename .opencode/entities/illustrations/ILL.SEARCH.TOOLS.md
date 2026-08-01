---
id: ILL.SEARCH.TOOLS
title: "Vector Search Tools Walkthrough — Search, Similar, Keyword, Reindex"
source: PROT.SEARCH.QUERY
summary: "Walk through a full search session: reindex after entity sync, semantic vector search, FTS5 keyword search, hybrid mode, entity similarity, and score interpretation across all four tools."
illustration: "An agent using all four mcp-patlib-vector tools: reindex after write-sync, vector search by concept, keyword search for exact terms, hybrid mode for combined results, similar for entity exploration"
illustrates: [PROT.SEARCH.QUERY]
tags: search,vector,embedding,mcp,walkthrough,semantic-search,fts5,hybrid
related: [PROT.SEARCH.QUERY, PROT.SEARCH.EMBEDDING, REF.SEARCH.VECTOR.SCHEMA]
---
## Context

After syncing new entities to `patlib.db` via `write-sync`, the vector index is stale. The agent runs reindex to rebuild the cache, then uses semantic search, keyword search, and entity similarity.

MCP server: `mcp-patlib-vector` at `.opencode/tools/mcp-patlib-vector/`.

Four tools: `patlib_vector_search` (three modes), `patlib_vector_similar`, `patlib_vector_keyword`, `patlib_vector_reindex`.

## Walkthrough

### Step 1: Reindex — refresh the vector index

After `write-sync` adds a new entity, the vector index needs refresh:

```
patlib_vector_reindex --type patterns
```

The tool:
1. Reads all patterns from `patlib.db` (via `_lib/read-entities.ts`)
2. Reads each pattern's source file mtime from disk
3. Skips entities where `source_mtime` matches the stored value
4. For changed entities, embeds all three scopes (full, meta, body) in batches of 16
5. Upserts into `patlib-vector.db` via `INSERT OR REPLACE`
6. Cleans stale rows — deletes embeddings for entities no longer in `patlib.db`

Output: `Reindex patterns: 1 updated, 68 unchanged`

Only the 1 changed entity consumed embedding time. The stale cleanup removed no rows.

### Step 2: Vector search — find by meaning

Search for patterns about building thin prototypes first:

```
patlib_vector_search --type patterns --query "build minimal working example first" --mode vector
```

The query is embedded with `bge-small-en-v1.5`, cosine compared against all pattern embeddings.

Results:

| rank | entity_id | score | title |
|------|-----------|-------|-------|
| 0 | PAT.TRACER.BULLETS.PRACTICE | 0.31 | Tracer Bullets — Build Thin End-to-End First, Grow Later |
| 1 | PAT.PROTOTYPE.TO.LEARN | 0.27 | Prototype to Learn |
| 2 | PAT.REFACTOR.EARLY.OFTEN | 0.22 | Refactor Early, Often |

Scores are lower than typical document search (31% vs 65%) because entity text is short and domain-specific. The correct entity (`PAT.TRACER.BULLETS.PRACTICE`) appears at rank 0.

### Step 3: Keyword search — exact term match

Find entities that mention "stdio" and "transport":

```
patlib_vector_keyword --query "stdio transport" --limit 5
```

The tool splits the query into OR-connected FTS5 terms: `"stdio" OR "transport"`. BM25 ranks by term frequency.

Results:

| rank | entity_id | bm25 | title |
|------|-----------|------|-------|
| 0 | PROT.MCP.TRANSPORT | 19.7 | Stdio Transport Contract for Local MCP Servers |
| 1 | PAT.MCP.READONLY | 4.6 | MCP Server Read-Only Contract |
| 2 | NEX.LIB.STACK | 4.1 | Lib Handler — io Orchestration, Pure Formatting |

Keyword search is instant — no model load required. The FTS5 OR transform ensures multi-word queries return results even when not all terms appear together.

### Step 4: Hybrid search — best of both

The same query in hybrid mode combines vector + BM25 via RRF:

```
patlib_vector_search --query "stdio transport mcp protocol" --mode hybrid
```

Results after RRF fusion (k=60):

| rank | entity_id | score | title |
|------|-----------|-------|-------|
| 0 | PROT.MCP.TRANSPORT | 0.033 | Stdio Transport Contract for Local MCP Servers |
| 1 | PAT.MCP.READONLY | 0.016 | MCP Server Read-Only Contract |
| 2 | NEX.LIB.STACK | 0.016 | Lib Handler — io Orchestration, Pure Formatting |

Hybrid catches entities that appear in either list. `PROT.MCP.TRANSPORT` appears in both vector and keyword results, gets a double RRF boost, and ranks first. Mode is the default — use hybrid unless you need pure semantics or pure exact match.

### Step 5: Similar — find related entities

Given `PROT.MCP.TRANSPORT`, find what else is semantically close:

```
patlib_vector_similar --entity_id PROT.MCP.TRANSPORT --limit 5
```

The tool finds the source entity's vector, runs cosine against all others.

Results:

| rank | entity_id | score | title |
|------|-----------|-------|-------|
| 0 | PROT.MCP.TRANSPORT | 1.00 | (self) |
| 1 | PAT.MCP.READONLY | 0.78 | MCP Server Read-Only Contract |
| 2 | PROT.TOOL.MCP.AUTODISCOVER | 0.71 | MCP Server Auto-Discovery |
| 3 | IDENTITY.MCP | 0.65 | MCP Identity |
| 4 | RUL.USE.LOCAL.MCP | 0.58 | Use Local MCP Servers |

Entity-to-entity scores are significantly higher than text-to-entity (60-80% vs 5-30%) because both vectors exist in the same embedding space. The MCP-related cluster is coherent.

### Score interpretation

For text-to-entity search (vector mode):

| Score range | Meaning |
|-------------|---------|
| 0.25+ | Strong semantic match — same concept |
| 0.15–0.25 | Moderate match — related domain |
| 0.05–0.15 | Weak match — tangential |
| < 0.05 | Noise |

For entity-to-entity similarity:

| Score range | Meaning |
|-------------|---------|
| 0.70+ | Same cluster — directly related |
| 0.40–0.69 | Same domain — related |
| 0.15–0.39 | Different domain — tangential |
| < 0.15 | Unrelated |

Scores depend on `bge-small-en-v1.5` (384-dim). Entity-to-entity scores are higher because both vectors exist in the same embedding space; text queries are out-of-distribution for the model.

### Key insight

The vector index is a derived cache — always recomputable from source entities. Source mtime gating makes reindex safe to run after every `write-sync`. The four tools form a complete query surface:
- **search** (vector) — find by meaning, best for concept-level queries
- **search** (keyword) — find by exact terms, best for known identifiers
- **search** (hybrid) — fused, best default for unknown result shape
- **similar** — explore by association, best for navigation
- **keyword** — standalone instant exact match, no model needed
- **reindex** — keeps the cache fresh, cleans stale rows automatically

## See also

- `PROT.SEARCH.EMBEDDING` — vector search registry
- `PROT.SEARCH.QUERY` — query modes, RRF, tool invocations
- `PROT.SEARCH.EMBEDDING` — registry pattern, weighted composition
- `REF.SEARCH.VECTOR.SCHEMA` — DB schema, FTS5 tables
- `PAT.MCP.READONLY` — read-only MCP contract, reindex exception
- `REF.LIB.DIRECTORY.LAYER` — lib extraction rules
