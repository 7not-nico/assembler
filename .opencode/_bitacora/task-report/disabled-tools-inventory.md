# Disabled Tools Inventory

Everything in `tools/_disabled/` — what it is, why it's disabled, and what it would take to restore.

## File List

```
_disabled/
├── bench-vectors.ts          (5.4 KB)
├── reindex-vectors.ts        (2.4 KB)
├── search-vectors.ts         (4.8 KB)
├── similar-vectors.ts        (3.6 KB)
└── mcp-patlib-vector/        (dir)
    ├── index.ts              (6.8 KB, 221 LOC)
    ├── embedder.ts           (0.3 KB, 7 LOC — thin re-export)
    ├── package.json
    ├── bun.lock
    └── node_modules/          (symlink → ../../.opencode/node_modules)
```

## What Each Tool Does

| Tool | Purpose | Replaced by |
|------|---------|-------------|
| `bench-vectors.ts` | Benchmark vector search (16 test queries, ONNX embedder) | Nothing — diagnostic only |
| `reindex-vectors.ts` | Reindex one entity type (`--type`, `--force`) | Nothing |
| `search-vectors.ts` | Search by query (`--query`, `--mode`, `--scope`, `--type`, `--limit`) | Nothing |
| `similar-vectors.ts` | Find entities similar to a given entity ID (`--entity-id`, `--scope`, `--type`, `--limit`) | Nothing |
| `mcp-patlib-vector/` | MCP server with 4 tools (search, similar, keyword, reindex) | Nothing |

## Why Disabled

All tools violated the `audit-tool` format rule: they use `#!/usr/bin/env bun` shebang CLI pattern instead of `export default tool({...})`. When opencode starts in `assembler/`, it scans `.opencode/tools/` and validates all tool files — the shebang CLIs trigger validation failures.

The cross-tool import violation (importing from `tools/mcp-patlib-vector/embedder.ts` instead of `_lib/embedder-onnx.ts`) had already been fixed before disabling.

## How to Restore

To restore any of these, convert from shebang CLI to Custom IPC Tool plugin:

1. Remove `#!/usr/bin/env bun` shebang
2. Add `import { tool } from "@opencode-ai/plugin"`
3. Replace `main()` function with `export default tool({ execute: async (args) => { ... } })` 
4. Replace all `console.log(...)` with `return { content: [{ type: "text", text: ... }] }`
5. Replace `process.argv` parsing with schema args: `args: { ... }`
6. Replace `process.exit(1)` with `throw new Error(...)` or early return
7. Add `crashOnError()` at top of `execute()`

## Data Files Still Present

```
.opencode/patlib-vector.db       (SQLite vector DB)
.opencode/patlib-vector.db-wal   (WAL journal)
.opencode/patlib-vector.db-shm   (SHM)
.opencode/_schemas/patlib-vector.sql  (schema definition)
```

These are not cleaned up — data persists if tools are restored.

## Dependencies Still in `_lib/`

12 `_lib/` modules (~716 LOC) have no remaining consumers and are orphaned:

- `embedder-onnx.ts` — ONNX pipeline (`@xenova/transformers`)
- `embedder.ts` — Registry pattern
- `vector-bench.ts` — Benchmark harness
- `reindex-entity.ts` — Reindex logic
- `vector-db.ts` — Vector DB init
- `vector-query.ts` — Cosine search, FTS5 query
- `vector-queries.ts` — Embedding/FTS DB queries
- `rank.ts` — RRF fusion
- `entity-lookup.ts` — Title lookup
- `read-entities.ts` — Entity text assembly
- `entity-paths.ts` — Source path + mtime
- `ensure-vector-schema.ts` — Schema migration
