**Tool Invocation Model** — tools operate in two invocation contexts: Shebang CLI for human-facing subproject tools (invoked via `bun run`), and Custom IPC Tool for agent-facing root tools (auto-discovered by OpenCode).

## Contexts

Two invocation contexts: Shebang CLI and Custom IPC Tool.
Shebang CLI is scoped to subprojects, human-audience, invoked via `bun run <file>`, no export, requires shebang, outputs to stdout, discovered manually, uses `read-*`/`write-*`/`audit-*` I/O prefixes.
Custom IPC Tool is scoped to root, agent-audience, auto-discovered by OpenCode, uses `export default tool({...})`, no shebang, returns value via toolResult, auto-discovered, name signals direction.

## Rules

- Shebang CLI is the invocation model for subproject user-facing tools.
- Custom IPC Tool is the invocation model for root agent-facing tools.
- CLI prefix signals I/O direction: `read-*` for reads, `write-*` for writes, `audit-*` for validation.

## Applicability

All tools under `assembler/`. Not applicable to MCP servers (discovered via `opencode.json`).

---
id: SPEC.TOOL.INVOCATION.MODEL
title: Tool Invocation Model — Shebang CLI vs Custom IPC Tool
source: assembler
summary: "Subproject user tools use shebang CLI with bun run; root agent tools use Custom IPC Tool with export default tool({...}). CLI prefix signals I/O direction."
specifies: Shebang CLI vs Custom IPC invocation contexts
tags: [tooling, architecture, invocation, cli, ipc, convention, specification]
status: active
---
