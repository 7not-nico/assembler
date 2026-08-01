---
id: PROT.MCP.SERVER
title: "Agentic MCP Server Contract — npm-Published External Server Configuration"
source: NEX.TOOL.CHOICE
related: [PROT.TOOL.RUNNER, PROT.MCP.TRANSPORT]
summary: "Agentic MCP servers are npm-published packages invoked via bunx. They carry --executable-path, --headless, and other flag configuration. They follow different lifecycle rules than local custom MCP servers."
protocol: "Agentic MCP servers are npm-published packages invoked via bunx in opencode.json command arrays. They carry --executable-path for the target system's runtime binary and --headless for headless mode. Flag configuration is per-server and documented in the server's own tool reference. Local custom MCP servers use bun run for local .ts files. The read-only constraint does not apply."
enforcement: Formality
status: active
priority: 3
tags: [mcp, agentic, tooling, architecture, convention, npm, server]
---

Agentic MCP servers are npm-published packages invoked via `bunx`. They differ from local custom MCP servers in invocation, configuration, and permissions.

## Protocol

1. **bunx invocation** — agentic MCP servers are npm-published packages. The `command` array in `opencode.json` uses `bunx` followed by the package name. No `-y` flag — `bunx` auto-installs without prompting.

2. **--executable-path for bundled runtimes** — when the server requires an external runtime binary (browser, terminal), `--executable-path` points to the binary location. The flag value is an absolute filesystem path.

3. **--headless for headless mode** — when the external system runs without a UI, `--headless` is added to the command arguments. Omitted when a visible window is desired.

4. **Flag configuration is per-server** — each agentic MCP server documents its own flags in its tool reference. No universal flag set across all agentic servers.

5. **Local custom servers use bun run** — local custom MCP servers invoke project `.ts` files via `bun run ./path/to/index.ts`. `bunx` is reserved for npm-published packages.

6. **Read-only constraint exempt** — agentic MCP servers mutate external system state. The read-only constraint does not apply.

7. **Complementary pairing** — two agentic servers for the same external system pair as complementary layers: one automates, the other debugs. They share the same runtime context and target.

8. **No tool-level purity boundary** — one agentic server may expose read, write, and diagnostic tools simultaneously. The external system is the boundary, not individual tool operations.

## Gotchas

- 1: `opencode.json` `command` contains `npx` instead of `bunx` (Agentic server invoked via npx)
- 2: `command` contains `bun run` for an npm package (Agentic server invoked via bun run)
- 3: Server starts but cannot find its target binary (--executable-path omitted for bundled runtime)
- 4: Audit flags agentic server tools for mutating state (Read-only constraint enforced on agentic server)

## Enforcement

Manual review on `opencode.json` changes. Audit identifies `command` entries with `bunx` as agentic servers and verifies `--executable-path` presence when a runtime binary is required. Flags agentic servers found with `npx` or `bun run` invocation.

## Applicability

All AMANDA projects with `opencode.json` files that define MCP servers. Root `opencode.json` and each subproject's `opencode.json` use the same contract for agentic MCP server entries.

## See also

- `ILL.AGENTIC.MCP.CONFIG` — concrete configuration walkthrough with opencode.json snippet
- `PROT.TOOL.RUNNER` — bunx over npx convention for all package invocation
- `PROT.MCP.TRANSPORT` — stdio transport contract for local custom MCP servers
- `PROT.TOOL.AUTOMATON` — tool I/O classification, agentic servers use TRNS
