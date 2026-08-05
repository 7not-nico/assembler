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

## Identity

This file is the agent instruction file for the {repo} dive. It instantiates the delegation environment per `IDENTITY.AGENT`; it states only final absolute states per `RUL.AGENTS.STATE`; it stands self-contained per `SPEC.AGENTS.SELF.CONTAINED` — the file names no other agent instruction file, upstream or downstream.

## Domain

This project dives the {repo} codebase — {one-sentence domain}. The dive {compiles/studies/extends/verifies} the source and documents the findings.

## Structure

- `{repo}/` holds the source tree — a shallow clone (depth 1, commit {hash}).
- `build/` hosts the build dir; the primary binary lands at {binary path}.
- `roms/` (or per-dive assets folder) stores test assets; every file uses a lowercase dash-slug.
- `invariant/` holds always-true state predicates + violation signatures. Outermost layer: the facts the dive must preserve. Guideline: `guideline/invariant-layer.md`.
- `scripts/` holds atomic project tooling (browse/fetch/verify/prepare/launch + conductor).
- `precept/` holds the dive's governing rules. Precepts precede work; every task consults them.
- `backup/` holds pre-edit restore points — `{repo}-src/` (source, no artifacts) + timestamped binaries + `study-monoliths/` (pre-split study docs).
- `study/` holds architecture documents — one concern per file, each grounded with file:line anchors.
- `concept/` holds one-concept-per-file knowledge grounded in `study/`.
- `fixture/` holds atomic regression harnesses + source-registered test suites. Rerun after any change in their domain.
- `pattern/` holds code morphisms. Each carries structure, verification, and a session instance.
- `procedure/` holds numbered step chains — one per code morphism. Procedures compose with patterns.
- `_bitacora/` stores the shared record under `_codex/`. Every file carries the `{YYYYMMDD}-{HHMMSS}-` prefix.
- `template/` holds the layer templates + precedences — the source of forms for new layer files; propagates via `script/copy-templates.sh`.

## Tooling — codex instantiation

- `_templates/instantiator/` holds shared code for projects — the canonical implementations (`acquire-game`, `stop-process`, `fetch-download`, `browse-romsfun`, `build-cmake`, `launch-emulator`, `verify-archive`, `trace-evidence`).
- `_templates/wrapper/` holds wrappers — the interface this project invokes; projects call wrappers, never implementations. Each wrapper resolves `_codex` from its own location and delegates to one canonical implementation.
- `_templates/shell/` holds shells codex needs to operate (`bitacora-run`, `run-logged`, `slugify`, `start-browser*`); `_templates/script/` holds scripts codex needs to operate (`fetch-repo`, `scaffold-knowledge`, `copy-templates`, `copy-skills`, Ruby/TS tools).
- `scripts/codex.sh {tool} [-- {args}]` — the dive's generic dispatcher; resolves `_codex` by walking up from any depth and execs `_templates/wrapper/{tool}.sh`. Tools: `run-bitacora`, `acquire-game`, `stop-process`, `fetch-download`, `browse-romsfun`, `build-cmake`, `launch-emulator`, `verify-archive`, `trace-evidence`.
- A dive needing a codex tool adds a thin `scripts/` entry resolving `_codex` and delegating to the shared wrapper — the interface, never the implementation.
- The bitacora chain: dive entry → `wrapper/run-bitacora.sh {name} [--trace] -- {cmd}` → `shell/bitacora-run.sh` → `_codex/_bitacora/task-stdout/{timestamp}-{name}.log`; `--trace` adds tracexec exec-tree enrichment; the tail appends `# DUR:`, `# DATE:`, `# exit:`.

## Build flow

{Numbered steps — the dive's build recipe with exact commands. Example:}

1. The agent configures with cmake. The native build carries host instruction-set flags and the test suite:
   ```bash
   cmake -S {repo} -B build -DBUILD_QT=OFF -DBUILD_SDL=ON -DCMAKE_BUILD_TYPE=Release \
     -DBUILD_SUITE=ON -DCMAKE_C_FLAGS="-O3 -march=native" -DCMAKE_CXX_FLAGS="-O3 -march=native"
   ```
2. The agent builds with `cmake --build build -j$(nproc)` ({baseline} s, {native} s with suite).
3. The agent verifies with `build/sdl/{bin} --version` and `file build/sdl/{bin}` (expect {arch} PIE).
4. The agent records flags, duration, binary size, and warnings in the bitacora report.

## Test suite

The full test run passes {N}/{N} under the native build (~{T} s): {suite list with per-suite counts}. Command: {test command}. Searches use `rg` (ripgrep).

## Quantitative doctrine — qalc

Every quantitative claim in the dive's records passes qalc verification before recording. The agent runs `qalc -t "{claim}"` for each value — frame cycles, frequencies, dimensions, size classes, checksums. The study doc carries the verified table; reports cite the qalc results. A claim without a qalc check marks the record incomplete.

## Precedence chain — obligatory

The dive's layers compose in a fixed order. Each layer precedes the next; a task advances through the chain.

`mcp/` → `invariant/` → `scripts/` → `_bitacora/` → `precept/` → `backup/` → `study/` → `concept/` → `fixture/` → `pattern/` → `procedure/`

Rings follow an ordinal order. Layers inside rings follow the chain order. Rings proceed in sequence: ring 0, ring 1, ring 2, ring 3. Each ring's layers run in chain order before the next ring starts. A task crosses a ring boundary after the ring's layers hold in order:

```text
ring 0  foundation             invariant/ → scripts/
ring 1  record + governance    _bitacora/ → precept/
ring 2  safety + understanding backup/ → study/ → concept/
ring 3  proof + structure + steps  fixture/ → pattern/ → procedure/
```

MCP precedes all — the connected servers (browser, acquire, patlib) form the tooling substrate that exists before any dive layer is used. Invariants follow — the state facts the dive must preserve exist before any work. Scripts then execute the work under those invariants. Bitacora then opens the record: the todo plans the work before it starts. Precepts then govern. Backup precedes study — restore points exist before any architecture work on the source. Study, concept, and fixture precede pattern: understand the architecture, distill the named ideas, prove the components, then derive the morphism. Pattern precedes procedure: the structure informs the steps.

### Layer roles

- `mcp/` — connected MCP servers (browser, acquire, patlib). Tooling substrate. Precedes all: servers connect before any dive layer is used.
- `invariant/` — always-true state predicates + violation signatures. Guideline: `guideline/invariant-layer.md`.
- `scripts/` — atomic tools + orchestrator. Execute the dive's tasks under the invariants.
- `_bitacora/` — the record. Todo first, report after.
- `precept/` — action-domain rule files. Declarative. Governs all work.
- `backup/` — restore points taken before any source study or edit.
- `study/` — architecture documents. Precedes the concept and the morphism.
- `concept/` — one-concept-per-file knowledge grounded in `study/`.
- `fixture/` — atomic regression harnesses. Precedes the morphism.
- `pattern/` — code morphisms. Derived from study + fixture proof.
- `procedure/` — numbered step chains. The morphism informs the steps.
- per-dive layers (`roms/`, etc.) — test assets and project-specific pickers.

Violating the order — starting work without the invariants, skipping the bitacora todo, editing code without consulting the precepts, studying source without a backup, deriving a pattern without study, writing a procedure without the morphism — marks the work incomplete.

## Change inventory

The authoritative list of every edited code line. Diff anchor: `backup/{repo}-src/`.

| File | Lines | Change |
|------|-------|--------|
| `{file}` | {lines} | {what changed and why} |

## Records

Every session writes timestamped files into `_codex/_bitacora/`. The todo precedes work; the report follows completion; every command output flows through `scripts/codex.sh run-bitacora {name} [--trace] -- {command}` into `_bitacora/task-stdout/`. Reports carry metrics — build, tests, acquisitions, fixtures. Knowledge gained lands in its layer: invariant (state fact) → precept (rule) → concept (knowledge) → procedure (steps) → pattern (morphism) → study (architecture) → fixture (proof). Templates for the dive layers live in `_codex/_templates/` and propagate via `script/copy-templates.sh`.

## Delegation

This project owns the {repo} dive: {build flags, acquisition, extension, verification}.
