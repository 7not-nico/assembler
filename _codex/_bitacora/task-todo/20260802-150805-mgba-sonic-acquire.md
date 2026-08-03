# Todo — 20260802-150805 mgba-sonic-acquire

Sonic Advance 3 acquisition for the mGBA dive (Sonic Team, 2004, GBA, 128 Mbit retail cart). Follows the Mario Golf session pattern (stamp 20260802-145911) and `precept/acquire-gb-rom.md`.

- [x] Write this todo — timestamped bitacora record (precedes work)
- [x] Acquire via `acquire-rom.sh "Sonic Advance 3" game-boy-advance` — browse → variant pick → fetch (logged)
- [x] Verify — header probe `0xA0` title, size class (GBA ≥4 MiB), mbc byte (16 MiB retail cart expected)
- [x] Prepare — slugify into `roms/` as `.gba`
- [x] Launch — `launch-rom.sh` → healthy `RUN pid=...` after 2 s
- [x] Qalc quantitative claims (size ↔ MiB ↔ Mbit)
- [x] Update `precept/acquire-gb-rom.md` Instance section — record the acquisition
- [x] Write the session report `_codex/_bitacora/task-report/20260802-150805-mgba-sonic-acquire.md`
- [x] Swap cleanup — kill mod instance, remove mod ROM/zip/sav (user chose retail USA)

Status: completed (2026-08-02)
