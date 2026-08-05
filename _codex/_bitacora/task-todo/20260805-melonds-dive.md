# melonDS dive — todo

**Date:** 2026-08-05
**Project:** `_codex/melonDS-repo/` — Nintendo DS emulator dive

## Tasks

- [x] Fetch melonDS source (shallow, depth 1) into `_codex/melonDS-repo/melonDS/`
- [x] Survey architecture: build system, directory topology, core modules
- [x] Study the DS hardware model: ARM9/ARM7, 2D/3D cores, audio, input
- [x] Compile core from source — `-march=native`, JIT x64 ON; log `20260805-121206-melonds-build.log` (exit 0, 48.4s); `build/src/libcore.a` (3.1M)
- [x] Acquire test ROM — Tetris DS (USA) ATRE01, staged `melonDS-repo/roms/tetris-ds-usa.nds` (16MB, decrypted; via romsfun nintendo-ds variant 8)
- [x] Install `extra-cmake-modules` (ECM) — frontend dep blocker cleared
- [ ] Fix frontend build — `MELONDS_GL_HEADER="frontend/glad/glad.h"` fails: include path lacks `src/` (frontend gets `src/frontend/` only). Options: (a) add `-I <src>` to CXX flags; (b) repoint `MELONDS_GL_HEADER` to `"glad/glad.h"`; (c) patch `PlatformOGL.h`. Log `20260805-123123-melonds-frontend-build.log` (exit 2)
- [ ] Build `melonDS` executable — `cmake --build build -j8` after include fix; expect `build/melonDS`
- [ ] Verify binary — `file build/melonDS` → `ELF 64-bit x86-64`
- [ ] Boot Tetris DS — `wrapper/launch-emulator.sh build/melonDS roms/tetris-ds-usa.nds --log /tmp/opencode/melonds-trace.log`
- [ ] Trace boot evidence — `wrapper/trace-evidence.sh /tmp/opencode/melonds-trace.log`
- [ ] Write study/ documents: architecture, memory map, render pipeline
- [ ] Derive pattern(s) from proven structures
- [ ] Write dive report with metrics + open edges

## Logs (bitacora task-stdout)

- `20260805-121144-melonds-build.log` — first core build attempt (aborted)
- `20260805-121206-melonds-build.log` — core build, exit 0, 48.4s
- `20260805-123035-melonds-configure.log` — frontend ON reconfigure
- `20260805-122833-melonds-frontend-build.log` — first frontend build
- `20260805-123123-melonds-frontend-build.log` — frontend build, exit 2 (glad.h)
