---
id: MORPHISM.COMPOSITION.DIVE.LIFECYCLE
title: Dive Lifecycle Composition — Todo to Report
layer: morphism/composition/
purpose: "A code dive composes through its chain: todo opens, source fetches, architecture surveys, build verifies, ROM runs, study documents, morphism derives, report closes."
naming: dive-lifecycle-composition.md
tags: [morphism, composition, dive, lifecycle, codex, chain]
status: active
---
# DIVE-LIFECYCLE-COMPOSITION.md

**Layer:** morphism/composition/
**Naming:** `dive-lifecycle-composition.md` — code morphism, reusable structure.
**Composes with:** `morphism/record-lifecycle.md` (base form); derived from `study/` + `fixture/` proof.

## Morphism

A code dive composes through its chain: the todo opens the record, the source fetches, the architecture surveys, the build verifies, the ROM runs with trace evidence, the study documents, the morphism derives, and the report closes — one lifecycle from todo to report.

## Composition

```text
step 1  open      bitacora-todo {dive}          — the record opens first
step 2  fetch     fetch-repo.sh {url} .         — source into {repo}-repo/
step 3  survey    study the topology, core modules, build path
step 4  build     cmake configure + build, logged through bitacora
step 5  run       acquire a ROM, launch + trace boot evidence
step 6  study     write study/ documents (architecture, memory map)
step 7  derive    morphism/ docs from proven structures
step 8  close     bitacora-report {dive}        — metrics, decisions, edges
```

Invariant: the todo precedes the work; every command logs to task-stdout; the build produces the binary the run consumes; the morphism derives from study + fixture proof; the report closes the record.

## Verification

The dive's todo items check off in order; each build/run command has a task-stdout log; the report cites those logs; the morphisms reference the dive's instances.

## Instance

The melonDS dive (2026-08-05) — `task-todo/20260805-melonds-dive.md`: fetched, surveyed (ARM9/ARM7, DSi), core compiled (`libcore.a`, exit 0), Tetris DS acquired, frontend build pending; the dive lifecycle exercises the chain end-to-end.
