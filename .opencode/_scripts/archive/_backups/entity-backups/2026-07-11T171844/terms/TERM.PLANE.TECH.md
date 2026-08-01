**Tech Plane — Project Classification** — describes the build pattern and tool interface.

**plugin-ipc** — tools written as `@opencode-ai/plugin` named exports with typed args. Auto-discovered by OpenCode. No CLI invocation needed.

**shebang-cli** — tools written as `#!/usr/bin/env bun` scripts. Invoked manually with `bun run .opencode/tools/<name>.ts [args]`.

**agent-hybrid** — few plugin-IPC tools exist; most work is done by sub-agents. The single tool file may expose 10+ tools.

**generative** — no tools dir pre-committed. Slash commands (`/db-domain`, `/db-entities`, etc.) drive schema, templates, and tool generation.

**flat** — no code or tooling. Content is flat markdown only.

**none** — no tooling pattern applies.

---
id: TERM.PLANE.TECH
title: Tech Plane — Project Classification
source: assembler
tags: project,classification,ontology
terms: [TERM.AMANDA.SYSTEMS, TERM.PLANE.INIT]
patterns: [PAT.ASSEMBLER.ARCHITECTURE, PAT.PLUGIN.IPC.TOOL]
related: []
reference:
  - title: Tech plane — Project tooling patterns
    url: https://opencode.ai/docs
  - title: TERM.PLANE.STRUCTURE — Structure plane classification
    url: https://opencode.ai/docs
  - title: TERM.PLANE.VOCATION — Vocation plane classification
    url: https://opencode.ai/docs
---
