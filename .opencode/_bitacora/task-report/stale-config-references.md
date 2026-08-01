# Stale Configuration & References

Entries in `opencode.json`, rules, and entities that reference now-disabled or moved tooling.

## `opencode.json`

| Entry | Line | Status | Issue |
|-------|------|--------|-------|
| `patlib-vector` | 33-37 | `"enabled": false` | Command path points to `tools/mcp-patlib-vector/index.ts` which is now in `_disabled/`. Stale config. |

## Rules (`rules/`)

| Rule | Reference | Issue |
|------|-----------|-------|
| `query-patlib-context.md` | `use patlib_vector_search (mcp-patlib-vector)` | Instructs agents to use a tool from a disabled MCP server. Should be removed or updated. |

## Protocol Entities (`entities/protocols/`)

| Entity | References mcp-patlib-vector | Issue |
|--------|---------------------------|-------|
| `PROT.SEARCH.QUERY.md` | Yes | Describes search modes from a disabled server |
| `PROT.SEARCH.EMBEDDING.md` | Yes | Describes embedder setup from a disabled server |

## Illustrations (`entities/illustrations/`)

| Entity | References mcp-patlib-vector | Issue |
|--------|---------------------------|-------|
| `ILL.SEARCH.VECTOR.TOOLS.md` | Yes | Walkthrough for tools that no longer exist |

## Backups

| File | References mcp-patlib-vector |
|------|---------------------------|
| `_backups/entity-backups/PAT.SEARCH.VECTOR.QUERY.md` | Yes |
| `_backups/entity-backups/PROT.SEARCH.VECTOR.INDEX.md` | Yes |

## Reports (`.opencode/reports/`)

| Report | References mcp-patlib-vector |
|--------|---------------------------|
| `vector-search-monolith-extraction.md` | Yes (historical, fine to keep) |
| `shared-dep-audit.md` | Yes (historical, fine to keep) |
| `system-health.md` | Yes (historical, fine to keep) |
| `vector-tooling-retrospective.md` | Yes (this report, intentionally) |

## TODO Files (`.opencode/todo/`)

| File | References mcp-patlib-vector |
|------|---------------------------|
| `extract-embedder-onnx.md` | Yes (completed task, fine to keep) |
| `extract-vector-reindex.md` | Yes (has 3 unverified remaining items) |
| `post-extraction-remaining.md` | Yes (completed) |
| `reindex-vectors-cli.md` | Yes (all unchecked) |
| `reindex-tool.md` | Yes (all unchecked) |
| `terms-classification.md` | Yes (references TYPE_SOURCE_DIRS in mcp-patlib-vector) |
| `code-infrastructure.md` | Yes (references TYPE_SOURCE_DIRS in mcp-patlib-vector) |

## Summary

| Category | Count | Action needed |
|----------|-------|---------------|
| Config entries to remove | 1 | Remove `patlib-vector` from `opencode.json` |
| Rules to update | 1 | `query-patlib-context.md` |
| Protocol entities to update | 2 | `PROT.SEARCH.QUERY`, `PROT.SEARCH.EMBEDDING` |
| Illustrations to update | 1 | `ILL.SEARCH.VECTOR.TOOLS` |
| Todo files with stale refs | 5 | `extract-vector-reindex`, `reindex-vectors-cli`, `reindex-tool`, `terms-classification`, `code-infrastructure` |
