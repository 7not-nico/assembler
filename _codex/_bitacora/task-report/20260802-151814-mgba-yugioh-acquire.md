# Report — 20260802-151814 mgba-yugioh-acquire

## Summary

Acquired **Yu-Gi-Oh! - Ultimate Masters - World Championship Tournament 2006 (USA)** (Konami, 2006, GBA) into the mGBA dive. Verified, launched healthy, no cleanup needed. Final ROM: `roms/yu-gi-oh-ultimate-masters-world-championship-tournament-2006-usa-en-ja-fr-de-es-it.gba`.

## What was done

1. Todo written (`task-todo/20260802-151814-mgba-yugioh-acquire.md`) before work; stamp `20260802-151814`; browser confirmed UP (CDP 9222).
2. Browse (`browse-romsfun.sh "Yu-Gi-Oh 2006" game-boy-advance 60`): retail page ranked **first** — `yu-gi-oh-ultimate-masters-world-championship-tournament-2006.html`. No mod trap this time (the Sonic lesson held: search ranking checked before fetch).
3. Variant table: USA (En,Ja,Fr,De,Es,It) / Europe Edition / Japan Duel Monsters Expert. Cascade pick: **USA, variant 1**.
4. Fetch (`playwright-fetch-rom.sh`, variant 1): **succeeded on the first attempt** — no transient. Token link resolved, zip saved, verify OK, prepared, launched `RUN pid=178221 cpu=alive`.
5. Qalc verification: `33554432 bytes to MiB` = 32 MiB; `32 MiB to Mbit` = 268.435456 Mbit ≈ **256 Mbit class**; `33554432 bytes to MB` = 33.554432 MB.
6. Precept Instance updated (`precept/acquire-gb-rom.md`); todo closed.

## Metrics

| Claim | Value | Qalc check |
|-------|-------|-----------|
| ROM size | 33,554,432 B = 32 MiB | verified |
| Cart class | 256 Mbit | 268.435456 Mbit |
| Header title (0xA0) | `YUGIOHWCT06` | `file` + probe agree |
| Product code | BY6EA4 (Rev.00) | `file` |
| Launch | pid 178221, cpu=alive, window=DISPLAY:0 | RUN line |

## Decisions

- **Cascade pick USA variant 1** — standard doctrine; no user override needed (retail page ranked first, variant table clean).
- **Size class expectation corrected** — the todo anticipated 128 Mbit; the 2006 Konami cart ships at **256 Mbit (32 MiB)**. The verify step accepts any GBA ≥4 MiB, so no rule tension; the record now notes the 256 Mbit class for late Konami titles.

## Open edges

- None new. The `browse-romsfun.sh` URL-targeting mode and the sticky-header click fallback remain open from the Sonic session (unchanged).
- Size-class default: acquisition precepts may note that 2006-era Konami GBA carts (Ultimate Masters) run 256 Mbit — informational, no action required.

## Logs

- `task-stdout/20260802-1518*-mgba-yugioh-*.log` — stamp, browser check, browse, fetch, qalc (5 logs)
- `task-todo/20260802-151814-mgba-yugioh-acquire.md` — all items checked

## Todo state summary

All 9 items complete; no pending follow-ups beyond the pre-existing open edges.
