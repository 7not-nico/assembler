---
id: MORPHISM.COMPOSITION.ACQUISITION.SESSION
title: Acquisition Session Composition — Per-Game Loop, One Report
layer: morphism/composition/
purpose: "An acquisition session composes: per-game acquire cycles (browse → fetch → verify → stage), each with its own record, closed by one session report."
naming: acquisition-session-composition.md
tags: [morphism, composition, acquisition, session, loop, report]
status: active
---
# ACQUISITION-SESSION-COMPOSITION.md

**Layer:** morphism/composition/
**Naming:** `acquisition-session-composition.md` — code morphism, reusable structure.
**Composes with:** `morphism/romsfun-toolchain-composition.md` (base form); derived from `study/` + `fixture/` proof.

## Morphism

An acquisition session composes as a loop: each game cycles browse → fetch → verify → stage with its own record, and one session report closes the batch — many games, per-game records, one summary.

## Composition

```text
step 1  open      session todo — the batch plan
step 2  loop      for each game:
    browse   → fetch → verify → stage (one acquire record per game)
step 3  close     session report — games acquired, variants chosen, totals
```

Invariant: each game gets its own acquire record (no-clobber per game); the loop reuses one toolchain; the session report summarizes the batch; a transient failure is recorded per-game and retried, not lost.

## Verification

Acquire N games — N per-game records exist (`{ts}-{game}-acquire.md`); the session report lists each with its variant and size; a failed fetch leaves a per-game record with the error.

## Instance

The rom-acquisition sessions (2026-07-31 through 2026-08-02) — twinbee-2, ninja-warrior, un-squadron, chrono-trigger, golf, sonic, yugioh, medabots acquire records + the rom-acquisition-session and acquisitions-tooling reports.
