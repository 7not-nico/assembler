---
id: PATTERN.BITACORA.LOG.FRAMING
title: Bitacora Log Framing — Header, Live Stream, Exit Tail
layer: morphism/
purpose: "A command runs through a log frame that writes a provenance header, streams output live, and appends duration + exit tail."
naming: bitacora-log-framing.md
tags: [pattern, morphism, bitacora, logging]
status: active
---
# BITACORA-LOG-FRAMING.md

**Layer:** morphism/
**Naming:** `bitacora-log-framing.md` — code morphism, reusable structure.
**Composes with:** `morphism/atomic-tool-contract.md`; derived from `study/` + `fixture/` proof.

## Morphism

A command runs through a log frame that writes a provenance header, streams output live, and appends a duration + exit tail, so every recorded command yields a self-describing log.

## Structure

```text
bitacora-run.sh {name} [--trace] -- {cmd}
    log_open:  header — # CMD: / # DATE: / # CWD: / ---
    live:      {cmd} | tee -a "$log"
    --trace:   stream enriched through tracexec (exec-tree lines)
    log_close: tail — # DUR: / # DATE: / # exit: {code}
    target:    _codex/_bitacora/task-stdout/{YYYYMMDD}-{HHMMSS}-{name}.log
```

Invariant: the wrapper writes provenance headers only; the log names with the timestamp prefix; the exit status always lands in the tail; the caller sees the live stream.

## Verification

Run a passing command and a failing one; assert the header fields, the live stream in the log, and the `# exit:` tail matching the real status; `--trace` adds exec lines without breaking the tail.

## Instance

`shell/deps/logger.sh` `log_open`/`log_close` behind `shell/bitacora-run.sh` + `shell/run-logged.sh` + root `bitacora-log.sh` (2026-08-05); the dive-copy `run-logged.sh` case logs under `_codex/` via the walk-up resolution.
