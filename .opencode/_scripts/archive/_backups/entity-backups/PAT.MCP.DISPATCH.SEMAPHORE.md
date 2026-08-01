---
id: PAT.MCP.DISPATCH.SEMAPHORE
Title: "Concurrent Dispatch for Local MCP Servers"
Source: assembler
Related: [PROT.MCP.TRANSPORT, PROT.TOOL.DISCOVERY, TERM.MCP]
Summary: "StdioServerTransport already dispatches handlers concurrently from the stdin buffer. This protocol describes explicit concurrency bounding via semaphore or switching to Streamable HTTP for controlled resource usage and higher throughput."
Protocol: "Concurrency bounding extends StdioServerTransport's native concurrent dispatch with explicit limits. Handlers are async and DB-scoped per call. Concurrency bounded to 3-5 in-flight requests. WAL mode handles concurrent reads. Responses correlate by JSON-RPC id."
Enforcement: Convention
Status: active
Priority: 3
Tags: [mcp, transport, stdio, concurrency, architecture, convention]
---

`StdioServerTransport` dispatches handlers concurrently from the stdin buffer by default. Each message dispatches immediately without waiting for the previous handler. This protocol adds explicit concurrency bounding (semaphore, pool) for resource control, or replaces stdio with Streamable HTTP for independent request handling. The baseline transport is concurrent already — bounding constrains unbounded resource growth.

## Protocol

1. **Concurrency bounding via semaphore** — `StdioServerTransport` dispatches handlers concurrently by default. Add a semaphore or connection pool to cap in-flight requests when resource usage requires explicit limits. Transport replacement is excluded — the semaphore wraps the handler dispatch.

   - **Stdio with semaphore** — keep `StdioServerTransport`, add a concurrency semaphore that guards handler execution. Queue requests beyond the bound until an active handler completes.
   - **Streamable HTTP** — `StreamableHTTPServerTransport` from `@modelcontextprotocol/sdk`. Each HTTP request gets an independent handler with runtime-managed connections. Higher throughput for write-heavy or long-request patterns.

2. **Tool handlers remain async with DB scope per call** — existing handler pattern (`initDB()` → `connect()` → query → `db.close()`) is already async-safe. Each handler opens and closes its own connection within a `try`/`finally` block. No shared state between handlers.

3. **Concurrency bounded to 3–5 in-flight requests** — requests beyond the bound queue until an active handler completes. Prevents memory exhaustion from N simultaneous result buffers. Implement via a semaphore or connection pool wrapper.

4. **WAL mode for concurrent DB reads** — SQLite WAL journal mode allows multiple concurrent readers. Writes serialize at the DB level (queued). WAL mode is set during `initDB()` and is safe for concurrent access.

5. **Responses correlate by JSON-RPC `id`** — response order is independent of request order. The runtime pairs each response `id` to the originating request `id`. No send-order dependency. Each concurrent request uses a unique `id`, no reuse within a session.

## Transport comparison

| Approach | Server change | Port | Dependencies | Best for |
|----------|---------------|------|-------------|----------|
| Stdio + semaphore | Add semaphore wrapper in handler dispatch | None | None | Zero-config bounding for resource control |
| Streamable HTTP | Replace transport, add HTTP listener | Ephemeral auto-assign | `@modelcontextprotocol/sdk` (included) | Higher throughput, runtime-managed |

## Rationale

- StdioServerTransport dispatches concurrently by default — handlers run in parallel when messages arrive faster than they complete. Empirically validated: 50 simultaneous searches complete within a single handler latency window
- Tool handlers are already async and DB-independent — no transport change needed for concurrent execution
- Bound concurrency prevents resource exhaustion while matching typical query patterns (3–5 simultaneous searches)
- WAL mode provides safe concurrent reads — the dominant pattern for MCP retrieval tools (search, get)
- JSON-RPC `id` correlation is protocol-native — the runtime already maps `id` to pending request, no new infrastructure needed

## Gotchas

| Signal | Observation | Redirect |
|--------|-------------|----------|
| Concurrent DB connections exceed SQLite pool | default SQLite pool handles 1 writer + unlimited readers in WAL mode | Set WAL mode during `initDB()`. For write-heavy servers, reduce concurrency bound to 2 |
| Large in-flight set causes memory pressure | each in-flight handler holds result buffers | Keep concurrency bound at 3–5. Monitor `process.memoryUsage()` during peak |
| JSON-RPC `id` collision | two concurrent requests share the same `id` | Verify unique `id` per request. The transport layer or SDK generates unique ids — no manual assignment |
| Out-of-order responses | runtime expects sequential responses | Runtime uses `id` correlation — response order and request order are independent. Verify the runtime SDK supports out-of-order responses |

## Relation to PROT.MCP.TRANSPORT

Both protocols define valid transport contracts:

| Aspect | `PROT.MCP.TRANSPORT` (baseline) | `PAT.MCP.DISPATCH.SEMAPHORE` (bounded) |
|--------|--------------------------------------|------------------------------------------|
| Transport | `StdioServerTransport` | `StdioServerTransport` with semaphore, or Streamable HTTP |
| Request handling | Concurrent dispatch from buffer, unbounded | Concurrent dispatch with explicit limit (3–5 in-flight) |
| DB access | Single connection per call | N connections per call, WAL mode |
| Concurrency control | None (all messages dispatched immediately) | Semaphore or pool bounds in-flight count |

Rules #1 (import), #3 (persistent process), #6 (stdout/stderr), and #7 (runtime lifecycle) from `PROT.MCP.TRANSPORT` apply to both variants unchanged. Rule #4 (concurrent dispatch) is the baseline behavior that this protocol extends with bounding. Rule #5 (DB per call) is refined with WAL mode and concurrency bounding.

## Enforcement

`audit-tool` verifies a concurrency bound mechanism (semaphore, pool, or explicit limit) exists in the server implementation when this protocol is selected. Verifies WAL mode is enabled in `initDB()`. Verifies `db.close()` in a `finally` block in every handler. Transport replacement is excluded — bounding is additive on StdioServerTransport.

## Applicability

MCP servers with high-frequency query patterns where unbounded concurrent dispatch causes resource pressure. Root servers (`mcp-patlib`, `mcp-spec-audit`) and project servers (`mcp-ludoteca`) adopt bounded concurrency when monitoring shows memory or connection exhaustion.

## See also

- `PROT.MCP.TRANSPORT` — stdio transport contract, concurrent dispatch baseline, bounded by this protocol when needed
- `PROT.TOOL.DISCOVERY` — MCP server auto-discovery, config-based parallel to IPC
- `TERM.MCP` — Model Context Protocol definition, stdio vs Streamable HTTP transports
