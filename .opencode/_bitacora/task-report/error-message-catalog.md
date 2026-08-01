# Error Message Catalog

Common error messages encountered during the vector tooling session, what they mean, and how to respond.

## Startup Validation Errors

### "shebang CLI pattern detected"

| Field | Value |
|-------|-------|
| **Context** | opencode scanning `.opencode/tools/` on session start |
| **Source** | `audit-tool` skill, Rule 2 |
| **Trigger** | File starts with `#!/usr/bin/env bun` instead of `// @toolclass` |
| **Example files** | `bench-vectors.ts`, `reindex-vectors.ts`, `search-vectors.ts`, `similar-vectors.ts` |
| **Meaning** | File is eligible for auto-discovery but uses the wrong entry point format |
| **Fix** | Convert to `export default tool({...})` or move to `_disabled/` |

### "console output in tool"

| Field | Value |
|-------|-------|
| **Context** | `audit-tool`, Rule 8 |
| **Trigger** | `console.log()`, `console.error()`, `process.stdout.write()` in tool file |
| **Example** | Any shebang CLI tool using `main().catch()` pattern |
| **Meaning** | Tools must return strings for LLM consumption, not write to terminal |
| **Fix** | Replace with `return { content: [{ type: "text", text: ... }] }` |

### "cross-tool import detected"

| Field | Value |
|-------|-------|
| **Context** | `audit-tool`, Rule 5 |
| **Trigger** | Import path contains `tools/` targeting another tool's directory |
| **Example** | `import("../tools/mcp-patlib-vector/embedder")` in `bench-vectors.ts` |
| **Meaning** | Tools import only from `_lib/` or `lib/`. Importing from another tool creates coupling. |
| **Fix** | Extract shared logic to `_lib/`, import from there |

### "export default tool({...}) not found"

| Field | Value |
|-------|-------|
| **Context** | opencode plugin discovery |
| **Trigger** | File in `tools/` doesn't export a default tool object |
| **Example** | Any file using `export default function` or `export default {}` instead |
| **Meaning** | opencode expects the plugin interface for auto-discovered tools |
| **Fix** | Add `export default tool({...})` with `@opencode-ai/plugin` |

## Runtime Errors

### "Entity not found in vector index"

| Field | Value |
|-------|-------|
| **Context** | Running `similar-vectors.ts --entity-id <id>` |
| **Trigger** | Entity ID not present in `patlib-vector.db` embeddings table |
| **Meaning** | The entity exists in `patlib.db` but hasn't been embedded yet. Need to run reindex first. |
| **Fix** | `bun run tools/_disabled/reindex-vectors.ts --type <type> --force` (if restored) |

### "Embedder not registered"

| Field | Value |
|-------|-------|
| **Context** | Calling `embed()` or `embedBatch()` without loading `_lib/embedder-onnx` |
| **Trigger** | The embedder registry (`_lib/embedder.ts`) has no implementation registered |
| **Meaning** | `_lib/embedder-onnx.ts` must be imported to call `setEmbedder()` at module scope |
| **Fix** | Add `import "../_lib/embedder-onnx"` before any embedder call |

### "Fatal: ..." (caught by main().catch())

| Field | Value |
|-------|-------|
| **Context** | Any shebang CLI tool |
| **Trigger** | Unhandled exception in `main()` |
| **Format** | `main().catch(e => { console.error("Fatal:", e); process.exit(1) })` |
| **Meaning** | An unexpected error occurred during tool execution |
| **Fix** | Check stack trace. Common causes: DB path not found, schema mismatch, missing table. |

## MCP Server Errors

### Connection refused / timeout

| Field | Value |
|-------|-------|
| **Context** | Agent calls `patlib_vector_search` tool |
| **Trigger** | `mcp-patlib-vector` MCP server is disabled in config |
| **Meaning** | The rule `query-patlib-context.md` instructs agents to use this tool, but the server doesn't run |
| **Fix** | Disable or update the rule |

## User-Observed Output (Not Errors, But Confusing)

### "loadding embedder moderl"

| Field | Value |
|-------|-------|
| **Source** | `bench-vectors.ts` line 48: `console.log("Loading embedder model...")` |
| **Why it appears** | Tool ran when session started (auto-discovery/validation triggered execution) |
| **Why confusing** | Typo in original message, no indication of what's happening or why |

### "runnin 16 query tst"

| Field | Value |
|-------|-------|
| **Source** | `bench-vectors.ts` line 52: `console.log("Running " + tests.length + " query tests...")` |
| **Why it appears** | Same as above — tool auto-executed |

### "reindex vectors reindex one entity type in isolated process"

| Field | Value |
|-------|-------|
| **Source** | `reindex-vectors.ts` help text (printed on --help or missing args) |
| **Why it appears** | Tool was invoked without required `--type` argument, triggering help() |

## Distinguishing Error Types

```
User sees output on terminal
├── Is it from opencode startup validation?
│   ├── Yes → audit-tool format violation (shebang, console.log, cross-import)
│   └── No → Is it from a tool running?
│       ├── Yes → tool was executed (check what triggered it)
│       └── No → Is it from MCP server?
│           ├── Yes → check opencode.json config
│           └── No → system service or cron output
└── Is it in terminal but not from opencode?
    ├── systemd service logs
    ├── background process output
    └── shell prompt interference
```
