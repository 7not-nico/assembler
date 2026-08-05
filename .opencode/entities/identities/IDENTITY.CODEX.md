**Codex** — the R1 code-dives domain — a codebase exploration container holding dive projects. Each dive fetches a repository shallow into `{repo}-repo/{repo}/`, compiles it, and documents the findings. The `_templates/` folder holds the shared toolchain — fetch, copy, logging, slugify. The `_bitacora/` folder holds the project record with `task-{concrete noun}` subfolders. Code Dives is a compound aggregator: it names a container, and no single action produces it.

---
id: IDENTITY.CODEX
title: Codex — Codebase Exploration Container
source: RING.DIRECTORY.TOPOLOGY
group: composition
ring: R1
naming: _codex/{repo}-repo/{repo}/
tags: code-dives,domain,container,identity,exploration
related: [IDENTITY.KNOWLEDGE, IDENTITY.BITACORA, RING.DIRECTORY.TOPOLOGY]
reference:
  - title: RING.DIRECTORY.TOPOLOGY — ring placement
    url: https://opencode.ai/docs
  - title: _codex/AGENTS.md — dive project instructions
    url: https://opencode.ai/docs
---
