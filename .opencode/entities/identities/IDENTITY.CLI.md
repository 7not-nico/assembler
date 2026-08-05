**CLI** — a human-facing tool invocation layer. command line tools with `// @toolclass` annotations run via Bun `bun run`. Shebang entry point. Console output to stdout. Subproject default. Fallback tier when MCP or plugin unavailable. Prefix naming signals I/O direction: `read-*`, `write-*`, `audit-*`.

Other cli may co exist as part of the system.

---
id: IDENTITY.CLI
title: CLI — Human-Facing Tool Invocation Layer
source: PROT.TOOL.MODEL
group: architectonic
ring: R2
naming: '{name}'
tags: cli,tool,identity,invocation,shebang,convention,architecture,metadata
related: [IDENTITY.IPC, IDENTITY.MCP, IDENTITY.PLUGIN, IDENTITY.SCRIPT, NEX.TOOL.LAYER.CHOICE]
reference:
  - title: PROT.TOOL.MODEL — CLI invocation contract
    url: https://opencode.ai/docs
  - title: PROT.TOOL.AUTOMATON — @toolclass annotations
    url: https://opencode.ai/docs
  - title: SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY — groups, layers
    url: https://opencode.ai/docs
---
