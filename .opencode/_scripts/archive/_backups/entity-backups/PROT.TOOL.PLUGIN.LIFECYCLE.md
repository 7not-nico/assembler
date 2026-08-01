---
id: PROT.TOOL.PLUGIN.LIFECYCLE
title: "Plugin Lifecycle Hooks — Event-Driven Behavior Modification"
source: assembler
related: [PROT.TOOL.PLUGIN.STRUCTURE, PROT.TOOL.HOOKS, PROT.TOOL.DEFINITION, PROT.TOOL.DISCOVERY, TERM.OPENCODE.PLUGIN]
summary: "OpenCode plugins in .opencode/plugins/ hook into lifecycle events. Architecture divides into two sub-protocols: structure (directory, exports, concerns, imports) and hooks (companion skills, tool registration, behavior interception, compaction)."
protocol: "Plugin architecture divides into two sub-protocols: PROT.TOOL.PLUGIN.STRUCTURE (directory, named exports, one-concern, imports) and PROT.TOOL.HOOKS (companion skills, tool: hook, behavior interception, compaction hooks, shebang prohibition)."
enforcement: Convention
status: draft
priority: 3
tags: [tooling, architecture, opencode, convention, plugin, lifecycle, events]
---

Registry for the two sub-protocols that define the opencode plugin architecture.

## Architecture

The plugin system divides into two sub-protocols:

| Protocol | Scope |
|----------|-------|
| `PROT.TOOL.PLUGIN.STRUCTURE` | Plugin directory, named async export pattern, context destructuring, one-concern rule, import conventions |
| `PROT.TOOL.HOOKS` | Companion skills, tool: hook registration, behavior interception (before/after), shell.env injection, shebang/console.log prohibition, compaction hooks |

## Applicability

Any AMANDA project needing lifecycle hooks (session events, tool interception, env injection) beyond what Custom IPC Tools and MCP servers provide. Projects with lifecycle needs add a plugin layer. Stateless-only projects use Custom IPC Tools or MCP servers.

## See also

- `PROT.TOOL.PLUGIN.STRUCTURE` — directory, exports, concerns, imports
- `PROT.TOOL.HOOKS` — companion skills, tool registration, behavior interception
- `PROT.TOOL.DEFINITION` — alternative layer for stateless tools
- `PROT.TOOL.DISCOVERY` — alternative layer for persistent multi-tool services
- `ILL.TOOL.PLUGIN.HOOK` — event-driven hook registration walkthrough
- `TERM.OPENCODE.PLUGIN` — opencode plugin term definition
- `TERM.OPENCODE.CUSTOM.TOOLS` — Custom IPC Tool term definition
