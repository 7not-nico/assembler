---
id: PAT.MCP.READONLY
Title: "MCP Server Read-Only Contract — Query-Only Tools via MCP Transport"
Source: assembler
Related: [PROT.MCP.TRANSPORT, PROT.TOOL.DISCOVERY, PAT.PLUGIN.DIRECTION, PROT.TOOL.AUTOMATON]
Summary: "MCP server tools execute read operations only — SELECT queries, file reads, no mutations. Write operations use plugins or CLI write-* tools."
Protocol: MCP server tools (defined via server.tool()) execute read operations only. Permitted; SELECT queries, readFileSync, stat/exists checks, stderr logging. Write operations use @opencode-ai/plugin plugins or CLI write-* tools. SELECT within a write flow (FK validation before insert) belongs in the plugin layer with the write — MCP executes pure retrieval only. MCP transport provides no transactional compensation or rollback. The in-process plugin layer handles mutation with confirmation and error recovery.
Enforcement: Convention
Status: active
Priority: 3
Tags: [mcp, architecture, read-only, convention, separation-of-concerns, performance]
---

MCP server tools execute read operations only — SELECT queries, file reads, no mutations. Write operations belong to plugins or CLI `write-*` tools.

## Protocol

1. **Read-only handlers** — every `server.tool()` handler executes read operations only. SELECT queries and `readFileSync` are the primary data access patterns.

2. **Write operations excluded** — INSERT, UPDATE, DELETE, DDL, `writeFileSync`, `unlinkSync`, or any state mutation belong in plugins or CLI `write-*` tools.

3. **Validation and stats are read operations** — `ludoteca_validate` reads files and executes SELECT queries. `ludoteca_stats` executes SELECT aggregation queries. Both return formatted output — no state mutation.

4. **stderr logging permitted** — diagnostic output to stderr is acceptable. stdout is reserved for JSON-RPC response frames per `PROT.MCP.TRANSPORT`.

5. **CLI `read-*` tools serve as fallback** — when MCP server unavailable, CLI `read-*` tools provide the same queries via `bun run` invocation.

## Rationale

- MCP transport (stdio JSON-RPC) operates as a subprocess — write operations require confirmation and error recovery. The plugin layer provides transaction boundaries, rollback, and idempotency that the transport layer lacks.
- Plugin tools run in-process with opencode lifecycle hooks offering confirmation, validation, and rollback paths
- Single direction per layer reduces cognitive load — MCP SEARCH and GET; plugins CREATE, UPDATE, SYNC; CLI covers both as fallback
- CLI `read-*` and `write-*` naming mirrors the tier separation, making direction discoverable from the tool name

## Performance characteristics

Measured on local NVMe with Bun 1.3.14.

- Cold init (initialize handshake, first call per session): ~60ms
- Subsequent calls: 1-6ms RTT — server stays alive across calls
- Best use: repeated queries within a session (3+ calls amortize init)
- Prefer CLI `read-*` tools for single queries. MCP server init adds ~60ms for one-off use.
- Heavy operation (>100ms lib work): overhead is negligible (<10%)

For layer choice guidance see `PROT.TOOL.MODEL` rule 9.

## Gotchas

| Signal | Observation | Redirect |
|--------|-------------|----------|
| Validation reads files | `ludoteca_validate` uses `readFileSync` and SELECT — appears write-like | File reads + SELECT are read operations. Validation returns diagnostics, mutates nothing. |
| stderr logging | `console.error` in MCP handler appears as side effect | stderr is the diagnostic channel. stdout carries JSON-RPC frames only. stderr output is permissible read-side I/O. |
| MCP tool executes SELECT then INSERT | Handler reads data then writes the result | Split into two tools: MCP for the SELECT, plugin for the INSERT. Or use CLI `read-*` + `write-*` as fallback pair. |
| No MCP server available | Project lacks an MCP server entry | CLI `read-*` tools serve as fallback. See `PROT.TOOL.MODEL` for the fallback pattern. |
| Single one-off MCP query | One `ludoteca_search` call per session | Use CLI `read-*` tool — same total cost, no server init overhead. |

## Enforcement

`audit-tool` verifies MCP server handlers execute no write operations. Checks: no `db.run()` in handler bodies or their lib dependencies. No `writeFileSync`, `INSERT`, `UPDATE`, `DELETE` in call paths reachable from MCP tools. `read-*` CLI tools audited for read-only compliance per `PROT.TOOL.MODEL`.

## Applicability

All local MCP servers across all projects. Root servers (`mcp-patlib`, `mcp-spec-audit`) and project servers (`mcp-ludoteca`, future `mcp-*` servers) follow the read-only contract. The plugin counterpart is `PAT.PLUGIN.DIRECTION`.

## See also

- `ILL.MCP.READONLY.QUERY` — MCP read-only contract walkthrough with ludoteca_search
- `PAT.PLUGIN.DIRECTION` — plugin write-only contract, the counterpart to this protocol
- `PROT.MCP.TRANSPORT` — stdio transport mechanics, stdout/stderr channel rules
- `PROT.TOOL.DISCOVERY` — MCP server registration, tool tier model
- `PROT.TOOL.AUTOMATON` — automaton I/O classes: MCP tools map to RECG (read-only)
- `PROT.TOOL.MODEL` — CLI fallback pattern, `read-*`/`write-*` naming, layer choice decision flow
