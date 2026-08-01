# Node Modules Symlink Audit

## Ref: `REF.TOOL.NODE_MODULES.SHARED`

All projects share a single root `.opencode/node_modules/` via symlinks, eliminating per-project dependency duplication.

## Before

| MCP Server | `node_modules` type | Violation |
|-----------|-------------------|-----------|
| `mcp-patlib` | Symlink → root ✓ | — |
| `mcp-spec-audit` | Symlink → root ✓ | — |
| `mcp-entity-audit` | Symlink → root ✓ | — |
| **`mcp-patlib-vector`** | **Real directory** ✗ | Own copy of all packages (~34MB) |

Only `mcp-patlib-vector` had its own `node_modules/` directory, duplicating `@modelcontextprotocol/sdk`, `zod`, `@xenova/transformers`, and all transitive dependencies (~34MB).

## After

| MCP Server | `node_modules` type | Status |
|-----------|-------------------|--------|
| `mcp-patlib` | Symlink → root ✓ | Unchanged |
| `mcp-spec-audit` | Symlink → root ✓ | Unchanged |
| `mcp-entity-audit` | Symlink → root ✓ | Unchanged |
| `mcp-patlib-vector` | Symlink → root ✓ | Fixed |

## Fix Applied

1. **Removed** `tools/mcp-patlib-vector/node_modules/` (real directory, ~34MB)
2. **Created** symlink: `tools/mcp-patlib-vector/node_modules → ../../../.opencode/node_modules`
3. **Rebuilt** `sharp` native binary in root `node_modules/` via `npm rebuild sharp` — the binary `sharp-linux-x64.node` was missing because bun ignores install scripts by default

## Verified

| Check | Result |
|-------|--------|
| `bun build --no-bundle mcp-patlib-vector/index.ts` | No errors |
| `bun build --no-bundle reindex-vectors.ts` | No errors |
| `bun build --no-bundle bench-vectors.ts` | No errors |
| `bun run reindex-vectors.ts --type maxims --force` | 54 embeddings created |
| `bun run bench-vectors.ts --quick` | 269ms cold, 5.8ms warm, 4/5 FTS5 (unchanged) |
| All 4 MCP servers use shared symlink | ✓ |

## Disk Savings

Replaced ~34MB of duplicated packages with a symlink (0 bytes). Actual savings depends on whether the root already had all packages — it did, so the ~34MB can be reclaimed.

## Maxim Compliance

- **MAX.DRY** — no duplicated `node_modules/` copies. Single authoritative source: root `.opencode/node_modules/`
- **REF.TOOL.NODE_MODULES.SHARED** — all MCP servers now follow the shared dependency plane pattern
- **MAX.ENTITY.ONTOLOGY** — `node_modules/` is a passive object shared across entities; symlink is the morphism connecting tool entities to their dependency object
