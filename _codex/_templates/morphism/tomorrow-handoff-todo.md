---
id: MORPHISM.TOMORROW.HANDOFF.TODO
title: Tomorrow Handoff Todo — Deferred Work Carries Over
layer: morphism/
purpose: "A session's unfinished work carries into a named tomorrow todo — planned work, context, and open edges survive the session boundary."
naming: tomorrow-handoff-todo.md
tags: [morphism, tomorrow, handoff, todo, deferral]
status: active
---
# TOMORROW-HANDOFF-TODO.md

**Layer:** morphism/
**Naming:** `tomorrow-handoff-todo.md` — code morphism, reusable structure.
**Composes with:** `morphism/record-lifecycle.md`; derived from `study/` + `fixture/` proof.

## Morphism

A session's unfinished work carries into a named tomorrow todo — context, planned work, and open edges — so the next session resumes exactly where the previous one stopped.

## Structure

```text
task-todo/{YYYYMMDD}-{HHMMSS}-tomorrow.md
  # Todo — {ts} tomorrow
  ## Context        — what the session was doing (dive, project, state)
  ## Planned work   — the deferred tasks, with file targets
  ## Open edges     — blockers and known gaps
```

Invariant: the tomorrow todo names the day it carries to; Context records the exact state; Planned work lists concrete targets; a session resumes from the todo, not from memory.

## Verification

End a session with unfinished work — a tomorrow todo exists with context and planned items; the next session opens it first and the work continues from the listed state.

## Instance

`20260805-180000-tomorrow.md` + `20260805-185000-tomorrow.md` (2026-08-05) — ppsspp dive continuation: invariant files, planned targets, open edges.
