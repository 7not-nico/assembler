---
name: semantic-dispatcher
description: Use this skill when a semantic MCP task starts — route to the right mode (search, stats, drift, embed, purge, eval) per ref/{mode}.md
state-profile: stateless
nexus: NEX.TOOL.CHOICE
---

## Trigger

A semantic MCP task starts — route to the right mode skill. The mode file names the route.

## Procedure

- Match the task to its mode — `ref/search.md`, `ref/stats.md`, `ref/drift.md`, `ref/embed.md`, `ref/purge.md`, `ref/eval.md`.
- Read the file; it names the target skill.
- Load the target `use-semantic-{mode}` skill before vector-store work.
- Follow the skill's tools and workflow. `PROT.SEMANTIC.WORKFLOW` governs.

## Gotchas

- Match the mode to the task — the route names the target skill
- Load the target skill before vector-store work — the shared patlib vector store carries the session
- Follow the skill's tools and workflow — the mode file names the route
