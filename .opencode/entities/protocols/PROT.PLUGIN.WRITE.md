---
id: PROT.PLUGIN.WRITE
title: "Plugin Write-Only Contract — Mutation Tools via Plugin IPC"
source: NEX.PLUGIN.LAYER
related: [PROT.TOOL.AUTOMATON, PROT.TOOL.MODEL]
summary: "Plugin tools execute write operations only — INSERT, UPDATE, DELETE, file writes. Read queries use MCP or CLI read-* tools. Plugin file.edited hook fires on editor manual saves only; agent-driven changes caught by tool.execute.after; any-source detection via MCP fs.watch."
protocol: "Plugin tools (defined via @opencode-ai/plugin Plugin factory) execute write operations only. Permitted: INSERT, UPDATE, DELETE, DDL, writeFileSync, unlinkSync — any state-mutating operation. Pure data retrieval (SELECT for display or analysis) uses MCP or CLI read-* tools. Incidental SELECT within a write flow (FK validation before INSERT) is part of the write operation and permitted. Plugins run in-process with opencode lifecycle hooks, providing confirmation, validation, and error recovery paths."
enforcement: Formality
status: active
priority: 3
tags: [plugin, architecture, write-only, convention, separation-of-concerns]
---

Plugin tools execute write operations only — INSERT, UPDATE, DELETE, file writes. Read queries use MCP or CLI `read-*` tools.

## Protocol

1. **Write-only handlers** — plugin tool handlers execute write operations only. INSERT, UPDATE, DELETE, DDL, `writeFileSync`, `unlinkSync`.

2. **Pure reads excluded** — SELECT queries for data display or analysis belong in MCP or CLI `read-*` tools.

3. **Incidental reads within write flow permitted** — SELECT for FK validation or duplicate checks within a write operation. The read serves the write exclusively.

4. **GENR classification** — plugin tools classify as GENR (generator, write-only) per `PROT.TOOL.AUTOMATON`.

5. **CLI `write-*` tools serve as fallback** — when plugin unavailable, CLI `write-*` tools provide the same mutations via `bun run` invocation.

## Performance characteristics

- Handler overhead: ~0ms beyond lib time — no subprocess, in-process execution
- No cold startup: plugins load once per agent turn, stay warm
- Exclusive event feature: `file.edited` hook (opencode editor manual saves) only available in plugins
- Best use: write operations, event-driven auditing, file-change detection
- Three-tier detection: `file.edited` (editor saves), `tool.execute.after` (agent tool calls), `fs.watch` (filesystem-level, MCP)
- Heavy operation (>100ms lib work): overhead is negligible (<10%)

## Gotchas

- Plugin executes SELECT for data display: Move the query to an MCP tool or CLI `read-*` tool. Plugin returns only write confirmation. (Handler runs SELECT query then returns the results)
- Plugin classified as RECG: RECG is invalid for plugins. Use GENR. See `PROT.TOOL.AUTOMATON`. (`// @pluginclass RECG` on plugin file)
- Plugin reads before write: This is incidental read within write flow — permitted. The read serves the write operation. (Handler SELECTs to validate FK, then INSERTs)
- Plugin calls MCP tool: Cross-tier calls permitted. Plugin aggregates data from MCP, then writes. (Plugin handler invokes MCP tool to gather data before writing)
- Plugin unavailable: CLI `write-*` tools serve as fallback. See `PROT.TOOL.MODEL`. (Project lacks a plugin file for the operation)

## Enforcement

`audit-tool` verifies plugin handlers execute write operations. Checks: `// @pluginclass GENR` present. Pure SELECT-only queries flagged as violations. Incidental reads within write flows examined case-by-case.

## Applicability

All `@opencode-ai/plugin` plugins across all projects. The MCP counterpart is `PROT.TOOL.AUTOMATON` rule 8 (subproject MCP TRNS exception).

## See also

- `ILL.PLUGIN.DIRECTION.WRITE` — write-only contract walkthrough with session-saver example
- `PROT.TOOL.AUTOMATON` — automaton I/O classes: plugins use GENR (write-only)
- `PROT.TOOL.MODEL` — CLI fallback pattern, `read-*`/`write-*` naming, layer choice decision flow
- `PROT.TOOL.PLUGIN.IPC` — plugin IPC mechanics, tool definition pattern
- `CON.FS.WATCH` — filesystem-level event detection, distinct from plugin hooks
