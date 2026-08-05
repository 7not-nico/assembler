---
id: PATTERN.PROCESS.LAUNCH.HEALTH
title: Process Launch Health — Detach, Grace, Verify
layer: pattern/
purpose: "A long-running process detaches via setsid + nohup, then a grace period and kill -0 verify it lives; the result reports RUN=pid or FAIL."
naming: process-launch-health.md
tags: [pattern, morphism, launch, process, health]
status: active
---
# PROCESS-LAUNCH-HEALTH.md

**Layer:** pattern/
**Naming:** `process-launch-health.md` — code morphism, reusable structure.
**Composes with:** `pattern/atomic-tool-contract.md`; derived from `study/` + `fixture/` proof.

## Morphism

A long-running process detaches through `setsid nohup` (new session, survives script exit), rests a grace period, then `kill -0` verifies the process lives; the result line reports `RUN=pid=` or `FAIL` with the log.

## Structure

```text
preflight: [ -f "$ROM" ] && [ -x "$BIN" ]       — fail with stderr hint, exit 1
launch:    setsid nohup env "${ENVS[@]}" "$BIN" "$ROM" >"$LOG" 2>&1 </dev/null &
           disown "$PID"                        — survive script exit
grace:     sleep 2
verify:    kill -0 "$PID"  → RUN  pid=$PID log=$LOG
           else FAIL + cat "$LOG" + exit 1
```

Invariant: the process outlives the launching script; verification happens only after the grace period; failure carries the log, never silence.

## Verification

Launch a real binary and assert `RUN pid=` plus `kill -0` true after script exit; launch a crashing binary and assert `FAIL` + non-zero exit + log tail; the MCP layer re-probes the same lines.

## Instance

`instantiator/launch-emulator.sh` + `inst_launch` (2026-08-04/05) — snes9x boot path; `--env` carries `SDL_VIDEODRIVER=x11` style overrides before the binary.
