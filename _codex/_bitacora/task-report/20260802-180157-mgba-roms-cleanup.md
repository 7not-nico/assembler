# Report — 20260802-180157 mgba-roms-cleanup

## Summary

Removed the two unslugged duplicate ROMs surfaced by `survey-roms.sh` (open edge from 20260802-175112). roms/ now holds 16 slugged images with zero non-slug names.

## What was done

1. Todo written (`task-todo/20260802-180157-mgba-roms-cleanup.md`) before work; stamp `20260802-180157`.
2. Identity verification — full SHA256 confirmed byte-identical twins:
   - Crash: `6be639d1db21…` == `6be639d1db21…`
   - Prism: `dea0729edbc5…` == `dea0729edbc5…`
3. Per `RUL.WORKFLOW.AUTOMATE.BEFORE.FIX`, `survey-roms.sh` gained a NONSLUG marker (basename with uppercase/space/paren/bracket appends `NONSLUG=1`).
4. Removed the unslugged twins: crash `.gba` + `.sav`, prism `.gbc` (+ `.sav` already absent — `rm -f` silently skipped).
5. Re-ran the survey — 16 ROMs, no NONSLUG flags; crash and prism each appear once.
6. Re-ran `probe-headers-test.sh` — 8 real ROMs pass (down from 9 with the twin).
7. Updated AGENTS.md fixture line — stale "7/7 real-ROM" → "8 real as of 2026-08-02".

## Metrics

- roms/ inventory: 16 images (7 GBA retail/hacks, 3 GB, 5 GBC + test-cart.gb), all lowercase dash-slugs
- Real-ROM probe pass count: 8 (kirby, mega-man, tetris, crystal, peridot, prism, orange, wario)

## Decisions

- **Detection before removal** — the survey now flags non-slug names, so future unslugged files surface in the sweep instead of hiding.
- **Kept the slugged copies** — both slugged twins (older mtime) are the convention-compliant canonical files; the unslugged copies were redundant.
- **AGENTS.md count as a snapshot** — the real-ROM probe count tracks roms/ contents and drifts with acquisitions; the line states the date.

## Open edges

- `probe-headers-test.sh` writes its own `test-cart.gb` (title "TEST CART 01", MBC 0x01) into `fixture/`; the `roms/test-cart.gb` copy is the dive's original test cart — two test carts coexist by design, but a note in the fixture docs would clarify.
- `run-fixtures.md` says probe-headers 22/22 (15 synthetic + 7 real) — the real half is now 8; the precept's count lags the fixture.

## Logs

- `task-stdout/20260802-1802*-mgba-cleanup-*.log` — stamp, identity, remove, survey, probe (5 logs)
- `task-todo/20260802-180157-mgba-roms-cleanup.md` — all items checked

## Todo state summary

All 7 items complete; the duplicate-ROM open edge is closed.
