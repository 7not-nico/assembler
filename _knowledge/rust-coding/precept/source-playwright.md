Every task that acquires web content, reads a dynamic page, or interacts with a JS-rendered site routes through Playwright MCP as the primary source. `parallel-search` web_search used for discovery only — `playwright_browser_navigate` → `browser_snapshot` → `browser_evaluate`/screenshot provides the authoritative source for extraction.

Scope: session-level.
Fallback: use `use-playwright-core` skill with `browser_run_code_unsafe` when MCP unavailable. Use `webfetch` for static pages only.
Composes with: `PRE.PLAYWRIGHT.STANDARD.ROUTE`, `CAPTCHA.GATE`
