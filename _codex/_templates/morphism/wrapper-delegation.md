---
id: PATTERN.WRAPPER.DELEGATION
title: Wrapper Delegation — Thin Entry, Canonical Delegate
layer: morphism/
purpose: "Thin entry points resolve the shared root from own location and delegate to one canonical implementation."
naming: wrapper-delegation.md
tags: [pattern, morphism, wrapper, delegation]
status: active
---
# WRAPPER-DELEGATION.md

**Layer:** morphism/
**Naming:** `wrapper-delegation.md` — code morphism, reusable structure.
**Composes with:** `procedure/wrapper-delegation.md`; derived from `study/` + `fixture/` proof.

## Morphism

A thin entry point resolves the shared root from its own location and delegates to one canonical implementation; projects invoke the entry point, never the implementation directly.

## Structure

```text
wrapper/{tool}.sh              — thin entry: resolves CODEX from own location
  → exec instantiator/{tool}.sh — canonical implementation (all logic)
scripts/codex.sh run-bitacora  — dive entry → wrapper/run-bitacora.sh → shell/bitacora-run.sh
```

Invariant: one canonical implementation per tool; the wrapper carries no logic beyond resolution and exec; the interface shape stays `{name} -- {command}`.

## Verification

Run the wrapper from any cwd: result lines match the canonical tool's output; a failing canonical exit code propagates through the wrapper unchanged; a wrapper without the shared root above it exits with a resolution hint, never a silent no-op.

## Instance

snes9x + mGBA dives (2026-08-05) — 8 dive `scripts/` entries exec `wrapper/{tool}.sh`; `mcp-instantiator` delegates every tool to the wrapper layer; the bitacora chain routes through `wrapper/run-bitacora.sh`.
