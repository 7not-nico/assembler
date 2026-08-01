# System Health Report

## Cross-Reference Integrity

| Check | Result | Details |
|-------|--------|---------|
| Orphan entity_terms | 0 | Cleaned 7 stale refs |
| Orphan entity_patterns | 0 | Cleaned 88 stale refs |
| Entity tables with NULL IDs | 0/16 | All tables clean |

## Stale Row Cleanup (syncTable)

| Test | Result |
|------|--------|
| Insert stale row | 34 terms |
| Run sync | 33 terms |
| Stale deleted | Yes (MAX.SYNC.STALE.CLEANUP verified) |

## Reindex Performance at B=32

| Type | Items | Embeddings | Time |
|------|-------|-----------|------|
| definitions | 2 | 6 | <10s |
| maxims | 18 | 54 | <15s |
| terms | 33 | 99 | <20s |
| cognitions | 16 | 48 | <15s |

## Vector DB Health

| Metric | Value |
|--------|-------|
| Total embeddings | 1061 |
| Entity types | 16/16 |
| Warm query latency | 5.4ms |
| FTS5 hit rate | 69% |
| Vector hit rate | 6% |
| Cold start | 269ms |

## Database Health

| DB | Location | Journal | Tables |
|----|----------|---------|--------|
| patlib.db | .opencode/patlib.db | WAL | 29 |
| mcp-search.db | .opencode/mcp-search.db | WAL | 5 |
| patlib-vector.db | .opencode/patlib-vector.db | WAL | 8 |
| sessions.db | .opencode/sessions.db | WAL | — |
| findings.db | findings/findings.db | WAL | 5 |

## Tool Health

| Tool | Type | Status |
|------|------|--------|
| reindex-vectors.ts | Shebang CLI, B=32, TRNS | Verified — thin wrapper (41 LOC) calling `_lib/reindex-entity.ts` |
| bench-vectors.ts | Shebang CLI, RECG | Verified — 269ms cold, 5.8ms warm, 4/5 FTS5 |
| write-sync | Custom IPC | Verified |
| read-selection | Custom IPC | Verified |
| mcp-patlib-vector | MCP server | Verified — refactored 398→215 LOC, shared deps extracted to `_lib/entity-paths.ts` and `_lib/reindex-entity.ts` |

## Shared Node Modules

| MCP Server | `node_modules` | Status |
|-----------|---------------|--------|
| `mcp-patlib-vector` | Symlink → root | Fixed (was real directory, now shared symlink) |
| `mcp-patlib` | Symlink → root | OK |
| `mcp-spec-audit` | Symlink → root | OK |
| `mcp-entity-audit` | Symlink → root | OK |

All 4 MCP servers now share root `.opencode/node_modules/` per REF.TOOL.NODE_MODULES.SHARED.

## Shared Lib Health

| Metric | Value |
|--------|-------|
| Total `_lib/` modules | 15 |
| New in this session | `entity-paths.ts`, `reindex-entity.ts` |
| Code duplication eliminated | ~120 LOC reindex logic (mcp-patlib-vector + reindex-vectors) |
| Duplicate initVectorDB | Removed — all 3 consumers use `_lib/vector-db.ts` |
| Duplicate node_modules | Fixed — mcp-patlib-vector now uses shared symlink |
