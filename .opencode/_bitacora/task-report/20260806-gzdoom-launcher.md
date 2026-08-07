# gzdoom-launcher — completion report

**Date:** 2026-08-06
**Topic:** gzdoom-launcher
**Location:** `/home/eddyr/assembler/_sandbox/gzdoom-launcher/`

## What was done

1. Created the launcher folder with singular-noun subfolders: `wad/`, `map/`, `mod/`, `save/`.
2. Copied 16 WADs from `/home/eddyr/Games/Heroic/DOOM + DOOM II/` (bitacora: `wads-copy`).
3. Moved 5 mods from `~/.config/gzdoom/pk3/` (bitacora: `mods-move`): BrutalDoomPlatinum-main.zip, D3ForDTX_v5.3.pk3, relighting v4.0165b.pk3, Doom3Textures_v5.3_hotfix2 folder + .rar.
4. Moved savegame from `~/.config/gzdoom/savegames/` (bitacora: `save-move`).
5. Moved 5 map packs to `map/` (bitacora: `maps-move`): nerve, masterlevels, sigil, sigil2, iddm1.
6. Wrote `launcher.py` — Python 3, no deps: IWAD menu, map multi-select, mod multi-select, `-file` loading, flags `--list` / `--iwad=` / `--dry-run`.
7. Extracted Doom3Textures RAR (`d3textures-extract`, 54 files), removed the RAR.
8. Cloned `EmeraldCoasttt/BrutalDoomPlatinum` depth 1 (`brutal-clone`, commit 423b7167).
9. Regenerated `mod/BrutalDoomPlatinum-main.zip` from the fresh clone (`brutal-zipped`, 24628 entries, verified).
10. Ran integrity verification (`integrity`): all 16 WADs sha256-identical to Heroic originals, headers IWAD/PWAD correct, archives pass 7z/unzip tests.
11. Fixed the launch blocker: `/usr/local/bin/gzdoom` (AUR wrapper) carried a stale RUNPATH and missed `libzmusic.so.1`; the self-contained `/opt/gzdoom/gzdoom` (v4.14.2) runs clean. Launcher now prefers `/opt/gzdoom/gzdoom`.
12. Ruff cleanup: import block sorted (I001), 2× `subprocess.run` gained explicit `check=False` (PLW1510). `ruff check` + `ruff format --check` pass clean.
13. uv integration: `uv init` project `gzdoom-launcher` (python ≥3.14); `pyproject.toml` carries `[tool.ruff]` (target py314); removed `[build-system]` block (script runs unpackaged); `.venv` created; `uv run launcher.py` verified (bitacora: `uv-verify`, exit 0).
14. Declared the project: wrote `AGENTS.md` at the launcher root (Identity, Domain, Structure, Runtime, Integrity, Reports sections; final absolute states per `RUL.AGENTS.STATE`). The launcher now counts as a project per `RUL.WORKFLOW.PROJECT.DELEGATION`.

## Decisions

- Folder names singular per workspace convention (`wad/`, `map/`, `mod/`, `save/`).
- Map packs (PWADs needing an IWAD) live in `map/`, loaded via `-file`; standalone games stay in `wad/` as IWADs.
- The BrutalDoomPlatinum GitHub repo root IS the pk3 tree; its zip loads directly in gzdoom.
- `/opt/gzdoom/gzdoom` replaces the broken `/usr/local/bin` wrapper (no root needed).

## Open edges

- Live gzdoom launch test: process started (pid observed) but the health-check command was aborted by the user; final window-level verification pending.
- `Doom3Textures_v5.3_hotfix2/` extracted tree duplicates `D3ForDTX_v5.3.pk3` at `mod/` root — do not load both at once.
- `extras.wad` (625 MB) in `wad/` is the re-release extras pack, not needed for standard IWAD play.

## Todo state

- All 9 items completed; live-launch verification remains as an open edge.

## Addendum — epub-maker pipeline (2026-08-06T23:18)

### What was done

15. Built `script/epub-maker/` — uv project (python ≥3.14, ruff py314): `main.py` orchestrator, `deps/fetch.py` (io ring: grab/parallel/convert/verify), `deps/extract.py` (pure ring: links/slug/mains/probe/chapters), `schema/const.py`, `fixture/run_tests.py` (8/8 pass).
16. Fixed the fetch-failure false negative: `grab()` writes `dest/{slug(page)}.html`, but `main.py` checked `print.html`/`toc.html` paths that never exist. Downloads succeeded; the existence check reported failure. Paths now derive via `extract.slug()` (bitacora: `epub-maker-build` logs 231501, 231330).
17. First successful full build (bitacora: `epub-maker-build` 231841, exit 0): PAGES=125, FETCHED=125, FAILED=0, MERGED=125, CHAPTERS=251, BYTES=215267. Pandoc emitted 485 duplicate-identifier warnings (source anchors repeat across pages) — cosmetic, verify passes.
18. Verified `ZScript.epub`: `7z t` reports "Everything is Ok" (133 files, 215267 compressed), mimetype `application/epub+zip`, 215267 bytes, 125 chapter xhtml files.
19. Cross-checked the sidebar page enumeration against the live site via Playwright snapshot (ZScript.html loaded, sidebar lists Introduction/Meta/ZScript·11/ACS/API/Concepts/Data) and pandoc EPUB3 flags via Context7 (`--toc`, `--toc-depth`, metadata) — conventions match `const.py`.
20. Updated launcher `AGENTS.md` Structure section with the `script/epub-maker/` entry.

### Decisions

- Page files get a `.html` suffix appended to the slug (slug keeps the original `.html`), so `print.html` → `print.html.html`; `main.py` derives paths through `extract.slug()` to stay in sync with `grab()`.
- The merged book reuses `print.html` content; per-page `<main>` sections merge when their probe text is absent from the print content (125 pages merged, 0 duplicate).
- Pandoc duplicate-identifier warnings accepted — the source anchors collide by design.

### Open edges

- `MERGED=125` means every sidebar page added content beyond print.html; chapter count (251 h1) is higher than the 126 sections the earlier pandoc-only build produced — full-content ebook, epubcheck still unavailable for authoritative validation.
- Site throttles bursts: standalone curl/urllib probes succeed; the earlier 987ms "unreachable" failures were the path bug, not the network. Retry/backoff exists via `grab(tries=2)`.

## Addendum 2 — epub-maker documentation (2026-08-06T23:40)

### What was done

21. Wrote `script/epub-maker/README.md` — documents the epub state machine (FETCH → ENUMERATE → PARALLEL → MERGE → CONVERT → VERIFY → EXIT(0)), per-state detail, exit states, failure behavior, usage, layout.
22. Computed epub statistics with `qalc 5.12.0` (bitacora: `qalc-epub`): compressed 210.221 KiB, uncompressed 1002.312 KiB, compression ratio 4.768×, chapters/page 2.008, savings 79.03%; wrote `script/epub-maker/qalc.md`.
23. Declared the epub-maker project: wrote `AGENTS.md` at `script/epub-maker/` (Identity, Domain, Structure, Runtime, Integrity, Precedence chain `uv format -> ruff check -> fixture -> build -> verify`, Reports). The epub-maker now counts as a project per `RUL.WORKFLOW.PROJECT.DELEGATION`.
24. Created `script/epub-maker/semantics/` — 7 atomic inference files (README index + language-model, type-system, inheritance-dispatch, memory-model, control-flow, api-scale) grounded in the epub chapters (ch004–ch015 core, term-frequency scan over 126 chapters: static 27, virtual 15, scope 13, null 13, native 11, pointer 8, override 6, final 4, abstract 4, garbage 3).
25. Converted all tables in the 8 epub-maker md files to code blocks per user instruction; grep for `^\|` confirmed zero table syntax remains.

### Decisions

- `semantics/` files each carry one topic (atomic units); README maps topics to source chapters.
- ZScript semantics inference: GC'd, VM-interpreted, virtual-dispatch OO language with a rich static-ish type layer, tuned for subclassing a C++ engine core.
- Tables banned in md files project-wide; key-value content now lives in fenced code blocks.
- The precedence chain gates epub-maker work identically to the launcher: format → lint → fixture → build → verify.

### Open edges

- epubcheck still unavailable for authoritative epub validation (7z t + zipfile verify stand in).
- Live gzdoom launch test remains pending from the launcher phase.
- The `ZScript.epub` build is deterministic across runs (215,266/215,267 B) — pandoc emits one-byte nondeterminism; both verify clean.

## Addendum 3 — custom wad convention (2026-08-06T23:45)

### What was done

26. Declared the `wad/custom/` convention: non-official custom WADs (community, user-made, modded levels) live there; official IWADs stay flat in `wad/`.
27. Updated launcher `AGENTS.md` Structure — new `wad/custom/` entry: `scan()` globs `wad/*.wad` non-recursively, so custom WADs never surface as IWAD candidates; load via `-file` like map packs.
28. Verified the scan behavior: `uv run python` probe lists 11 IWAD candidates (all flat `wad/` files), `wad/custom/` excluded; directory exists.

### Decisions

- Custom WADs are PWAD-class content (need an IWAD base), so they load via `-file`, not as IWAD menu entries.
- Non-recursive `glob("*.wad")` keeps the IWAD menu clean without code changes — the folder convention suffices.

### Open edges

- `wad/custom/` currently empty — first custom WAD lands on arrival.

## Addendum — ruff cleanup, schema registry, atelier move + push (2026-08-07T06:40)

### What was done

29. Ruff cleanup on both uv projects (bitacora: `ruff-format-*`, `ruff-check-*`, `ruff-fmtcheck-*`): `uv format` reformatted `launcher.py` (1 file), epub-maker 8 files already clean; `ruff check` zero findings on both; `ruff format --check` green (24 / 18 files); behavior gates re-passed — launcher smoke (`--list`, `--dry-run` builds the correct gzdoom cmdline), epub-maker fixture 6/6.
30. Built the download registry at `schema/` (user: "paste the url of things you download; use append and upsert protocols"): TSV seed (11 columns incl. `url` + `sha256`), then aligned to the canonical `.opencode/_schemas/seeds/` pattern — `seeds/00-ddl.sql` (wad_sources: file UNIQUE, url UNIQUE paste point, CHECKs), `seeds/01-wads.sql` (15 rows, `INSERT OR IGNORE`), `schema/wads.db` (sqlite3, 15 rows / 22,858,194 B); `scripts/{probe-header,append,upsert}.sh` — append = `INSERT OR IGNORE` (dup guard), upsert = `INSERT OR REPLACE` keyed on file; `WADS_DB=`/`CUSTOM_DIR=` env overrides; tests: append guard exit 1, upsert `MODE=updated` (sha256 matches disk), scratch insert `MODE=inserted`, 15 rows / 15 distinct urls.
31. Moved the project `_sandbox/gzdoom-launcher` → `_atelier/gzdoom-launcher` per `RING.DIRECTORY.TOPOLOGY`; updated the two AGENTS.md path references; smoke re-verified from the new location (dry-run resolves `_atelier/...`).
32. Root `.gitignore` gained the atelier exception block — track `_atelier/gzdoom-launcher/**` source; exclude `.venv/`, `__pycache__/`, `wad/`, `map/`, `mod/`, `save/`, `BrutalDoomPlatinum/`, `ZScript.epub`, `schema/wads.db`.
33. Pushed: commit `3e339ab` ("atelier/gzdoom-launcher: move from _sandbox — ruff-clean launcher, epub-maker pipeline, wad-downloader, schema registry"), 43 files / 1497 insertions, all source, zero binaries; `d622f4f..3e339ab main -> main` to `github.com/7not-nico/assembler`.
34. Post-push verification: `main` synced with `origin/main`; epub-maker `ruff check` + fixture pass from the new location.

### Decisions

- The atelier tracks source only — WAD binaries, mods, savegames, the epub artifact, the cloned mod tree, and the registry db stay out of git (root convention: exclude runtime artifacts and binary media; the seed SQL is the registry's source of truth).
- AGENTS.md files state the new absolute location per `RUL.AGENTS.STATE`; the bitacora reports keep the historical `_sandbox/` paths (history is not rewritten).
- Unrelated pre-existing working-tree deletions (`.opencode/_lib/_disabled/*.ts`) were left uncommitted — not part of this task.

### Open edges

- `_atelier/assembler-launchercli` remains untracked — the precedent project; same .gitignore exception block would track it on request.
- Live in-game `-file` load of a custom WAD remains the final user-side check.
- `schema/stud.sql` (empty stub, tracked) — candidate for removal on a cleanup pass.

## Addendum — temporal WAD fetcher (2026-08-07T06:47)

### What was done

35. Wrote `script/wad-downloader/scripts/fetch-temp.sh` — atomic temporal-WAD stage: downloads a zip via the existing `fetch-wad.sh` chain (curl -sL + 7z t verify), flattens its `.wad` files into `map/temp/` with `7z e "*.wad"`, emits `TEMP_DIR=`/`TEMP_WADS=`/`WAD=` keyed lines; the zip stays in a mktemp staging dir and dies with the script.
36. Extended `launcher.py` `scan_map()` to include `map/temp/*.wad` (non-recursive at both levels) so temporal wads appear in the map menu for `-file` testing; documented `map/temp/` + `fetch-temp.sh` in the launcher AGENTS.md.
37. Gates: `uv format` (7 files unchanged), `ruff check` all passed, smoke (`--list`, `--dry-run`) exit 0.
38. Live test (bitacora: `tempwad-fetch`, tracexec): `fetch-temp.sh levels/doom/Ports/d-f/e1m8b.zip` → `TEMP_DIR=.../map/temp`, `TEMP_WADS=1`, `WAD=.../map/temp/e1m8b.wad` (566,157 B); `scan_map()` now returns `['iddm1.wad','masterlevels.wad','nerve.wad','sigil.wad','sigil2.wad','e1m8b.wad']`.

### Decisions

- Temporal wads are a folder convention, not a flag: `map/temp/` marks disposability (`rm map/temp/*.wad` clears), and the launcher lists them alongside permanent packs.
- `7z e` flattens (nested zip layouts like `swtw/swtw.wad` land flat in `map/temp/`), matching the header-probe behavior.

### Open edges

- The user-side check is ready: `uv run launcher.py` → pick doom.wad → map menu shows e1m8b.wad → launch via `-file`.
- `map/temp/e1m8b.wad` is the live temporal fixture; delete it (`rm map/temp/*.wad`) to clear.

## Addendum — game-split temporal wads (2026-08-07T06:56)

### What was done

39. Re-split temporal wads by base game per user direction: `map/doom1-tmp/` (Doom 1) and `map/doom2-tmp/` (Doom 2) replace the single `map/temp/`; `fetch-temp.sh` gained the `<doom1|doom2>` game arg selecting the target dir; migrated `e1m8b.wad` into `doom1-tmp/` and removed `map/temp/`.
40. Fixed a case-sensitivity bug the split exposed: `hoover.zip` stores `HOOVER.WAD` uppercase, and `7z e "*.wad"` is case-sensitive on Linux — extraction produced nothing. `fetch-temp.sh` now extracts everything and moves `.wad` entries matching any case (`*.wad|*.WAD|*.Wad`).
41. Fixed the matching bug in the launcher too: Python `glob("*.wad")` is also case-sensitive, so `HOOVER.WAD` never surfaced. `scan_map()` now scans `doom1-tmp/` + `doom2-tmp/` iteratively with a case-insensitive `.lower().endswith(".wad")` check.
42. Verified live (bitacora: `tempwad-doom2`, `tempwad-doom1`, `tempwad-gates`): doom1 fetch → `map/doom1-tmp/e1m8b.wad`; doom2 fetch → `map/doom2-tmp/HOOVER.WAD`; `scan_map()` returns 7 entries (`e1m8b.wad`, `HOOVER.WAD`, 5 permanent packs); `uv format` + `ruff check` + `--dry-run` all pass.

### Decisions

- Temporal wads split by the base game they run on — `doom1-tmp/` for `doom`-game WADs, `doom2-tmp/` for `doom2`-game WADs — matching the schema `game` column; the game arg is required (no guess).
- Case-insensitive matching at both layers (shell extract, Python scan) — archive entries arrive in any case and must not be missed.

### Open edges

- User-side test ready: `uv run launcher.py` → map menu lists both temporal wads; `rm map/{doom1,doom2}-tmp/*.wad` clears them.
- `map/doom2-tmp/HOOVER.WAD` is the live doom2 fixture.

## Addendum — fixture regression layer (2026-08-07T07:15)

### What was done

43. Declared the fixture layer at `fixture/` (README: precedence `uv format -> ruff check -> fixture -> smoke -> integrity -> launch`, planned fixtures, sample data contract).
44. Refactored `.wad` extraction out of `fetch-temp.sh` into the atomic `script/wad-downloader/scripts/extract-wads.sh` helper (network fetch stays in fetch-temp; local extraction is now offline-testable — mirrors the epub-maker io/pure ring split).
45. Implemented the full suite: `fixture/run.sh` (aggregate gate, pass/fail counts), `fixture/sample/build.sh` (4 offline sample zips: pwad, iwad, uppercase `HOOVER.WAD`, no-wad), 4 Python fixtures (`scan-iwad-test.py`, `scan-map-test.py`, `scan-mods-test.py`, `command-build-test.py`) and 3 bash fixtures (`extract-wads-test.sh`, `probe-header-test.sh`, `append-upsert-test.sh` — hermetic scratch WADS_DB/CUSTOM_DIR).
46. The suite caught a real bug: `probe-header.sh` was case-sensitive (`"$Work"/*.wad` missed `HOOVER.WAD`) → `probe-error: no .wad inside`; it cascaded into the upsert-insert path (empty header → `CHECK constraint failed: header IN ('PWAD','IWAD')`). Fixed with the case-insensitive loop; also fixed the `scan-map-test` sorted assertion (Path sort is path-based, not name-based).
47. Final gates (bitacora: `fixture-final-lint`, `fixture-final`, `fetchtemp-refactor-check`): `uv format` clean, `ruff check` zero findings, `FIXTURES pass=7 fail=0` (30 checks), refactored `fetch-temp.sh doom1` live-verified (`EXTRACTED=1`, `WAD=.../map/doom1-tmp/e1m8b.wad`), launcher smoke exit 0.
48. Wrote `fixture/AGENTS.md` (Identity/Domain/Structure/Runtime/Precedence/Integrity per `RUL.AGENTS.STATE`); flipped README status boxes; `.gitignore` excludes generated `fixture/sample/*.zip`.

### Decisions

- Fixtures prove real behavior offline: Python fixtures import and call the live functions; bash fixtures run the real scripts against generated samples and a scratch db — no network, no gzdoom launch.
- The `fixture` gate sits between lint and smoke; a fixture claim requires a clean `ruff check` in the same session (same rule as epub-maker).
- The any-case `.wad` contract is guarded at every layer it lives in: `probe-header.sh`, `extract-wads.sh`, and `scan_map()`.

### Open edges

- Live in-game `-file` load remains the final user-side check.
- Commit `b7bd8b7` pushed `3e339ab..b7bd8b7` — the fixture layer, probe-header case fix, extract-wads/fetch-temp split, and game-split temp scan are in `main`; `_atelier/.gitignore` stays untracked (local-only; the root `.gitignore` guards the generated zips).

## Addendum — menu 'all' gate, folder groups, purity rings (2026-08-07T08:00)

### What was done

49. `menu_multi` gained `allow_all: bool = False` — `all` is restricted to the mods menu (`picks_mod = menu_multi(scan_mods(), "mods", allow_all=True)`); the maps menu rejects `all` (loading every map pack would crash gzdoom with duplicate lumps/conflicts). Fixture gained the guard `all without allow_all returns none` — the regression check for exactly that crash.
50. `menu_multi` now prints the numbered list **grouped by folder** (`folder_label(p)` — `doom1-tmp` → `doom1`, `doom2-tmp` → `doom2`, `map` → `map`) with headers and contiguous numbering (1–8 in the live layout); selection mapping unchanged; `FURB188` → `removesuffix`.
51. Purity-ring split per `PATTERN.PURITY.PORT.PIPELINE` (epub-maker precedent): `deps/const.py` (paths/tables/EXT/binary default — no I/O at import), `deps/pure.py` (ring 0: `folder_label`, `command(binary, path, maps, mods)`, new `parse_picks(raw, n)` — no local imports, no side effects), `deps/io.py` (ring 4: binary discovery, scans, menus, `run` — imports pure). `launcher.py` is now a thin entry with a sorted `__all__` re-export shim; fixtures and call sites unchanged.
52. Gates (bitacora: `purity-split`, `purity-final`): `uv format` clean, `ruff check` zero findings (fixed `RUF022` unsorted `__all__`), `FIXTURES pass=8 fail=0`, smoke `--dry-run` builds the exact cmdline, and a pure-ring assert matrix (parse_picks empty/single/comma/invalid/whitespace, folder_label, command) passed with no io import.

### Decisions

- Filenames follow single descriptive nouns (user rule): `deps/pure.py` + `deps/io.py`, not ring-prefixed names — mirroring the epub-maker's `fetch.py`/`extract.py`.
- `command` takes the resolved binary as its first argument — the io ring resolves it, the pure ring stays deterministic (fixture proves the preference via `launcher.binary`).
- `parse_picks` extraction makes selection logic fixture-testable with zero setup.

### Open edges

- `deps/` + the `all`-gate + folder groups are local; commit pending at the time of this addendum.

## Addendum — PythonRef.epub with staged TOC (2026-08-07T08:25)

### What was done

53. Fixed a corruption bug in `script/epub-maker/deps/fetch.py`: `except OSError, KeyError:` (Python 2 syntax, invalid on 3.14) → `except (OSError, KeyError):`; `convert()` gained a `flags=None` param defaulting to `const.Pandoc`.
54. Built the Python reference epub (`ref.py` + `Ref*` consts): first pass extracted nothing — Playwright diagnosed that docs.python.org has **no `<main>` tag** (content lives in `<div class="body" role="main">`, 34 nested divs) and that `links()` let `/bugs.html` + `/license.html` through. Fixed with a balanced `section()` (role="main") + `"/"` prefix filter; `mains()` falls back to `section()`. Build 2: `CHAPTERS=10, H1=10, FAILED=0, BYTES=186232`.
55. Proper TOC (user: "fetch each page chapter itself, descriptive name, tmp/ folder inside the epubmaker, then unify, this creates the TOC"): pandoc would not split chapters because every page wraps its h1 in `<section>` — added pure `unwrap()` (outer-section removal); `clean()` strips `¶` headerlinks; `tmp/` (git-ignored) stages descriptive `{NN}-{slug}.html` files; `ordered_links()` preserves the index's document order (the first pass used sorted links → wrong chapter order); `--epub-chapter-level=1`.
56. Verified final epub (bitacora: `ref-*` logs, tracexec everywhere): `tmp/01-introduction.html … 10-full-grammar-specification.html`, nav TOC reads 1→10 with subsections (`5. The import system` → `5.1. importlib … 5.9. References`), `TOC_ITEMS=19`, `CHAPTER_FILES=11`, `CHAPTERS=10, H1=10, FAILED=0, BYTES=200918`, `7z t` Everything is Ok; launcher gates (`FIXTURES pass=8 fail=0`) re-passed after the deps rename.
57. deps/ renamed to action verbs per user rule: `pure.py→build.py`, `io.py→launch.py`, `const.py→schema/const.py`; imports + README updated.
58. Commit `3f77113` pushed `8d9ae16..3f77113` (12 files: rename ×3, extract/fetch fixes, ref.py, docs, .gitignore).

### Decisions

- Chapters stage as descriptive files in a persistent `tmp/` (inspectable, deterministic TOC) rather than a deleted tempdir; `tmp/` + `PythonRef.epub` are git-ignored.
- Document order comes from first-appearance in the index (`ordered_links`), never from sorted hrefs.

### Open edges

- `main.py` (ZDoom) still uses sorted `links()` and `<main>` — unaffected; a `role="main"`/`unwrap` fixture sample for the epub-maker regression gate is optional.
- Live reader check of `PythonRef.epub` (chapter order + nav) is the final user-side verification.

## Addendum — deps modularization + schema step (2026-08-07T08:50)

### What was done

59. Modularized `script/epub-maker/deps/` per the action-verb file rule: the 13-function `extract.py` split into `discover.py` (links, ordered_links), `extract.py` (mains, section, unwrap, flatten), `prepare.py` (clean, title, slug, slugify), `count.py` (probe, chapters), `emit.py` (emit — the schema SQL builder, renamed from skeleton). `fetch.py` gained a corrected import (`from deps.prepare import slug` — the split moved slug out of extract, breaking fetch).
60. Renamed `enumerate.py` → `discover.py`: the module name shadowed the builtin `enumerate()` used inside `ref.py` (TypeError: module not callable).
61. Added the **schema state-machine step** to `ref.py` (user: after fetching, create a skeleton schema file in `script/epub-maker/schema/`, guided by the launcher's `schema/` registry): after staging chapters, `emit.emit(rows)` builds `page_sources` DDL + `INSERT OR IGNORE` seed (page/file UNIQUE, sha256, chapter order) and writes `schema/pages.sql` — the fetch record, mirroring `wad_sources`. Applied to a scratch sqlite db (10 rows), double-apply idempotent.
62. Extended `fixture/run_tests.py` 8 → 16 checks with a `role-main.html` sample covering the new pure functions: role-main fallback, balanced section, flatten, pilcrow clean, title, slugify, emit DDL, emit seed row. All 16 pass; ruff clean.
63. Updated epub-maker `AGENTS.md` (six-module deps layout + schema step). Commits `4d2548d` (modularization + schema step) and the fixture extension pushed to `main`.

### Decisions

- The epub-maker `deps/__init__.py` + `schema/__init__.py` deletions are committed — uv format removes them and namespace packages are valid on 3.14 (Python reference §5.2.2); the modules import cleanly without them.
- The schema skeleton is a per-build artifact (git-ignored); the launcher's `wads.db` registry stays the persistent instance of the pattern, the epub `pages.sql` the per-fetch record.

### Open edges

- Live reader check of `PythonRef.epub` (chapter order + subdivided nav) remains the final user-side verification.


## Addendum — awaitables + folding skeleton + domain derivation (2026-08-07T10:40)

### What was done

64. **Awaitable objects** in `deps/fetch.py` (user rule): `class Fetch` with `__await__` → `asyncio.to_thread(grab, …)`, `async collect` (Semaphore-bounded gather), `parallel` = sync bridge (`asyncio.run`); ThreadPoolExecutor removed. **No default arguments** (user rule): every signature declares bare parameters; call sites pass all args from `schema/const.py` (Tries=2 added). Fixture stubs `grab` to prove awaits resolve; `it.close()` clears the `to_thread` never-awaited RuntimeWarning.
65. **Phantom-time finding**: `/usr/bin/time` missing on the host — all earlier pandoc "stalls"/exit-127 failures were the missing wrapper, not pandoc. Direct multi-input conversion of 263 staged pages → `full.epub` (2,810,789 B) in ~50 s; the single-unified-19MB-HTML approach blows up RSS (6.2 GB, killed).
66. **Folding skeleton taxonomy** (user): three tiers — main headings (h1), heading (h2), sub headings (h3); each body folds on the previous (spans to the next same-or-higher heading); h4+ folds into the h3 body; each heading → atomic file in `tmp-lib/skeleton/`. Rebuilt: PAGES=263, SECTIONS=1801 (273 h1, 806 h2, 722 h3). Fixture extended to 29 checks.
67. **Domain tier** (user: "a previous tier for h1, maybe domain"): domains derive from the library index toctree. Pattern rule (`deps/discover.entries`): a category is a domain when a member follows the lib pattern — lowercase name — definition (`LIB = ^[a-z][a-z0-9_.]*\s+[—\-]\s+`); Built-in (functions, constants, types, exceptions) and Modules command-line interface (CLI) join by explicit rule; residual entries (Introduction, Thread Safety Guarantees, Removed Modules, Security Considerations) fold into the domain nearest their ordinal position — nothing drops, unmapped=0. Final: **32 domains, 263 pages, 1801 sections, 1833 atomic files**. Verified `0001-d0-built-in.html` = Introduction + 4 built-in h1s; Text Processing Services folds Thread Safety Guarantees first.
68. `deps/split.py` `sections()` = folded heading extraction (HEADING regex `<h([1-3])`, TAGS strip); `deps/emit.py` gains `sections` (section_sources DDL: order_no/page/file/level/title/size_bytes/sha256); fixture `sample/index.html` added (toctree with anchor + Built-in merge + lib titles); fixture now **34/34**.
69. Both AGENTS.md updated: epub-maker (libref.py pipeline, discover.entries/domains, split folding, lib constants, 34 tests, `--skeleton` runtime) and launcher (epub-maker section covering ref.py + libref.py four-tier skeleton).

### Decisions

- The unified epub joins **domain files only** (level 0) — each fold chain contributes once; the 1801 section files serve measurement + manifest (`lib-sections.sql`), not the epub body.
- `slug("index.html")` returns "index.html" — `grab` writes `index.html.html`; the libref index read follows that pattern.
- Domain selection lives in `libref.py` assembly (pattern OR kept titles); `discover` stays pure (catalog + pattern detection).

### Open edges

- Epub phase pending: multi-input pandoc over the 32 domain files (`--toc --toc-depth=4 --split-level=1`, metadata title/author), then `fetch.verify` + `7z t`.
- Live reader check of `PythonLibRef.epub` (domain order + nav depth) remains final user-side verification.

## Addendum — 39-domain model + full-tree TOC (2026-08-07T11:35)

### What was done

70. **39-domain model per `heading-format/libdomain.md`** (user: authoritative spec — "domains begin with #, each domain begins on each #"): every toctree-l1 entry is a domain; no merge, no pattern filter, no residual fold. Built-in Functions, Built-in Constants, Built-in Types, Built-in Exceptions stand separate; Introduction, Thread Safety Guarantees, Modules CLI, Superseded, Removed, Security each a domain. `discover.entries()` returns every l1 entry as `(title, page, kids, lib)`; `domains()` = all entries. `libref.py` assembly: `members` = all catalog entries, bucket = `.html` children only (landing page tracked in `assigned`); domain file = `<h1>{title}</h1>` + `strip_h1(landing body)` — landing h2s are the anchor members (`## Truth Value Testing`), NOT demoted — + `demote(child pages)` (`## string — Common string operations`). Manifest row `page` = l1 href; section loop covers `[page] + kids` so anchors get rows. Rebuilt: **PAGES=263, DOMAINS=39, SECTIONS=1801, H1=273, unmapped=0**, 1840 sql rows.
71. **`strip_h1` anchor-prefix fix** (`deps/split.py`): landing bodies start with whitespace + `<span id="…"></span>` before the h1, so the `^<h1>` anchor missed and domain files carried duplicate h1s. New `LEAD` regex tolerates the prefix; fixture check "strip h1 anchor prefix" added → **38/38**.
72. **No silent folds** (user: "we cannot have silent folds"): `LibPandoc` `--toc-depth=2` → `--toc-depth=4` so all four fold tiers appear in the TOC. Rebuilt epub: FAILED=0, BYTES=2,396,804, `7z t` Everything is Ok, 47 files; TOC = 1 title + 39 domains + 266 members + 819 h3 + 743 h4 = **1868 navPoints** (was 306 at depth ≤2).

### Decisions

- The landing page body is NOT demoted — its h2s ARE the anchor members at `##`; only `.html` child pages demote one level.
- `_needorder-map/` and `.backup/` untracked dirs left unstaged — not part of this work.

### Open edges

- Live reader check of `PythonLibRef.epub` (domain order + four-tier nav) remains final user-side verification.
