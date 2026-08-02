# Vector Tooling Retrospective

## Problem

When starting an opencode session in `assembler/`, tools auto-executed and produced terminal output that interfered with the user's ability to interact. Observed output:

```
loadding embedder moderl
runnin 16 query tst
reindex vectors reindex one entity type in isolated process
--type <name>    entity type (required)
--force          ignore source_mtime, full recompute
```

## Investigation

### Root Cause: Cross-Tool Imports

Three tools imported the ONNX embedder implementation from `tools/mcp-patlib-vector/embedder.ts` instead of a shared `_lib/` module:

| Tool | Old import | Violation |
|------|-----------|-----------|
| `bench-vectors.ts` | `import("../tools/mcp-patlib-vector/embedder")` | Cross-tool |
| `reindex-vectors.ts` | `import("../tools/mcp-patlib-vector/embedder")` | Cross-tool |
| `mcp-patlib-vector/index.ts` | `import("./embedder")` | (internal, OK) |

This created a hard dependency chain: disabling the `patlib-vector` MCP server in `opencode.json` did **not** prevent the CLI tools from loading because they imported directly into the MCP server's directory.

### Secondary Issue: Plugin Format Violation (Actual Startup Error)

The `_lib/` modules (`embedder-onnx`, `vector-query`, `vector-queries`, `rank`, `entity-lookup`, `reindex-entity`, etc.) were extracted from the `mcp-patlib-vector` MCP server monolith during an earlier refactoring session. The imports in the new CLI tools (`search-vectors.ts`, `similar-vectors.ts`) correctly pointed to `_lib/` — the cross-tool import issue had already been fixed.

The actual error on session startup was the **plugin format**: the new tools used `#!/usr/bin/env bun` with `main().catch()` (shebang CLI pattern) instead of `export default tool({...})` (Custom IPC Tool format). The `audit-tool` skill flags two violations:

1. **Rule 2**: `export default tool({...})` required — shebang CLI pattern flagged
2. **Rule 8**: Console output excluded — tools must return strings for LLM consumption, not use `console.log`

When opencode starts in `assembler/`, it scans `.opencode/tools/` and validates all tool files. The shebang CLI tools triggered validation failures on session startup — the same class of error as the original issue, even though the import path violation had been resolved.

The fix was not to restore the tools as shebang CLIs, but either to leave them disabled or rebuild them as proper Custom IPC Tools (`export default tool({...})`).

## Actions Taken

| Date | Action | Files |
|------|--------|-------|
| 2026-07-23 | Moved `mcp-patlib-vector/` MCP server to `_disabled/` | `tools/mcp-patlib-vector/ → _disabled/mcp-patlib-vector/` |
| 2026-07-23 | Moved `bench-vectors.ts` to `_disabled/` | `tools/bench-vectors.ts → _disabled/bench-vectors.ts` |
| 2026-07-23 | Moved `reindex-vectors.ts` to `_disabled/` initially, restored later, then re-disabled | `tools/reindex-vectors.ts → _disabled/reindex-vectors.ts` |
| 2026-07-23 | Created `search-vectors.ts` then disabled | `tools/search-vectors.ts → _disabled/search-vectors.ts` |
| 2026-07-23 | Created `similar-vectors.ts` then disabled | `tools/similar-vectors.ts → _disabled/similar-vectors.ts` |

## Dependencies Per Disabled Tool

### `mcp-patlib-vector/` (MCP Server)

| Dependency | Source | Purpose |
|-----------|--------|---------|
| `@modelcontextprotocol/sdk` | npm | MCP server framework |
| `zod` | npm | Schema validation |
| `bun:sqlite` | built-in | Database |
| `_lib/db` | shared | patlib.db init |
| `_lib/vector-db` | shared | Vector DB init |
| `_lib/entity-paths` | shared | Entity source path + mtime |
| `_lib/reindex-entity` | shared | Reindex logic |
| `_lib/vector-query` | shared | Cosine search, FTS5 query, entity table |
| `_lib/vector-queries` | shared | Embedding/FTS DB queries |
| `_lib/rank` | shared | RRF fusion |
| `_lib/entity-lookup` | shared | Title lookup |
| `_lib/read-entities` | shared | Entity text assembly |
| `./embedder` | local (thin re-export) | Re-exports `_lib/embedder-onnx` |

### `reindex-vectors.ts` (Shebang CLI)

| Dependency | Source | Purpose |
|-----------|--------|---------|
| `bun:sqlite` | built-in | Database |
| `_lib/db` | shared | patlib.db init |
| `_lib/vector-db` | shared | Vector DB init |
| `_lib/reindex-entity` | shared | Reindex logic |
| `_lib/embedder-onnx` | shared (lazy) | ONNX embedding model |

### `search-vectors.ts` (Shebang CLI)

| Dependency | Source | Purpose |
|-----------|--------|---------|
| `bun:sqlite` | built-in | Database |
| `_lib/db` | shared | patlib.db init |
| `_lib/vector-db` | shared | Vector DB init |
| `_lib/vector-query` | shared | Cosine search, FTS5 query, entity table |
| `_lib/vector-queries` | shared | Embedding/FTS DB queries |
| `_lib/rank` | shared | RRF fusion (hybrid mode) |
| `_lib/entity-lookup` | shared | Title lookup |
| `_lib/embedder-onnx` | shared (lazy) | ONNX embedding model (vector/hybrid modes) |

### `similar-vectors.ts` (Shebang CLI)

| Dependency | Source | Purpose |
|-----------|--------|---------|
| `bun:sqlite` | built-in | Database |
| `_lib/db` | shared | patlib.db init |
| `_lib/vector-db` | shared | Vector DB init |
| `_lib/vector-query` | shared | Cosine search, entity table |
| `_lib/vector-queries` | shared | Entity embedding + vector queries |
| `_lib/entity-lookup` | shared | Title lookup |

### `bench-vectors.ts` (Shebang CLI)

| Dependency | Source | Purpose |
|-----------|--------|---------|
| `bun:sqlite` | built-in | Database |
| `_lib/db` | shared | patlib.db init |
| `_lib/vector-db` | shared | Vector DB init |
| `_lib/vector-bench` | shared | Benchmark harness |
| `_lib/embedder-onnx` | shared | ONNX embedding model |

### External Package: `@xenova/transformers`

All tools that use `_lib/embedder-onnx` (bench-vectors, reindex-vectors, search-vectors, mcp-patlib-vector) transitively depend on `@xenova/transformers` for the `Xenova/bge-small-en-v1.5` embedding model. The model is loaded lazily via HuggingFace on the first `embed()` call — ~269ms cold start with model download.

## Current State

### Disabled (`tools/_disabled/`)

| File | Type | Purpose |
|------|------|---------|
| `mcp-patlib-vector/` | MCP server | Vector search, similar, keyword, reindex tools |
| `bench-vectors.ts` | Shebang CLI (RECG) | Vector search benchmark (16 test queries, loads embedder) |
| `reindex-vectors.ts` | Shebang CLI (TRNS) | Reindex one entity type in isolated process |
| `search-vectors.ts` | Shebang CLI (TRNS) | Vector/keyword/hybrid search by query |
| `similar-vectors.ts` | Shebang CLI (TRNS) | Find entities similar to a given entity ID |

### Active (`tools/`)

All remaining tools use the Custom IPC Tool pattern (`export default tool({...})`) or are MCP servers. No vector/embedding-related tools remain active.

### Shared Libraries (`_lib/`)

The following shared modules remain in place but are only consumed by disabled tools:

| Module | Used by |
|--------|---------|
| `embedder-onnx.ts` | bench-vectors, search-vectors, mcp-patlib-vector |
| `embedder.ts` | embedder-onnx (registry) |
| `vector-bench.ts` | bench-vectors |
| `reindex-entity.ts` | reindex-vectors, mcp-patlib-vector |
| `vector-db.ts` | bench-vectors, reindex-vectors, search-vectors, similar-vectors, mcp-patlib-vector |
| `vector-query.ts` | search-vectors, similar-vectors, mcp-patlib-vector |
| `vector-queries.ts` | search-vectors, similar-vectors, mcp-patlib-vector |
| `rank.ts` | search-vectors, mcp-patlib-vector |
| `entity-lookup.ts` | search-vectors, similar-vectors, mcp-patlib-vector |
| `read-entities.ts` | reindex-entity, mcp-patlib-vector |
| `entity-paths.ts` | reindex-entity, mcp-patlib-vector |
| `ensure-vector-schema.ts` | vector-db |
| `patlib-vector.db*` | Vector database files (data, WAL, SHM) |

## Lessons

1. **Import discipline**: Tools must import from `_lib/` only. Cross-tool imports (`tools/ → tools/`) are violations per `PROT.TOOL.COMPOSITE` and `REF.LIB.DIRECTORY.LAYER`.
2. **Format compliance**: All tools in `.opencode/tools/` must use `export default tool({...})` per `audit-tool` skill. Shebang CLI tools cause validation failures on session startup. The `_lib/` import path fix was necessary but insufficient — the format violation alone was enough to trigger the startup error.
3. **Same error, different cause**: The original and post-fix errors had the same symptom (startup failure) but different causes. First: cross-tool imports. Second: plugin format violation. Both must be checked.
4. **Clean disable**: To fully disable a tool, both the config entry (if MCP) and the file must be removed or moved. A disabled config entry with a still-present directory causes confusion.
5. **Dead libs**: Extracting shared logic to `_lib/` is good (MAX.DRY), but when all consumers are disabled, the libs become dead code and should be flagged for cleanup.

## Pending

- [ ] Remove stale `patlib-vector` entry from `opencode.json` (`:35-37`, already `"enabled": false`, path is now moved)
- [ ] Update `query-patlib-context.md` rule — instructs agents to use `patlib_vector_search` which no longer exists
- [ ] Update protocol entities (`PROT.SEARCH.VECTOR.*`) and illustrations referencing `mcp-patlib-vector`
- [ ] Remove `patlib-vector.db*` files if not re-enabling
- [ ] Remove dead `_lib/` modules if vector tooling is permanently retired
