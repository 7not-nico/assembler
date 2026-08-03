# playwright-missing-images

Timestamp: 2026-08-03 20260803-051614

## What was done

- Audited image refs in `print.html` (`img-refs-audit`): 28 distinct `img/...` refs — 23 SVG (ferris, trpl04/15/17 diagrams) + 5 PNG (trpl14, trpl21).
- Audited EPUB media contents (`epub-media-audit`): 28 media files embedded (`EPUB/media/file0.svg` … `file27.png`).
- Cross-referenced refs ↔ EPUB media (`verify-images`): 28/28 match — ALL PRESENT, none missing, none empty, 1,146,992 total image bytes.
- Content-integrity check (`verify-image-content`): every SVG starts with `<svg`/`<?xml`, every PNG with the `\x89PNG` magic — no HTML error-page substitutions. VERDICT: ALL VALID IMAGE CONTENT.
- Closed todo `2026-08-03--playwright-missing-images.md`.

## Decisions

- Playwright NOT needed — curl downloads were complete; no browser pass required.
- The "9 of 37 do not embed" open edge from the epub session was a miscount: the 37 figure included 9 JS `src=` refs (book-*.js, ferris-*.js, etc.), not images. Actual image set = 28, all embedded.
- Content-magic verification (first bytes) chosen over browser render check — sufficient for byte-level integrity.

## Open edges

- None — the EPUB is image-complete (28/28 refs embedded, valid content).

## Todo state

- [x] audit image refs in print.html — 28 found
- [x] verify EPUB media contents — 28 embedded
- [x] cross-reference refs ↔ media — all present
- [x] content-integrity check — all valid
- [x] close todo + report — done

Logs: `playwright-imgs-todo`, `img-refs-audit`, `epub-media-audit`, `verify-images`, `verify-image-content`, `bitacora-imgs-close` → `_knowledge/_bitacora/task-stdout/`.
