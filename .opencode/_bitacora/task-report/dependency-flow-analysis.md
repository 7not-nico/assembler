# Dependency Flow Analysis

How dependencies between tools, MCP servers, and shared libraries propagate errors.

## The Dependency Chain

```
opencode start
  ├── opencode.json ────────────────────────── MCP servers (patlib, burst-alert, ...)
  └── tools/ auto-discovery
        ├── read-selection.ts         ✅ plugin format
        ├── write-sync.ts             ✅ plugin format
        ├── search-vectors.ts         ❌ shebang CLI → ERROR
        ├── similar-vectors.ts        ❌ shebang CLI → ERROR
        ├── reindex-vectors.ts        ❌ shebang CLI → ERROR
        └── _lib/
              ├── db.ts               ─── used by all
              ├── embedder-onnx.ts    ─── used by none (orphaned)
              ├── vector-query.ts     ─── used by none (orphaned)
              └── ...
```

## Error Propagation

```
Shebang CLI in tools/ (file created)
  │
  ▼
opencode discovers file in tools/ scan
  │
  ▼
audit-tool checks format
  │
  ├── ✅ if plugin format → tool registered, no output
  │
  └── ❌ if shebang format → validation failure → terminal output
        │
        ▼
      User sees error
      User cannot type (terminal flooded)
```

## Library Orphan Chain

```
MCP server (mcp-patlib-vector) has logic
  │
  ▼
Logic extracted to _lib/ modules (reindex-entity, vector-query, etc.)
  │
  ▼
CLI tools created that import from _lib/
  │
  ▼
CLI tools disabled
  │
  ▼
_lib/ modules now orphaned — no remaining consumers
```

The extraction was good engineering (MAX.DRY) but created dead code when the consumers were removed. The `_lib/` modules have no way to know they're orphaned.

## Import Flow (Original Bug)

```
tools/bench-vectors.ts
  │
  ├── import("../_lib/db")              ✅ _lib/
  ├── import("../_lib/vector-bench")    ✅ _lib/
  ├── import("../_lib/vector-db")       ✅ _lib/
  │
  └── import("../tools/mcp-patlib-vector/embedder")   ❌ cross-tool
        │
        └── re-exports from _lib/embedder-onnx
              │
              └── calls setEmbedder() at module scope
```

The cross-tool import was a single wrong path that bypassed the `_lib/` abstraction. The embedder logic itself was correctly in `_lib/`, but the import path went through `tools/` instead of directly to `_lib/`.

## Import Flow (Follow-Up Bug)

```
tools/search-vectors.ts
  │
  ├── import("../_lib/db")              ✅ _lib/
  ├── import("../_lib/vector-db")       ✅ _lib/
  ├── import("../_lib/vector-query")    ✅ _lib/
  ├── import("../_lib/vector-queries")  ✅ _lib/
  ├── import("../_lib/entity-lookup")   ✅ _lib/
  ├── import("../_lib/rank")            ✅ _lib/
  │
  └── await import("../_lib/embedder-onnx")   ✅ _lib/ (lazy)
       │
       └── calls setEmbedder() at module scope
```

Imports are all correct. No cross-tool violation. But the file format itself (shebang + main + console.log) is the violation.

## Key Insight

The error **propagated differently** in each bug:

| Bug | Error Source | Error Detection | Impact |
|-----|-------------|-----------------|--------|
| 1 (cross-tool import) | Static import path | Code review, file grep | Code quality, fragile deps |
| 2 (shebang format) | File entry point | Session startup validation | Blocks user from working |

Bug 1 was a code quality issue that could have caused runtime failures. Bug 2 was an operational issue that blocked session startup. Both appeared as "terminal output on session start" but had completely different mechanisms.

## How Dependencies Should Flow

```
opencode start
  │
  └── tools/ discovery
        │
        ├── plugin tools (*.ts)
        │     └── import from _lib/ only
        │
        └── MCP servers (*/index.ts)
              └── import from _lib/ only
                    │
                    └── _lib/ modules
                          └── import from _lib/ only (internal)
```

No `tools/` file imports from another `tools/` file. All shared logic routes through `_lib/`. This is the pattern described in `REF.LIB.DIRECTORY.LAYER` and `PROT.TOOL.COMPOSITE`.
