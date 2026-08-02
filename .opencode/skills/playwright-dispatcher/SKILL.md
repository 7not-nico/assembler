---
name: playwright-dispatcher
description: Use this skill when a Playwright MCP task starts — route to the right mode (core, ai-mode, debug, network-storage, vision) per ref/{mode}.md.
state-profile: stateless
nexus: NEX.BROWSER.STACK
---

**Trigger**

A Playwright MCP task starts — route to the right mode skill. The mode file names the route.

**Procedure**

1. Match the task to its mode — `ref/core.md`, `ref/ai-mode.md`, `ref/debug.md`, `ref/network-storage.md`, `ref/vision.md`.
2. Read the file; it names the target skill.
3. Load the target `use-playwright-{mode}` skill before browser work.
4. Follow the skill's tools and workflow. `PRE.PLAYWRIGHT.STANDARD.ROUTE` governs.

**Gotchas**

- Match the mode to the task — the route names the target skill
- Load the target skill before browser work — the shared browser carries the session
- Follow the skill's tools and workflow — the mode file names the route
