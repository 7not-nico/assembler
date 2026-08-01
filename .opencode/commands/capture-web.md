---
description: Recursively crawl a doc site and capture all child pages as a single EPUB
subtask: true
---

Recursively capture `$ARGUMENTS` and child links as EPUB

1. Ensure pandoc installed — `which pandoc`
2. Navigate Playwright browser to `$ARGUMENTS` — `browser_navigate`
3. Extract all same-origin child links via `browser_evaluate`:

   ```js
   Array.from(document.querySelectorAll('a[href^="/" i], a[href^="' + location.origin + '" i]'))
     .map(a => a.href.split('#')[0])
     .filter((v, i, a) => a.indexOf(v) === i)
   ```

   Filter to links under the same path prefix (child pages only).
4. For each unique URL (including the base page):
   - `browser_navigate` to URL
   - Wait for load
   - `browser_evaluate` → `document.documentElement.outerHTML`
   - Write HTML to `$TMPDIR/{slug}.html`
5. Concatenate into single EPUB with pandoc — each file becomes a chapter:

   ```bash
   pandoc -f html -t epub \
     --embed-resources --standalone \
     --toc --toc-depth=2 \
     --metadata title="$TITLE" \
     --metadata author="$AUTHOR" \
     -o $OUTPUT.epub \
     $TMPDIR/*.html
   ```

6. Move EPUB to target directory
7. Verify — `file $OUTPUT.epub` and check size

**Edge cases**: skip anchor-only links (`#section`), deduplicate URLs, respect `$MAX_DEPTH` (default 1 — direct children only)
