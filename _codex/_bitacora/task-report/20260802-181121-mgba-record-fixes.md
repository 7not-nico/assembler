# Report — 20260802-181121 mgba-record-fixes

Timestamp: 2026-08-02 20260802-181121

## What was done

- **C — Mario Golf report written** — `task-report/20260802-145911-mgba-golf-acquire.md` fills the first-segment gap: acquisition facts (16 MiB / 128 Mbit, `MARIOGOLFGBA`, BMGE01, pid 166287, transient retry), qalc table, open edges (GBA probe fallback, browse first-hit).
- **D — change inventory reconciled** — AGENTS.md now lists five rows: CMakeLists TEST_FILES widened (banking/overrides/unlicensed), `test/overrides.c` (gb-overrides 3/3), `test/unlicensed.c` (gb-unlicensed 3/3), `src/script/engines/lua.c:1380` (`intKey = 0` init fix — uninitialized read in `_luaGetTable`).
- **E — gen-cart usage verified** — the script header already documents the signature on line 4: `bash gen-cart.sh {out.gb} {size} {type-byte} {title} [{cgb-flag}]`. The chain-run guess loop came from not reading the header; no edit needed.
- **F — run-fixtures count reconciled** — probe-headers 22/22 → 23/23 (15 synthetic + 8 real, dated).

## Decisions

- **Report retroactivity** — the golf report carries its original stamp `20260802-145911` and a note that the write closed the gap on 2026-08-02 18:11; the record's timeline stays honest.
- **Inventory from the live diff** — the lua.c row cites the actual one-line change (`intKey = 0`, line 1380) verified via `git diff`.

## Open edges

- None new. The change inventory now matches the `mgba/` tree state from the chain run.

## Logs

- `task-stdout/20260802-1811*-mgba-fixes-*.log` — stamp, lua diff (2 logs)
- `task-todo/20260802-181121-mgba-record-fixes.md` — all items checked

## Todo state summary

All 6 items complete; record-completeness (C) and accuracy (D, F) edges closed; E verified as already-documented.
