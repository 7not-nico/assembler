---
id: MORPHISM.COMPOSITION.ROMSFUN.TOOLCHAIN
title: Romsfun Toolchain Composition — Schema to MCP
layer: morphism/composition/
purpose: "How the romsfun toolchain composes: schema owns constants, shells cite them, wrappers delegate, the MCP server passes through — one citation chain end to end."
naming: romsfun-toolchain-composition.md
tags: [morphism, composition, toolchain, schema, wrapper, mcp]
status: active
---
# ROMSFUN-TOOLCHAIN-COMPOSITION.md

**Layer:** morphism/composition/
**Naming:** `romsfun-toolchain-composition.md` — code morphism, reusable structure.
**Composes with:** `morphism/schema-citation-chain.md` (base form); derived from `study/` + `fixture/` proof.

## Morphism

The romsfun toolchain composes as one citation chain: the schema owns every constant, the shells cite it, the wrappers delegate, and the MCP server passes through — a game acquisition flows from a validated console argument to a launched, traced emulator without a hardcoded value anywhere but the seed.

## Composition

```text
step 1  schema     instantiator/romsfun/schema/seed.sql  — constants only (9 rows)
step 2  lookup     lookup.sh exports SCHEMA_{KEY}        — the citation link
step 3  tools      8 romsfun shells use $SCHEMA_*        — never hardcode
step 4  wrappers   wrapper/{tool}.sh thin delegation      — resolve _codex, exec
step 5  mcp        mcp-romsfun default-free pass-through  — no .default()
step 6  flow       browse → fetch → verify → stage → launch → trace → stop
step 7  verify     full matrix: 8 tools via MCP, console valid-list, trace evidence
```

Invariant: a constant lives once (seed.sql); a tool never hardcodes; the MCP carries no defaults; the acquisition flow works identically through shell tools or the MCP server.

## Verification

Scan for `.default(` (zero) and hardcoded constants in tools (zero); run the acquisition flow through both paths — shell (`browse-romsfun.sh` → ... → `launch-emulator.sh`) and MCP (`inst_browse` → ... → `inst_launch`) — both yield the same staged ROM + trace evidence.

## Instance

The romsfun toolchain (2026-08-05) — 3 consoles proven (SNES snes9x, GBA mGBA, DS melonDS-ROM); commits `fc5feaf` (schema), `8ea2bc5` (console valid-list), `87a63ed` (mcp-romsfun rename).
