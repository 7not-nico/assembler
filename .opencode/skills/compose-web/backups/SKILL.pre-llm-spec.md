---
name: compose-web-research
description: Use this skill when researching topics that require both web search and browser automation — it composes parallel-search MCP for discovery and Playwright MCP for deep-page crawling
state-profile: stateless
type: procedure
related: [use-parallel-search, use-playwright-core, use-playwright-debug, use-playwright-network-storage, use-playwright-vision]
---

**Compose Web Research** — parallel-search MCP for discovery, Playwright for deep-dive. Always in this order.

## Procedure

1. **Search** — call `parallel-search_web_search` with 2-3 focused queries:

   ```
   queries: ["keyword1 research topic", "keyword2 best practices", "keyword3 comparison"]
   objective: "What I need to find"
   ```

2. **Fetch** — if excerpts insufficient, call `parallel-search_web_fetch` on specific URLs with `objective`. Batch multiple URLs per call.

3. **Navigate** — for interactive/dynamic/JS pages, switch to Playwright:

   ```
   playwright_browser_navigate(url)
   playwright_browser_snapshot
   playwright_browser_find(text)
   ```

4. **Interact** — per `use-playwright-core`:
   - `browser_click`
   - `browser_type`
   - `browser_fill_form`
   - `browser_select_option`

5. **Extract** — per `use-playwright-debug`:
   - `browser_evaluate`
   - `browser_take_screenshot`
   - `browser_console_messages`
   - `browser_network_requests`

6. **Log** — call `mcp-log-search` to record findings.

## When to use each

| Scenario | Tool |
|----------|------|
| Factual question, current info | parallel-search |
| Full article, exact quotes | parallel-search web_fetch |
| JS-rendered page, dynamic content | Playwright navigate |
| Form submission, login flow | Playwright click + type |
| API inspection, network debug | Playwright network_requests |

## Gotchas

- parallel-search first, Playwright second
- `full_content: true` returns large output
- `browser_snapshot` captures accessibility tree, not visual — use `browser_take_screenshot` for visual
- `browser_find(text)` cheaper than full `browser_snapshot`
- Playwright runs locally — no external rate limits. Local resource constraints (RAM, CPU) only.
