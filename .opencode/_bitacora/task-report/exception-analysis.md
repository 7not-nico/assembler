# Exception Analysis — What Actually Happened

## The Import System

When opencode starts in `assembler/`, its plugin system scans `.opencode/tools/` and attempts to import every `.ts` file. The import goes through an auto-discovery loader that:

1. Reads the file
2. Imports it as a module via `await import(path)`
3. Expects `module.exports.default` to be a `tool({...})` object
4. Calls `tool.execute(args)` with the agent's arguments

## The Exception

When a shebang CLI tool is imported, the following occurs:

```
1. Import starts:  await import("tools/search-vectors.ts")
                     │
2. Top-level code executes:
   │  console.log("Loading patlib and vector DB...")    ← side effect
   │  const patlib = initDB()                            ← side effect
   │  const vdb = initVectorDB()                         ← side effect
   │  main().catch(e => console.error(e))               ← runs main()
   │
3. Module evaluation completes:
   │  exports: {}                                        ← EMPTY
   │  default: undefined                                 ← NO tool object
   │
4. Plugin loader checks:
   │  mod.default?.execute                               ← undefined
   │
5. Exception thrown:
   │  TypeError: Cannot read properties of undefined
   │  (reading 'execute')
   │  at opencode plugin loader
   │
6. Error output to terminal:
   │  [Exception] tools/search-vectors.ts
   │  (no indication of what is wrong with the file)
```

## The Exception Message

The actual error is a **TypeError on undefined access**, not a format validation error. This is why it is confusing — it points to the file but does not explain the root cause:

| What the exception says | What it actually means |
|------------------------|------------------------|
| `TypeError: Cannot read properties of undefined (reading 'execute')` | The file's `default` export is `undefined` — there is no `export default tool({...})` |
| `at tools/search-vectors.ts` | The file that failed to export a valid tool |
| (No format message) | The loader only checks `default !== undefined && typeof default.execute === 'function'` |

## Why the Exception Is Misleading

1. **No format validation** — the loader does not check for shebang, `console.log`, or missing `export default`. It only checks that the resulting object has `.execute()`.
2. **Side effects execute silently** — top-level `console.log`, DB connections, and `main()` all run before the exception is thrown. This is why the user saw "loadding embedder moderl" and "runnin 16 query tst" — those are side effects from `bench-vectors.ts` running during import.
3. **Wrong root cause** — the exception points to the file but suggests a runtime error, not a format violation. The format violation (missing `export default tool({...})`) is the root cause but is never mentioned.

## The "Little System" (Import Interceptor)

The opencode plugin system acts as an import interceptor:

```
User starts session
  → opencode scans tools/
  → for each .ts file:
      → await import(file)
      → if import throws → report exception → CONTINUE
      → if default?.execute exists → register tool
      → if default?.execute is undefined → report exception → CONTINUE
```

The exception handler catches the error and reports it, but does not:
- Distinguish between "import failed" and "import succeeded but wrong format"
- Explain what the expected format is
- Suggest how to fix the file

This is the "little system" the user refers to — it catches exceptions but doesn't help debug them.

## Reproduced Exceptions

| File | Exception | Root cause |
|------|-----------|------------|
| `_disabled/bench-vectors.ts` | `ResolveMessage: Cannot find module '../_lib/db'` | Wrong relative path from `_disabled/` |
| `_disabled/search-vectors.ts` | `ResolveMessage: Cannot find module '../_lib/db'` | Wrong relative path from `_disabled/` |
| Any shebang CLI in `tools/` | `TypeError: Cannot read properties of undefined (reading 'execute')` | No `export default tool({...})` |
| Any shebang CLI in `tools/` | Side effects: console.log, DB open, main() run | Top-level code executes during import |

## What an Error Message Should Say

Instead of:
```
TypeError: Cannot read properties of undefined (reading 'execute') at tools/search-vectors.ts
```

It should say:
```
FORMAT VIOLATION: tools/search-vectors.ts
  - Missing: export default tool({...})
  - Found:   #!/usr/bin/env bun (shebang CLI)
  - Fix:     Use PROT.TOOL.DEFINITION template
             See tool-creation-checklist.md
```

## Prevention

1. **Pre-import validation** — before importing a tool file, check its first line for `// @toolclass` (not `#!/usr/bin/env bun`). If shebang is detected, skip import and report format error.
2. **Descriptive errors** — when `default?.execute` is undefined, check what the file actually exports and report the mismatch.
3. **Audit tool** — run `audit-tool` on all tool files before import to preempt format violations.

## See Also

- `format-violation-patterns.md` — patterns of tool format violations
- `verification-gap-analysis.md` — why bun run doesn't catch format issues
- `ANT.TOOL.SHEBANG.FORMAT` — the anti-pattern
- `PROT.TOOL.DEFINITION` — the correct format
