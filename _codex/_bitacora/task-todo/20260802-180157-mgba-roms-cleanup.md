# Todo — 20260802-180157 mgba-roms-cleanup

Remove the unslugged duplicate ROMs surfaced by `survey-roms.sh` (open edge from 20260802-175112). Per dive convention every roms/ file uses a lowercase dash-slug. Per `RUL.WORKFLOW.AUTOMATE.BEFORE.FIX`: the survey gains a NONSLUG detection marker before the manual removal.

- [x] Write this todo — timestamped bitacora record (precedes work)
- [x] Verify twin identity — full SHA256 of crash + prism unslugged vs slugged copies
- [x] Add NONSLUG detection to `survey-roms.sh` (basename with uppercase/space/paren marks the line)
- [x] Remove unslugged twins: `Crash Bandicoot - The Huge Adventure (USA).gba` + `.sav`, `Pokemon Prism v0.95 build 254 (Hotfix 5).gbc` + `.sav`
- [x] Re-run `survey-roms.sh` — duplicates gone, NONSLUG clean (logged)
- [x] Re-run `probe-headers-test.sh` — real-ROM pass count after the prism twin removal (logged)
- [x] Write the session report `_codex/_bitacora/task-report/20260802-180157-mgba-roms-cleanup.md`
