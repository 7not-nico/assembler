# mgba-repo GBA acquisition — Mario Golf: Advance Tour (Camelot)

## Plan (this session)

- [x] Read acquisition doctrine — `precept/acquire-gb-rom.md` + `use-shared-browser.md` (GBA section, CDP 9222)
- [x] Verify shared browser state — CDP 9222 down, start via `start-browser.sh`
- [x] Inventory `roms/` — GBA: crash-bandicoot, fire-emblem, metroid-re-fusion present; retail cart absent
- [x] Write this todo — timestamped bitacora record (precedes work)
- [x] Acquire via `acquire-rom.sh "Mario Golf Advance Tour" game-boy-advance` — browse → variant pick → fetch (logged)
- [x] Verify — header probe `0xA0` title, size class (GBA ≥4 MiB), mbc byte (16 MiB retail cart)
- [x] Prepare — slugify into `roms/` as `.gba`
- [x] Launch — `launch-rom.sh` → healthy `RUN pid=...` after 2 s (pid 166287, cpu=alive)
- [x] Update `precept/acquire-gb-rom.md` Instance section — record the acquisition
- [x] Write the session report `_codex/_bitacora/task-report/20260802-145911-mgba-golf-acquire.md`

## Target

- **Game:** Mario Golf: Advance Tour — Camelot Software Planning, GBA (2004), 128 Mbit retail cart
- **Section:** `game-boy-advance`
- **Variant preference:** USA No-Intro → (USA) → first listed (conductor cascade)

## Open edges (future todos)

- None expected
