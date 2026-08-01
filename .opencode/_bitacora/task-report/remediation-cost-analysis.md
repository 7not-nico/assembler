# Remediation Cost Analysis

What it cost to identify and fix the vector tooling errors, and what it would cost to restore.

## Debugging Cost

| Activity | Time (estimated) | Tools used |
|----------|-----------------|------------|
| Identify original error | Conversation | Observation |
| Trace cross-tool imports | Investigation | `rg`, `read`, `ps` |
| Read todo/report files | Investigation | `read` |
| Understand dep chain | Investigation | `rg`, `read` |
| Move files to `_disabled/` | 30s | `mv` |
| Create CLI fallbacks | ~10 min | `write` |
| Smoke test CLIs | ~5 min | `bun run` |
| Identify second error | Conversation | Observation |
| Disable new CLIs | 15s | `mv` |
| Write reports | ~30 min | `write` |
| **Total** | **~1 hour** | |

## Code Written

| File | LOC | Status |
|------|-----|--------|
| `tools/search-vectors.ts` | ~100 | Disabled |
| `tools/similar-vectors.ts` | ~70 | Disabled |
| `tools/_disabled/reindex-vectors.ts` | ~42 | Disabled (restored then re-disabled) |
| Reports (9 new) | ~1500 | Active |

## Code Orphaned

| Module | LOC | Reason |
|--------|-----|--------|
| 12 `_lib/` vector modules | ~716 | All consumers disabled |
| `_lib/embedder-onnx.ts` | 52 | embedder implementation |
| `_lib/embedder.ts` | 45 | registry pattern |
| `_lib/read-entities.ts` | ~50 | entity text assembly |
| `_lib/entity-paths.ts` | 58 | source path resolution |
| `_lib/reindex-entity.ts` | 130 | reindex logic |
| `_lib/vector-bench.ts` | 119 | benchmark harness |
| `_lib/vector-db.ts` | 27 | vector DB init |
| `_lib/vector-query.ts` | 52 | cosine search, FTS5 |
| `_lib/vector-queries.ts` | 63 | DB queries |
| `_lib/rank.ts` | 40 | RRF fusion |
| `_lib/entity-lookup.ts` | 13 | title lookup |
| `_lib/ensure-vector-schema.ts` | 67 | schema migration |
| **Total orphaned** | **~716** | |

## Data Orphaned

| File | Size | Content |
|------|------|---------|
| `.opencode/patlib-vector.db` | ~1-5 MB | 1061 embeddings, 16 entity types |
| `.opencode/patlib-vector.db-wal` | Varies | WAL journal |
| `.opencode/patlib-vector.db-shm` | Small | Shared memory |
| `.opencode/_schemas/patlib-vector.sql` | Small | Schema definition |

## Cost to Restore

| Scenario | Effort | Risk |
|----------|--------|------|
| **Restore as shebang CLIs** | Low (move from `_disabled/`) | HIGH — same startup error again |
| **Convert to plugin format** | Medium (~15 min per tool) | Low — follows audit rules |
| **Re-enable MCP server** | Low (move + update config) | Low — MCP servers are exempt |
| **Clean up dead code** | Medium (remove libs + DB + config) | Low — no consumers left |
| **Full rebuild from scratch** | High | Low — can follow checklist |

## What We Lost

| Loss | Impact |
|------|--------|
| Vector search MCP tools | Agents cannot use `patlib_vector_search` |
| CLI search fallbacks | No command-line vector search |
| Reindex capability | No way to update embeddings without restoring tools |
| Benchmarking | No way to measure vector search accuracy |
| 12 `_lib/` modules | ~716 LOC of dead code to maintain or clean up |
| Vector DB | 1061 embeddings orphaned in database |

## What We Gained

| Gain | Value |
|------|-------|
| Clean `tools/` directory | All 17 active tools pass audit |
| No startup errors | Session starts without terminal interference |
| Tool creation checklist | Prevents recurrence of format violations |
| Format violation patterns catalog | Quick reference for agents creating tools |
| Error message catalog | All known error messages with fixes |
| Deeper project understanding | Map of all subprojects, entities, DBs, configs |
