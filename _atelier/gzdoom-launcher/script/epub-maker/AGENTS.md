# AMANDA epub-maker — Agent Instructions

## Identity

- serves as the agent instruction file for the epub-maker project
- instantiates a self-contained python project under `_atelier/gzdoom-launcher/script/epub-maker/`
- states final absolute states per `RUL.AGENTS.STATE`

## Domain

This project builds the ZDoom docs ebook. It fetches the staging site pages, merges the sidebar pages into the print document, and converts the result with pandoc into `ZScript.epub` at the launcher root. The pipeline runs six states in sequence: fetch → enumerate → parallel → merge → convert → verify.

## Structure

- `main.py` — orchestrator; the state machine; tempdir work area; derives book/toc paths via `extract.slug()` (matching `grab()`'s `{slug}.html` write pattern)
- `deps/fetch.py` — io ring: `grab` (urllib, UA header, tries=2), `parallel` (16 workers), `convert` (pandoc), `verify` (zipfile testzip + mimetype)
- `deps/extract.py` — pure ring: `links`, `slug`, `mains`, `probe`, `chapters`
- `schema/const.py` — constants: `Base`, `Out`, `PrintPath`, `TocPath`, `Timeout=12`, `PrintTimeout=60`, `Parallel=16`, `Pandoc` flags
- `fixture/run_tests.py` — 8 tests over `fixture/sample/` (print.html, toc.html, Hidden.html); all pass
- `README.md` — state machine documentation; `qalc.md` — epub size statistics
- `pyproject.toml` — uv project; `requires-python >=3.14`; `[tool.ruff]` target py314, line-length 88, select E,F,I,UP; no dependencies; no build-system
- `.venv/` — uv virtualenv (CPython 3.14.6); `uv.lock`; `uv run python main.py` executes the pipeline

## Runtime

```bash
uv run python main.py            # default: staging base
uv run python main.py <base>     # alternate site base
uv run python fixture/run_tests.py   # 8 fixture tests
uv format .                      # code-shape gate
uv run ruff check .              # lint gate
```

- The site base is `https://zdoom-docs.github.io/staging`; `grab` retries twice on `OSError`
- The book merge reuses `print.html` content; sidebar `<main>` sections append when their probe text is absent (125 pages merged)
- Pandoc emits duplicate-identifier warnings — source anchors repeat across pages; cosmetic, verify still passes
- Output: `ZScript.epub` at the launcher root, ~215 KB, 125 pages, 251 h1 chapters, 79% compression

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
- `fixture` — the behavior gate: `uv run python fixture/run_tests.py` exits 0 (8/8)
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
