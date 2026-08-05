---
id: MORPHISM.BUILD.METRICS.RECORD
title: Build Metrics Record — Toolchain, Flags, Duration, Binary
layer: morphism/
purpose: "A build record captures its metrics — toolchain, configure flags, duration, binary location — so a compile's cost and provenance are reproducible facts, not memory."
naming: build-metrics-record.md
tags: [morphism, build, metrics, record, compile, duration]
status: active
---
# BUILD-METRICS-RECORD.md

**Layer:** morphism/
**Naming:** `build-metrics-record.md` — code morphism, reusable structure.
**Composes with:** `morphism/record-lifecycle.md`; derived from `study/` + `fixture/` proof.

## Morphism

A build record captures its metrics — toolchain version, configure flags, duration, binary location — as reproducible facts: the compile's cost and provenance live in the record, cited by the report.

## Structure

```text
build → bitacora-run {name}-build -- cmake --build build -j$(nproc)
  → log: # CMD: / # DATE: / # CWD:
         [compile output]
         # DUR: {ms} / # exit: {code}
record → toolchain (cmake/gcc version), flags (-march=native, -DBUILD_QT_SDL=OFF),
         duration, binary path (build/src/libcore.a), exit status
```

Invariant: the build logs through the bitacora chain (DUR + exit in the tail); the report cites the toolchain and flags; the binary location names the artifact; a rerun produces comparable metrics.

## Verification

Build through the bitacora chain — the log's `# DUR:` + `# exit:` capture the metrics; the report records toolchain/flags/binary; two builds of the same tree show comparable durations.

## Instance

The melonDS core build (2026-08-05) — `# DUR: 48423ms`, `# exit: 0`, `build/src/libcore.a` (3.1M) with `-march=native`; the snes9x-compile-metrics and quiet-build reports follow the same shape.
