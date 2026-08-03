---
name: workflow-dispatcher
description: Use this skill when a workflow task starts — route to the right mode (bash-flows, stdout, surveys, context-seven, bitacora) per ref/{mode}.md
state-profile: stateless
nexus: NEX.META.ORCHESTRATION
---

## Trigger

A workflow task starts — route to the right mode skill. The mode file names the route.

## Procedure

- Match the task to its mode — `ref/bash-flows.md`, `ref/stdout.md`, `ref/surveys.md`, `ref/context-seven.md`, `ref/bitacora.md`.
- Read the file; it names the target skill.
- Load the target skill before workflow work.
- Follow the skill's tools and workflow. `NEX.META.ORCHESTRATION` governs.

## Gotchas

- Match the mode to the task — the route names the target skill
- Load the target skill before workflow work — the mode carries the session
- Follow the skill's tools and workflow — the mode file names the route
