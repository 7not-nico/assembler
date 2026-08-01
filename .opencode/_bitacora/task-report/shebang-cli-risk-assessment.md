# Shebang CLI Risk Assessment

Analysis of the shebang CLI pattern across the project and the risks it introduces.

## What Is a Shebang CLI

A file starting with `#!/usr/bin/env bun` that defines `main()` and calls `main().catch()`. Designed to be run directly via `bun run file.ts`.

## Where Shebang CLIs Live

### In `tools/` (HIGH RISK — auto-discovered and validated)

| File | Location | Status | Risk |
|------|----------|--------|------|
| `bench-vectors.ts` | `tools/_disabled/` | Disabled | Would fail audit |
| `reindex-vectors.ts` | `tools/_disabled/` | Disabled | Would fail audit |
| `search-vectors.ts` | `tools/_disabled/` | Disabled | Would fail audit |
| `similar-vectors.ts` | `tools/_disabled/` | Disabled | Would fail audit |

### In `tools/*/index.ts` (LOW RISK — MCP servers, not plugin-discovered)

| File | Status | Format | Risk |
|------|--------|--------|------|
| `mcp-patlib-vector/index.ts` | Disabled | Shebang + MCP SDK | None (MCP servers exempt) |
| `mcp-burst-alert/index.ts` | Active | Shebang + MCP SDK | None (MCP servers exempt) |
| `mcp-patlib/index.ts` | Active | Shebang + MCP SDK | None |
| `mcp-spec-audit/index.ts` | Active | Shebang + MCP SDK | None |
| `mcp-entity-audit/index.ts` | Active | Shebang + MCP SDK | None |
| `mcp-compartment-audit/index.ts` | Active | Shebang + MCP SDK | None |

MCP servers are configured in `opencode.json` and started as child processes. They are NOT auto-discovered as plugins and therefore NOT subject to `audit-tool` format rules.

### In `findings/` and subprojects (LOW RISK — own discovery scope)

| File | Status | Risk |
|------|--------|------|
| `findings/.opencode/tools/*/index.ts` | Active | None (subproject MCP servers) |

## The Confusion

The root cause of both bugs in this session:

| Confusion | Consequence |
|-----------|-------------|
| `tools/*/index.ts` (MCP server) uses shebang → OK | Copied pattern into `tools/*.ts` (tool) → ❌ |
| MCP servers have `main().catch()` → OK | Tool with `main().catch()` → fail audit Rule 2 |
| MCP servers use `console.log` → OK | Tool with `console.log` → fail audit Rule 8 |

**MCP servers and tools are different artifact types.** They look similar (both are `.ts` files in `tools/`) but have different entry points, different discovery mechanisms, and different validation rules.

## Detection

Check for shebang CLIs that are NOT MCP servers:

```bash
# Find all shebang files in tools/ that are NOT inside a subdirectory
for f in tools/*.ts; do
  if head -1 "$f" | grep -q '#!/usr/bin/env bun'; then
    echo "SHEBANG CLI: $f"
  fi
done

# Active count (should be 0)
for f in tools/*.ts; do
  if [ -f "$f" ] && head -1 "$f" | grep -q '#!/usr/bin/env bun'; then
    echo "$f"
  fi
done | wc -l
```

## Risk Summary

| Location | Count | Risk Level | Reason |
|----------|-------|-----------|--------|
| `tools/*.ts` (active) | 0 | ✅ None | All use plugin format |
| `tools/*.ts` (disabled) | 4 | ❌ Would fail | Shebang CLIs in validation scope |
| `tools/*/index.ts` (active) | 6 | ✅ None | MCP servers, exempt from validation |
| `tools/*/index.ts` (disabled) | 1 | ✅ None | MCP server, exempt |

## Recommendation

1. Keep shebang CLIs out of `tools/` unless they are MCP servers (`tools/name/index.ts`)
2. If a standalone CLI is needed, place it in a `scripts/` directory instead
3. Document the distinction in `AGENTS.md`:
   > `tools/` contains plugin-format tools and MCP servers. Shebang CLI scripts go in `scripts/`.
