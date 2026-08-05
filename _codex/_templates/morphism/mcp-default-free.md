---
id: MORPHISM.MCP.DEFAULT.FREE
title: MCP Default-Free — Shells Own the Defaults
layer: morphism/
purpose: "An MCP server carries no default values — every default lives in the canonical shell (via the schema); the server passes through only what the caller provides."
naming: mcp-default-free.md
tags: [morphism, mcp, defaults, server, schema, pass-through]
status: active
---
# MCP-DEFAULT-FREE.md

**Layer:** morphism/
**Naming:** `mcp-default-free.md` — code morphism, reusable structure.
**Composes with:** `morphism/schema-citation-chain.md`; derived from `study/` + `fixture/` proof.

## Morphism

An MCP server's tool schemas carry no `.default(...)` values; handlers pass args only when provided (`if (x !== undefined) args.push(...)`) — every default lives in the canonical shell, so the protocol layer has zero hardcoded values.

## Structure

```ts
// schema: optional, no default
timeout: z.number().int().positive().optional().describe("shell default applies when absent"),
// handler: conditional pass-through
async ({ timeout }) => {
  const args = [base]
  if (timeout !== undefined) args.push("--timeout", String(timeout))
  return runAndReturn("tool.sh", args, "tool")
}
```

Invariant: no `.default()` in any MCP schema; absent args are never sent — the shell's schema value applies; the server is a pure protocol pass-through.

## Verification

Scan both servers for `.default(` — zero hits; call a tool omitting `timeout` — the shell's schema default applies; the tools/list + one live call both succeed.

## Instance

`mcp/mcp-romsfun` + `mcp-rom-acquire` (2026-08-05) — 8 `.default()` calls removed (timeouts, head, console); console became required + validated; verified via tools/list (16 tools) + live `inst_verify`.
