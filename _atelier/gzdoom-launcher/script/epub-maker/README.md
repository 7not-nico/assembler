# Epub-maker

Epub-maker builds the ZDoom docs ebook. It fetches the staging site's pages, merges the sidebar pages into the print document, and converts the result with pandoc into `ZScript.epub` at the launcher root.

## State machine

The pipeline runs six states in sequence. Each state completes before the next starts; no state loops back.

```text
FETCH → ENUMERATE → PARALLEL → MERGE → CONVERT → VERIFY → EXIT(0)
```

```text
State       Action                                          Output
fetch       grab(print.html) + grab(ZScript.html)           two html files in the temp dir
fail-guard  book.is_file() and toc.is_file() checks         return 1 on absence
enumerate   extract.links(toc)                              sorted unique page list (125)
parallel    fetch.parallel(pages, 16 workers)               fetched page count
merge       mains → probe → dedupe against print content    merged count + body html
convert     pandoc final.html → ZScript.epub                epub file
verify      zipfile.testzip() + mimetype check              exit 0 or 1
```

### Fetch

`fetch.grab(page, base, dest)` downloads one page into `dest/{slug(page)}.html` and retries twice on `OSError`. The request carries the `epub-maker/0.1` user agent.

### Enumerate

`extract.links()` parses the sidebar html for `.html` hrefs, drops `index.html`, `print*`, and external links, sorts the rest uniquely.

### Parallel

`fetch.parallel()` submits every page to a 16-worker thread pool. Each worker runs `grab` with a 12 s timeout. The function returns the success count.

### Merge

For each fetched page, `extract.mains()` extracts the `<main>` sections; `extract.probe()` fingerprints the first 200 characters; when the fingerprint does not appear in the print document, the main sections append to the body. The merged body inserts before `</body>`.

### Convert

`fetch.convert()` runs pandoc with epub3 output, `--toc`, `--toc-depth=2`, and title/author metadata. Pandoc emits duplicate-identifier warnings — the source anchors repeat across pages; the warnings are cosmetic.

### Verify

`fetch.verify()` opens the epub as a zipfile, runs `testzip()`, and reads the `mimetype` entry. Both must pass for exit 0.

## Exit states

```text
0   epub verified intact
1   fetch failure (print or toc missing), or verify failure
```

## Failure behavior

- Site throttling: `grab` retries twice; a run that fails at fetch reports `fetch failed — site unreachable` on stderr and exits 1
- A failed fetch at the parallel stage reduces `FETCHED`; pages that never download simply skip the merge
- Verify failure leaves a partially written epub — the file may exist without a valid archive

## Usage

```bash
uv run python main.py            # default: staging site
uv run python main.py <base>     # alternate site base
```

## Layout

- `main.py` — orchestrator; the state machine
- `deps/fetch.py` — io ring: grab, parallel, convert, verify
- `deps/extract.py` — pure ring: links, slug, mains, probe, chapters
- `schema/const.py` — constants
- `fixture/run_tests.py` — 8 tests over `fixture/sample/`
- `semantics/` — ZScript semantics inference files

## References

- `AGENTS.md` at the launcher root (precedence chain)
- bitacora `epub-maker-build` logs under `.opencode/_bitacora/task-stdout/`
