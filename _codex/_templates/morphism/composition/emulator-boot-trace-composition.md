---
id: MORPHISM.COMPOSITION.EMULATOR.BOOT.TRACE
title: Emulator Boot-Trace Composition — Launch to Evidence
layer: morphism/composition/
purpose: "How an emulator boot becomes trace evidence: launch (health), enable the log, mine the patterns, stop — composing process-launch-health, boot-evidence-enablement, and keyed-line-handoff."
naming: emulator-boot-trace-composition.md
tags: [morphism, composition, emulator, boot, trace, evidence]
status: active
---
# EMULATOR-BOOT-TRACE-COMPOSITION.md

**Layer:** morphism/composition/
**Naming:** `emulator-boot-trace-composition.md` — code morphism, reusable structure.
**Composes with:** `morphism/boot-evidence-enablement.md` (base form); derived from `study/` + `fixture/` proof.

## Morphism

An emulator boot composes into trace evidence across four steps: launch with health-check, enable the log-level when the emulator is silent, mine the enabled patterns, stop the process — one composition from boot to evidence.

## Composition

```text
step 1  launch   process-launch-health     setsid nohup + grace + kill -0 → RUN pid=
step 2  enable   boot-evidence-enablement  --emu-arg -l {level} when silent
step 3  mine     keyed-line-handoff        trace-evidence.sh → LINES=/EVIDENCE=
step 4  stop     process-launch-health     stop-process.sh → STOPPED=
```

Invariant: the launch's process health is always the base proof; the log-level flag applies only when the emulator is silent; the mined evidence cites the enabled categories; the stop closes the cycle.

## Verification

Boot snes9x (default-trace) — 4 evidence lines without a flag; boot mGBA (silent) — 0 lines until `-l 127`, then 6180; both processes health-confirmed; stop returns `STOPPED=1`.

## Instance

The 3-console acquisitions (2026-08-05) — snes9x (yoshi, looney), mGBA (MMZ2 with `-l 127`), melonDS ROM staged; commits `91a31ee` + the acquisition flow.
