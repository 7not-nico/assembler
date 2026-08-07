# AMANDA epub-maker — Agent Instructions

## Identity

- serves as the agent instruction file for the epub-maker project
- instantiates a self-contained python project under `_atelier/gzdoom-launcher/script/epub-maker/`
- states final absolute states per `RUL.AGENTS.STATE`

## Domain

This project builds the ZDoom docs ebook. It fetches the staging site pages, merges the sidebar pages into the print document, and converts the result with pandoc into `ZScript.epub` at the launcher root. The pipeline runs six states in sequence: fetch → enumerate → parallel → merge → convert → verify.

## Structure

- `main.py` — orchestrator; the state machine; tempdir work area; derives book/toc paths via `extract.slug()` (matching `grab()`'s `{slug}.html` write pattern)
- `ref.py` — Python language reference orchestrator: fetch index → enumerate chapters (ordered) → fetch each into `tmp/` as a descriptive `{NN}-{slug}.html` → schema step (emit `schema/pages.sql` skeleton) → unify into `tmp/unified.html` → pandoc convert → verify; writes `PythonRef.epub` at launcher root (202 KB, 10 chapters, subdivided 76-entry TOC); `tmp/` and `schema/pages.sql` are git-ignored artifacts
- `libref.py` — Python standard library orchestrator: fetch index → ordered links (263 pages) → parallel fetch → stage into `tmp-lib/` → derive domains from the index toctree → split domains + headings into `tmp-lib/skeleton/` atomic files → emit `schema/lib-sections.sql` + `schema/lib-pages.sql` → `--skeleton` stops before pandoc; prints `PAGES/DOMAINS/SECTIONS/H1/FAILED/BYTES/EPUB`; writes `PythonLibRef.epub` at launcher root; `tmp-lib/`, `lib-sections.sql`, `lib-pages.sql` are git-ignored
- `deps/fetch.py` — io ring: `grab` (urllib, UA header, tries param), `Fetch` (awaitable download unit, `__await__` → `asyncio.to_thread`), `collect` (async bounded gather), `parallel` (sync bridge via `asyncio.run`), `convert` (pandoc, flags param), `verify` (zipfile testzip + mimetype); no default arguments — every call site passes all args from `schema/const.py`
- `deps/discover.py` — pure: `links`, `ordered_links` (page enumeration; ordered preserves the index's document order), `entries` (toctree catalog as (title, page, kids, lib); every toctree-l1 entry returns as its own domain — no merge, no filter; kids hold .html child pages only; anchor sections live inside the entry's own page body; lib = lowercase name — definition pattern), `domains` (all entries)
- `deps/extract.py` — pure: `mains`, `section` (balanced role="main" divs), `unwrap`, `flatten` (container extraction)
- `deps/prepare.py` — pure: `clean` (¶ headerlinks), `title`, `slug`, `slugify` (content prep + naming)
- `deps/count.py` — pure: `probe`, `chapters` (structure measurement)
- `deps/split.py` — pure: `sections` (heading-anchored section extraction; four-tier folding — a section body spans to the next same-or-higher heading, so a domain folds its h1s, an h1 folds its h2s, an h2 folds its h3s, h4+ folds into the h3 body), `demote` (bump tier headings one level deeper), `strip_h1` (drop the leading h1 and its anchor-prefix span)
- `deps/emit.py` — pure: `emit` (page_sources DDL + INSERT OR IGNORE seed for the schema step), `sections` (section_sources DDL with order_no/page/file/level/title/size_bytes/sha256)
- `schema/const.py` — constants: `Base`, `Out`, `PrintPath`, `TocPath`, `Timeout=12`, `PrintTimeout=60`, `Parallel=16`, `Tries=2`, `Pandoc` flags, `LibBase`, `LibIndex`, `LibTmp`, `LibSkeleton`, `LibSchema`, `LibSections`, `LibOut`, `LibTitle`, `LibAuthor`, `LibPandoc`
- `fixture/run_tests.py` — 38 tests over `fixture/sample/` (print.html, toc.html, Hidden.html, role-main.html, index.html); all pass
- `README.md` — state machine documentation; `qalc.md` — epub size statistics
- `pyproject.toml` — uv project; `requires-python >=3.14`; `[tool.ruff]` target py314, line-length 88, select E,F,I,UP; no dependencies; no build-system
- `.venv/` — uv virtualenv (CPython 3.14.6); `uv.lock`; `uv run python main.py` executes the pipeline

## Runtime

```bash
uv run python main.py            # default: staging base
uv run python main.py <base>     # alternate site base
uv run python libref.py          # standard library: full pipeline to PythonLibRef.epub
uv run python libref.py --skeleton   # skeleton only: domains + atomic files, no pandoc
uv run python fixture/run_tests.py   # 38 fixture tests
uv format                          # code-shape gate (no args; `uv format .` errors)
uv run ruff check .              # lint gate
```

- The site base is `https://zdoom-docs.github.io/staging`; `grab` retries twice on `OSError`
- The book merge reuses `print.html` content; sidebar `<main>` sections append when their probe text is absent (125 pages merged)
- Pandoc emits duplicate-identifier warnings — source anchors repeat across pages; cosmetic, verify still passes
- Output: `ZScript.epub` at the launcher root, ~215 KB, 125 pages, 251 h1 chapters, 79% compression
- The standard-library skeleton derives 39 domains from the index toctree per `heading-format/libdomain.md`: every toctree-l1 entry is a domain (Built-in Functions, Built-in Constants, Built-in Types, Built-in Exceptions, Introduction, Thread Safety Guarantees, Modules command-line interface (CLI), Superseded, Removed, Security, and the 26 categories) — no merge, no filter, no residual folding; each domain file begins `<h1>{title}</h1>`, the landing page body (h1 stripped) carries anchor sections at their natural level, and each `.html` child page demotes one level — nothing drops, unmapped=0
- Library skeleton counts: 263 pages, 39 domains, 1801 section files (273 h1, 806 h2, 722 h3) in `tmp-lib/skeleton/`; the epub unifies the 39 domain files (level 0) so each fold chain contributes once; `LibPandoc` carries `--toc-depth=4` so every fold tier appears in the TOC (1 title + 39 domains + 266 members + 819 h3 + 743 h4 = 1868 navPoints); `PythonLibRef.epub` verifies at 2,396,804 B compressed, 47 files

## Integrity

- `fetch.verify` runs zipfile `testzip()` and reads the `mimetype` entry (`application/epub+zip`); exit 0 requires both
- Independent check: `7z t ZScript.epub` reports "Everything is Ok" (133 files, 215,267 B compressed, 1,026,367 B uncompressed)
- A failed fetch at the print/toc stage exits 1 with `fetch failed — site unreachable` on stderr; failed parallel fetches reduce `FETCHED` and skip the merge

## Precedence chain

Epub-maker work advances in chain order; each gate passes before the next stage runs.

```text
uv format -> ruff check -> fixture -> build -> verify
```

- `uv format` — the code-shape gate; format precedes lint
- `ruff check` — the lint gate; zero findings required (select E,F,I,UP)
- `fixture` — the behavior gate: `uv run python fixture/run_tests.py` exits 0 (38/38)
- `build` — the pipeline gate: `uv run python main.py` exits 0, `FAILED=0`
- `verify` — the archive gate: `7z t` clean, mimetype correct

Examples:

- `uv format -> fixture` — a formatting pass precedes any test run
- `ruff check -> build` — lint gates the pipeline; a failing lint blocks the build claim
- `fixture -> build` — tests pass before a full fetch runs
- `build -> verify` — the epub lands only after `FAILED=0`; a verify failure blocks delivery

The forbidden state is a later-stage artifact whose predecessor never happened — a delivered epub with no passing build, a build claim against unformatted code.

## Reports and todos

- bitacora records live under the workspace root `.opencode/_bitacora/` per the root `AGENTS.md`
- every command pipes through `bash .opencode/_bitacora/bitacora-log.sh {name} -- {command}`
- build logs: `epub-maker-build`, `epub-maker-trace`, `qalc-epub` under `.opencode/_bitacora/task-stdout/`
- task report: `.opencode/_bitacora/task-report/20260806-gzdoom-launcher.md` (addendum items 15–20)
