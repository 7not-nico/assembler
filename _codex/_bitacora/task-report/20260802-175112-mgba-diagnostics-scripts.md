# Report — 20260802-175112 mgba-diagnostics-scripts

## Summary

Added four atomic bash diagnostic scripts to the mGBA dive (`scripts/`) that emit rich keyed debug data in stdout: header forensics, inventory sweep, live process sampling, save diagnostics. All verified against real dive data.

## What was done

1. Todo written (`task-todo/20260802-175112-mgba-diagnostics-scripts.md`) before work; stamp `20260802-175112`.
2. Read the atomic-script contract (`_templates/atomic-script-template.sh`), the existing `verify-rom.sh` pattern, and the `run-fixtures` precept.
3. Wrote four scripts per the contract (one task, args in, keyed `KEY=value` out, stderr diagnostics, non-zero on failure, `set -uo pipefail`):
   - `inspect-rom.sh {rom}` — header forensics: SHA256, SIZE, TYPE, TITLE (0xA0 GBA / 0x134 GB), CODE, MAKER, VERSION, MBC, ROMSZ, RAMSZ, DEST, HDRSUM, GLBSUM
   - `survey-roms.sh [gb|gbc|gba]` — inventory sweep: one keyed line per ROM (SHA, SIZE, TITLE, CODE, MBC) + COUNT
   - `probe-runtime.sh {pid}` — /proc sampling: PID, NAME, STATE, CPU% (1 s two-sample delta), RSS_KB, VSZ_KB, THREADS, ELAPSED_S, CMD
   - `check-save.sh {rom}` — SAV presence/size/mtime, SS_COUNT, SS_NEWEST
4. Fixed two defects found in testing: `0xn/a` prefix wart in `inspect-rom.sh` (prefix moved into assignments), exit-1-on-no-savestate in `check-save.sh` (explicit `exit 0`).
5. Updated the dive AGENTS.md scripts list (7 → 11).

## Test evidence

- `inspect-rom.sh` on `mario-golf-advance-tour-usa.gba` — SHA256 f58b827e…, SIZE 16777216, TITLE `MARIOGOLFGBA`, CODE `BMGE` (matches `file`'s BMGE01), MAKER 0x3031, HDRSUM 0x6b
- `inspect-rom.sh` on `tetris-japan-en.gb` — TITLE `TETRIS`, MBC 0x00, ROMSZ 0x00, RAMSZ 0x00, DEST 0x00, HDRSUM 0x0b, GLBSUM 0x89b5
- `survey-roms.sh gba` — 8 GBA ROMs; surfaced the duplicate `Crash Bandicoot - The Huge Adventure (USA).gba` (unslugged twin, same SHA 6be639d1db21) and the EUR-region metroid-re-fusion (CODE `AMTP`)
- `probe-runtime.sh 278058` — NAME=mgba, STATE=S, CPU=8.0, RSS_KB=141664, VSZ_KB=1056552, THREADS=15, ELAPSED_S=16.1, CMD shows the launched ROM
- `check-save.sh mario-golf…gba` — SAV 32768 B, mtime 15:05:37, SS_COUNT=0, exit 0

## Decisions

- **Four atomic scripts, not one mega-tool** — one responsibility each per `MAX.ATOMIC.CONCERN`; the survey composes the header read inline (kept independent of inspect to stay atomic).
- **Keyed lines throughout** — downstream orchestrators and humans parse the same contract.
- **`pgrep -x mgba` for runtime probing** — `pgrep -f "build/sdl/mgba"` self-matches the wrapper; exact-name match avoids it.

## Open edges

- The duplicate crash-bandicoot ROM (unslugged twin) surfaces in the survey — candidate for cleanup (slugify + remove the unslugged copy).
- `survey-roms.sh` counts by extension filter; a `--hash` full-SHA mode could follow if dedup checks need whole-file identity.
- The probe's CPU% samples 1 s apart; longer windows smooth idle spikes for frame-timing work.

## Logs

- `task-stdout/20260802-1752*-mgba-diag-*.log` — stamp, tests (inspect gba/gb, survey, probe ×3, check-save ×2), 10 logs
- `task-todo/20260802-175112-mgba-diagnostics-scripts.md` — all items checked

## Todo state summary

All 8 items complete; the AGENTS.md scripts list now carries 11 tools.
