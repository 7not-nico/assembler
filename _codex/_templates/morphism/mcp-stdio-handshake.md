---
id: MORPHISM.MCP.STDIO.HANDSHAKE
title: MCP Stdio Handshake — Probe the Server Directly
layer: morphism/
purpose: "An MCP server over stdio is probed directly: initialize → initialized → tools/list → tools/call, via newline-delimited JSON — no client, no config needed."
naming: mcp-stdio-handshake.md
tags: [morphism, mcp, stdio, handshake, probe, json-rpc]
status: active
---
# MCP-STDIO-HANDSHAKE.md

**Layer:** morphism/
**Naming:** `mcp-stdio-handshake.md` — code morphism, reusable structure.
**Composes with:** `morphism/mcp-tool-server.md`; derived from `study/` + `fixture/` proof.

## Morphism

An MCP server over stdio is probed directly: feed `initialize`, `notifications/initialized`, `tools/list`, `tools/call` as newline-delimited JSON-RPC on stdin — the server answers on stdout, proving registration and delegation without a client or config.

## Structure

```text
printf '%s\n' \
  '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{...}}' \
  '{"jsonrpc":"2.0","method":"notifications/initialized"}' \
  '{"jsonrpc":"2.0","id":2,"method":"tools/list"}' |
  bun run index.ts          # server over stdio
→ tools register; a tools/call routes through wrapper → canonical → result lines
```

Invariant: the handshake sequence is fixed (initialize → initialized → list → call); each call is one JSON-RPC line; the server answers on stdout; the keyed result lines prove the delegation chain.

## Verification

Feed the four-message sequence — `tools/list` returns every registered tool; a `tools/call` with valid args returns the canonical tool's keyed lines; an invalid arg surfaces as `ERROR` text + non-zero exit.

## Instance

`mcp/mcp-romsfun` + `mcp-rom-acquire` (2026-08-05) — 8 tools each verified via the stdio handshake; live `inst_verify`/`inst_acquire`/`inst_stop` calls returned the expected result lines.
