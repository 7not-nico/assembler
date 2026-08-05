# MCP issue — mGBA silent trace

**Date:** 2026-08-05
**Project:** `_codex/_templates/instantiator/trace-evidence.sh` + `mcp-instantiator`

## What happened

`inst_trace` on an mGBA launch log returns 0 lines — the default patterns (SNES boot markers: `Booted`, `Loading disc`, Alsa init) never match mGBA's output because **mGBA emits nothing on successful launch** (0-byte log).

## Evidence

```
mega-man-zero-2-usa.gba → LAUNCH → RUN pid=348776
inst_trace mmz2-launch.log → TRACE=... LINES=0 DONE 0 lines, 7 patterns
```
Process was alive (16s elapsed) — the game was running; the empty log is normal for mGBA, not a failure.

## Root cause

`trace-evidence.sh`'s default patterns are SNES/PSP-oriented. mGBA (and other silent emulators) produce no stdout on success, so the trace evidence is genuinely empty. The **process health** (RUN pid= + kill -0) is the real boot evidence for silent emulators.

## Fix path (candidate)

1. Add mGBA/GBA boot patterns to the defaults if mGBA ever emits (it doesn't currently)
2. Or: `inst_trace` on an empty-but-healthy launch should report `SILENT` + confirm process health instead of `LINES=0`
3. Or: document that silent-emulator boot evidence = process health, not log lines (morphism note)

## Todo state

- [ ] Decide: SILENT status vs. patterns vs. doc-only
- [ ] Apply the chosen fix to trace-evidence.sh
- [ ] Re-test mmz2 launch + trace

## UPDATE 2026-08-05 — mGBA HAS a log level; the fix is real

mGBA's `--help` exposes `-l, --log-level N` (a bitmask). `-l 127` (0x7F = ALL) emits rich boot evidence to stdout:

```
SDL Events: Joystick attached
GBA DMA: Starting DMA 3 0x03007D94 -> 0x03000000 (8500:1F80)
GBA BIOS: SWI: 0B r0: 080ECF10 r1: 03000000 ...
GBA Serial I/O: GPIO write: Unhandled SIOMULTI0
```

Level enum (mgba/include/mgba/core/log.h): FATAL 0x01, ERROR 0x02, WARN 0x04, INFO 0x08, DEBUG 0x10, STUB 0x20, GAME_ERROR 0x40, ALL 0x7F.

**The "SILENT status" option is superseded** — the fix is: enable the log, then mine it.
Fix path: (1) launch-emulator.sh gains `--emu-arg` passthrough; (2) trace-evidence.sh defaults gain GBA categories (GBA DMA, GBA BIOS, GBA Serial I/O, SDL Events); (3) mGBA launches pass `-l 127`.
