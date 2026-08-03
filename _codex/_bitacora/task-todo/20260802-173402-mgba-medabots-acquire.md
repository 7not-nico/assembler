# Todo — 20260802-173402 mgba-medabots-acquire

Medabots acquisition for the mGBA dive (Natsume, 2002, GBA). Follows the established pattern (stamps 20260802-145911, 150805, 151814) and `precept/acquire-gb-rom.md` — including the variant-ranking lesson: verify the search-first game page is retail, not a hack/mod; use the direct-navigation variant-lister for a known retail page.

- [x] Write this todo — timestamped bitacora record (precedes work)
- [x] Browse — search ranking check; confirm retail page (not a mod/hack first hit)
- [x] Acquire — variant pick (USA per cascade) → fetch via `playwright-fetch-rom.sh` (logged; retry on transient)
- [x] Verify — header probe title, size class — actual: **8 MiB (64 Mbit) cart**, title `MEDABOTS MTB`, AK8EE9
- [x] Prepare — slugify into `roms/` as `.gba`
- [x] Launch — healthy `RUN pid=...` after 2 s (pid 259396, cpu=alive)
- [x] Qalc quantitative claims (size ↔ MiB ↔ Mbit)
- [x] Update `precept/acquire-gb-rom.md` Instance section — record the acquisition
- [x] Write the session report `_codex/_bitacora/task-report/20260802-173402-mgba-medabots-acquire.md`
