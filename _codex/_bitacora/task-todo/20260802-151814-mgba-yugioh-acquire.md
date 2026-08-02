# Todo — 20260802-151814 mgba-yugioh-acquire

Yu-Gi-Oh! Ultimate Masters: World Championship Tournament 2006 acquisition for the mGBA dive (Konami, 2006, GBA, 128 Mbit retail cart). Follows the Sonic Advance 3 pattern (stamp 20260802-150805) — including the variant-ranking lesson: `browse-romsfun.sh` opens the first search hit, so verify the picked game page is the retail cart, not a hack/mod; use the validated direct-navigation variant-lister for a known retail page.

- [x] Write this todo — timestamped bitacora record (precedes work)
- [x] Browse — search ranking check; confirm retail page (not a mod/hack first hit)
- [x] Acquire — variant pick (USA per cascade) → fetch via `playwright-fetch-rom.sh` (logged; retry on transient)
- [x] Verify — header probe title, size class (GBA ≥4 MiB) — actual: **32 MiB (256 Mbit) cart**, title `YUGIOHWCT06`, BY6EA4
- [x] Prepare — slugify into `roms/` as `.gba`
- [x] Launch — healthy `RUN pid=...` after 2 s (pid 178221, cpu=alive)
- [x] Qalc quantitative claims (size ↔ MiB ↔ Mbit)
- [x] Update `precept/acquire-gb-rom.md` Instance section — record the acquisition
- [x] Write the session report `_codex/_bitacora/task-report/20260802-151814-mgba-yugioh-acquire.md`
