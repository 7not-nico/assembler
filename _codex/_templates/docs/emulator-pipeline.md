# Emulator acquisition pipeline — reference

**Layer:** docs/
**Project:** `_codex/_templates/` — the codex toolchain

## The pipeline

One flow acquires and runs a console game, through either the shell tools or the MCP server (same canonical implementations):

```text
browse → fetch → verify → stage → launch → trace → stop
```

| Step | Shell tool (wrapper/) | MCP tool | Result |
|---|---|---|---|
| browse | browse-romsfun.sh | inst_browse | GAME + VARIANTS lines |
| fetch | fetch-download.sh | inst_fetch | SAVEDPATH= |
| verify | verify-archive.sh | inst_verify | OK= / IMAGE= / SIZE= |
| stage | `7z x` → `roms/` | — (inst_acquire does it) | slugified `.sfc`/`.gba`/`.nds` |
| launch | launch-emulator.sh | inst_launch | RUN=pid= |
| trace | trace-evidence.sh | inst_trace | LINES= + EVIDENCE= |
| stop | stop-process.sh | inst_stop | STOPPED= |

## Proven acquisitions (2026-08-05)

| Game | Console | Emulator | ROM staged |
|---|---|---|---|
| Yoshi's Island (Japan) | SNES | snes9x | `snes9x-repo/roms/yoshi-island-japan.sfc` |
| Looney Tunes B-Ball (USA) | SNES | snes9x | `snes9x-repo/roms/looney-tunes-b-ball-usa.sfc` |
| Mega Man Zero 2 (USA) | GBA | mGBA | `mgba-repo/roms/mega-man-zero-2-usa.gba` |
| Tetris DS (USA) | DS | melonDS (build pending) | `melonDS-repo/roms/tetris-ds-usa.nds` |

## Emulator binaries

| Console | Binary | Dive |
|---|---|---|
| SNES | `snes9x-repo/snes9x/unix/snes9x` | snes9x-repo |
| GBA | `mgba-repo/build/sdl/mgba` | mgba-repo |
| DS | `melonDS-repo/...` (core built; frontend pending) | melonDS-repo |

## Launch conventions

snes9x — emits Alsa init lines on boot (trace works by default):
```text
launch-emulator.sh {snes9x} {rom} --log {path}
```

mGBA — silent by default; enable the log for trace evidence:
```text
launch-emulator.sh {mgba} {rom} --log {path} --emu-arg -l --emu-arg 127
```

## Boot evidence

- **snes9x**: `Alsa available rates/buffers/periods` + `joystick: No joystick found` (4 lines)
- **mGBA** with `-l 127`: `GBA DMA`, `GBA BIOS`, `GBA Serial I/O`, `SDL Events` (thousands of lines)
- **melonDS**: Alsa init lines (snes9x-style)

## Stop convention

```text
stop-process.sh {binary-name}    # snes9x | mgba | melonDS
```

Exact pgrep -x match; `STOPPED=1` on success, `STOPPED=0` when nothing matched.
