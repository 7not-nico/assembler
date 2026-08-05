---
id: ILL.MCP.DISCOVERY
title: "MCP Discovery Walkthrough — Registering a Project MCP Server"
source: PROT.MCP.TRANSPORT
summary: "Walk through registering a ludoteca MCP server: add opencode.json entry, create mcp-ludoteca/index.ts with search and get tools, verify auto-discovery picks them up, and call from agent."
illustration: "An agent adds an mcp-ludoteca server to opencode.json, creates the server directory with search and get tools, the opencode runtime auto-discovers them, and the LLM calls ludoteca_search and ludoteca_get"
illustrates: [PROT.TOOL.DISCOVERY]
tags: mcp,discovery,registration,walkthrough,server,tools
related: [PAT.MCP.READONLY, PROT.TOOL.DEFINITION, PROT.TOOL.SCOPE, IDENTITY.MCP]
---
## Context

The ludoteca subproject has frequent game queries — humans use CLI tools via `bun run`. An MCP server wraps the most-used queries for direct LLM access. The registration process follows a single step: add an `opencode.json` entry.

## Walkthrough

### Step 1: Create the server directory

Create `one-timers/ludoteca/.opencode/tools/mcp-ludoteca/index.ts`:

```ts
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js"
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js"
import { z } from "zod"
import { initDB } from "../../lib/db"

const server = new McpServer({ name: "mcp-ludoteca", version: "1.0.0" })

server.tool(
  "ludoteca_search",
  { query: z.string() },
  async ({ query }) => {
    const db = initDB()
    const rows = db.query(
      "SELECT * FROM games WHERE name LIKE ?"
    ).all(`%${query}%`)
    return { content: [{ type: "text", text: JSON.stringify(rows) }] }
  }
)

server.tool(
  "ludoteca_get",
  { id: z.number() },
  async ({ id }) => {
    const db = initDB()
    const row = db.query("SELECT * FROM games WHERE id = ?").get(id)
    return { content: [{ type: "text", text: JSON.stringify(row) }] }
  }
)

const transport = new StdioServerTransport()
await server.connect(transport)
```

Two tools: `ludoteca_search` (by name pattern) and `ludoteca_get` (by ID). Focused surface per protocol rule 4.

### Step 2: Register in opencode.json

Add to `one-timers/ludoteca/opencode.json`:

```json
{
  "mcpServers": {
    "ludoteca": {
      "type": "local",
      "command": ["bun", "run", ".opencode/tools/mcp-ludoteca/index.ts"]
    }
  }
}
```

The entry IS the registration — no separate manifest, DB table, or registration step required per protocol rule 1.

### Step 3: Runtime auto-discovers the server

On next session start, opencode reads `opencode.json`, launches `mcp-ludoteca` as a subprocess, and lists tools per `PROT.MCP.TRANSPORT`. The protocol is stateless — no `initialize` handshake; requests carry protocol version and capabilities in `_meta`. The server's `listTools` response returns `ludoteca_search` and `ludoteca_get`.

Discovery flow: `opencode.json` → MCP subprocess → `listTools` → tools available to LLM.

### Step 4: LLM calls the tool

The LLM calls `ludoteca_search` with `query: "Halo"`:

```
ludoteca_search({ query: "Halo" })
```

Returns:

```
[{"id":1,"name":"Halo: Combat Evolved","platform":"Xbox"},{"id":7,"name":"Halo 3","platform":"Xbox 360"}]
```

The call goes through MCP transport — JSON-RPC over stdio. Response returns as structured text.

### Step 5 (variant): Root-level server

A root `mcp-patlib` server follows the same pattern with registration in root `opencode.json`:

```json
{
  "mcpServers": {
    "patlib": {
      "type": "local",
      "command": ["bun", "run", ".opencode/tools/mcp-patlib/index.ts"]
    }
  }
}
```

Root-level servers are available across all projects. Project-level servers scope to that project directory per protocol rule 2.

## Key insight

MCP auto-discovery is config-based (opencode.json), parallel to filesystem-based Custom IPC auto-discovery (.opencode/tools/). The opencode.json entry IS the registration — no secondary manifest required. Project-level MCP servers wrap CLI query patterns into direct LLM-callable tools, bridging the gap between manual `bun run` and auto-discovered IPC tools.

## See also

- `PROT.TOOL.DISCOVERY` — the MCP discovery protocol this walkthrough illustrates
- `PAT.MCP.READONLY` — MCP read-only contract for server tools
- `PROT.TOOL.DEFINITION` — parallel auto-discovery mechanism for Custom IPC
- `PROT.TOOL.SCOPE` — tool scoping convention
- `IDENTITY.MCP` — MCP identity
- `PROT.MCP.TRANSPORT` — stdio transport for MCP servers
