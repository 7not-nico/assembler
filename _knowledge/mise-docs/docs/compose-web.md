---
name: compose-web
description: Use this skill when researching topics that require both web search and browser automation — it composes parallel-search MCP for discovery and Playwright MCP for deep-page crawling
state-profile: stateless
type: procedure
related: [use-parallel-search, use-playwright-core, use-playwright-debug, use-playwright-network-storage, use-playwright-vision, use-context-seven]
---

**Compose Web Research** — parallel-search MCP for discovery, Context7 for library docs, Playwright for deep-dive. Always in this order.

Multiple Playwright skills exist — consult each for its domain: `use-playwright-core` (navigation, clicks, typing), `use-playwright-debug` (evaluate, screenshots, network), `use-playwright-network-storage` (mocking, auth), `use-playwright-vision` (mouse coordinates).

## Procedure

1. **Search** — call `parallel-search_web_search` with 2-3 focused queries:

   ```
   queries: ["keyword1 research topic", "keyword2 best practices", "keyword3 comparison"]
   objective: "What I need to find"
   ```

2. **Fetch** — if excerpts insufficient, call `parallel-search_web_fetch` on specific URLs with `objective`. Batch multiple URLs per call.

3. **Library docs** — for SDK/API/framework docs, use `context7_resolve_library_id` then `context7_query_docs` per `use-context-seven`

4. **Navigate** — for interactive/dynamic/JS pages, switch to Playwright:

   ```
   playwright_browser_navigate(url)
   playwright_browser_snapshot
   playwright_browser_find(text)
   ```

5. **Interact** — per `use-playwright-core`:
   - `browser_click`
   - `browser_type`
   - `browser_fill_form`
   - `browser_select_option`

6. **Extract** — per `use-playwright-debug`:
   - `browser_evaluate`
   - `browser_take_screenshot`
   - `browser_console_messages`
   - `browser_network_requests`

7. **Log** — call `mcp-log-search` to record findings.

## When to use each

| Scenario | Tool |
|----------|------|
| Factual question, current info | parallel-search |
| SDK/API/framework docs | Context7 resolve + query |
| Full article, exact quotes | parallel-search web_fetch |
| JS-rendered page, dynamic content | Playwright navigate |
| Form submission, login flow | Playwright click + type |
| API inspection, network debug | Playwright network_requests |

## Gotchas

- parallel-search first, Playwright second
- `full_content: true` returns large output
- `browser_snapshot` captures accessibility tree, not visual — use `browser_take_screenshot` for visual
- `browser_find(text)` cheaper than full `browser_snapshot`
- Playwright runs locally — Local resource constraints (RAM, CPU) only.
- Context7 has 3 calls per question limit — batch related queries into one call.

## CAPTCHA handling

Academic sites (JSTOR, ACM, ScienceDirect) may CAPTCHA-block automated access. Follow `RUL.CAPTCHA.GATE`:
pause the flow, report the blocked URL, prompt user to solve in the browser session, then resume.
