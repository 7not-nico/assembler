---
id: TEMPLATE.DIVE.AGENTS
title: Dive Agents Template — Dive AGENTS.md Scaffold
layer: agents
purpose: "Scaffolds a dive's AGENTS.md: domain, structure, build flow, precedence chain, records."
naming: AGENTS.md
tags: [template, agents, scaffold]
status: active
---
# AMANDA {repo}-repo — Agent Instructions

## Domain

This project dives the {repo} codebase — {one-sentence domain}. The dive {compiles/studies/extends/verifies} the source and documents the findings.

## Structure

- `{repo}/` holds the source tree — a shallow clone (depth 1, commit {hash}).
- `roms/` (or per-dive assets folder) stores test assets; every file uses a lowercase dash-slug.
- `invariant/` holds always-true state predicates + violation signatures. Outermost layer: the facts the dive must preserve. Guideline: `guideline/invariant-layer.md`.
- `scripts/` holds atomic project tooling (browse/fetch/verify/prepare/launch + conductor).
- `precept/` holds the dive's governing rules. Precepts precede work; every task consults them.
- `backup/` holds pre-edit restore points — `{repo}-src/` (source, no artifacts) + timestamped binaries.
- `study/` holds architecture documents + the change inventory (authoritative list of every edited code line).
- `fixture/` holds atomic regression harnesses. Rerun after any change in their domain.
- `pattern/` holds code morphisms. Each carries structure, verification, and a session instance.
- `procedure/` holds numbered step chains — one per code morphism. Procedures compose with patterns.
- `_bitacora/` stores the shared record under `_codex/`. Every file carries the `{YYYYMMDD}-{HHMMSS}-` prefix.

## Precedence chain — obligatory

The dive's layers compose in a fixed order. Each layer precedes the next; a task advances through the chain.

`mcp/` → `invariant/` → `scripts/` → `_bitacora/` → `precept/` → `backup/` → `study/` → `fixture/` → `pattern/` → `procedure/`

MCP precedes all — the connected servers (browser, acquire, patlib) form the tooling substrate that exists before any dive layer is used. Invariants follow — the state facts the dive must preserve exist before any work. Scripts then execute the work under those invariants. Bitacora then opens the record: the todo plans the work before it starts. Precepts then govern. Backup precedes study — restore points exist before any architecture work on the source. Study and fixture precede pattern: understand the architecture, prove the components, then derive the morphism. Pattern precedes procedure: the structure informs the steps.

### Layer roles

- `mcp/` — connected MCP servers (browser, acquire, patlib). Tooling substrate. Precedes all: servers connect before any dive layer is used.
- `invariant/` — always-true state predicates + violation signatures. Guideline: `guideline/invariant-layer.md`.
- `scripts/` — atomic tools + orchestrator. Execute the dive's tasks under the invariants.
- `_bitacora/` — the record. Todo first, report after.
- `precept/` — action-domain rule files. Declarative. Governs all work.
- `backup/` — restore points taken before any source study or edit.
- `study/` — architecture documents. Precedes the morphism.
- `fixture/` — atomic regression harnesses. Precedes the morphism.
- `pattern/` — code morphisms. Derived from study + fixture proof.
- `procedure/` — numbered step chains. The morphism informs the steps.
- per-dive layers (`roms/`, etc.) — test assets and project-specific pickers.

Violating the order — starting work without the invariants, skipping the bitacora todo, editing code without consulting the precepts, studying source without a backup, deriving a pattern without study, writing a procedure without the morphism — marks the work incomplete.

## Records

Every session writes timestamped files into `_codex/_bitacora/`. The todo precedes work; the report follows completion; every command output flows through `run-logged.sh` into `_bitacora/task-stdout/`. Knowledge gained lands in its layer: invariant (state fact) → precept (rule) → procedure (steps) → pattern (morphism) → study (architecture) → fixture (proof). Templates for the dive layers live in `_codex/_templates/` and propagate via `copy-templates.sh`.

## Delegation

This project owns the {repo} dive: {build flags, acquisition, extension, verification}.
