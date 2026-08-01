---
id: PROT.TOOL.HOOKS
title: "Plugin Hooks — Companion Skills, Tool Registration, Behavior Interception"
source: NEX.PLUGIN.LAYER
related: [PROT.TOOL.PLUGIN.STRUCTURE, PROT.TOOL.DEFINITION]
summary: "Plugins register tools via tool: hook, intercept before/after execution, inject env vars via shell.env. Lifecycle events via file.edited (editor saves only). Companion skill required for tool-registering plugins. No shebang or console.log — plugins load in-process. Compaction hooks for session context injection."
protocol: "Plugins register tools via tool: hook with tool() helper. Companion skill required at .opencode/skills/{name}/SKILL.md for every tool-registering plugin (AGENTS.md exception for subprojects). Behavior interception via tool.execute.before, tool.execute.after, shell.env. No shebang — console.log excluded; client.app.log() for structured logging. Compaction hooks via experimental.session.compacting. Tool names: [a-z][a-z0-9-]*, descriptions: 10-200 characters."
enforcement: Formality
status: draft
priority: 3
tags: [tooling, architecture, opencode, convention, plugin, hooks, interception]
---

Tool registration, behavior interception, companion skills, and hook conventions for opencode plugins.

## Architecture

The plugin system divides into two sub-protocols:

Two sub-protocols divide the plugin system:

- **PROT.TOOL.PLUGIN.STRUCTURE** covers plugin directory, named async export pattern, context destructuring, one-concern rule, and import conventions.
- **PROT.TOOL.HOOKS** covers companion skills, tool hook registration, behavior interception (before/after), shell.env injection, shebang/console.log prohibition, and compaction hooks.

## Protocol

0. **Lifecycle event hooks** — plugins register `file.edited` for opencode editor manual save events. This hook fires on editor saves only — agent Write/Bash tool calls do NOT trigger it. For agent-driven file changes, use `tool.execute.after`. For any-source filesystem monitoring, use `fs.watch` at the MCP server level.

1. **Companion skill** — plugins that register callable tools via `tool:` hook MUST include a companion skill at `.opencode/skills/{name}/SKILL.md`. The skill teaches the agent the tool workflow, invocation order, and expected output format.

   Exception for subproject plugins: when the project's `AGENTS.md` documents the plugin tools and workflow directly, the companion skill is optional. The agent learns the tool interface from the project's own documentation.

2. **Custom tools via `tool:` hook** — register tools using `tool()` helper inside the hooks object. Tool names match `[a-z][a-z0-9-]*` pattern. Tool descriptions stay between 10 and 200 characters:
   ```ts
   tool: {
     mytool: tool({
       description: "...",
       args: { foo: tool.schema.string().describe("...") },
       async execute(args, context) { return `...` },
     }),
   }
   ```
   Plugin-registered tools override built-in tools of the same name. No `.opencode/tools/` file needed for plugin-registered tools.

3. **Behavior interception** — use `tool.execute.before` to validate or modify tool input. Use `tool.execute.after` to log or transform tool output. Use `shell.env` to inject environment variables into all shell execution contexts.

4. **No shebang, no console.log** — plugins load in-process. Shebang lines are violations. `console.log` output is invisible to the opencode runtime — use `client.app.log()` for structured logging.

5. **Compaction hooks** — `experimental.session.compacting` for injecting domain-specific context into session summaries. Use sparingly — compaction context consumes token budget.

## Gotchas

- Plugin uses `console.log`: Use `client.app.log()` — structured logging with severity levels (`console.` in plugin file)
- Plugin with hooks omitted, tool registry only: Convert to `.opencode/tools/` — Custom IPC Tool for stateless operations (Plugin file contains `tool:` hook, event hooks absent)
- Companion skill omitted when tools registered: Add companion skill, or document tool workflow in project AGENTS.md (subproject exception) (Plugin registers tools, `skills/{name}/SKILL.md` absent)
- Plugin tool name collision with another plugin: Rename one tool — plugin tools share global namespace, last-loaded wins (Two plugins register same tool name)
- Plugin modifies `process.env` directly: Use `shell.env` hook — returns env vars per execution context, no global mutation (Plugin calls `process.env.X = val`)

## Enforcement

`audit-tool` scans `.opencode/plugins/` — flags plugins registering tools without companion skills. Verifies no shebang lines. Verifies `console.log` absence.

## See also

- `PROT.TOOL.PLUGIN.STRUCTURE` — directory, exports, concerns, imports
- `PROT.TOOL.DEFINITION` — alternative layer for stateless tools
- `ILL.TOOL.PLUGIN.HOOK` — event-driven hook registration walkthrough
- `TERM.OPENCODE.PLUGIN` — opencode plugin term definition
- `TERM.OPENCODE.CUSTOM.TOOLS` — Custom IPC Tool term definition
- `CON.FS.WATCH` — filesystem-level change detection, distinct from plugin hooks
- `PROT.PLUGIN.LIFECYCLE` — hook matrix with trigger source disambiguation
