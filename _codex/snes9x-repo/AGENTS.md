# AMANDA snes9x-repo — Agent Instructions

## Domain

This project dives the snes9x codebase — a portable SNES emulator. The dive compiles the source, studies the emulation core, acquires test ROMs, extends the emulator (internal resolution), and verifies the emulator runs them

## Structure

- `snes9x/` — source tree; shallow clone (depth 1, commit b5cc765)
- `snes9x/unix/` — autotools port; configure + make run here; binary lands as `snes9x`
- `roms/` — test ROMs, lowercase dash-slugs (`super-mario-world-usa.sfc`); `snes9x_launcher.rb` picks and launches
- `scripts/snes9x-launcher.cr` — Crystal port of the Ruby launcher (compiled to `scripts/snes9x-launcher` with `--release --mcpu native`); same contract: letter menu / index / slug-fragment selection, `-v0` default filter, `RUN pid=`/`FAIL` result lines, log at `/tmp/opencode/snes9x-launch.log`; detaches via setsid (SID == PID, replaces Ruby's `pgroup: true`); path constants resolve `../roms` + `../snes9x/unix/snes9x` from `scripts/`
- `precept/` — governing rules: `use-shared-browser.md`, `acquire-rom.md`, `run-atomic.md`
- `invariant/` — state facts + violation signatures: `browser-singleton.md`, `download-destination.md`, `acquisition-consistency.md`, `rom-integrity.md`, `launch-detachment.md`, `scale-centralization.md`, `depth-24-buffer.md`, `precedence-chain.md`; `guideline/invariant-layer.md` defines the form
- `procedure/` — numbered step chains, one per code morphism (extend-scale, sweep-scale-sites, test-fixture, launch-detached, connect-shared-browser, compose-atomic-pipeline, compose-conductor-chain, build-preference-cascade, probe-archive-region, parse-name-safe, acquire-from-variant-url, retry-transient-launch)
- `pattern/` — code morphisms (scale-extend, scale-plumbing-sweep, fixture-first, detached-launch, shared-browser, atomic-composition, conductor-chain, preference-cascade, in-archive-probe, whitespace-field-parse, url-provenance, transient-launch-retry); each carries structure, verification, session instance
- `study/` — `internal-resolution-architecture.md`: render pipeline + authoritative change inventory, qalc-verified resolution math
- `fixture/` — `blit-scale-test.c`: proves HQ2X/HQ3X/HQ4X scaler output (exact scale×, probe position, zero overrun); rerun after any scaler change
- `backup/` — pre-edit restore points: `snes9x-src/` + timestamped binaries
- `scripts/` — atomic tooling: `browse-romsfun.sh` (variant table, `GAME`/`DL`/`VARIANTS:`), `fetch-rom.sh` (shared-browser download), `verify-rom.sh` (`file` + `unzip -l` + title probe `0xFFC0`/`0x7FC0`), `prepare-rom.sh` (extract, slugify, move), `launch-rom.sh` (detached run), `acquire-rom.sh` (conductor: browse → pick → pipeline), `playwright-fetch-rom.sh` (fetch→verify→prepare→launch)
- `_bitacora/` — shared record under `_codex/`; `{YYYYMMDD}-{HHMMSS}-` prefix

## Shared browser

All browser work runs on one shared persistent Chromium — CDP 9222, original MCP profile (`~/.cache/ms-playwright-mcp/mcp-chrome-*`), extensions + cookies. `_templates/shell/start-browser.sh` starts it; scripts connect via `connectOverCDP`. Never launch a new Chrome instance for downloads; never copy the profile. The headless variant (CDP 9223) exists for scripted acquisition, but romsfun is Cloudflare-gated — ROM downloads require the headed 9222 instance. The profile lock allows one instance per profile; the SingletonLock abort fires otherwise

## Build flow

```bash
CFLAGS="-O3 -march=native" CXXFLAGS="-O3 -march=native" \
./configure --enable-sse41 --enable-avx2 --disable-netplay --disable-debugger
make -j$(nproc)
```

- Verify with `./snes9x --help` + `file snes9x` (x86-64 PIE, not stripped)
- Reports record flags, duration, binary size, warnings

## Video modes — internal resolution

The X11 driver exposes selectable internal render scales (rendered inside the emulator, not window-stretched):

```text
| Mode | Flag | Internal output |
|------|------|-----------------|
| Blocky..HQ2X | `-v1`..`-v8` | 2× — 512×480 |
| HQ3X | `-v9` | 3× — 768×672 |
| HQ4X | config `10` | 4× filtered — 1024×896 |
| Blocky4X | `-v0` | 4× plain (no filter) — 1024×896 |
```

`S9xVideoScale()` in `x11.cpp` centralizes the per-mode factor; every scale-dependent site routes through it. Config `Unix/X11::VideoMode` accepts 1–11. Extending a scale: `procedure/extend-scale.md` + `procedure/sweep-scale-sites.md`; prove scalers first via `fixture/blit-scale-test`. Windowed mode is fixed-size at the scaled dims. Hyprland xwayland scale ×2 reports logical half in `hyprctl clients` — physical = reported × 2. Change inventory: `study/internal-resolution-architecture.md` (diff anchor `backup/snes9x-src/`)

### Opening a ROM at 4× (Blocky4X, no filter)

4× plain scale = `-v0` (Blocky4X — nearest-neighbor, no filter; the HQ4X filter keeps config value 10). Pass the flag through the emulator-arg chain:

```bash
bash _codex/_templates/instantiator/romsfun/composer/compose-launch.sh \
  _codex/snes9x-repo/snes9x/unix/snes9x {rom} --emu-arg -v0
```

- Flag order: `{binary} {rom}` positional, then `--emu-arg -v0` — the launcher passes the flag verbatim to snes9x
- The MCP `inst_launch` schema supports `emu_args` (e.g. `["-v0"]`) — the MCP route is the primary path (used for Kirby, Star Fox, Doom 2026-08-06). The composer shell (`compose-launch.sh --emu-arg`) remains the alternate route for `{rom}` positionals
- Known launch-chain wart: `inst_launch` appends the rom positionally *and* emu_args may carry it — snes9x receives the ROM twice in argv and tolerates the duplicate; dedupe in the composer when touching the chain
- Verify: `pgrep -af "snes9x.*-v0"` shows the flag on the command line; window opens at 4× scaled dims (1024×896 at 4× base)

## ROM acquisition flow

- One-command path: `bash scripts/acquire-rom.sh {game}` — discovers, auto-picks variant (USA No-Intro → plain USA → any USA → first), pipelines, launches
- Step-by-step: `browse-romsfun.sh {game}` → `fetch-rom.sh {variant-url}` → `verify-rom.sh {zip}` → `prepare-rom.sh {zip}` → `launch-rom.sh {rom}`
- Variant URLs: `romsfun.com/download/{slug}-{id}/{n}`; the download anchor carries `token=` (`statics.romsfun.com` or `sto.romsfast.com` — mods/translations use the latter); zips land in `$ASSEMBLER/.opencode/.playwright-mcp/`
- Verification: one `.sfc`/`.smc` at 524,288/1,048,576 B (larger warn-only: 2/3/4/6 MiB hacks, HiROMs, ExHiROM); the title probe at `0xFFC0` (HiROM/ExHiROM) / `0x7FC0` (LoROM) proves the header — `file` misdetects HiROMs and expanded ExHiROM maps; the probe decides
- Fetch routing (2026-08-06): root download URLs (`/download/{game}-{id}`) render a variant table with no `token=` anchor — `inst_fetch` stalls there; feed the **variant URL** (`/download/{game}-{id}/{n}` from the `VARIANTS:` lines) to `inst_fetch`. Curl to the statics token URL is JS-challenge-gated per-file (some pass with browser-UA, e.g. Star Fox; Doom returned HTML) — the authenticated browser is the reliable route
- Slugs collide across systems (SNES/PSX/PSP/GBA) — browse titles disambiguate
- Variant URLs always derive from the `browse-romsfun.sh` table — never reconstructed from memory; a guessed slug serves the wrong game. Browse → copy the exact `DL`/`VARIANTS:` URL → fetch
- The library holds 40 ROMs (zips in `.opencode/.playwright-mcp/`; extracted `.sfc` slugs in `roms/`); slug suffix encodes the exact variant (`-usa-en-fr-es`, `-japan-t-en-by-psyklax`)

## Launch verification

`launch-rom.sh` detaches snes9x with `setsid nohup` — the script exits, the emulator stays open; output to `/tmp/opencode/snes9x-launch.log`. A healthy start shows ALSA init lines, no joystick errors, a live process (`pgrep -x snes9x`), a window on `DISPLAY=:0`. A crash or missing window marks the run failed; the agent records it. Kill with `pkill -x snes9x` — never `pkill -f` with a pattern the wrapper's own command line contains. A `FAIL ... X connection to :0 broken` after a verified ROM is transient X contention, not a corrupt ROM — relaunch once before diagnosing. In sessions with repeated X deaths post-render (Doom 2026-08-06: two tracexec runs died after `Created XShmImage`), relaunch per run; the buffered tracexec stdout proves the game rendered before the X error — an environment issue, not a ROM issue. Performance sampling: `CLK_TCK=100`; CPU% = (utime+stime delta / 100) / wall × 100

## Precedence chain — obligatory

```text
mcp/ → invariant/ → scripts/ → _bitacora/ → precept/ → backup/ → study/ → fixture/ → pattern/ → procedure/
```

### Layer roles

- `mcp/` — connected MCP servers (browser, acquire, patlib); tooling substrate; precedes all
- `invariant/` — always-true state predicates + violation signatures
- `scripts/` — atomic tools + orchestrator; execute under the invariants
- `_bitacora/` — the record; todo first, report after
- `precept/` — declarative rule files; govern all work
- `backup/` — restore points before any source study or edit
- `study/` — architecture documents; precede the morphism
- `fixture/` — atomic regression harnesses; prove components before integration, rerun after changes
- `pattern/` — code morphisms; derived from study + fixture proof; every pattern file carries an Invariant section
- `procedure/` — numbered step chains; informed by the morphism
- `roms/` — test assets

Violating the order marks the work incomplete

## Records

Every session writes timestamped files into `_codex/_bitacora/`; every command output flows through `run-logged.sh` into `_bitacora/task-stdout/`. Knowledge lands in its layer: precept (rule) → procedure (steps) → pattern (morphism) → study (architecture) → fixture (proof). Templates live in `_codex/_templates/` and propagate via `script/copy-templates.sh`

## Delegation

This project owns the snes9x dive: build flags, ROM acquisition, emulator extension (internal resolution), and verification
