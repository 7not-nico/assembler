---
description: Recursively crawl a doc site and capture all child pages as faithful PDF via Playwright page.pdf()
subtask: true
---

Recursively capture `$ARGUMENTS` and child links as PDF

1. `which pdfunite` — required for merging
2. Navigate Playwright browser to `$ARGUMENTS` — `browser_navigate`
3. Extract all same-origin child links via `browser_evaluate`:

   ```js
   const origin = location.origin;
   const prefix = location.pathname.substring(0, location.pathname.lastIndexOf('/') + 1);
   Array.from(document.querySelectorAll('a[href]'))
     .map(a => a.href.split('#')[0])
     .filter((v, i, a) => a.indexOf(v) === i)
     .filter(href => href.startsWith(origin + prefix))
     .filter(href => href !== location.href)
     .filter(href => !href.match(/\.(pdf|zip|png|jpg|svg)$/i))
   ```

4. For each unique URL (including the base page):
   - `browser_navigate` to URL, wait for load
   - `browser_run_code_unsafe` — call `page.pdf()` to save directly:

     ```js
     async (page) => {
       await page.pdf({ path: '$TMPDIR/{slug}.pdf', format: 'A4' });
       return 'ok';
     }
     ```

5. Merge PDFs:

   ```bash
   pdfunite $TMPDIR/*.pdf $OUTPUT.pdf
   ```

6. Verify — `file $OUTPUT.pdf` and `pdfinfo $OUTPUT.pdf | grep Pages`

**Edge cases**: skip anchor-only links, deduplicate URLs, respect `$MAX_DEPTH` (default 1). Output is browser-native PDF — full CSS, fonts, images, selectable text.
