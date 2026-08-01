# COMPOSE.WEB.SEARCH.FIRST — search before Playwright navigation

Before navigating to any page with Playwright, first use web search (exa or parallel-search MCP) to discover the correct URL.

Procedure:
1. Search using `exa_web_search_exa` or `parallel-search_web_search` with focused queries
2. Review search results to identify the correct official reference URL
3. Only then navigate with `playwright_browser_navigate` to the confirmed URL

This prevents blind navigation, dead links, and non-authoritative sources.

Exceptions: known URLs previously confirmed in the same session may be navigated directly.
