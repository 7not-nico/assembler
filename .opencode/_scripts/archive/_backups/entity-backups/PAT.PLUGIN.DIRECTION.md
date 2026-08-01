---
id: PAT.PLUGIN.DIRECTION
Title: "Plugin Write-Only Contract — Mutation Tools via Plugin IPC"
Source: assembler
Related: [PROT.TOOL.PLUGIN.IPC, PROT.TOOL.AUTOMATON, PAT.MCP.READONLY, PROT.TOOL.MODEL]
Summary: "Plugin tools execute write operations only — INSERT, UPDATE, DELETE, file writes. Read queries use MCP or CLI read-* tools."
Protocol: Plugin tools (defined via @opencode-ai/plugin Plugin factory) execute write operations only. Permitted; INSERT, UPDATE, DELETE, DDL, writeFileSync, unlinkSync — any state-mutating operation. Pure data retrieval (SELECT for display or analysis) uses MCP or CLI read-* tools. Incidental SELECT within a write flow (FK validation before INSERT) is part of the write operation and permitted. Plugins run in-process with opencode lifecycle hooks, providing confirmation, validation, and error recovery paths. Read operations bypass the MCP tier's separation of concerns.
Enforcement: Convention
Status: active
Priority: 3
Tags: [plugin, architecture, write-only, convention, separation-of-concerns, performance]
---

Plugin tools execute write operations only — INSERT, UPDATE, DELETE, file writes. Read queries use MCP or CLI `read-*` tools.

## Protocol

1. **Write-only handlers** — every plugin tool handler executes write operations only. INSERT, UPDATE, DELETE, DDL, `writeFileSync`, and `unlinkSync` are the primary access patterns.

2. **Pure reads excluded** — SELECT queries whose sole purpose is returning data for display or analysis belong in MCP or CLI `read-*` tools.

3. **Incidental reads within write flow permitted** — SELECT executed as part of a write operation (FK validation, duplicate check before insert) is part of the write flow. The read serves the write operation exclusively.

4. **GENR classification** — plugin tools classify as GENR (generator, write-only) per `PROT.TOOL.AUTOMATON`. RECG, TRNS, and SGNL are invalid classifications for plugins.

5. **CLI `write-*` tools serve as fallback** — when plugin unavailable, CLI `write-*` tools provide the same mutations via `bun run` invocation.

## Rationale

- Plugins run in-process with opencode lifecycle hooks — the runtime provides confirmation, validation, and error recovery that write operations require
- Read operations in plugins bypass the MCP tier's caching, logging, and separation of concerns — mixing modes in a single tool violates the tier contract
- `PROT.TOOL.AUTOMATON` defines four automaton classes — plugins use GENR (generator, write-only) exclusively
- GENR classification means plugins produce output from parameters alone. SELECT for FK validation is the write-flow exception, falling inside the GENR boundary as incidental input validation

## Performance characteristics

Measured on local NVMe with Bun 1.3.14.

- Handler overhead: ~0ms beyond lib time — no subprocess, in-process execution
- No cold startup: plugins load once per agent turn, stay warm
- Exclusive event feature: `file.edited` hook only available in plugins
- Best use: write operations, event-driven auditing, file-change hooks
- Heavy operation (>100ms lib work): overhead is negligible (<10%)

For layer choice guidance see `PROT.TOOL.MODEL` rule 9.

## Gotchas

| Signal | Observation | Redirect |
|--------|-------------|----------|
| Plugin executes SELECT for data display | Handler runs SELECT query then returns the results | Move the query to an MCP tool or CLI `read-*` tool. Plugin returns only write confirmation. |
| Plugin classified as RECG | `// @pluginclass RECG` on plugin file | RECG is invalid for plugins. Use GENR. See `PROT.TOOL.AUTOMATON`. |
| Plugin reads before write | Handler SELECTs to validate FK, then INSERTs | This is incidental read within write flow — permitted. The read serves the write operation. |
| Plugin calls MCP tool | Plugin handler invokes `ludoteca_search` to gather data before writing | Cross-tier calls permitted. Plugin aggregates data from MCP, then writes. |
| Plugin unavailable | Project lacks a plugin file for the operation | CLI `write-*` tools serve as fallback. See `PROT.TOOL.MODEL`. |
| Plugin intended for repeated read query | Plugin handler executes SELECT returning data to agent | Move read to MCP or CLI `read-*`. Plugin overhead equals MCP for reads; separation violation remains. |

## Enforcement

`audit-tool` verifies plugin handlers execute write operations. Checks: `// @pluginclass GENR` present. Pure SELECT-only queries in plugin handlers flagged as violations. Incidental reads within write flows examined case-by-case — query must serve a write operation visible in the same handler.

## Applicability

All `@opencode-ai/plugin` plugins across all projects. The MCP counterpart is `PAT.MCP.READONLY`.

## See also

- `ILL.PLUGIN.DIRECTION.WRITE` — write-only contract walkthrough with session-saver example
- `PAT.MCP.READONLY` — MCP read-only contract, the counterpart to this protocol
- `PROT.TOOL.PLUGIN.IPC` — plugin IPC mechanics, tool definition pattern
- `PROT.TOOL.AUTOMATON` — automaton I/O classes: plugins use GENR (write-only)
- `PROT.TOOL.MODEL` — CLI fallback pattern, `read-*`/`write-*` naming, layer choice decision flow
