---
id: MORPHISM.BOOT.EVIDENCE.ENABLEMENT
title: Boot Evidence Enablement — Enable the Log, Then Mine It
layer: morphism/
purpose: "A silent-on-success emulator hides its boot trace; enable the log-level flag first, then mine the evidence — process health is the fallback proof."
naming: boot-evidence-enablement.md
tags: [morphism, boot, evidence, log-level, emulator, trace]
status: active
---
# BOOT-EVIDENCE-ENABLEMENT.md

**Layer:** morphism/
**Naming:** `boot-evidence-enablement.md` — code morphism, reusable structure.
**Composes with:** `morphism/process-launch-health.md` + `morphism/keyed-line-handoff.md`; derived from `study/` + `fixture/` proof.

## Morphism

A silent-on-success emulator hides its boot trace; enabling its log-level flag turns the empty log into rich evidence, and process health remains the fallback proof when the emulator emits nothing at all.

## Structure

```text
launch  → emulator + ROM + --emu-arg -l {level}   (enable the log)
mine    → trace-evidence.sh with per-console patterns
proof   → RUN pid= + kill -0  (process health — always valid)
```

Emulator profiles: snes9x prints init lines by default (no flag needed); mGBA emits nothing unless `-l 127` (0x7F = ALL); a level enum exists per emulator (`FATAL 0x01 ... ALL 0x7F`).

Invariant: the log-level flag is passed through `--emu-arg` (before the ROM); trace patterns match the enabled categories; a healthy process is boot evidence even with zero log lines.

## Verification

Launch a silent emulator without the flag — 0 trace lines despite a running process; launch with `-l 127` — the log fills (GBA DMA, BIOS, Serial I/O); the trace tool extracts the evidence; process health confirms boot either way.

## Instance

mGBA + Mega Man Zero 2 (2026-08-05) — `--emu-arg -l --emu-arg 127` turned the launch log from 0 to 6180 trace lines; GBA patterns added to `trace-evidence.sh` defaults. Commit `91a31ee`.
