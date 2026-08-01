# Import Interceptor Analysis — The "Little System"

## What It Is

When opencode starts in `assembler/`, it runs a plugin auto-discovery system that scans `.opencode/tools/` and imports every `.ts` file. This system acts as an import interceptor — each file is loaded as a module, and its `default` export is checked for the `tool({...})` interface.

## The Import Flow

```
opencode start
  │
  ├── 1. Scan .opencode/tools/*.ts
  │
  ├── 2. For each file:
  │       await import("tools/name.ts")
  │         │
  │         ├── If import throws:
  │         │     └── Report "exception running tool name.ts"
  │         │     └── Continue to next file
  │         │
  │         ├── If import succeeds:
  │         │     ├── Check: mod.default?.execute
  │         │     │
  │         │     ├── If exists:
  │         │     │     └── Register tool as available
  │         │     │
  │         │     └── If undefined:
  │         │           └── Report "exception running tool name.ts"
  │         │           └── Continue to next file
  │         │
  │         └── (Side effects from top-level code have already run)
```

## The Exception Types

The interceptor produces the same error message for two different root causes:

| Actual error | What the interceptor reports | Root cause |
|-------------|----------------------------|------------|
| `TypeError: Cannot read properties of undefined (reading 'execute')` | "exception running tool name.ts" | Shebang CLI — no `export default tool({...})` |
| `TypeError: mod.default.execute is not a function` | "exception running tool name.ts" | Wrong export shape (e.g., `export default function`) |
| `ResolveMessage: Cannot find module '...'` | "exception running tool name.ts" | Import path broken (e.g., moved file) |
| Any syntax/runtime error | "exception running tool name.ts" | Code broken in the file |

The interceptor does not distinguish between these cases. It catches all exceptions with a generic handler.

## What the Interceptor Sees vs What Actually Happened

### Case 1: Shebang CLI in tools/ (the actual error)

```
Interceptor sees:                    Actually happened:
  Import succeeded                     File had no export default
  default is undefined                 Top-level console.log ran
  .execute is undefined                main() ran
  → TypeError                           DB connections opened
  → "exception running tool"           setEmbedder() called
                                       Then: no tool object to register
```

### Case 2: Moved file in _disabled/

```
Interceptor sees:                    Actually happened:
  Import failed                        File moved to _disabled/
  ResolveMessage thrown                Relative import ../_lib/db
  → "exception running tool"            now resolves from wrong path
```

## Why the Error Is Silent About Format

The interceptor is designed to be resilient — a broken tool file should not crash the entire session. It catches all exceptions and continues. However, by using a single generic handler for all errors, it loses diagnostic information:

1. The exception type is not logged (TypeError vs ResolveMessage vs SyntaxError)
2. The specific field that was missing (default vs execute) is not reported
3. The expected format is not mentioned

## What Would Help

A more diagnostic interceptor would:

1. **Catch separately by exception type**:
   - `ResolveMessage` → "File not found or import path broken"
   - `TypeError` on default → "Missing export default tool({...})"
   - `TypeError` on execute → "export default does not have .execute()"
   - Other → "Unexpected error in tool file"

2. **Log the expected format**:
   ```
   tools/search-vectors.ts: expected export default tool({...}),
   got exports=[] default=undefined
   ```

3. **Report BEFORE executing top-level code** — if possible, parse the file for `export default tool` before importing it. This would prevent side effects from running.

## The Side Effect Problem

The most dangerous aspect of the current interceptor is that **top-level code executes before the format check**. When a shebang CLI is imported:

```typescript
// top-level code runs immediately:
console.log("Loading embedder model...")  // terminal output
const db = initDB()                        // DB connection
main()                                     // runs the full tool
```

Then only after all that, the interceptor checks `default?.execute` and finds it missing. The user sees the output from the side effects before the error message.

## Recommendation

Add a pre-import format check that scans the file's first line before importing:

```
Pre-import scan:
  head -1 tools/name.ts
  ├── if line starts with "// @toolclass" → proceed with import
  ├── if line starts with "#!/usr/bin/env" → skip import, report format violation
  └── otherwise → import with warning
```

This would prevent shebang CLI side effects from executing during discovery and produce a clear error message instead of a confusing TypeError.
