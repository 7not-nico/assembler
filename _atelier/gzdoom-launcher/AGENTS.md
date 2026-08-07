# AMANDA gzdoom-launcher — Agent Instructions

## Identity

- serves as the agent instruction file for the gzdoom launcher project
- instantiates a self-contained atelier project under `_atelier/gzdoom-launcher/`
- states final absolute states per `RUL.AGENTS.STATE`

## Domain

This project launches GZDoom with local IWADs, map packs, and mods. The launcher picks an IWAD from `wad/`, optional map packs from `map/`, and optional mods from `mod/`, then starts the GZDoom binary with `-file` arguments per selection and `-savedir` pointing at `save/`.

## Structure

- `launcher.py` — Python 3 launcher (ruff-formatted, lint-clean); IWAD menu, map multi-select, mod multi-select; flags `--list`, `--iwad=NAME`, `--dry-run`; executable
- `pyproject.toml` — uv project metadata; `requires-python >=3.14`; `[tool.ruff]` target py314, line-length 88; no build-system (script runs unpackaged)
- `.venv/` — uv virtualenv (CPython 3.14.6); `uv run launcher.py` executes the script
- `wad/` — IWAD candidates: doom.wad, doom2.wad, tnt.wad, plutonia.wad (standalone games), extras.wad, id1.wad, id1-res.wad, id1-tex.wad, id1-mus.wad, id1-weap.wad, id24res.wad (re-release assets); sha256-identical to Heroic originals
- `wad/custom/` — non-official custom WADs (community, user-made, modded levels); `scan()` globs `wad/*.wad` non-recursively, so custom WADs never surface as IWAD candidates; load them via `-file` like map packs
- `map/` — PWAD map packs (load via `-file` on an IWAD): nerve.wad, masterlevels.wad, sigil.wad, sigil2.wad, iddm1.wad
- `mod/` — loadable mods (gzdoom loads `.zip`/`.pk3` as archives): BrutalDoomPlatinum-main.zip (rebuilt from the clone), D3ForDTX_v5.3.pk3, relighting v4.0165b.pk3, Doom3Textures_v5.3_hotfix2/ (extracted tree)
- `save/` — savegame directory: doom.id.doom1.ultimate
- `BrutalDoomPlatinum/` — source tree; shallow clone (depth 1, commit 423b7167); repo root is the pk3 structure; `mod/BrutalDoomPlatinum-main.zip` derives from it
- `script/epub-maker/` — ZDoom docs epub pipeline; `uv` project, ruff clean; `main.py` orchestrates fetch → enumerate → parallel → merge → pandoc convert → zipfile verify; `deps/fetch.py` io ring (grab/parallel/convert/verify), `deps/extract.py` pure ring (links/slug/mains/probe/chapters), `schema/const.py` constants, `fixture/run_tests.py` (8 tests); writes `ZScript.epub` at launcher root (215 KB, 125 pages, 251 h1 chapters); pandoc duplicate-identifier warnings are expected
- `script/wad-downloader/` — idgames WAD downloader; bash-first, atomic scripts in `scripts/` (`fetch-index.sh` read, `fetch-wad.sh` write, `download.sh` orchestrator); `curl -sL` follows Apache 301 trailing-slash redirects; `7z t` gates every zip; downloads stage into `wad/custom/`; Python+uv httpx-retries path documented as fallback in its `AGENTS.md`

## Runtime

```bash
uv run launcher.py                 # interactive: IWAD → maps → mods → launch
uv run launcher.py --list          # list IWAD candidates
uv run launcher.py --dry-run --iwad=doom.wad   # print command without launching
```

- The launcher prefers `/opt/gzdoom/gzdoom` (v4.14.2, self-contained) as the binary; it falls back to `shutil.which("gzdoom")`
- `/usr/local/bin/gzdoom` is a broken wrapper (stale RUNPATH, missing `libzmusic.so.1`); the launcher never uses it when `/opt/gzdoom/gzdoom` exists
- `subprocess.run` carries explicit `check=False` — a nonzero gzdoom exit does not raise
- Folder names are singular nouns: `wad/`, `map/`, `mod/`, `save/`

## Integrity

- WAD files verify against `/home/eddyr/Games/Heroic/DOOM + DOOM II/` originals via sha256; header probe reads `IWAD` (standalone) or `PWAD` (packs/assets)
- The BrutalDoomPlatinum zip loads as a pk3 mod; regeneration follows a fresh `git clone --depth 1 https://github.com/EmeraldCoasttt/BrutalDoomPlatinum.git`

## Precedence chain

Launcher work advances in chain order; each gate passes before the next stage runs.

```text
uv format -> ruff check -> smoke -> integrity -> launch
```

- `uv format` — the code-shape gate; format precedes lint so shape changes never pollute lint findings
- `ruff check` — the lint gate; zero findings required
- `smoke` — the behavior gate: `uv run launcher.py --list` and `uv run launcher.py --dry-run --iwad=doom.wad` exit 0
- `integrity` — the asset gate: sha256 of `wad/` + `map/` against Heroic originals, IWAD/PWAD header probes, archive tests for `mod/`
- `launch` — the runtime gate: gzdoom starts and stays alive

Examples:

- `uv format -> smoke test` — a formatting pass precedes any smoke run; a smoke claim requires a clean `ruff format --check` in the same session
- `ruff check -> uv run --dry-run` — lint gates command construction; a dry-run that prints a malformed gzdoom line fails the smoke stage
- `smoke -> integrity` — behavior verified before asset checksums; a wad copy lands in `wad/` only after the sha256 comparison passes
- `integrity -> launch` — the launch stage never runs against unverified assets

The forbidden state is a later-stage artifact whose predecessor never happened — a launch log with no passing dry-run, a smoke claim against unformatted code.

## Reports and todos

- bitacora records live under the workspace root `.opencode/_bitacora/` per the root `AGENTS.md`
- every command pipes through `bash .opencode/_bitacora/bitacora-log.sh {name} -- {command}`
