---
id: ILL.TOOL.HOOK
title: "Plugin Lifecycle — Event-Driven Hook Registration"
source: PROT.TOOL.DEFINITION
summary: "Walkthrough of creating a plugin: tool.execute.after hook logs tool name, args, and duration. Covers named export, context destructuring, client.app.log for structured logging, companion skill placement."
illustration: "A log-mcp plugin registers a tool.execute.after hook that logs tool name, args, and duration via client.app.log. Follows named export pattern; rule governs companion skill requirement."
illustrates: [PROT.TOOL.HOOKS]
tags: plugin,walkthrough,lifecycle,hook,interception,event
related: [PROT.TOOL.DEFINITION, PROT.PLUGIN.WRITE, PROT.TOOL.DISCOVERY]
---
## Context

The team needs to audit every tool call during a session. A plugin at `.opencode/plugins/log-mcp.ts` intercepts `tool.execute.after` events and writes structured logs to a `mcp_log` table.

## Walkthrough

### Step 1: File placement

Place the file at `.opencode/plugins/log-mcp.ts`. Plugins belong in `.opencode/plugins/`, separate from `.opencode/tools/`.

### Step 2: Named export with context destructuring

```ts
export const LogMcp = async function({ project, client, $, directory, worktree }) {
  return {
    'tool.execute.after': async (event, context) => {
      // event: { tool, args, result }
      const duration = Date.now() - context.startTime
      client.app.log({
        level: 'info',
        message: `Tool ${event.tool} executed`,
        body: { tool: event.tool, args: event.args, duration }
      })
    }
  }
}
```

The named export uses `LogMcp`; `export default` excluded. The filename determines plugin identity. Context destructuring uses exact parameter names.

### Step 3: Event hook assignment

The `tool.execute.after` hook fires after every tool call. In this plugin, it logs the tool name, args, and execution duration. The `client.app.log()` call writes structured output visible in the opencode runtime.

### Step 4: Companion skill evaluation

Does this plugin register a callable tool? No — it only intercepts events. Per PROT.TOOL.HOOKS §1, companion skills are required only for plugins that register tools via the `tool:` hook. The `log-mcp` plugin registers no tools, so the companion skill is excluded.

### Step 5: Test coverage

The plugin has one hook (`tool.execute.after`) and zero registered tools. Per rule enforcement: test count matches hook count — one test verifies the after-hook fires and logs correctly.

## Full source

```ts
export const LogMcp = async function({ project, client }) {
  return {
    'tool.execute.after': async (event, context) => {
      const duration = Date.now() - context.startTime
      client.app.log({
        level: 'info',
        message: `Tool ${event.tool} completed`,
        body: {
          tool: event.tool,
          duration: `${duration}ms`,
          result: event.result?.substring(0, 200)
        }
      })
    }
  }
}
```

## Rules applied

| Rule | In this plugin |
|------|---------------|
| Plugin in `.opencode/plugins/` | `log-mcp.ts` placed in `plugins/` |
| Named export pattern | `export const LogMcp = async function(...)` |
| Context destructuring | `{ project, client }` destructured |
| One concern per plugin | Single concern: execution logging |
| No console.log | `client.app.log()` for structured logging |
| Companion skill | Excluded — no `tool:` hook registered |
| No shebang | Shebang line absent |
| File size < 200 lines | ~30 lines |

## Key insight

A plugin with event hooks only (zero registered tools) excludes the companion skill requirement. The hook intercepts existing tools; tool creation is outside the hook scope. The plugin stays in `plugins/` rather than `tools/` because its primary interface is event-driven; callable interface excluded.

## See also

- `PROT.TOOL.HOOKS` — the plugin lifecycle protocol this illustrates
- `PROT.TOOL.DEFINITION` — alternative layer for callable functions
- `PROT.PLUGIN.WRITE` — plugin write-only contract
- `PROT.TOOL.DISCOVERY` — MCP server auto-discovery, alternative to plugin for persistent services
