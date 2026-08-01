---
id: PROT.SEARCH.EMBEDDING
title: "Vector Search Embedding — Registry Pattern, Entity Composition, Scoped Embedding, Source Tracking"
source: NEX.TOOL.CHOICE
related: [PROT.SEARCH.QUERY, PROT.LIB.CONTRACT]
summary: "Embedding uses Xenova/bge-small-en-v1.5 via @xenova/transformers (ONNX WASM, CPU inference) in a registry pattern: _lib/embedder.ts defines the interface (pure), tool embedder.ts registers the implementation (io). Entity text composition applies weighted field repetition (title×4, summary×3, body×1) before embedding. Three embedding scopes: full, meta, body. Source file mtime tracks changes instead of content_hash."
protocol: "Embedding via registry pattern: _lib/embedder.ts declares interface and setEmbedder() (purity: io due to runtime delegation). Tool embedder.ts registers @xenova/transformers pipeline. Xenova/bge-small-en-v1.5 model loaded lazily, cached per process. Entity text weighted: title×4, summary×3, principle×2, body×1. Three scopes per entity: full (weighted), meta (fields only), body (body only). Source file mtime replaces content_hash for change detection."
enforcement: Formality
status: active
priority: 3
tags: [search, vector, embedding, model, patlib, hash, batch, registry, purity]
---

Registry pattern, entity text composition, scoped embedding, source file mtime tracking.

## Protocol

### 1. Registry pattern for embedder isolation

`_lib/embedder.ts` defines the interface and a registration slot. The tool `mcp-patlib-vector/embedder.ts` registers the real `@xenova/transformers` pipeline at module load time.

```
_lib/embedder.ts (purity: io) — setEmbedder(), getModel(), embed(), embedBatch(), cosine()
    ↑ register
Tool embedder.ts (purity: io) — owns @xenova/transformers import, registers implementation
```

Rationale:
- `_lib/` stays dependency-free — no `@xenova/transformers` in root `package.json`
- Heavy ONNX runtime (~200MB RAM, ~90MB download) lives only in the tool's `node_modules/`
- Future tools (CLI reindex, auto-hooks) register their own implementation without changing `_lib/`
- Follows `REF.LIB.DEPENDENCY.DIRECTION`: tool (impure) → `_lib/` (io via delegation)

### 2. Embedding model

`Xenova/bge-small-en-v1.5` via `@xenova/transformers` (ONNX WASM embedded, CPU inference). 384-dim float32 vectors. Loaded lazily on first `embed()` call, cached per MCP server process lifetime (~200MB resident). Cold start ~2s, subsequent calls ~5ms.

### 3. Entity text composition with weighted fields

Entity text is constructed per type with weighted field repetition. The repetition amplifies the semantic signal of important fields:

```typescript
// _lib/entity-text.ts (pure)
Add("title", 4)      // title repeated 4×
If pattern: add("summary", 3); add("principle", 2)
If skill:   add("description", 2)
If command: add("description", 2)
Add("body", 1)       // body repeated 1×
```

Each entity type uses a weighted field formula for embedding text:

- **Patterns** use title×4 + summary×3 + principle×2 + body×1. Body column: yes.
- **Terms** use title×4 + body×1. Body column: yes.
- **Cognitions** use title×4 + body×1. Body column: yes.
- **Concepts** use title×4 + body×1. Body column: yes.
- **Definitions** use title×4 + body×1. Body column: yes.
- **Skills** use title×4 + description×2 + body×1. Body column: yes.
- **Protocols** use title×4 + body×1. Body column: yes — body is empty for all protocols (see note below).
- **Rules** use title×4 + body×1. Body column: yes.
- **Commands** use title×4 + description×2. Body column: no.
- **Abstractions** use title×4 + body×1. Body column: yes.
- **Linguistics** use title×4 + body×1. Body column: yes.
- **Apologias** use title×4 + body×1. Body column: yes.
- **Persons** use title×4 + body×1. Body column: yes.

Note on protocols: body column is empty for all protocols — actual content is in the `protocol` column. Content excluded from embed text. Use keyword search on `protocol` column for content-level matching.

Weighted text is fed to the embedder. The vector represents a composition where title contributes ~50% of semantic signal.

### 4. FTS text composition (separate from embed text)

FTS text is clean (no weighting), built from all available text columns:

```
Title + body + protocol + description + summary + principle
```

Only columns that exist for the entity type are included. Protocol column added for protocols type. Stored in `fts_entities` content table, indexed by `entities_fts` FTS5 virtual table. Tokenized with `porter unicode61`.

### 5. Three embedding scopes

Each entity produces three separate embedding vectors:

Three scopes produce separate embedding vectors:

- **full** uses weighted fields from `_lib/entity-text.ts`. Purpose: semantic search (default).
- **meta** uses title + summary + tags (frontmatter fields only). Purpose: concept-level matching.
- **body** uses body text only. Purpose: content-level matching.

Stored in separate rows with different `field` values (`'full'`, `'meta'`, `'body'`). All three indexed by default on reindex.

### 6. Source file mtime for change detection

Each entity row stores `source_file` (absolute path to the source `.md` or YAML file) and `source_mtime` (file modification timestamp from `statSync`). Reindex compares `source_mtime` against the stored value:

- Match → skip (entity unchanged)
- Mismatch → re-embed all three scopes
- No file → skip (entity deleted; cleaned up by stale row cleanup)

This catches file edits, renames, and content changes without computing a content hash from concatenated text.

### 7. Batch embedding

Reindex processes changed entities in batches of 16 via `embedBatch()`. Batches process sequentially per `Xenova/transformers` worker limit. Throughput ~3× faster than serial per-entity embedding. Two reindex interfaces: MCP `patlib_vector_reindex` (server) and CLI `reindex-vectors` (human). Both share the same lib modules — no duplicate logic.

### 8. Stale row cleanup

After reindexing a type, `cleanupStaleRows()` deletes `embeddings` and `fts_entities` rows for entities whose IDs no longer appear in `patlib.db`. Prevents ghost results from deleted entities.

### Lib architecture

The vector search lib divides into eight modules with two purity levels:

Eight modules in `_lib/` divide into two purity levels:

- **embedder.ts** (io) — registry interface and delegation.
- **vector-query.ts** (pure) — cosineSearch, toFtsQuery, ENTITY_TYPES, SEARCH_MODES.
- **vector-queries.ts** (io) — queryEmbeddingVectors, queryFtsRank, queryEntityEmbedding.
- **rank.ts** (pure) — rrf (RRF fusion).
- **entity-text.ts** (pure) — buildEmbedText, buildFtsText, readEntityFields.
- **read-entities.ts** (io) — readEntityTexts (DB + text assembly).
- **entity-lookup.ts** (io) — getEntityTitle.
- **ensure-vector-schema.ts** (io) — schema migration.

## Applicability

Root-level and subproject vector search deployments using the same embedding pipeline. The registry pattern applies to any tool requiring a heavy ML dependency in `_lib/` — define interface in `_lib/`, register implementation in the tool.

## See also

- `REF.SEARCH.VECTOR.SCHEMA` — DB schema, columns, FTS5 tables, source file columns
- `PROT.SEARCH.QUERY` — cosine similarity, hybrid RRF, tool invocations
- `PRE.BATCH.PROCESS.SCALE` — batch embedding model, B=32, P=4 concurrency
- `_lib/embedder.ts` — registry interface (io)
- `_lib/entity-text.ts` — text composition functions (pure)
- `_lib/read-entities.ts` — DB query + text assembly (io)
- `REF.LIB.PURITY.BOUNDARY` — pure vs io classification
- `REF.LIB.DEPENDENCY.DIRECTION` — impure→pure dependency rule
