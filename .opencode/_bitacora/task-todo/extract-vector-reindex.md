# Extract vector reindex shared deps from mcp-patlib-vector monolith

**Maxim refs:** MAX.DRY (single source of truth), MAX.ORTHOGONALITY (one thing per tool), MAX.CODE.LAYERS (purity rings), MAX.CATALYST.FOR.CHANGE (ship smallest useful)

## Source
`tools/mcp-patlib-vector/index.ts` — 398 LOC monolith containing:
- MCP server boilerplate
- Entity source path resolution (entitySourcePath, entityMtime)
- Vector DB init (duplicate of _lib/vector-db.ts)
- Reindex logic (duplicated in reindex-vectors.ts)
- Search handlers (search, similar, keyword)

## Extractions

| Extraction | Shared lib | LOC saved | Consumers |
|-----------|----------|-----------|-----------|
| entitySourcePath + entityMtime | `_lib/entity-paths.ts` (new) | ~35 LOC × 2 consumers = 70 | mcp-patlib-vector, future tools |
| Reindex logic (batch embed, FTS insert, stale cleanup) | `_lib/reindex-entity.ts` (new) | ~120 LOC × 2 consumers = 240 | mcp-patlib-vector, reindex-vectors.ts |
| initVectorDB consolidation | `_lib/vector-db.ts` (existing) | ~10 LOC removed duplicate | mcp-patlib-vector uses shared version |

## Before/After

| File | Before | After | Delta |
|------|--------|-------|-------|
| mcp-patlib-vector/index.ts | 398 LOC | ~230 LOC | −168 LOC |
| reindex-vectors.ts | 120 LOC | ~40 LOC | −80 LOC |
| _lib/entity-paths.ts | — | 63 LOC | +63 LOC (shared) |
| _lib/reindex-entity.ts | — | 116 LOC | +116 LOC (shared) |
| **net** | **518 LOC across 2 files** | **449 LOC across 4 files** | **−69 LOC net, zero duplication** |

## Verified
- [x] `bun build --no-bundle tools/reindex-vectors.ts` — no errors
- [x] `bun build --no-bundle tools/mcp-patlib-vector/index.ts` — no errors

## Remaining
- [ ] Restart opencode runtime to clear MCP module cache (picks up new _lib modules)
- [ ] Verify patlib_vector_reindex MCP tool works after restart
- [ ] Update bench-vectors.ts if it has any path issues (no changes needed currently)
