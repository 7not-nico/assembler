# Dependency Management — Lessons from trump-voices

**Date**: 2026-07-24
**Status**: Documented

## The Failure

Bun's dependency management failed in the trump-voices project:
- `bun install` resolution issues
- `bun.lock` became unmanageable
- Fallback to `uv` (Python) for faster-whisper dependency

## The Root Cause

Bun's package resolution uses a different algorithm than npm. Issues encountered:
- Peer dependency conflicts not handled the same way
- Native module resolution (`.node` files) inconsistent
- Lock file merge conflicts in team workflows
- Transitive dependency duplication

## The Solution for Assembler

**Move all lib dependencies to Rust/Cargo.** Cargo has:
- Deterministic resolution (Cargo.lock)
- Single dependency tree
- Bundled native deps (rusqlite bundled SQLite, ort bundled ONNX)
- No runtime dependency resolution — everything linked at build time

**Tools stay in Bun** (per MAX.BUN.ONLY) but they depend on zero npm packages for lib logic. The only imports are:
1. `assembler-native.node` (the Rust binary)
2. `@opencode-ai/plugin` (tool registration — required by opencode runtime)
3. `@modelcontextprotocol/sdk` (MCP protocol — required by opencode runtime)

## What to Avoid

| Pattern | Problem | Replacement |
|---------|---------|-------------|
| Tool imports `_lib/embedder-onnx.ts` | ONNX npm dep in Bun | Tool imports `assembler-native` → Rust handles ONNX |
| Tool imports `_lib/sync.ts` | 706 LOC parsing logic in Bun | Tool imports `assembler-native` → Rust handles parsing |
| MCP server has ONNX inline | Crash takes down MCP | MCP calls Rust lib → Result always |
| Multiple tools import same heavy dep | Duplicate resolution | Single `.node` binary |

## Verification

- [ ] No `_lib/` imports in tools after migration
- [ ] All tools only import: `assembler-native`, `@opencode-ai/plugin`, `@modelcontextprotocol/sdk`
- [ ] `bun install` completes in <5s (was potentially much longer with ONNX)
- [ ] No `node_modules` for lib deps
