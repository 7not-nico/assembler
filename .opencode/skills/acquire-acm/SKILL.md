---
name: acquire-acm
description: Use this skill when downloading PDFs from ACM DL — it navigates to the DOI page, clicks the download button via Playwright, captures the download event, and saves with verification
state-profile: hybrid
related: ["SKL.ACQUIRE.PAPERS", "SKL.USE.PLAYWRIGHT.CORE", "SKL.USE.PLAYWRIGHT.DEBUG"]
---
**Procedure**

- 1. **Navigate** — `browser_navigate` to `dl.acm.org/doi/{DOI}`, `waitUntil: 'networkidle'`
- 2. **Click download** — `a[href*="download=true"]` (primary) or `span:has-text("Download PDF")` (secondary)
- 3. **Capture** — `page.waitForEvent('download')` before click, `download.saveAs(absolutePath)` after
- 4. **Verify** — `file {path}.pdf | grep PDF` confirms PDF; confirm file size exceeds 1KB
- 5. **Register** — `registerPaper({...}, filePath)` with `source_url: https://doi.org/{doi}`

**Batch workflow**

- Script via `browser_run_code_unsafe` — register download listener, loop over DOIs, click, save
- Per iteration: `waitForEvent → click → saveAs`
- Check DB before each download — process new papers after verification

**Selector priority**

1. `a[href*="download=true"]` — targets PDF download link directly
2. `span:has-text("Download PDF")` — resilient if ACM changes anchor markup
3. Inline download button in DOM — snapshot to locate before clicking

**Rules**

- Playwright download-event primary — use `waitForEvent('download')` + `saveAs(absolutePath)` for ACM
- Absolute paths for `saveAs()` — confirm path starts with `/` for correct output location
- `file`-verify every download — ACM may return HTML instead of PDF
- Check DB before downloading — register papers new to database
- Batch via `browser_run_code_unsafe` for multi-paper sessions

**Gotchas**

- `download.saveAs(path)` uses `.playwright-mcp/` as CWD — always pass absolute paths
- ACM DL Basic Edition serves PDFs via click-to-download — use Playwright download-event for `/doi/` pages
- Papers requiring institutional access — confirm download button visible before proceeding
- `waitForEvent('download')` registers listener *before* click — correct order ensures capture
- Snapshot page before clicking to verify the download button exists on current layout

**See also**

- `SKL.ACQUIRE.PAPERS` — generic paper acquisition (curl primary)
- `SKL.USE.PLAYWRIGHT.CORE` — browser navigation and click tools
- `SKL.USE.PLAYWRIGHT.DEBUG` — `browser_run_code_unsafe` for batch scripts
