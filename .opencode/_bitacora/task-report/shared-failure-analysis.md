# Shared Failure Analysis

Multiple tools failed with the same symptom (startup validation error). Was it a shared dependency problem, or the same independent problem in each tool?

## The Tools That Failed

| # | Tool | Creator | Format | Cross-tool import | Status |
|---|------|---------|--------|-------------------|--------|
| 1 | `bench-vectors.ts` | Earlier session | shebang ❌ | Yes (fixed) ❌ | Disabled |
| 2 | `reindex-vectors.ts` | Earlier session | shebang ❌ | Yes (fixed) ❌ | Disabled |
| 3 | `search-vectors.ts` | This session | shebang ❌ | No ✅ | Disabled |
| 4 | `similar-vectors.ts` | This session | shebang ❌ | No ✅ | Disabled |
| 5 | `mcp-patlib-vector/` | Earlier session | shebang MCP ✅ | No ✅ | Disabled (unrelated reason) |

## Hypothesis A: Shared Dependency

All tools import from `_lib/` modules. If one of those shared modules had a format or import violation, all tools that import from it would fail.

Let's trace the actual shared dependency graph:

```
mcp-patlib-vector/index.ts            bench-vectors.ts       reindex-vectors.ts
  │                                      │                      │
  ├── _lib/db                            ├── _lib/db            ├── _lib/db
  ├── _lib/vector-db                     ├── _lib/vector-db     ├── _lib/vector-db
  ├── _lib/embedder-onnx ←─── shared ─── ├── _lib/embedder-onnx  │
  ├── _lib/vector-query                  │                       ├── _lib/reindex-entity
  ├── _lib/vector-queries                │                       │   ├── _lib/read-entities
  ├── _lib/rank                          │                       │   └── _lib/entity-paths
  ├── _lib/entity-lookup                 │                       │
  ├── _lib/read-entities                 │                       │
  └── _lib/entity-paths                  │                       │
                                         │                       │
search-vectors.ts              similar-vectors.ts               │
  │                              │                              │
  ├── _lib/db                    ├── _lib/db                    │
  ├── _lib/vector-db             ├── _lib/vector-db             │
  ├── _lib/embedder-onnx (lazy)  │                              │
  ├── _lib/vector-query          ├── _lib/vector-query          │
  ├── _lib/vector-queries        ├── _lib/vector-queries        │
  ├── _lib/entity-lookup         ├── _lib/entity-lookup         │
  └── _lib/rank                  │                              │
                                 │                              │
```

All 5 tools share these `_lib/` modules:
- `_lib/db` — shared by ALL tools in the project (not just these 5)
- `_lib/vector-db` — shared only by these 5
- `_lib/embedder-onnx` — shared by 4 of these 5 (not similar-vectors)
- `_lib/vector-query` — shared by 3 of these 5
- `_lib/entity-lookup` — shared by 3 of these 5

**If any of these shared modules had a violation**, all consumers would fail.

Let's check each shared module:

| Module | Has violation? | Evidence |
|--------|---------------|----------|
| `_lib/db` | No | Used by 17 active tools without error |
| `_lib/vector-db` | No | Only imports from `_lib/paths`, `_lib/ensure-vector-schema`, `bun:sqlite`, `fs`, `path` |
| `_lib/embedder-onnx` | No | Only imports from `_lib/embedder`, `@xenova/transformers`. Calls `setEmbedder()` at module scope (function pointer registry) |
| `_lib/embedder` | No | No imports (registry pattern) |
| `_lib/vector-query` | No | Pure module, no imports |
| `_lib/vector-queries` | No | Only imports `bun:sqlite` |
| `_lib/rank` | No | Pure module, no imports |
| `_lib/entity-lookup` | No | Only imports `bun:sqlite` and `_lib/vector-query` |
| `_lib/reindex-entity` | No | Only imports `_lib/read-entities`, `_lib/vector-query`, `_lib/entity-paths`, `bun:sqlite` |
| `_lib/vector-bench` | No | Depends on `_lib/embedder-onnx`, `bun:sqlite`, `_lib/db` — all clean |

**Conclusion: Hypothesis A is rejected.** No shared dependency has a format or import violation. All `_lib/` modules pass audit.

## Hypothesis B: Same Independent Problem in Each Tool

Each tool independently violates the same audit rules:

| Tool | Rule 2 (shebang) | Rule 8 (console.log) | Rule 5 (cross-import) |
|------|------------------|---------------------|----------------------|
| `bench-vectors.ts` | ❌ | ❌ | ❌ (fixed) |
| `reindex-vectors.ts` | ❌ | ❌ | ❌ (fixed) |
| `search-vectors.ts` | ❌ | ❌ | ✅ |
| `similar-vectors.ts` | ❌ | ❌ | ✅ |
| `mcp-patlib-vector/` | ✅ (exempt) | ✅ (exempt) | ✅ |

All 4 CLI tools fail Rules 2 and 8. The cross-import (Rule 5) was fixed but the format violations remained.

**Why do all 4 have the same violation?**

They all share a common **ancestor**: the MCP server `mcp-patlib-vector/index.ts`.

```
mcp-patlib-vector/index.ts
  └── uses shebang + main().catch() + console.log (OK for MCP)
        │
        ├── bench-vectors.ts
        │     └── copies format from MCP server ──→ ❌ (not OK for tools)
        │
        ├── reindex-vectors.ts
        │     └── copies format from bench-vectors ──→ ❌
        │
        └── (later) search-vectors.ts, similar-vectors.ts
              └── copies format from reindex-vectors ──→ ❌
```

**Conclusion: Hypothesis B is confirmed.** The violation is not from a shared dependency — it's from a shared **template pattern**. Each tool was independently created using the MCP server's format as a template, which is valid for MCP servers but invalid for plugin tools.

## The Actual Shared Dependency: The Agent

The agent (me) is the true shared dependency. I:

1. Read `reindex-vectors.ts` (disabled shebang CLI) during investigation
2. Used its format as the template when creating `search-vectors.ts` and `similar-vectors.ts`
3. Did not verify the template format against audit rules before writing

This is a **workflow dependency**, not a code dependency.

```
Agent reads disabled tool
  │
  └── Internalizes format: "shebang + main() + console.log = valid tool pattern"
        │
        ├── Creates search-vectors.ts ──→ same invalid format
        ├── Creates similar-vectors.ts ──→ same invalid format
        └── Restores reindex-vectors.ts ──→ already invalid format
```

## What to Derive

### 1. The Template Determines Quality

The first tool in a family sets the pattern. If the first tool follows the wrong template, all subsequent tools will copy the same errors. This is why a verified template (`tool-creation-checklist.md`) is critical.

### 2. Auditing Existing Tools Is Not Enough

Reading a disabled tool to understand its logic does not mean its format should be copied. The format of a failed tool must be treated as suspect.

### 3. Shared Dependency Has Two Meanings

| Type | Definition | Detection |
|------|-----------|-----------|
| Code dependency | Shared module imported by multiple tools | `rg 'import.*from.*_lib/X'` |
| Template dependency | Shared format pattern copied across tools | File header inspection (`head -1`) |

The original investigation only checked code dependencies. The actual problem was a template dependency, which required a different detection method.

### 4. Prevention

1. **Template over copy**: Always use the verified template from `tool-creation-checklist.md`, never copy an existing tool's format.
2. **Verify after create**: After creating a tool, run the audit checks independently — don't assume the format is correct just because the imports are clean.
3. **Flag all shebang CLIs**: A pre-creation check should warn: "You are about to create a tool. The shebang CLI pattern is invalid for tools. Use the plugin template."

## Summary

| Question | Answer |
|----------|--------|
| Did a shared `_lib/` module cause all failures? | **No.** All `_lib/` modules are clean. |
| Did all tools independently have the same bug? | **Yes.** All 4 use shebang CLI format, invalid for tools. |
| Why did they all use the same wrong format? | **Template dependency**: The MCP server's format was copied as a template. |
| What is the true shared dependency? | **The agent's workflow** — reading disabled tools' format internalized it as valid. |
