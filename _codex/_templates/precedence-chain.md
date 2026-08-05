---
id: TEMPLATE.PRECEDENCE.CHAIN
title: Precedence Chain — Codex Chain Doctrine
layer: convention
purpose: "The general codex chain: 10 layers, ordinal rings, inherited by every dive."
naming: precedence-chain.md
tags: [template, chain, precedence, rings]
status: active
---
# Precedence chain — codex (general)

**Layer:** convention
**Naming:** `precedence-chain.md` — the general codex chain, inherited by every dive.
**Composes with:** per-dive AGENTS.md chains (dives may extend with dive-specific layers).

## Chain — obligatory

```text
mcp/ → invariant/ → scripts/ → _bitacora/ → precept/ → backup/ → study/ → concept/ → fixture/ → morphism/ → procedure/
```

Each layer precedes the next; a task advances through the chain in order. The chain is the same for every code-dive project in `_codex/`.

## Rings — ordinal order

Rings follow an ordinal order. Layers inside rings follow the chain order. Rings proceed in sequence: ring 0, ring 1, ring 2, ring 3. Each ring's layers run in chain order before the next ring starts. A task crosses a ring boundary after the ring's layers hold in order:

```text
ring 0  foundation             invariant/ → scripts/
ring 1  record + governance    _bitacora/ → precept/
ring 2  safety + understanding backup/ → study/ → concept/
ring 3  proof + structure + steps  fixture/ → morphism/ → procedure/
```

## Layer roles

- `mcp/` — connected MCP servers (browser, acquire, patlib). The tooling substrate. Precedes all: the servers connect before any dive layer is used. (Not a chain layer — the substrate the chain runs on.)
- `invariant/` — always-true state predicates + violation signatures. The facts the dive must preserve exist before any work. (Guideline: `guideline/invariant-layer.md`.)
- `scripts/` — atomic tools + orchestrator. Execute the work under the invariants.
- `_bitacora/` — the record. Todo first, report after.
- `precept/` — action-domain rule files. Declarative. Governs all work.
- `backup/` — restore points taken before any source study or edit.
- `study/` — architecture documents. How the codebase and its extensions work. Precedes the concept and the morphism.
- `concept/` — one-concept-per-file knowledge grounded in `study/`. Distills the architecture into named ideas before proof.
- `fixture/` — atomic regression harnesses. Prove components before integration; rerun after changes. Precedes the morphism.
- `morphism/` — code morphisms. Reusable structures derived from study + fixture proof.
- `procedure/` — numbered step chains. Atomic per workflow. The morphism informs the steps.

## Rationale

MCP servers are the tooling substrate — the browser, acquire, and patlib endpoints exist and connect before any dive layer is used, so they stand outermost. Invariants declare the state facts — what must always hold — next: the tooling is built to preserve them, the record documents work governed by them. Scripts execute the work then, under those invariants. The bitacora opens the record — a todo plans work before it starts. Precepts govern the how. Backup protects the source before any study. Study, concept, and fixture ground the pattern — understand the architecture, distill the named ideas, prove the components, then derive the morphism. The pattern informs the procedure's steps.

## Violation

Running work without the MCP servers connected, starting work without the tooling, skipping the bitacora todo, editing code without consulting the precepts, studying source without a backup, deriving a pattern without study, writing a procedure without the morphism — each marks the work incomplete.

## Instance

snes9x dive (2026-07-31) — first dive to run the general chain; the dive's AGENTS.md carries it verbatim. mGBA dive (2026-08-01) — rings formalized; `concept/` added as a chain layer.
