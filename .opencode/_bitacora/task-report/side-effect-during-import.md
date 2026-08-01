# Side Effects During Import

Why the user saw tool output before the error.

## The Problem

When opencode imports a tool file for auto-discovery, it executes the file's top-level code as part of the import process. If the tool file has side effects at the top level (console.log, DB connections, function calls), those run BEFORE the format check.

## The Execution Order

```
1. opencode calls: await import("tools/search-vectors.ts")
     │
2. Node/Bun loads the file
     │
3. Top-level code executes (IN ORDER):
     │
     │   #!/usr/bin/env bun           ← shebang (ignored at runtime)
     │   // @toolclass TRNS           ← comment
     │   import { initDB } from ...   ← import resolved
     │   import { initVectorDB } ...  ← import resolved
     │   // ... more imports ...
     │
     │   async function main() {      ← function definition
     │     console.log("Loading embedder model...")  ← ❌ SIDE EFFECT
     │     const db = initDB()         ← ❌ SIDE EFFECT
     │     const vdb = initVectorDB()  ← ❌ SIDE EFFECT
     │     main()                      ← ❌ SIDE EFFECT (runs main)
     │   }
     │
     │   main().catch(...)             ← ❌ SIDE EFFECT (invokes main)
     │
4. Module evaluation completes
     │
     │   exports: {}                   ← no default export
     │
5. Interceptor checks:
     │
     │   mod.default?.execute          ← undefined
     │   → TypeError
     │   → "exception running tool"
     │
6. User sees:
     │   "Loading embedder model..."   ← from step 3
     │   "Running 16 query tests..."   ← from step 3
     │   TypeError: ...                ← from step 5
```

Steps 3 and 5 are separated in time. The side effects from step 3 produce visible output BEFORE the error from step 5.

## What the User Actually Experienced

```
Terminal output order:
  1. "loadding embedder moderl"       ← bench-vectors.ts line 48
  2. "runnin 16 query tst"            ← bench-vectors.ts line 52
  3. [Exception: tools/bench-vectors.ts] ← interceptor catch block
  4. [TypeError: ...]                  ← from mod.default?.execute
```

The user saw "loadding embedder moderl" and "runnin 16 query tst" first — these are side effects from the tool running during import. The actual error (TypeError) appeared after the side effects.

This is why the error was confusing: the output suggested the tool WAS running (it printed progress messages), but it actually failed to register because the format was wrong.

## Tools That Produce Side Effects on Import

| Tool | Side effects on import |
|------|----------------------|
| `bench-vectors.ts` | console.log, initDB, initVectorDB, embedder model load |
| `reindex-vectors.ts` | console.log, initDB, initVectorDB |
| `search-vectors.ts` | (import only, lazy embedder) |
| `similar-vectors.ts` | (import only, no embedder) |
| `mcp-patlib-vector/index.ts` | MCP server init, file watcher start |

## The Embedder Loading Problem

`bench-vectors.ts` calls `initDB()` and `initVectorDB()` at the top of `main()` — these open database connections. The `main()` function is called immediately via `main().catch(...)`. If the embedder model has not been cached yet, the first `embed()` call downloads the model from HuggingFace (~269ms cold start):

```typescript
async function main() {
  console.log("Loading embedder model...")   // ← appears in terminal
  const { embed, getModel } = await import("../_lib/embedder-onnx")
  getModel()                                   // ← triggers model load
  // ...
}
main().catch(e => console.error("Fatal:", e))
```

The user saw "loadding embedder moderl" because `console.log` ran during import. The actual model download might have started before the import failed.

## What Plugins/Events Run During Import

When a plugin tool is imported successfully, it may register event handlers via the plugin system. The following plugins run code during import:

| Plugin | Import side effects |
|--------|-------------------|
| `auto-sync.ts` | Sets up file watchers, debounce timers |
| `burst-alert.ts` | Starts file watcher |
| `audit-events.ts` | (lazy, runs on events) |
| `ref-integrity.ts` | (lazy, runs on events) |
| `session-saver.ts` | (lazy, runs on events) |
| `bash-guard.ts` | Registers bash command guard |
| `cmd-audit.ts` | Registers command audit hook |
| `log-mcp.ts` | Registers MCP logging hook |

These plugins use the `@pluginclass` pattern and register event handlers via the `{ client }` object. They do NOT produce console output or run heavy operations during import.

## Prevention

1. **Shebang pre-check** — scan file's first line before importing; skip shebang files
2. **Side-effect budgets** — a tool file should not have top-level IO beyond import statements
3. **Lazy initialization** — DB connections and model loading should be deferred to the first `execute()` call
4. **No console.log in module scope** — all terminal output should be inside `execute()`
