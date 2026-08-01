---
id: PRE.PLAYWRIGHT.STANDARD.ROUTE
title: Playwright Standard — Delegate to Use-Playwright Skills for All Browser Automation
source: assembler
summary: Four canonical skills define all Playwright MCP usage — core interaction, network/storage, debug/capture, and vision. Any browser task routes through them.
precept: All Playwright MCP browser automation follows the four canonical skills — SKL.USE.PLAYWRIGHT.CORE, SKL.USE.PLAYWRIGHT.NETWORK.STORAGE, SKL.USE.PLAYWRIGHT.DEBUG, and SKL.USE.PLAYWRIGHT.VISION. No ad-hoc Playwright usage outside these.
enforcement: Convention
tags: [playwright, convention, standard, browser-automation, tooling]
status: active
priority: 3
---

**Playwright Standard** — delegate to `use-playwright` skills for all browser automation tasks.

## Corollaries

- Any browser automation task routes through one of the four canonical skills
- `SKL.USE.PLAYWRIGHT.CORE` — navigation, snapshot, click, type, forms, tabs, dialogs, wait, screenshot, file upload, resize
- `SKL.USE.PLAYWRIGHT.NETWORK.STORAGE` — network mocking, cookies, localStorage, sessionStorage, auth state persistence
- `SKL.USE.PLAYWRIGHT.DEBUG` — code execution, console diagnostics, assertions, tracing, video, PDF export
- `SKL.USE.PLAYWRIGHT.VISION` — pixel-coordinate mouse interaction for canvas and inaccessible UIs
- Capability-gated tools (network, storage, assert, trace, video, pdf, vision) document their required `--caps=` flag
- Ad-hoc Playwright usage (raw `browser_run_code` without skill reference) discouraged — route through the canonical skill first

## Applicability

Any agent session involving Playwright MCP browser automation. Session resets, task switches, or tool selection defaults to skill lookup before raw tool calls.
