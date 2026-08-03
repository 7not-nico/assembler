# Report — 20260802-173402 mgba-medabots-acquire

## Summary

Acquired **Medabots AX: Metabee Ver. (USA)** (Natsume, 2002, GBA arena fighter) into the mGBA dive. Verified, launched healthy, no cleanup needed. Final ROM: `roms/medabots-ax-metabee-ver-usa.gba`.

## What was done

1. Todo written (`task-todo/20260802-173402-mgba-medabots-acquire.md`) before work; stamp `20260802-173402`; browser confirmed UP (CDP 9222).
2. Browse (`browse-romsfun.sh "Medabots" game-boy-advance 60`): retail pages ranked first — `medabots-ax-metabee-ver.html` first hit; no mod trap. Six retail matches: AX Metabee, Rokusho, AX Rokusho, Metabee, Medarot G Kabuto, Medarot G Kuwagata.
3. Variant table: Metabee Ver. Europe (En,Fr,De,Es,It) / **USA**. Cascade pick: USA, variant 2.
4. Fetch (`playwright-fetch-rom.sh`, variant 2): **succeeded on the first attempt** — token resolved, zip saved, verify OK, prepared, launched `RUN pid=259396 cpu=alive`.
5. Qalc verification: `8388608 bytes to MiB` = 8 MiB; `8 MiB to Mbit` = 67.108864 Mbit ≈ **64 Mbit class**.
6. Precept Instance updated (`precept/acquire-gb-rom.md`); todo closed.

## Metrics

| Claim | Value | Qalc check |
|-------|-------|-----------|
| ROM size | 8,388,608 B = 8 MiB | verified |
| Cart class | 64 Mbit | 67.108864 Mbit |
| Header title (0xA0) | `MEDABOTS MTB` | `file` + probe agree |
| Product code | AK8EE9 (USA, Rev.00) | `file` |
| Launch | pid 259396, cpu=alive, window=DISPLAY:0 | RUN line |

## Decisions

- **USA variant 2** — standard cascade; the Europe variant carries language tags, the USA carries none — USA wins per the cascade order.
- **Size class corrected** — the todo anticipated 128 Mbit; the AX arena games ship at **64 Mbit (8 MiB)**. The record notes the 64 Mbit class for early Natsume GBA titles.

## Open edges

- None new. The `browse-romsfun.sh` URL-targeting mode and the sticky-header click fallback remain open (Sonic session).
- The user's title "Medabot Battle Arena" maps to Medabots AX (the GBA arena fighter); if the intended cart was a different Medabots title (Rokusho Ver., Medarot G), the sibling pages exist in the search listing.

## Logs

- `task-stdout/20260802-1734*-mgba-medabots-*.log` — stamp, browser check, browse, fetch, qalc (5 logs)
- `task-todo/20260802-173402-mgba-medabots-acquire.md` — all items checked

## Todo state summary

All 9 items complete; no pending follow-ups beyond the pre-existing open edges.
