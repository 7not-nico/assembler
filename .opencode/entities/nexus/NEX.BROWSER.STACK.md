---
id: NEX.BROWSER.STACK
title: "Browser Debug Stack — Automation Plus Debugging Composition"
source: assembler
summary: "An automation MCP server and a debugging MCP server compose into a full browser tooling stack. Automation handles navigation and input; debugging handles performance traces, network inspection, and memory analysis."
composition: "An automation MCP server and a debugging MCP server compose a full browser tooling stack. Automation handles navigation, input, screenshots, and form interaction. Debugging handles performance traces, network inspection, memory analysis, console diagnostics, and Lighthouse audits. Each server serves a distinct role; both share the same browser context."
enforcement: Convention
related: []
tags: [browser, debugging, automation, mcp, composition, tooling]
status: active
priority: 3
---

An automation MCP server and a debugging MCP server compose a full browser tooling stack. Each serves a distinct role; both share the same browser.

## Protocol

1. **Automation role** — navigation, input, screenshots, form fill, hover, click, key press. The automation server drives the browser like a user would.

2. **Debugging role** — performance traces, Core Web Vitals, network request inspection, console message capture, heap snapshots, Lighthouse audits, DOM and CSS inspection. The debugging server inspects what the browser is doing and why.

3. **Same browser context** — both servers share the same browser instance. Automation drives; debugging observes and diagnoses.

4. **Role separation** — automation does not diagnose; debugging does not drive. Each tool set maps to one role. A tool that both drives and diagnoses belongs to neither — split into separate automation and debugging tools.

5. **Stack order** — automation runs first when a task requires both navigation and diagnosis. Navigate then trace. Click then capture console. Fill then inspect DOM.

## Applicability

Any project that needs browser interaction beyond a single tool surface — automating page interaction and diagnosing the result. The composition covers all browser-facing MCP servers.

## See also

- `PAT.AGENTIC.MCP` — pattern for external system-controlling MCP servers
- `PROT.MCP.SERVER` — contract for agentic MCP server configuration
- `ILL.AGENTIC.MCP.CONFIG` — concrete walkthrough of automation + debugging setup
