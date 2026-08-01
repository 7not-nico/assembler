**Plugin** — an event-driven behavior modification layer. TypeScript modules loaded at opencode startup. Subscribe to lifecycle hooks (`file.edited`, `tool.execute.before`, `tool.execute.after`). Write-only per `PROT.PLUGIN.WRITE`. In-process execution with zero cold start. Register tools via `tool()` helper.

---
id: IDENTITY.PLUGIN
title: Plugin — Event-Driven Behavior Modification Layer
source: PROT.PLUGIN.WRITE
group: architectonic
ring: R2
naming: '{name}'
tags: plugin,tool,identity,event,lifecycle,hooks,convention,architecture,metadata
related: [IDENTITY.CLI, IDENTITY.IPC, IDENTITY.MCP, IDENTITY.SCRIPT, NEX.TOOL.LAYER.CHOICE]
reference:
  - title: PROT.PLUGIN.WRITE — write-only contract
    url: https://opencode.ai/docs
  - title: PROT.TOOL.HOOKS — plugin hooks protocol
    url: https://opencode.ai/docs
  - title: SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY — groups, layers
    url: https://opencode.ai/docs
---
