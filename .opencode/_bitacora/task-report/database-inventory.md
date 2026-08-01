# Database Inventory

All SQLite databases in the assembler project.

## Root `.opencode/`

| DB | Path | Journal | Tables | Purpose |
|----|------|---------|--------|---------|
| `patlib.db` | `.opencode/patlib.db` | WAL | 29 | Main entity store (patterns, terms, skills, etc.) |
| `patlib-vector.db` | `.opencode/patlib-vector.db` | WAL | ~8 | Vector embeddings + FTS5 index. Currently orphaned — all consumers are disabled. |
| `mcp-search.db` | `.opencode/mcp-search.db` | WAL | 5 | MCP session/search log |
| `sessions.db` | `.opencode/sessions.db` | WAL | — | OpenCode session tracking |
| `mcp-search.db` | `mcp-search.db` | WAL | 5 | Duplicate? Same name as above |

## Subproject `.opencode/`

| DB | Path | Purpose |
|----|------|---------|
| `homophones/homophones.db` | `homophones/homophones.db` | Homophone reference data |

## `findings/`

| DB | Path | Journal | Tables | Purpose |
|----|------|---------|--------|---------|
| `findings.db` | `findings/findings.db` | WAL | 5 | Research findings (acquired papers, notes) |

## `_findings/`

| DB | Path | Purpose |
|----|------|---------|
| (unknown) | `_findings/` | May contain additional DBs |

## Root Directory

| DB | Path | Purpose |
|----|------|---------|
| `patlib.db` | `assembler/patlib.db` | Root-level patlib replica? |
| `patlib_vector.db` | `assembler/patlib_vector.db` | Root-level vector DB? |
| `mcp-search.db` | `assembler/mcp-search.db` | Root-level MCP search DB? |
| `darkestdungeon-code.db` | `assembler/darkestdungeon-code.db` | Code dive artifact |

## Sizes

| DB | Size | Notes |
|----|------|-------|
| `.opencode/patlib.db` | ~1-5 MB | Main entity store |
| `.opencode/patlib-vector.db` | ~1-5 MB | Vector embeddings (orphaned) |
| `homophones/homophones.db` | Small | 528 entries |
| `findings/findings.db` | Small | 5 tables |
| `patlib.db` (root) | Unknown | May be symlink or duplicate |

## Access Patterns

| DB | Consumers | Access method |
|----|-----------|---------------|
| `.opencode/patlib.db` | All tools + MCP servers | `bun:sqlite` via `_lib/db.ts` |
| `.opencode/patlib-vector.db` | Only disabled tools | `bun:sqlite` via `_lib/vector-db.ts` |
| `.opencode/mcp-search.db` | MCP servers | `bun:sqlite` via `_lib/db.ts` |
| `findings/findings.db` | findings MCP servers | `bun:sqlite` via findings lib |
| `homophones/homophones.db` | homophones tools | `bun:sqlite` via homophones lib |
