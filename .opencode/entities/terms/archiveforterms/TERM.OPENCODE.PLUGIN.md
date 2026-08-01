**OpenCode Plugin** — a JavaScript/TypeScript module loaded by opencode at startup that subscribes to lifecycle events and customizes behavior. Defined in `.opencode/plugins/` (project-level), `~/.config/opencode/plugins/` (global), or via npm packages declared in `opencode.json` `"plugin"` array. Exports one or more async functions returning a hooks object. Can register custom tools via `tool()` helper, intercept tool execution, inject environment variables, and respond to session/file/permission events. Distinct from Custom IPC Tools (`.opencode/tools/*.ts`): plugins are event-driven and behavior-modifying; tools are callable by the LLM directly. Companion skills at `.opencode/skills/{name}/SKILL.md` teach the agent how to use plugin-registered tools.

Available lifecycle hooks and their trigger scope:

| Hook | Trigger scope |
|------|---------------|
| `file.edited` | opencode editor manual save only — agent Write/Bash tool calls excluded |
| `tool.execute.before` | before any agent tool execution |
| `tool.execute.after` | after any agent tool execution (Write, Bash, sync, validate, etc.) |
| `shell.env` | shell environment variable injection |
| `event` | opencode session events (created, updated, compacted, deleted) |
| `dispose` | plugin teardown |
| `config` | configuration load |

---

id: TERM.OPENCODE.PLUGIN
title: OpenCode Plugin
source: CON.TOOLCLASS.AUTOMATON
tags: [opencode, plugin, lifecycle, events, hooks, convention, architecture]
related: [TERM.OPENCODE.CUSTOM.TOOLS, IDENTITY.MCP, CON.FS.WATCH, PROT.PLUGIN.LIFECYCLE, PROT.TOOL.HOOKS]
reference:
  - title: OpenCode — Plugins
    url: https://opencode.ai/docs/plugins/
  - title: OpenCode — Custom Tools
    url: https://opencode.ai/docs/custom-tools/
  - title: OpenCode — Ecosystem
    url: https://opencode.ai/ecosystem
---

