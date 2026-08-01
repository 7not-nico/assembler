# PASS.URL.TO.PLAYWRIGHT — pass search result URLs into Playwright

Every URL found via any search MCP (exa, parallel-search, or other) must be passed as a `playwright_browser_navigate` target to verify the source content directly in the browser.

Procedure:
1. Execute web search via MCP (exa, parallel-search, etc.)
2. Take the most authoritative result URL from the search results
3. Pass it directly to `playwright_browser_navigate`
4. Capture a snapshot of the page
5. Present the verified text in conversation
6. Only then proceed to write

Search excerpts are previews, not sources. The browser-verified page is the source. No URL from a search result is trusted until it has been opened and snapshotted via Playwright.

Composes with: BROWSE.AFTER.SEARCH, WRITE.BROWSER.FIRST, SHOW.SPEC.EXTRACT.FIRST
