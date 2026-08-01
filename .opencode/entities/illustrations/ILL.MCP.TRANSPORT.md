---
id: ILL.MCP.TRANSPORT
title: "MCP Transport Setup — StdioServerTransport Walkthrough"
source: PROT.MCP.TRANSPORT
summary: "Walkthrough of setting up StdioServerTransport for a local MCP server — import, instantiation, connect, DB lifecycle."
illustration: "A new mcp-search server follows the stdio transport contract. Import from @modelcontextprotocol/sdk, instantiate at module end, connect as final statements, fresh DB connection per handler."
illustrates: [PROT.MCP.TRANSPORT]
tags: mcp,transport,walkthrough,stdio,setup,server
related: [PROT.MCP.TRANSPORT, PAT.MCP.READONLY, PROT.TOOL.DEFINITION]
---
## Context

A new MCP server `mcp-search` provides entity search tools. It needs stdio transport setup, DB connection lifecycle, and process lifecycle management.

## Walkthrough

1. Import `StdioServerTransport` from the SDK. The single import path is used consistently across all local MCP servers.

```ts
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js"
```

2. Place transport instantiation and connect as the final two statements of `index.ts`. The transport is the single exit path before process lifecycle.

```ts
const transport = new StdioServerTransport()
await server.connect(transport)
```

3. Inside each `server.tool()` handler, call `initDB()` and `connect()` at the start. Call `db.close()` in a `finally` block before the handler returns. Fresh connection per request prevents leaks across session lifetime.

```ts
server.tool("search", { query: z.string() }, async (args) => {
  const db = initDB()
  try {
    const results = searchEntities(db, args.query)
    return { content: [{ type: "text", text: JSON.stringify(results) }] }
  } finally {
    db.close()
  }
})
```

4. The runtime spawns the process from the `command` field in `opencode.json`. The process stays alive across requests — multiple tool calls reuse the same process.

5. Route diagnostic output to stderr. stdout is reserved for JSON-RPC response frames. `console.error` for diagnostics; `console.log` excluded from server files.

## Key insight

The stdio transport eliminates network configuration for local servers — no ports, no TLS, no host binding. Process-per-server isolates failures — one server crash leaves other servers and the runtime unaffected. The DB connection-per-call pattern prevents resource leaks across session lifetime.

## See also

- `PROT.MCP.TRANSPORT` — abstract stdio transport rules
- `PAT.MCP.READONLY` — MCP read-only contract
- `PROT.TOOL.DEFINITION` — Custom IPC tool implementation
