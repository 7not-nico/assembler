---
name: search-dispatcher
description: Use this skill when a web-search MCP task starts — route to the right engine (exa, parallel) per ref/{engine}.md
state-profile: stateless
nexus: NEX.INVESTIGATION.STAGE
---

## Trigger

A web-search MCP task starts — route to the right engine skill. The engine file names the route.

## Procedure

- Match the task to its engine — `ref/exa.md`, `ref/parallel.md`.
- Read the file; it names the target skill.
- Load the target `use-{engine}` skill before web-search work.
- Follow the skill's tools and workflow. `NEX.INVESTIGATION.STAGE` governs.

## Gotchas

- Match the engine to the task — the route names the target skill
- Load the target skill before web-search work — the engine carries the session
- Follow the skill's tools and workflow — the engine file names the route
