---
id: PROT.TOOL.RUNNER
title: "Package Runner — bunx over npx for Package Invocation"
source: NEX.TOOL.CHOICE
related: [PROT.TOOL.MODEL, PROT.MCP.TRANSPORT]
summary: "Package invocation in MCP server commands and CLI tool calls uses bunx over npx. No -y flag — bunx auto-installs without prompting."
protocol: "MCP server command arrays in opencode.json use bunx as the package runner. bunx replaces npx across all project levels. The -y flag is omitted — bunx does not prompt before installing."
enforcement: Formality
status: active
priority: 3
tags: [tooling, convention, package-runner, bun, npx, mcp, invocation]
---

Package invocation uses `bunx` over `npx` across all `opencode.json` MCP server definitions and CLI tool calls.

## Protocol

1. **Use `bunx` in MCP command arrays** — every local MCP server `command` field in `opencode.json` that invokes an npm package uses `bunx` as the executable.

2. **Drop `-y` flag** — `bunx` auto-installs without prompting. The `-y` flag from `npx` is unnecessary and omitted.

3. **`bun run` for local scripts** — `bunx` is for npm packages. Local `.ts` files, project tools, and scripts use `bun run` per `PROT.TOOL.MODEL`.

4. **Apply across all project levels** — root `opencode.json` and every subproject `opencode.json` use `bunx` over `npx`.

## Gotchas

- `npx` in MCP command array: Replace with `bunx`, drop `-y` (`opencode.json` contains `npx` in `command`)
- `npx -y` preserved after migration: `bunx` does not support `-y`; omit it (`command` array contains `["bunx", "-y", ...]`)
- `npm` used for package installs: Use `bun install` / `bun add` (`npm install` or `npm add` in commands)

## Enforcement

Manual audit via grep for `npx` across all `opencode.json` files.

## Applicability

Every `opencode.json` file in the project — root and subprojects — that defines local MCP servers or invokes npm packages.

## See also

- `PROT.TOOL.MODEL` — CLI vs Custom IPC tool invocation model
- `PROT.MCP.TRANSPORT` — local MCP server stdio transport contract
- `IDENTITY.MCP` — MCP identity
