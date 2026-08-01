# Precedence chain — mcp-first update report

**Date:** 2026-07-31 21:55 local
**Status:** complete

## Change

Chain updated from `invariant/ → scripts/ → _bitacora/ → precept/ → backup/ → study/ → fixture/ → pattern/ → procedure/` to:

```text
mcp/ → invariant/ → scripts/ → _bitacora/ → precept/ → backup/ → study/ → fixture/ → pattern/ → procedure/
```

`mcp/` precedes all — the connected MCP servers (browser, acquire, patlib) form the tooling substrate that exists before any dive layer is used.

## Files updated

| File | Section |
|------|---------|
| `_codex/_templates/precedence-chain.md` | chain block, layer roles, rationale, violation list |
| `_codex/AGENTS.md` | Precedence chain — obligatory (general), lines 36–51 |
| `_codex/snes9x-repo/AGENTS.md` | Precedence chain — obligatory, lines 108–129 |
| `_codex/snes9x-repo/invariant/precedence-chain.md` | Formal chain description + forbidden-state clause |
| `_codex/_templates/dive-agents-template.md` | Precedence chain — obligatory |

## Out of scope

- `_templates/AGENTS.md` — the knowledge 13-layer learning chain (`format/ → precept/ → ...`), a different chain
- `guideline/invariant-layer.md`, `guideline-template.md` — reference the chain file by name only, no chain text
- Historical bitacora report `20260731-194500-invariant-layer-template-completion.md` — factual snapshot of its time, left unchanged

## Verification

Grep across `_codex/` (excluding node_modules): no remaining invariant-first chain strings in active files. Only the historical report retains the old form.
