# Extract ONNX embedder to shared _lib/embedder-onnx.ts

**Maxim refs:** MAX.DRY (single source), MAX.ORTHOGONALITY (no cross-tool imports), MAX.STALL.ENGINE (disable MCP without breaking CLI)

## Problem

Three tools imported ONNX embedder implementation from `tools/mcp-patlib-vector/embedder.ts`:
- `reindex-vectors.ts` — `import("../tools/mcp-patlib-vector/embedder")`
- `bench-vectors.ts` — `import("../tools/mcp-patlib-vector/embedder")`  
- `mcp-patlib-vector/index.ts` — `import("./embedder")`

Disabling the MCP server (`patlib-vector`) still left the embedder loading because CLI tools had hard cross-tool imports into the MCP tool directory.

## Fix

Extracted the ONNX pipeline implementation from `tools/mcp-patlib-vector/embedder.ts` to `_lib/embedder-onnx.ts`. This is a neutral shared lib importable by all tools.

| Before | After |
|--------|-------|
| `tools/mcp-patlib-vector/embedder.ts` — 49 LOC, full impl | `tools/mcp-patlib-vector/embedder.ts` — 7 LOC, thin re-export |
| `_lib/embedder-onnx.ts` — (did not exist) | `_lib/embedder-onnx.ts` — 49 LOC, shared impl |
| `reindex-vectors.ts` → cross import to `mcp-patlib-vector` | `reindex-vectors.ts` → imports `_lib/embedder-onnx` |
| `bench-vectors.ts` → cross import to `mcp-patlib-vector` | `bench-vectors.ts` → imports `_lib/embedder-onnx` |
| `_lib/vector-bench.ts` depends-on: cross-tool | depends-on: `./embedder-onnx` |

## Verified

- [x] `bun build --no-bundle reindex-vectors.ts` — 0 errors
- [x] `bun build --no-bundle bench-vectors.ts` — 0 errors
- [x] `bun build --no-bundle mcp-patlib-vector/index.ts` — 0 errors
- [x] `bun build --no-bundle _lib/embedder-onnx.ts` — 0 errors
- [x] No more `mcp-patlib-vector/embedder` imports from `tools/` or `_lib/`
- [x] `bun run reindex-vectors.ts --type definitions --force` — 6 embeddings, works
