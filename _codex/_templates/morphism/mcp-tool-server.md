---
id: PATTERN.MCP.TOOL.SERVER
title: MCP Tool Server — Protocol Layer Wraps Canonical Tools
layer: morphism/
purpose: "An MCP server wraps a CLI tool suite: protocol in TypeScript, tool logic in the canonical shell layer, _lib execs shared wrappers."
naming: mcp-tool-server.md
tags: [pattern, morphism, mcp, server, tools]
status: active
---
# MCP-TOOL-SERVER.md

**Layer:** morphism/
**Naming:** `mcp-tool-server.md` — code morphism, reusable structure.
**Composes with:** `morphism/wrapper-delegation.md`; derived from `study/` + `fixture/` proof.

## Morphism

An MCP server wraps a CLI tool suite: the protocol layer stays in TypeScript, the tool logic stays in the canonical shell layer, and a `_lib` query module execs the shared wrappers.

## Structure

```text
mcp/{server}/index.ts          — McpServer + StdioServerTransport; zod schemas per tool
mcp/{server}/_lib/query.ts     — execFileSync runScript → shared wrapper with args
  → wrapper/{tool}.sh          — thin entry (pattern: wrapper-delegation)
  → instantiator/{tool}.sh     — canonical implementation
opencode.json                  — registers the server entry
```

Invariant: MCP adds the protocol; no tool algorithm lives in the server; result lines pass through unchanged; each tool keeps its zod schema and doc.

## Verification

Standalone JSON-RPC handshake (`initialize`, `tools/list`) before registering; each tool invoked through the MCP layer and its keyed result line asserted; a server restart follows any canonical-layer edit.

## Instance

`mcp/mcp-instantiator/index.ts` exposing `inst_acquire`, `inst_stop`, `inst_fetch`, `inst_browse`, `inst_build`, `inst_launch`, `inst_verify`, `inst_trace` (2026-08-04/05) — 4 tools re-probed live through the Go-backed deps chain.
