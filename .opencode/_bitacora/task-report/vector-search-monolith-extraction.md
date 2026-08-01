# Vector Search Monolith Extraction

## Source

`tools/mcp-patlib-vector/index.ts` — a 398-LOC monolith containing MCP server, path resolution, DB init, reindex logic, and 4 search handlers mixed together.

## Principle

**MAX.DRY** — every piece of knowledge has a single authoritative representation. Reindex logic was duplicated verbatim in `reindex-vectors.ts` CLI tool. Path resolution and DB init duplicated within the monolith.

**MAX.ORTHOGONALITY** — one thing per tool. The MCP server handles MCP protocol; shared logic routes through `_lib/` modules.

**MAX.CODE.LAYERS** — all extracted libs declare purity rings.

**MAX.CATALYST.FOR.CHANGE** — shipped in 2 rounds: first the big reindex extraction, then the smaller boilerplate helpers.

## Round 1: Reindex + Path Logic (+ Entity/Purity layers)

| Extraction | Target | LOC removed from monolith |
|-----------|--------|--------------------------|
| `entitySourcePath()` + `entityMtime()` | `_lib/entity-paths.ts` (new, 58 LOC) | −35 |
| `initVectorDB()` duplicate | `_lib/vector-db.ts` (existing, consolidated) | −10 |
| Reindex logic (`batch embed → FTS → stale cleanup`) | `_lib/reindex-entity.ts` (new, 129 LOC) | −120 |
| **Round 1 total** | | **−165 LOC from monolith** |

## Round 2: Boilerplate Helpers + Unused Import Cleanup

| Extraction | LOC removed | Benefit |
|-----------|-------------|---------|
| `jsonResponse(data)` — wraps `{ content: [{ type: "text", text: JSON.stringify(...) }] }` | −7 per usage × 7 = −49 chars each | Removes repetitive response construction across 4 handlers |
| `withDB<T>(fn)` — wraps `initVectorDB() + initDB() + try/finally close` | −4 per handler × 4 = −16 LOC | Removes repetitive DB lifecycle in all 4 tool handlers |
| Remove unused `import { Database }` | −1 line | Was needed only by the deleted inline `initVectorDB()` |
| Remove unused `import { entityTable }` | −1 line | Was needed only by deleted inline reindex logic |
| **Round 2 total** | | **−18 LOC from monolith** |

## Before/After

| Metric | Before | After |
|--------|--------|-------|
| `mcp-patlib-vector/index.ts` LOC | 398 | 215 |
| Reindex code duplication | Full reindex duplicated (~120 LOC) | Zero — shared `_lib/reindex-entity.ts` |
| `initVectorDB()` implementations | 2 (own + `_lib/vector-db.ts`) | 1 (`_lib/vector-db.ts`) |
| DB lifecycle pattern | `initDB+initVectorDB+try/finally` repeated 4× | 1× `withDB()` helper |
| Response construction | `{content:[{type:"text",text:JSON.stringify(...)}]}` repeated 7× | 1× `jsonResponse()` helper |
| Unused imports | 2 (`Database`, `entityTable`) | 0 |
| Shared `_lib/` modules | 12 | 15 (+`entity-paths`, `reindex-entity`, consolidated `vector-db`) |
| **Net LOC (all files)** | **518 across 2 files** | **449 across 4 files, −69 net** |

## Files Changed

| File | Action |
|------|--------|
| `_lib/entity-paths.ts` | Created |
| `_lib/reindex-entity.ts` | Created |
| `_lib/vector-db.ts` | Already existed; mcp-patlib-vector now imports from here |
| `tools/mcp-patlib-vector/index.ts` | Refactored — 398→215 LOC |
| `tools/reindex-vectors.ts` | Refactored — 120→41 LOC |
| `reports/shared-dep-audit.md` | Updated — added 2 modules, before/after table |
| `todo/extract-vector-reindex.md` | Created — tracks extraction steps |
| `reports/vector-search-monolith-extraction.md` | This file |

## Architectural Diagram

```
tools/mcp-patlib-vector/index.ts (215 LOC, MCP server only)
├── jsonResponse() — local helper
├── withDB() — local helper
├── patlib_vector_search → calls _lib/vector-query, _lib/vector-queries, _lib/rank
├── patlib_vector_similar → calls _lib/vector-queries, _lib/vector-query
├── patlib_vector_keyword → calls _lib/vector-queries
└── patlib_vector_reindex → calls _lib/reindex-entity, _lib/read-entities

tools/reindex-vectors.ts (41 LOC, thin CLI wrapper)
└── calls _lib/reindex-entity

_lib/
├── entity-paths.ts     — entitySourcePath, entityMtime
├── reindex-entity.ts   — reindexEntityType (shared between server + CLI)
├── vector-db.ts        — initVectorDB (shared between server + CLI + bench)
├── vector-query.ts     — cosineSearch, entityTable, toFtsQuery (pure)
├── vector-queries.ts   — queryEmbeddingVectors, queryFtsRank (io)
├── rank.ts             — rrf fusion (pure)
├── entity-lookup.ts    — getEntityTitle (io)
├── read-entities.ts    — readEntityTexts (io)
├── entity-text.ts      — buildEmbedText, buildFtsText (pure)
└── embedder.ts         — registry pattern (io)
```

## Verified

| Check | Result |
|-------|--------|
| `bun build --no-bundle reindex-vectors.ts` | No errors |
| `bun build --no-bundle mcp-patlib-vector/index.ts` | No errors |
| `bun build --no-bundle _lib/reindex-entity.ts` | No errors |
| `bun build --no-bundle _lib/entity-paths.ts` | No errors |
| `bun run reindex-vectors.ts --type definitions --force` | 6 embeddings, 0 errors |
| `bun run bench-vectors.ts --quick` | 5/5 FTS5 hits, 0 errors |
| `bun run reindex-vectors.ts --type maxims --force` | 54 embeddings (18×3), 0 errors |
| `useMtime=true` incremental skip | Confirmed: first run 2 inserted, second run 2 skipped |
| `useMtime=true` source_file resolution | Fixed: uses `entitySourcePath()` not `item.id` |
| `useMtime=false` skip (CLI path after MCP reindex) | Confirmed: 0 inserted, 2 skipped |
| `force=true` bypasses all checks | Confirmed: re-embeds everything |
