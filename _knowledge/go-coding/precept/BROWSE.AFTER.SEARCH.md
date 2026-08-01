# BROWSE.AFTER.SEARCH — open pages in Playwright after every MCP search

After every MCP parallel-search or exa search, open the top result URLs in Playwright to verify and extract full content. Search excerpts are summaries — the full page is the authoritative source.

## Procedure

1. Run MCP search (parallel-search or exa) with 2-3 queries
2. Identify the top 1-2 result URLs from the search results
3. Open each URL using `playwright_browser_navigate(url)`
4. Extract relevant content using `playwright_browser_evaluate` with `document.getElementById()` or `playwright_browser_find`
5. Verify the extracted content matches the search excerpt
6. Only then write reference files or code

## Why

- Search excerpts truncate — full page may contain nuances or corrections
- Dynamic pages (JS-rendered) need a real browser to render fully
- Official spec pages (go.dev, docs.ruby-lang.org) have anchor-linked sections that Playwright can target precisely
- CAPTCHA-gated pages (JSTOR, ACM) require human intervention per RUL.CAPTCHA.GATE

## Exception

If the search result is from a known-static source (raw GitHub markdown, Go Spec plain text, Ruby docs) and the excerpt contains the full relevant text, browsing is optional. When in doubt, browse.

## Composes with

- SOURCE.DOCS.PLAYWRIGHT — using Playwright to source documentation
- STUDY.SOURCE.BEFORE.CODE — study before writing code
- REFERENCE.ATOMIC.SOURCE — reference files cite exact source URLs
