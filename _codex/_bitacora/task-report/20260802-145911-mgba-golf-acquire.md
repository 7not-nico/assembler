# Report — 20260802-145911 mgba-golf-acquire

Timestamp: 2026-08-02 20260802-145911

## Summary

Acquired **Mario Golf: Advance Tour (USA)** (Camelot, 2004, GBA, 128 Mbit retail cart) into the mGBA dive. Verified, launched healthy. Final ROM: `roms/mario-golf-advance-tour-usa.gba`.

## What was done

1. Todo written (`task-todo/20260802-145911-mgba-golf-acquire.md`) before work; stamp `20260802-145911`; browser checked and started (was down, `start-browser.sh` → UP on CDP 9222).
2. Conductor run (`acquire-rom.sh "Mario Golf Advance Tour" game-boy-advance 90`): browse surfaced the retail page first; variant picked; token link resolved.
3. First fetch failed — the download-navigation click timed out (transient, per the 2026-07-31 doctrine); zip zone check confirmed no partial file.
4. Retry (`playwright-fetch-rom.sh`, download-page URL): **succeeded** — token regenerated, zip saved, verify OK, prepared, launched `RUN pid=166287 cpu=alive`.
5. Qalc verification: `16777216 bytes to MiB` = 16 MiB; `16 MiB to Mbit` = 134.217728 Mbit ≈ 128 Mbit class.
6. Precept Instance updated (`precept/acquire-gb-rom.md`).

## Metrics

| Claim | Value | Qalc check |
|-------|-------|-----------|
| ROM size | 16,777,216 B = 16 MiB | verified |
| Cart class | 128 Mbit | 134.217728 Mbit |
| Header title (0xA0) | `MARIOGOLFGBA` | `file` (BMGE01, Rev.00) |
| Product code | BMGE01 | `file` |
| Launch | pid 166287, cpu=alive, window=DISPLAY:0 | RUN line |

## Decisions

- **Retry doctrine applied** — the first fetch failed on the download-navigation wait; the plain retry succeeded, matching the Blues Brothers transient pattern.
- **Provenance-sourced URL** — the retry used the download-page URL from the browse output, not memory.

## Open edges

- **GBA probe fallback** — the verify probe printed `!ML GhL G` (GB-offset read at 0x134) while `file` confirms the true 0xA0 title `MARIOGOLFGBA`; the probe's GBA fallback logic is a fixture-study candidate. (Later sessions: Sonic/Yu-Gi-Oh/Medabots probed correctly — the quirk is ROM-dependent.)
- `browse-romsfun.sh` first-hit bias (resolved for later acquisitions by direct navigation; the URL-targeting mode landed 2026-08-02 18:16 in the tool-hardening pass).

## Logs

- `task-stdout/20260802-1459*-mgba-golf-*.log` — stamp, browser check, roms listing, browser start, acquire run, zip-zone check, fetch retry, qalc (9 logs)

## Todo state summary

All todo items complete; this report (written 2026-08-02 18:16, closing the first-segment gap) completes the record.
