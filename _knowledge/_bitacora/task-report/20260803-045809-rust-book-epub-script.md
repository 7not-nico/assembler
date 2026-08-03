# rust-book-epub-script

Timestamp: 2026-08-03 20260803-045809

## What was done

- Probed the Rust Book site structure (`probe-book-structure`, `probe-chapter-structure`): mdBook `print.html` = whole book in one page — 1.8 MB, 112 `<h1 id="...">` chapters, 28 distinct `img/...` refs, sidebar iframe → `toc.html`.
- Tested pandoc HTML→EPUB3 conversion (`pandoc-epub-test`, `pandoc-abs-url-test`): chapter splitting into `ch001.xhtml`…, images embedded only after resolving relative refs.
- Wrote `script/fetch-epub.rb` — Functional Ruby, stdlib only (`net/http`, `open3`, `tempfile`, `fileutils`): fetch print.html → batched local image download (`curl --parallel --parallel-max 8 --max-time 8`) → rewrite src to local paths → strip sidebar iframe → `timeout 120 pandoc -t epub3`; emits keyed stage lines (`FETCH=`, `IMGS=`, `CONVERT=`, `EPUB=`, `SIZE=`).
- Tested end-to-end (`fetch-epub-test`, `fetch-epub-batch-test`): 111 chapters, 28 images, 1.5 MB, exit 0, ~8 s.
- Validated via calibre (`epub-validate*`): `ebook-convert` round-trips cleanly.
- Added `DUR` (ms) to `script/run-logged.sh` after `DATE`, with output buffering + `trap` cleanup; verified 1004 ms / 503 ms (`dur-test`, `dur-order-test`, `dur-final-check`).
- Verified tracexec 0.17.0 exec capture (`tracexec-fetch-test`, `tracexec-flags-test`).
- Updated `rust-docs/AGENTS.md`: Tools table (rg, ruby, curl, pandoc, ebook-convert, zip/unzip, wget, jq, tracexec, run-logged.sh, bitacora-*), Scripts line for `fetch-epub.rb`.

## Decisions

- `print.html` single-page fetch over 112 chapter fetches — one request, complete coverage.
- Local image download with curl timeouts over pandoc network fetch — pandoc fetches without timeouts and stalls on slow CDN.
- pandoc primary converter, calibre `ebook-convert` for validation only.
- `Open3` over `system()`/backticks — argv arrays, no shell interpolation.
- Staged keyed output over silent runs — silent scripts read as "stalled engine".

## Open edges

- None blocking — EPUB builds and validates; images 28/28 verified present (20260803-051614 report).

## Todo state

- [x] probe rust-book site structure (print.html, chapters, images)
- [x] write `script/fetch-epub.rb`
- [x] test the script end-to-end, verify EPUB output
- [x] update rust-docs/AGENTS.md — Tools section
- [x] close todo, write report

Logs: `probe-book-structure`, `probe-chapter-structure`, `pandoc-epub-test`, `pandoc-abs-url-test`, `fetch-epub-test`, `fetch-epub-batch-test`, `epub-validate*`, `dur-test`, `dur-order-test`, `tracexec-*` → `_knowledge/_bitacora/task-stdout/`.
