---
id: ILL.PLUGIN.WRITE
title: "Plugin Direction — Write-Only Contract for Lifecycle Hooks"
source: PROT.PLUGIN.WRITE
summary: "Walkthrough of PROT.PLUGIN.WRITE: plugins write data via hooks, reads go to MCP or CLI. A session-saver plugin demonstrates the direction boundary."
illustration: "A session-saver plugin writes session context to a JSON file via tool.execute.after hook. Reading session history uses MCP or CLI — the plugin layer handles write-only operations exclusively."
illustrates: [PROT.PLUGIN.WRITE]
tags: plugin,walkthrough,direction,write-only,lifecycle
related: [PROT.TOOL.HOOKS, PAT.MCP.READONLY, PROT.TOOL.MODEL]
---
## Context

A session-saver plugin persists conversation context between sessions. PROT.PLUGIN.WRITE establishes: plugins write data via hooks; read operations use MCP or CLI.

## Walkthrough

### Step 1: Identify the direction

The plugin saves session context to a JSON file after every tool execution. This is a write operation — file writes fall under plugin direction.

### Step 2: Plugin implementation (write)

```ts
export const SessionSaver = async function({ project, client }) {
  return {
    'tool.execute.after': async (event) => {
      const file = `${project.path}/.opencode/session-state.json`
      const state = { tool: event.tool, timestamp: Date.now() }
      await Bun.write(file, JSON.stringify(state))
    }
  }
}
```

The plugin writes to `.opencode/session-state.json` after each tool execution. Write-only operations belong in the plugin layer per PROT.PLUGIN.WRITE.

### Step 3: Read operation (excluded from plugin)

Reading the session state back is a read operation. PROT.PLUGIN.WRITE excludes reads from plugins — use MCP or CLI instead:

```ts
// MCP tool (read layer): queries session-state.json and returns content
export default tool({
  name: "read-session-state",
  execute: async () => {
    const state = await Bun.file(".opencode/session-state.json").text()
    return state
  }
})
```

The reader tool lives in `.opencode/tools/` or as an MCP server — `plugins/` directory excluded for read operations.

### Step 4: Direction boundary

| Operation | Layer | File location |
|-----------|-------|--------------|
| Write session state | Plugin | `.opencode/plugins/session-saver.ts` |
| Read session state | MCP or CLI | `.opencode/tools/read-session-state.ts` |
| Read and write | Excluded — split into two tools | |

The direction boundary is enforced by file location. A plugin that both reads and writes violates the contract.

## Direction decision table

| I need to... | Use layer | Because |
|-------------|-----------|---------|
| Write data on file edit | Plugin | `file.edited` hook only available in plugin |
| Write data on tool execution | Plugin | `tool.execute.after` hook only available in plugin |
| Read data on demand | MCP or CLI | Read operations belong in queryable layer |
| Read data on schedule | MCP | Server persists across session; no plugin hook needed |

## Key insight

The direction boundary concerns contract above capability — plugins CAN read files. The boundary declares plugins as write-oriented so the system reasons about access patterns. A plugin that reads introduces bidirectional coupling; MCP/CLI tools maintain unidirectional coupling.

## See also

- `PROT.PLUGIN.WRITE` — the plugin direction protocol this illustrates
- `PROT.TOOL.HOOKS` — plugin lifecycle hooks
- `PAT.MCP.READONLY` — MCP read-only contract, complementary to plugin direction
- `PROT.TOOL.MODEL` — layer choice by call pattern
