---
id: ILL.MCP.QUERY
title: "MCP Read-Only — SELECT-Only Tools via MCP Transport"
source: PROT.MCP.TRANSPORT
summary: "Walkthrough of MCP read-only contract: a ludoteca_search MCP tool executes SELECT queries only; writing search results or metadata belongs in the plugin layer."
illustration: "A ludoteca_search MCP tool runs SELECT queries against ludoteca.db and returns formatted results. If the agent wants to save a search result as a note, the write operation goes to a plugin handler. MCP stays read-only."
illustrates: [PROT.TOOL.AUTOMATON]
tags: mcp,walkthrough,read-only,select,query
related: [PROT.MCP.TRANSPORT, PROT.PLUGIN.WRITE, PROT.TOOL.MODEL]
---
## Context

A `ludoteca_search` MCP tool queries games by name or platform. The read-only contract ensures SELECT queries stay fast and safe; writes go to the plugin layer with full error recovery.

## Walkthrough

### Step 1: MCP tool implements read-only handler

The MCP server registers a tool that executes SELECT queries:

```ts
server.tool(
  "ludoteca_search",
  { query: z.string() },
  async ({ query }) => {
    const db = new Database(".opencode/ludoteca.db")
    const rows = db.query("SELECT * FROM games WHERE name LIKE ?").all(`%${query}%`)
    return { content: [{ type: "text", text: JSON.stringify(rows) }] }
  }
)
```

The handler executes a SELECT only. No INSERT, UPDATE, DELETE, or DDL. The return is the query result as formatted text.

### Step 2: Write operation — separate layer

When the agent wants to save a search result as a bookmark, the write operation uses a plugin:

```ts
export const LudotecaBookmark = async function({ client }) {
  return {
    'tool.execute.after': async (event) => {
      if (event.tool === 'ludoteca_search') {
        const db = new Database(".opencode/ludoteca.db")
        db.run("INSERT INTO bookmarks (query, result, timestamp) VALUES (?, ?, ?)",
          [event.args.query, event.result, Date.now()])
      }
    }
  }
}
```

The plugin intercepts the search result and writes a bookmark. MCP handles the read; plugin handles the write.

### Step 3: Direction boundary

| Operation | Layer | Tool |
|-----------|-------|------|
| Search games by name | MCP | `ludoteca_search` — SELECT |
| Count games by platform | MCP | `ludoteca_stats` — SELECT aggregation |
| Validate game metadata | MCP | `ludoteca_validate` — file reads + SELECT |
| Save bookmark | Plugin | `tool.execute.after` — INSERT |
| Sync game catalog | Plugin | `tool.execute.after` — INSERT/UPDATE |

### Step 4: Fallback with CLI

When MCP server unavailable, CLI `read-*` tool provides equivalent reads:

```bash
bun run .opencode/tools/read-game.ts --name "Halo"
```

The write direction uses `write-*` CLI or plugin — MCP excluded for write operations.

## Direction table

| I need to... | Use MCP | Use Plugin | Fallback CLI |
|-------------|---------|-----------|--------------|
| Query games | ✓ SELECT | ✗ | `read-game` |
| Get game count | ✓ SELECT aggregation | ✗ | `read-stats` |
| Validate schema | ✓ file reads + SELECT | ✗ | `read-validate` |
| Save bookmark | ✗ | ✓ INSERT | `write-bookmark` |
| Sync catalog | ✗ | ✓ INSERT/UPDATE | `write-sync` |

## Key insight

The MCP transport provides no transactional compensation — if a write fails mid-operation, no rollback mechanism exists. Plugin handlers run in-process with lifecycle hooks offering confirmation and error recovery. The read-write boundary maps to the transport architecture: MCP for stateless queries, plugin for stateful mutations.

## See also

- `PAT.MCP.READONLY` — the MCP read-only contract this illustrates
- `PROT.PLUGIN.WRITE` — plugin write-only contract, the counterpart
- `PROT.MCP.TRANSPORT` — stdio transport mechanics
- `PROT.TOOL.MODEL` — CLI fallback pattern and layer choice
