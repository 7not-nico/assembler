# Report — 20260802-150805 mgba-sonic-acquire

## Summary

Acquired **Sonic Advance 3 (USA)** (Sonic Team, 2004, GBA, 128 Mbit retail cart) into the mGBA dive. Verified, launched healthy, swap cleanup complete. Final ROM: `roms/sonic-advance-3-usa-en-ja-fr-de-es-it.gba`.

## What was done

1. Todo written (`task-todo/20260802-150805-mgba-sonic-acquire.md`) before work; stamp `20260802-150805`; browser confirmed UP (Chrome/151, CDP 9222).
2. Conductor run (`acquire-rom.sh "Sonic Advance 3" game-boy-advance 90`): variant pick landed on **Sonic Advance 3 - Playable Shadow (Undub)** — a fan mod (Playable Shadow hack, Undub audio). Pipeline completed on first attempt: verified (`SONICADVANC3`, 16 MiB), prepared to `roms/sonic-advance-3-playable-shadow-undub.gba`, launched (pid 170394).
3. Variant question surfaced to the user: cascade picked the mod because `browse-romsfun.sh` opens the **first search hit** and the mod page ranked above the retail page. User chose **swap to retail USA**.
4. Retail variant discovery: exact-slug search misses (romsfun text search ignores dashes); direct navigation to `sonic-advance-3.html` listed 4 variants — Europe Beta, Europe, Japan, **USA**. Cascade pick: USA (variant 4) → `https://romsfun.com/download/sonic-advance-3-3797/4`.
5. USA fetch — first attempt failed: the download-link click timed out (sticky pink header intercepts pointer events; link instability across retries). Retry succeeded (transient per 2026-07-31 doctrine): token regenerated, zip saved, verify OK, prepared, launched `RUN pid=174865 cpu=alive`.
6. Swap cleanup: mod pid already exited; mod ROM, zip, and save removed. Retail .sav (65,536 B) kept.
7. Qalc verification: `16777216 bytes to MiB` = 16 MiB; `16 MiB to Mbit` = 134.217728 Mbit ≈ 128 Mbit class.
8. Precept Instance updated (`precept/acquire-gb-rom.md`); todo closed.

## Metrics

| Claim | Value | Qalc check |
|-------|-------|-----------|
| ROM size | 16,777,216 B = 16 MiB | verified |
| Cart class | 128 Mbit | 134.217728 Mbit |
| Header title (0xA0) | `SONICADVANC3` | `file` + probe agree |
| Product code | B3SE78 (USA, Rev.00) | `file` |
| Launch | pid 174865, cpu=alive, window=DISPLAY:0 | RUN line |

## Decisions

- **Retail over mod** — user decision; the Undub mod never matched intent. Mod artifacts fully removed.
- **Retry doctrine applied** — first USA fetch failed on the sticky-header click interception; plain retry succeeded, matching the Mario Golf and Blues Brothers transient pattern.
- **Cascade kept** — variant selection followed `precept/acquire-gb-rom.md` (USA over Japan/Europe); the mis-pick root cause is the browse tool, not the cascade.

## Open edges

- `browse-romsfun.sh` opens the first search hit with no URL-targeting mode — the mod page ranked above retail, causing the mis-pick. Candidate improvement (per `RUL.WORKFLOW.AUTOMATE.BEFORE.FIX`): optional `{game-url}` argument that lists a known page's variants directly (validated inline this session; the shared script lacks the mode).
- Sticky-header click interception on romsfun download pages recurs as a transient; a `force: true` / scroll-then-click fallback in `playwright-fetch-rom.sh` would harden the fetch (open for a tool task).
- GBA probe fallback (0x134 vs 0xA0 title read) remains open from the Mario Golf session — this acquisition probed `SONICADVANC3` correctly, so the quirk is ROM-dependent, not universal.

## Logs

- `task-stdout/20260802-1508*-mgba-sonic-*.log` — stamp, browser check, acquire, browse, retail variants, usa fetch + retry, swap cleanup, qalc (8 logs)
- `task-todo/20260802-150805-mgba-sonic-acquire.md` — all items checked

## Todo state summary

All 9 items complete; no pending follow-ups beyond the open edges above.
