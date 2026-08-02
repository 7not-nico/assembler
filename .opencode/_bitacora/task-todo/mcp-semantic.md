# mcp-semantic — MCP server for the semantic engine — todo

Status: complete
Started: 2026-08-02
Report: `.opencode/_bitacora/task-report/20260802-mcp-semantic.md`

## Tasks

- [x] Design mcp-semantic (6 tools, purity split, reference mcp-patlib pattern)
- [x] Write pure lib modules: `_lib/semantic-types.ts`, `_lib/semantic-format.ts`
- [x] Write io lib: `_lib/semantic-query.ts` (search/stats/drift/embed/purge/eval)
- [x] Write `tools/mcp-semantic/` package.json + tsconfig
- [x] Write `tools/mcp-semantic/index.ts` server (6 tools)
- [x] Share deps via symlink: `node_modules` → `.opencode/node_modules` (documented in root AGENTS.md)
- [x] Register mcp-semantic in opencode.json (valid JSON confirmed)
- [x] Stdio smoke test: initialize → tools/list (6) → tools/call all 6 OK
- [x] Verify embed write path (force upsert: 15 terms)
- [x] Document symlink convention + MCP in root AGENTS.md
- [x] Write bitacora report
