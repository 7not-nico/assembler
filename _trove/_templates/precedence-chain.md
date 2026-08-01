# Precedence chain — codex (general)

**Layer:** convention
**Naming:** `precedence-chain.md` — the general codex chain, inherited by every dive.
**Composes with:** per-dive AGENTS.md chains (dives may extend with dive-specific layers).

## Chain — obligatory

```text
invariant/ → scripts/ → _bitacora/ → precept/ → backup/ → study/ → fixture/ → pattern/ → procedure/
```

Each layer precedes the next; a task advances through the chain in order. The chain is the same for every code-dive project in `_codex/`.

## Layer roles

- `invariant/` — always-true state predicates + violation signatures. Outermost: the facts the dive must preserve exist before any work. (Guideline: `guideline/invariant-layer.md`.)
- `scripts/` — atomic tools + orchestrator. Execute the work under the invariants.
- `_bitacora/` — the record. Todo first, report after.
- `precept/` — action-domain rule files. Declarative. Governs all work.
- `backup/` — restore points taken before any source study or edit.
- `study/` — architecture documents. How the codebase and its extensions work. Precedes the morphism.
- `fixture/` — atomic regression harnesses. Prove components before integration; rerun after changes. Precedes the morphism.
- `pattern/` — code morphisms. Reusable structures derived from study + fixture proof.
- `procedure/` — numbered step chains. Atomic per workflow. The morphism informs the steps.

## Rationale

Invariants declare the state facts — what must always hold — so they stand outermost: the tooling is built to preserve them, the record documents work governed by them. Scripts execute the work next, under those invariants. The bitacora then opens the record — a todo plans work before it starts. Precepts govern the how. Backup protects the source before any study. Study and fixture ground the pattern — understand the architecture, prove the components, then derive the morphism. The pattern informs the procedure's steps.

## Violation

Starting work without the tooling, skipping the bitacora todo, editing code without consulting the precepts, studying source without a backup, deriving a pattern without study, writing a procedure without the morphism — each marks the work incomplete.

## Instance

snes9x dive (2026-07-31) — first dive to run the general chain; the dive's AGENTS.md carries it verbatim.
