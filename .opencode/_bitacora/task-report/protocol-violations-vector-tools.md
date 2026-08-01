# Protocol Violations — Vector Tooling

Which protocols were violated by the disabled tools and what rules were broken.

## PROT.TOOL.DEFINITION — Tool Format

| Rule | Description | Violated by | Status |
|------|-------------|-------------|--------|
| 1 | `export default tool({...})` | All 4 shebang CLIs | ❌ Use `#!/usr/bin/env bun` instead |
| 4 | Return string from execute() | All 4 shebang CLIs | ❌ Use `console.log` instead |
| 6 | Import only from `_lib/` | bench-vectors, reindex-vectors (original) | ❌→✅ Fixed (was `../tools/mcp-patlib-vector/embedder`) |
| 8 | One direction per tool | search-vectors (hybrid mode reads+reports) | ⚠️ Debated (read-only tool with embedder load) |
| 9 | crashOnError() in execute() | All 4 shebang CLIs | ❌ Absent — no error reporting to LLM |
| Gotcha | No shebang line | All 4 | ❌ Shebang on line 1 |

## PROT.TOOL.MORPHISM — Tool Import Architecture

| Rule | Description | Violated by | Status |
|------|-------------|-------------|--------|
| 1 | @toolclass at line 1 | All 4 | ❌ Shebang pushes @toolclass to line 2 |
| 2 | Separate object domains (lib/) | bench-vectors, reindex-vectors (original) | ❌→✅ Fixed — now import from `_lib/` |
| Gotcha 1 | Tool imports another tool | bench-vectors, reindex-vectors (original) | ❌→✅ Fixed (was `tools/mcp-patlib-vector/embedder`) |

## PROT.TOOL.AUTOMATON — Tool I/O Class

| Rule | Description | Violated by | Status |
|------|-------------|-------------|--------|
| 6 | @toolclass at line 1 | All 4 | ❌ Line 1 is shebang, @toolclass at line 2 |
| 9 | Run audit-tool after creation | This session | ❌ Not run after creating search-vectors, similar-vectors |

## REF.LIB.DIRECTORY.LAYER — Import Paths

| Rule | Description | Violated by | Status |
|------|-------------|-------------|--------|
| 7 | Tools import from `_lib/` only | bench-vectors, reindex-vectors (original) | ❌→✅ Fixed |
| 8 | Import graph is a DAG (tool→lib only) | Original cross-tool imports | ❌→✅ Fixed |

## MAX.CODE.LAYERS — Dependency Rings

| Rule | Description | Violated by | Status |
|------|-------------|-------------|--------|
| 40 | Lib imports only from same or inward ring | Check needed | Need to verify purity annotations match actual imports |
| 45 | Lib declares purity at line 1 | All `_lib/` modules | ✅ All have `// purity:` |
| 46 | Pure files import from pure only | Check needed | Need to verify |

## MAX.ORTHOGONALITY — One Thing Per Tool

| Rule | Description | Violated by | Status |
|------|-------------|-------------|--------|
| 17 | Each tool does one thing | search-vectors (3 modes) | ⚠️ One tool, three search modes |
| 18 | Tools import from lib only | Original bench-vectors, reindex-vectors | ❌→✅ Fixed |
| 21 | Read and write: separate tools | reindex-vectors (writes), bench-vectors (reads) | ✅ Separate |

## Summary

| Protocol | Rules violated | Severity |
|----------|---------------|----------|
| PROT.TOOL.DEFINITION | 5 violations | HIGH — format prevents startup |
| PROT.TOOL.MORPHISM | 2 violations | HIGH — cross-tool imports (fixed) |
| PROT.TOOL.AUTOMATON | 2 violations | MEDIUM — annotation position |
| REF.LIB.DIRECTORY.LAYER | 2 violations | HIGH — import direction (fixed) |
| MAX.CODE.LAYERS | 2 to verify | LOW — annotation completeness |
| MAX.ORTHOGONALITY | 2 to verify | LOW — design decisions |

All violations stem from a single root cause: **shebang CLI format was used instead of the Custom IPC Tool format specified in PROT.TOOL.DEFINITION**. Fixing that one protocol violation resolves all derived violations.

## Revival Protocol

To revive, each tool must:

1. Remove shebang line (Rule 1 fix)
2. Add `import { tool } from "@opencode-ai/plugin"` (Rule 1 fix)
3. Convert to `export default tool({...})` (Rule 1 fix)
4. Add typed `args` schema with `.describe()` (Rule 1 fix)
5. Replace `console.log` with `return { content: [...] }` (Rule 4 fix)
6. Add `crashOnError()` at top of execute (Rule 9 fix)
7. Keep `@toolclass` on what is now line 1 (Rule 6 fix)
8. Keep imports from `_lib/` only (already fixed)
