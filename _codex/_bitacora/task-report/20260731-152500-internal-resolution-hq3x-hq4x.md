# snes9x internal resolution — HQ3X/HQ4X implementation

Timestamp: 2026-07-31 15:25

## What was done

Implemented selectable internal render resolution in the snes9x unix X11 driver: HQ3X (3×, 768×672) and HQ4X (4×, 1024×896) video modes, rendering inside the emulator — not window stretching.

1. **Study** — render pipeline mapped: PPU `RenderedScreenWidth/Height` → `S9xDeinitUpdate` → `S9xPutImage` → blit filter → SHM image → `XShmPutImage` → window. Scaler library already contained HQ3x16/HQ4x16 (FFmpeg hqx); the driver exposed only 2× modes. `study/internal-resolution-architecture.md` written with the full change set and qalc-verified math (3× = 768×672, 4× = 1024×896, aspect-pure 8:7).
2. **Backup** — `backup/snes9x-src/` + `backup/snes9x-binary-20260731-150334` before edits.
3. **Atomic fixture** — `fixture/blit-scale-test.c` proves HQ2X/HQ3X/HQ4X produce exact scale× output (512×448 / 768×672 / 1024×896), probe pixel at correct scaled coordinates, zero extra writes (64 KB sentinel). First run's "overrun" was a test read-past-pad artifact — fixed. All PASS.
4. **Driver edits** — 17 scale sites in `x11.cpp`: enum (`VIDEOMODE_HQ3X/HQ4X`), CLI `-v9`/`-v0`, config range 1–10, `S9xVideoScale()` helper (3/4/2) + forward declaration, window creation, xvideo defaults + `imageHeight`, `XShmCreateImage`/`XCreateImage`, blit switch cases, `copyWidth/copyHeight`, extended-region clear, `Repaint()` source rect (SHM + plain), mouse `/ scale`, `filter_buffer` allocation, `blit_screen_pitch` in the convert path, xvimage (SHM + plain), YUY2 loop bound, I420 `tw/th`, XvPutImage source widths.
5. **Build** — `make -j$(nproc)`, 2,746,376 B binary, no errors (only pre-existing deprecation warnings).
6. **Runtime verification** (Hyprland xwayland scale 2 — hyprctl reports logical half):

| Mode | Logical | Physical | Expected |
|------|---------|----------|----------|
| HQ2X `-v8` | 256×239 | 512×480 | 512×480 — regression clean |
| HQ3X `-v9` | 384×358 | 768×672 | 768×672 — PASS |
| HQ4X `-v0` | 512×478 | 1024×896 | 1024×896 — PASS |

## Decisions

- HQ3X/HQ4X map to `-v9`/`-v0` (extending the `-v1..-v8` CLI); config `Unix/X11::VideoMode` accepts 1–10.
- `S9xVideoScale()` centralizes the per-mode factor — every fixed 2× site converts through it.
- Windowed mode stays fixed-size (PSize|PMinSize|PMaxSize) at the scaled dims — WM resizing disabled by design.

## Errors found

- **Segfault on first `-v9` run (exit 139)** — depth-24 X server → `need_convert` path → `blit_screen` pointed at `filter_buffer` sized for 2× (491 KB) while HQ3X wrote ~1 MB → overflow. Fixed: `filter_buffer` and `blit_screen_pitch` scale-aware. (Fixture passed because it tested the scaler in isolation at 16-bit logic — the convert-path buffer sizing was a driver concern.)
- **`S9xVideoScale` undeclared** — helper defined after first use (window creation). Fixed with a forward declaration after the enum.
- **Missed scale sites** — initial 8-edit plan missed 9 more: `copyWidth/copyHeight`, extended-clear, Repaint source rect, mouse scale, filter_buffer, blit_screen_pitch, xvimage, YUY2/I420, XvPutImage. Final grep sweep (`SNES_WIDTH * 2`, `>> 1`) left only legitimate sites (XVideo min-capability check, RGB bit shifts).

## Open edges

- Hi-res SNES modes (512×448) × HQ3X/HQ4X — untested; 4× hi-res = 2048×1792 (likely oversized).
- XVideo fullscreen path scale-aware but untested (windowed verified).
- xBRZ (up to 6×) and sharp-bilinear remain unwired — same pattern.
- `snes9x.conf.default` video-mode docs may need range update.

## Todo state

Study + fixture + driver edits + build + runtime verification: completed. Bitacora report: written. New precepts: written.

## Addendum — knowledge layers (15:35)

Dive knowledge stack completed across five layers, each grounded in this session's work:

- `precept/` — 3 rules: `use-shared-browser`, `acquire-rom`, `run-atomic`
- `procedure/` — 6 chains: `extend-scale`, `sweep-scale-sites`, `test-fixture`, `launch-detached`, `connect-shared-browser`, `compose-atomic-pipeline`
- `pattern/` — 6 morphisms: `scale-extend`, `scale-plumbing-sweep`, `fixture-first`, `detached-launch`, `shared-browser`, `atomic-composition`
- `study/` — `internal-resolution-architecture.md` (pipeline, change set, qalc math)
- `fixture/` — `blit-scale-test.c` (regression harness, all PASS)

Final state: internal resolution selectable `-v9` (768×672) / `-v0` (1024×896); `roms/` holds 4 titles; scripts atomic; emulator detached-launchable; record complete.
