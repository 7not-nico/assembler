# BROWSE.AFTER.SEARCH — browse into search result URLs via Playwright

Every web search (exa, parallel-search, or any search MCP) must be followed by browsing into at least one result URL via Playwright to verify the source directly.

Procedure:
1. Execute web search via MCP (exa, parallel-search, etc.)
2. Select the most authoritative result URL (official spec, standard, or documentation)
3. Open it via `playwright_browser_navigate`
4. Capture a snapshot or screenshot of the page
5. Present the verified text in conversation
6. Only then write the file

Search excerpts alone are insufficient. The browser-verified source text is the ground truth. This prevents relying on truncated or out-of-context excerpts.

Composes with: SHOW.SPEC.EXTRACT.FIRST, WRITE.BROWSER.FIRST, COMPOSE.WEB.SEARCH.FIRST
