---
id: PROT.MCP.TRANSPORT
title: "Stdio Transport Contract for Local MCP Servers"
source: NEX.TOOL.CHOICE
related: [PROT.TOOL.DISCOVERY]
summary: "Local MCP servers use StdioServerTransport from @modelcontextprotocol/sdk. The opencode runtime spawns one process per server entry in opencode.json, communicating via stdin/stdout over JSON-RPC 2.0. The protocol is stateless per the 2026-07-28 revision — no initialize handshake; every request carries protocol version and client capabilities in _meta."
protocol: "Local MCP servers import StdioServerTransport from @modelcontextprotocol/sdk/server/stdio.js, instantiate at module end, and connect via await server.connect(transport). Process persists across requests. Transport dispatches handlers concurrently from stdin buffer — multiple handlers run in parallel when messages arrive faster than completion. Per the 2026-07-28 spec revision the protocol is stateless: servers implement server/discover to advertise protocol versions, capabilities, and identity; every request carries io.modelcontextprotocol/protocolVersion and io.modelcontextprotocol/clientCapabilities in _meta; every result carries a required resultType field ('complete' or 'input_required'). opencode runtime manages lifecycle. stdout reserved for JSON-RPC frames, stderr for diagnostics."
enforcement: Formality
status: active
priority: 3
tags: [mcp, transport, stdio, architecture, convention, stateless]
---

Local MCP servers communicate with the opencode runtime via `StdioServerTransport` from `@modelcontextprotocol/sdk`. The runtime spawns one process per server entry in `opencode.json`, pipes stdin/stdout for JSON-RPC 2.0 messaging, and terminates the process on session end. The protocol follows the stateless model of the 2026-07-28 spec revision — no initialize handshake, per-request capability negotiation in `_meta`.

## Protocol

1. **Import StdioServerTransport** — use `import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js"`. Single import path, consistent across all local MCP servers.

2. **Transport instantiation and connect as final statements** — place `const transport = new StdioServerTransport()` then `await server.connect(transport)` as the last two lines of `index.ts`. The transport is the single exit path before process lifecycle.

3. **Stateless protocol conformance** — the initialize/notifications/initialized handshake no longer exists. Every request carries its protocol version (`io.modelcontextprotocol/protocolVersion`) and client capabilities (`io.modelcontextprotocol/clientCapabilities`) in `_meta`. Servers identify themselves in each result's `_meta` (`io.modelcontextprotocol/serverInfo`). Version mismatches return `UnsupportedProtocolVersionError`.

4. **Implement server/discover** — servers implement the `server/discover` RPC to advertise supported protocol versions, capabilities, and identity. Clients may call it before any other request for up-front version selection, or as a backward-compatibility probe on stdio.

5. **Process persists across requests** — opencode runtime spawns one process per `opencode.json` entry. Multiple tool calls reuse the same process for session duration.

6. **Concurrent dispatch from buffer** — `StdioServerTransport` reads JSON-RPC messages from the stdin buffer continuously. Each message dispatches to its handler immediately, without awaiting the previous handler. Multiple handlers run concurrently when messages arrive faster than handlers complete. Confirmed by empirical test: 50 simultaneous searches complete within a single handler latency window.

7. **DB connection per tool call** — call `initDB()` and `connect()` inside each `server.tool()` handler. Call `db.close()` in a `finally` block before the handler returns. Fresh connection per request prevents leaks across session lifetime.

8. **stdout for JSON-RPC response frames** — response payload writes to stdout. Diagnostic output and crash logs route to stderr. stdout reserved for valid JSON-RPC frames only.

9. **Runtime manages process lifecycle** — `command` field in `opencode.json` drives process spawn. Runtime terminates the process on session end. Process cleanup is a runtime responsibility.

10. **Concurrency bounding for resource control** — when unbounded concurrent dispatch causes memory pressure, add a semaphore wrapping handler execution. Bound to 3–5 in-flight requests. Use `WAL` journal mode in `initDB()` for concurrent reads. Requests beyond the bound queue until an active handler completes. Streamable HTTP from `@modelcontextprotocol/sdk` serves as an alternative transport for write-heavy or long-request patterns.

### Transport comparison

Two transport approaches serve different throughput and configuration needs:

- **Stdio + semaphore** requires no server change beyond adding a semaphore wrapper in handler dispatch. No port needed, no additional dependencies. Best for zero-config bounding of resource control.
- **Streamable HTTP** replaces the transport and adds an HTTP listener. Uses an ephemeral auto-assigned port. Depends on `@modelcontextprotocol/sdk` (included). Best for higher throughput and runtime-managed connections.

## Gotchas

- Stdio transport eliminates network configuration for local servers — no ports, no TLS, no host binding
- Process-per-server isolates failures — one server crash leaves other servers and the runtime unaffected
- DB connection-per-call prevents resource leaks — SQLite connections scoped to single request, released after response
- stdout/stderr separation preserves JSON-RPC framing — diagnostic output and response frames use separate channels
- Concurrent dispatch is transport-native — `StdioServerTransport` reads from the stdin buffer continuously and dispatches each handler immediately without awaiting. Handlers run concurrently when messages arrive faster than they complete. No custom transport or HTTP upgrade needed for parallel execution

- DB connection open without close in handler: Add `finally { db.close() }` in each `server.tool()` handler — guarantees release per request (handler calls `connect()` without matching `close()`)
- Response exceeds stdout buffer: Keep tool responses under 100KB — paginate results with `limit` and `offset` parameters (large payload saturates stdio buffer, degrades session throughput)
- Process continues after runtime disconnect: Wrap `main()` in `process.on("exit")` handler for cleanup; runtime handles primary termination (orphan process from runtime crash or unclean exit)
- Diagnostic output on stdout: Route all diagnostic output to `console.error` or stderr — stdout reserved for response frames (stderr-level data directed to stdout, corrupts JSON-RPC message framing)

## Enforcement

`audit-tool` verifies `StdioServerTransport` import present in every `mcp-*/index.ts`. Verifies `transport` instantiation and `server.connect(transport)` as the final two statements. Verifies `db.close()` or `finally` block present in every `server.tool()` handler.

## Applicability

Every local MCP server under `.opencode/tools/mcp-*/`. Root servers (`mcp-patlib`) and project servers (`mcp-ludoteca`) follow the same stdio transport contract.

## See also

- `PROT.TOOL.DISCOVERY` — MCP server auto-discovery, config-based parallel to IPC
- `IDENTITY.MCP` — MCP identity (agent-facing transport layer)
- `PROT.TOOL.DEFINITION` — Custom IPC implementation pattern, parallel auto-discovery mechanism
- `PROT.TOOL.AUTOMATON` — tool I/O classification for MCP servers
