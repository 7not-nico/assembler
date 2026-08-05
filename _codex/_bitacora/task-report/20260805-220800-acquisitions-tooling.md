# Session report — 20260805-220800 acquisitions + tooling fixes

## What was done

- Acquired and booted five more PSP minis from archive.org `pspminis` (CSO v1, direct curl): Vanguard II, Burnin' Rubber, 5-in-1 Solitaire, Aero Racer, plus the card-game pick 5-in-1 Solitaire per user choice
- Acquired and booted two homebrew EBOOT.PBP from GitHub `Saymond/PSP-apps` releases: Mini Mine RT v3.0 (VFPU ray-tracing demo), Cornell-Box PSP v2.0-C
- Acquired Mercury Meltdown (USA) from romsfun full catalog via the shared browser — the first full-ISO acquisition since Metal Slug XX
- Fixed three dive scripts: `build-ppsspp.sh` (stale binary path + BUILD_DIR env), `kill-ppsspp.sh` (pgrep self-match), `launch-ppsspp.sh` (verbose→quiet default)
- Extended `browse-romsfun.sh` + MCP `acquire_browse` to accept any romsfun console section (default `super-nintendo`, verified against `playstation-portable`)
- Traced every boot: Vanguard II, 5-in-1 Solitaire, Cornell-Box, Mini Mine RT, Mercury Meltdown

## Decisions

- **Vanguard II pick**: smallest new pspminis candidate (3,154,592 B) — user-approved download after qalc size check (~3.0 MiB stored)
- **Card game pick**: 5-in-1 Solitaire (6,477,000 B) over Solitaire/Battle Poker/Basha — user chose smallest
- **3D mini pick**: Aero Racer (33,339,125 B) over Cubixx/Stellar Attack/Carnivores — user chose racing
- **Mercury Meltdown variant**: romsfun variant 4 — Mercury Meltdown (USA) (EnFrEs) Redump, 316.18 M; fetched manually (MCP restart pending)
- **Homebrew source**: Saymond/PSP-apps GitHub releases — native C with VFPU assembly, directly relevant to the Allegrex CPU study
- **kill-ppsspp.sh exact match**: `pgrep -f` caught the script's own wrapper command line → `pgrep -x PPSSPPSDL` for the self-match-free check
- **launch-ppsspp.sh quiet default**: `./build/PPSSPPSDL` → `${PPSSPP_BIN:-./build-quiet/PPSSPPSDL}`, matching the AGENTS.md convention that the dive launches the quiet binary
- **browse-romsfun console arg**: 3rd positional with `super-nintendo` default — backward-compatible with the snes9x dive's existing calls

## Findings

- **Full-ISO boots slower than CSO minis**: Mercury Meltdown's window sits black ~8s while `EBOOT.BIN` decompresses from the 360 MB ISO — the "no image" was the load, not a failure; trace shows `Booted`, PPGe initialized, frames presenting (IMMEDIATE present mode, 4 swapchain images)
- **Homebrew boot evidence**: `\0PBP` magic + version 0x00010000 header check on both EBOOT.PBP; PPSSPP generates a fake DiscID for homebrew without a PARAM.SFO DiscID — `EBOO00649` for Mini Mine RT (`ELF/ParamSFO.cpp:110 W[Loader]: No DiscID found - generating a fake one`)
- **Mercury Meltdown runtime**: `ULUS10133 : Mercury Meltdown`, `Loading disc0:/PSP_GAME/SYSDIR/EBOOT.BIN`, `sceeDLSThread` (Sony DLS save-download service, missing DATA2.BIN expected first-run), stable 4.9% CPU on quiet binary
- **Vanguard II level mix**: 438 I / 2 N / 2 W / 2 E / 1 D — quiet binary confirmed; `I[Printf]` dominates (253) via sceIo stdout
- **Kill script rc=0 on clean chain**: verified `no emulator running` path after the exact-match fix

## Open edges

- **MCP restart pending**: opencode must restart to load the `acquire_browse` console schema; until then the tool carries the old signature (manual `browse-romsfun.sh {game} {timeout} {console}` works)
- **acquire_run still SNES-hardcoded**: the conductor `acquire-rom.sh` + `acquire_run` MCP tool need the same console passthrough for one-command cross-console flow
- **Homebrew study doc not written**: the `study/` doc on the Saymond/PSP-apps EBOOT.PBP path is still due
- **pspminis study inventory stale**: `study/pspminis-rom-source.md` lacks Burnin' Rubber, Aero Racer rows (Vanguard II + 5-in-1 Solitaire added) and the romsfun full-catalog path
- **Font asset gap + version string** (`Build problems? edd9680`) remain cosmetic open edges
- **Aero Racer / Burnin' Rubber traces**: Aero Racer booted (stream `/tmp/tmp.voDeZ1YMXo`); Burnin' Rubber downloaded but never launched
- Core study (Allegrex MIPS CPU, GE graphics, Media Engine) + fixtures remain open from the main dive todo

## Todo state summary

- [x] Acquire Vanguard II (3.0 MiB, smallest new pick) — booted
- [x] Acquire Burnin' Rubber (3,303,617 B) — downloaded, CSO verified, not launched
- [x] Acquire 5-in-1 Solitaire (card game pick) — booted, resized, closed clean
- [x] Acquire Aero Racer (3D pick) — booted
- [x] Acquire Mercury Meltdown (USA) (romsfun full catalog, manual fetch) — booted, closed clean
- [x] Acquire Mini Mine RT v3.0 homebrew — booted
- [x] Acquire Cornell-Box PSP v2.0-C homebrew — booted
- [x] Fix `build-ppsspp.sh` stale path + BUILD_DIR env
- [x] Fix `kill-ppsspp.sh` pgrep self-match (verified rc=0)
- [x] Fix `launch-ppsspp.sh` quiet default + PPSSPP_BIN env
- [x] Extend `browse-romsfun.sh` + `acquire_browse` console param (live-verified PSP)
- [x] Trace all five boots (Vanguard II, Solitaire, Cornell-Box, Mini Mine RT, Mercury)
- [ ] Homebrew study doc (`study/`)
- [ ] pspminis inventory update (Burnin' Rubber, Aero Racer, romsfun path)
- [ ] acquire_run console passthrough
- [ ] Core study (CPU/GE/Media Engine) + fixtures — main dive todo

## Records

- Session stdout: `_codex/_bitacora/task-stdout/` — bitacora logs for each launch (`ppsspp-x11`), Vanguard II browse, Mercury fetch
- Live streams in `/tmp/tmp.*` (temp files; killed runs lose the flush — killed-run traces only in the temp files)
- `roms/` now holds 9 bootable titles: 7 CSO minis + metal-slug-xx.iso + mercury-meltdown-usa.iso
- Homebrew at `~/.config/ppsspp/PSP/GAME/{MiniMineRT,CornellBox}/EBOOT.PBP`
