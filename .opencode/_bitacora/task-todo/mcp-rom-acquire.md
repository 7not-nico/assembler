# MCP server — mcp-rom-acquire (snes9x acquisition orchestrator)

Status: completed (2026-08-01)

## Tasks

### Design
- [x] layer confirm: persistent pipeline state + script orchestration → MCP server (SKL.PROPOSE.MCP)
- [x] purpose confirm: user picked acquisition orchestrator (wrapper of all dive scripts)
- [x] reference study: mcp-findings (active) — McpServer + StdioServerTransport, node_modules symlink to root .opencode/node_modules

### Build
- [x] scaffold `.opencode/mcp/mcp-rom-acquire/` — package.json, node_modules symlink, tsconfig
- [x] `_lib/rom-acquire-types.ts` (pure) — VariantRow, StepRecord, RunRecord
- [x] `_lib/rom-acquire-query.ts` (io) — exec dive scripts, read/write state json
- [x] `_lib/rom-acquire-format.ts` (pure) — response formatting
- [x] `index.ts` — McpServer + StdioServerTransport; tools: browse, fetch, verify, prepare, launch, pipeline, run, status

### Wire
- [x] register `mcp-rom-acquire` in opencode.json mcp section
- [x] stdio smoke test: initialize → tools/list → tools/call (browse, verify, status — all pass)

### Record
- [x] report write to `.opencode/_bitacora/task-report/`
- [x] todo closure (this file)

## Context

- Server dir: `_codex/snes9x-repo/.opencode/mcp/mcp-rom-acquire/`
- Wrapped scripts: `_codex/snes9x-repo/scripts/{browse,fetch,verify,prepare,launch,acquire,playwright-fetch}-rom.sh`
- Deps: SDK 1.29.0 + zod 4.1.8 via symlink to `/home/eddyr/assembler/.opencode/node_modules`
- State: `state/acquire-runs.json` — step status per run
