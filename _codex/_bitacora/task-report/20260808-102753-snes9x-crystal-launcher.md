# snes9x-crystal-launcher — report

**Date:** 2026-08-08
**Project:** Port `roms/snes9x_launcher.rb` (Ruby) → Crystal launcher, placed in the snes9x project root

## What was done

- Read Ruby launcher contract — `roms/snes9x_launcher.rb`: letter menu / index / slug-fragment selection, `-v0` default filter, `pgroup: true` detached launch, `RUN pid=` / `FAIL` result lines, log at `/tmp/opencode/snes9x-launch.log`
- Probed Crystal 1.21.0 API surface before writing code (3 probe rounds):
  - `Process.new` has **no** `process_group:` parameter → setsid wrapper (`/usr/bin/setsid`) replaces Ruby's `pgroup: true`; verified PGID == PID, session leader, PID survives exec
  - `Process.exists?(pid)` exists in stdlib — clean liveness probe (no /proc parsing)
  - `Process.new` output accepts `IO` only (not String) → `File.open(LOG, "w")` wraps the log path; same File object for output+error
  - `Dir.glob("*.{sfc,smc}")` brace expansion works — 48 ROMs matched
  - `sleep 2` deprecated → `sleep 2.seconds`
- Planned 10-function port (method table) — placement decided by user: launcher in the snes9x project root
- Wrote `snes9x-launcher.cr` (project root) — functional style, explicit return types, 10 functions + main dispatch
- Compiled: `crystal build snes9x-launcher.cr -o snes9x-launcher --release --mcpu native` → exit 0, ~12.4 s; ELF x86-64 PIE, 1.79 MB, not stripped
- Context7 verification of the API surface: `Process.new(command, args, output: IO)` documented form matches the launcher's spawn

## Compile fixes (3 rounds)

1. Crystal `Hash` has no `sort` → ordered hash built from sorted keys (Crystal hashes preserve insertion order)
2. `STDIN.gets?` doesn't exist → `STDIN.gets.try(&.strip)` (IO#gets already returns `String?`)
3. Quit parity: Ruby exits 0 on `q`/EOF at prompts; port returned nil → main exit 1. Fixed: `exit 0` directly at quit points inside `pick_by_letter`

## Decisions

- setsid wrapper over Ruby's `pgroup: true` — same detachment semantics (own session), PID stays valid because setsid execs the target
- Launcher lives at the snes9x project root (user instruction) — `ROM_DIR`/`SNES9X` resolve from `__DIR__` (compile-time, stable for the compiled binary)
- Compiled binary gitignored (check-ignore exit 0); only the `.cr` source tracks

## Verification

- Menu: 19 letter buckets, 48 ROMs (`A: 2 ... Y: 1`)
- Quit path: `printf 'q\n'` → exit 0 (parity with Ruby)
- Miss path: `999` → `no ROM matches "999"`, exit 1
- `-l` letter flow: `S` → 12 ROMs listed; `q` at pick prompt → "pick again" (Ruby parity); EOF → exit 0
- Unknown bucket: `Z` → `no ROMs under Z`, loop, quit 0
- Real launch: `zelda` → `LAUNCH legend-of-zelda-the-a-link-to-the-past-usa.sfc -v0` + `RUN pid=200010`
  - Session check: SID == PID (200010) → detached session confirmed
  - Log: healthy ALSA init, no joystick errors
  - Window: `"THE LEGEND OF ZELDA" Snes9x: 1.63` on `DISPLAY=:0`
  - Cleanup: `pkill -x snes9x` → stopped

## Open edges

- Launch window size at `-v0` (4×, 1024×896) not measured this session — internal-resolution verification belongs to the dive's existing procedure
- No fixture yet for the launcher — menu/selection logic is exercised by the smoke matrix only; a fixture could assert bucket counts + selection rules (e.g. `fixture/launcher-test`)
- Ruby launcher remains the reference in `roms/`; the Crystal port mirrors its contract — future behavior changes should land in both or one designated as canonical

## Todo state

All items complete: contract read, API probes, method plan + placement, source written, compiled, smoke tests (menu/index/fragment/launch), report written

## Relocation addendum (2026-08-08, after user request "move the code into here" pointing at scripts/acquire-rom.sh)

- Interpretation: relocate the launcher into the `scripts/` directory (the folder holding acquire-rom.sh), per the earlier "launchers must be in snes9x root folder" being superseded by the explicit scripts/ path
- Moved `snes9x-launcher.cr` → `scripts/snes9x-launcher.cr`; removed the root binary
- Path constants updated for the new `__DIR__`: `ROM_DIR = ../roms`, `SNES9X = ../snes9x/unix/snes9x`
- Rebuilt `--release --mcpu native` → `scripts/snes9x-launcher` (exit 0, 13.8 s)
- Re-verified the full matrix from the new location: menu (18 buckets + counts), quit exit 0, miss exit 1, real launch `RUN pid=216781` with SID == PID (detached session), window `"THE LEGEND OF ZELDA" Snes9x: 1.63`, clean `pkill`
- AGENTS.md structure line updated to `scripts/snes9x-launcher.cr`
- Decision: the launcher source + compiled binary now live with the dive's other atomic tooling in `scripts/`
