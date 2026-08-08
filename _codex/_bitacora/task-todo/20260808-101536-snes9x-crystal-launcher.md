# snes9x-crystal-launcher — todo

**Date:** 2026-08-08
**Project:** Port snes9x_launcher.rb (Ruby) to Crystal — read roms/, detach-launch via setsid, same usage contract

## Tasks

- [x] Read Ruby launcher contract (roms/snes9x_launcher.rb — menu/index/fragment, -v0 default, pgroup detach)
- [x] Probe Crystal API surface: Process.new lacks process_group → setsid wrapper (PGID==PID verified); Process.exists? stdlib; File-open redirect; Dir.glob braces (48 ROMs)
- [x] Plan methods (10-function port table) + placement decision: launcher in snes9x project root per user
- [x] Write snes9x-launcher.cr (project root) — 10 functions + main dispatch
- [x] Compile via bitacora chain --release --mcpu native; fixed Hash#sort, gets?, quit-exit parity
- [x] Context7 verification: Process.new(command, args, output: IO) documented form matches
- [x] Smoke-test: no-arg menu, -l letter flow, miss path, quit path (exit 0 parity), slug fragment, real launch (RUN pid=200010, SID==PID, window "THE LEGEND OF ZELDA" Snes9x: 1.63)
- [x] Write task report + AGENTS.md update (Structure line: snes9x-launcher.cr + compiled binary, setsid detachment)
- [x] Relocate launcher → scripts/ per user: mv snes9x-launcher.cr → scripts/, path constants ../roms + ../snes9x, rebuild, re-verify (menu/quit/miss/launch, SID==PID, window) — addendum below

## Relocation addendum

- Moved `_codex/snes9x-repo/snes9x-launcher.cr` → `scripts/` (folder of acquire-rom.sh); removed root binary
- Path constants updated: `ROM_DIR = File.expand_path("../roms", __DIR__)`, `SNES9X = File.expand_path("../snes9x/unix/snes9x", __DIR__)`
- Rebuilt `--release --mcpu native` → scripts/snes9x-launcher (exit 0, 13.8 s)
- Re-verified: menu (18 buckets + counts), quit exit 0, miss exit 1, real launch (RUN pid=216781, SID==PID, window "THE LEGEND OF ZELDA" Snes9x: 1.63), clean kill

**Status: completed (2026-08-08, relocation pass)

