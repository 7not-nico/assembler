# Two Errors, One Symptom

Throughout this session, we encountered two distinct errors that produced the same symptom: terminal output on session startup that blocked the user.

## The Errors

| | Error 1: Cross-Tool Import | Error 2: Shebang CLI Format |
|---|---------------------------|---------------------------|
| **Files** | `bench-vectors.ts`, `reindex-vectors.ts` | `search-vectors.ts`, `similar-vectors.ts` |
| **Root cause** | `import("../tools/mcp-patlib-vector/embedder")` | `#!/usr/bin/env bun` instead of `export default tool` |
| **Protocol violated** | PROT.TOOL.MORPHISM Gotcha 1, REF.LIB.DIRECTORY.LAYER Rule 7 | PROT.TOOL.DEFINITION Rules 1, 4, 9 |
| **Detected by** | Code review, `rg import.*tools/` | Session startup validation |
| **When it fails** | Runtime when tool runs (embedder not found if MCP dir removed) | Import time during tool discovery |
| **Fix** | Extract to `_lib/embedder-onnx.ts` | Convert to `export default tool({...})` |

## Why They Look the Same

Both errors produced the same visible symptom:

```
Terminal output during session start
  → "exception running tool name.ts"
  → User cannot type or interact
```

But the mechanisms are completely different:

```
Error 1 (cross-tool import):
  ┌─────────────────────────────┐
  │ File is discovered           │
  │ Import starts                │
  │ Import succeeds (path valid) │
  │ default?.execute succeeds    │ ← tool IS valid format
  │ Tool registered              │
  │ Later: tool runs, imports    │
  │   from wrong path            │
  │   → embedder from MCP dir   │
  │   → MCP dir may be deleted   │
  │   → import fails at runtime  │
  └─────────────────────────────┘

Error 2 (shebang format):
  ┌─────────────────────────────┐
  │ File is discovered           │
  │ Import starts                │
  │ Top-level code executes      │
  │   → console.log runs         │
  │   → main() runs              │
  │ Import succeeds              │
  │ default?.execute fails       │ ← undefined
  │ → TypeError                  │
  │ → "exception running tool"   │
  │ Tool NOT registered          │
  └─────────────────────────────┘
```

## The Diagnostic Trap

Because both errors produce the same symptom, we assumed they had the same cause. We fixed Error 1 (cross-tool imports) and assumed Error 2 was also fixed. But:

| Fix round | What we fixed | What we thought | What was still broken |
|-----------|--------------|----------------|----------------------|
| 1 | Cross-tool imports in bench-vectors, reindex-vectors | "Import paths are clean now" | Shebang format in same files |
| 2 | Repeated: "imports are from _lib/, no violations" | "Format is clean too" | Shebang format in NEW files (search-vectors, similar-vectors) |

Each time we verified one dimension (import paths) and assumed the other dimension (format) was correct.

## Key Insight

The two errors are **independent** — fixing one does not fix the other. They share:

- Same symptom ✅
- Same project area (vector tooling) ✅
- Same files (bench-vectors, reindex-vectors) ✅

But NOT:
- Same root cause ❌
- Same protocol violation ❌
- Same fix ❌
- Same detection method ❌

## How to Avoid This in the Future

1. **List all violations independently** — when a tool fails, check ALL audit rules, not just the first one found
2. **Verify each fix dimension** — after fixing imports, verify format separately
3. **Don't assume same error = same cause** — the same symptom can come from different bugs
4. **Use the audit checklist** — `tool-creation-checklist.md` covers all 8 rules
5. **Test with a fresh session** — only a new opencode start validates the auto-discovery path
