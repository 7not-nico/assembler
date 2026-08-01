# Vector Search — Status Report

**Date**: 2026-07-24
**Status**: Fully coded, disabled in opencode.json

## Inventory

| Component | Location | Status |
|-----------|----------|--------|
| MCP server | `.opencode/tools/_disabled/mcp-patlib-vector/index.ts` | Coded (221 LOC), **disabled** |
| CLI search | `.opencode/tools/_disabled/search-vectors.ts` | Coded (96 LOC), **disabled** |
| CLI reindex | `.opencode/tools/_disabled/reindex-vectors.ts` | Coded (42 LOC), **disabled** |
| CLI similar | `.opencode/tools/_disabled/similar-vectors.ts` | Coded (70 LOC), **disabled** |
| CLI bench | `.opencode/tools/_disabled/bench-vectors.ts` | Coded (77 LOC), **disabled** |
| Embedder | `.opencode/tools/_disabled/mcp-patlib-vector/embedder.ts` | Re-exports from `_lib/embedder-onnx.ts` |
| Shared libs | `_lib/vector-db.ts`, `_lib/vector-query.ts`, `_lib/vector-queries.ts`, `_lib/rank.ts`, `_lib/reindex-entity.ts`, `_lib/entity-paths.ts` | Active |

## MCP Server Capabilities (coded, disabled)

| Tool | Description | Deps |
|------|-------------|------|
| `patlib_vector_search` | Hybrid (vector + keyword via RRF), vector-only, keyword-only | embed, cosineSearch, FTS5, rrf |
| `patlib_vector_similar` | Find entities similar to a given entity ID | queryEntityEmbedding, cosineSearch |
| `patlib_vector_keyword` | FTS5 keyword search | toFtsQuery, queryFtsRank |
| `patlib_vector_reindex` | Recompute embeddings per entity type with mtime check | reindexEntityType, readEntityTexts, entityMtime |

## Vector DB State

- 1061 embeddings (353 entities × 3 scopes: full, meta, body)
- 16/16 entity types indexed
- Model: Xenova/bge-small-en-v1.5 (384-dim, 33M params)
- ONNX WASM runtime (CPU, single-thread)
- 0.54 MiB raw vector data

## Performance (bench-vectors.ts, 2026-07-23)

| Metric | Cold | Warm |
|--------|------|------|
| Model load + embed | 273ms | 3.4ms |
| Cosine scan | 1.82ms | 1.82ms |
| FTS5 scan | 0.01ms | 0.01ms |
| **Total** | **275ms** | **5.2ms** |

## Accuracy Gap

| Signal | Hit Rate | Contribution |
|--------|----------|-------------|
| FTS5 keyword | 69% | Dominant |
| Vector (bge-small) | 6% | Near-zero |
| RRF hybrid | 69% | = FTS5 alone |

## What's Missing

1. **opencode.json** — `"patlib-vector"` entry exists but `"enabled": false`
2. **disabled/ → tools/** — all 5 vector tools need to be moved
3. **Accuracy** — vector model fine-tuning to improve 6% hit rate
4. **Bench rebuild** — re-run `bench-vectors.ts --full --report` after reactivation

## Rust Binary Opportunity

Vector search is the ideal first Rust native addon target:
- Compute-heavy (ONNX embedding, cosine scan)
- Multiple tools call same libs (reindex, search, similar, bench)
- Current bottleneck is vector hit rate (6%) — Rust enables fine-tuning pipeline
- napi-rs → single `.node` binary replaces 15+ TS imports
