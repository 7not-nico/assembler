---
id: PAT.AGENTIC.MCP
title: "Agentic MCP — External System-Controlling MCP Servers"
source: assembler
summary: "Agentic MCP servers are npm-published packages that control external systems. They are exempt from the read-only constraint that governs local custom MCP servers."
principle: "Agentic MCP servers are npm-published packages that control external systems. Two agentic servers for the same system pair as complementary layers — one automates, the other debugs. The read-only constraint does not apply."
enforcement: Convention
tags: [mcp, agentic, architecture, tooling, browser, convention]
status: active
priority: 3
---

Agentic MCP servers are npm-published packages that control external systems. They differ from local custom MCP servers in lifecycle, permissions, and purpose.

## Rules

- Agentic MCP servers control external systems — browsers, terminals, APIs. Their purpose is to act on the external system, not merely to query it.
- The read-only constraint from local custom MCP servers does not apply. Mutating external state is the server's function.
- Two agentic servers for the same external system pair as complementary layers — one automates, the other debugs. They share the same runtime context and target.
- One agentic server may expose read, write, and diagnostic tools simultaneously. No purity boundary enforced at the tool level — the external system is the boundary.
- Agentic MCP servers are invoked via `bunx` in `opencode.json` command arrays. Local custom MCP servers use `bun run` for local `.ts` files.
- An agentic server carries `--executable-path` pointing to the external system's runtime and `--headless` when no UI is needed. Local custom servers carry no such flags.

## Applicability

Any project that uses npm-published MCP servers to control external systems — browsers, terminals, file systems, or cloud APIs. The pattern distinguishes these from local custom MCP servers that query project databases or read project files.

## See also

- `PROT.MCP.SERVER` — contract for npm-published agentic MCP servers
- `NEX.BROWSER.DEBUG.STACK` — composition of automation + debugging agentic servers
- `ILL.AGENTIC.MCP.CONFIG` — concrete configuration walkthrough
- `PROT.TOOL.RUNNER` — bunx invocation convention
- `PAT.MCP.READONLY` — the read-only pattern that agentic servers are exempt from
