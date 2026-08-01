# compose-web — Web Research Pipeline

**Purpose** — research toolchain: parallel-search → Context7 → Playwright → log-search.

## Procedure

1. `parallel-search_web_search` — 2-3 focused queries + objective
2. `parallel-search_web_fetch` — specific URLs when excerpts insufficient
3. `context7_resolve_library_id` → `context7_query_docs` — SDKs and frameworks
4. Playwright — dynamic JS-rendered pages
5. Interact — click, type, fill forms per use-playwright-core
6. Extract — evaluate, screenshot, network requests
7. `mcp-log-search` — record findings

## Tool Selection

```text
Scenario                          Tool
Factual question, current info    parallel-search
SDK/API/framework docs            Context7 resolve + query
Full article, exact quotes        parallel-search web_fetch
JS-rendered page, dynamic content Playwright navigate
Form submission, login flow       Playwright click + type
API inspection, network debug     Playwright network_requests
```

## CAPTCHA Handling

Academic sites (JSTOR, ACM, ScienceDirect) trigger bot detection. Per `RUL.CAPTCHA.GATE`:

1. Pause automated flow
2. Report blocked URL to user
3. Prompt user to solve challenge in browser session
4. Resume after user confirms completion

## Constraints

- Context7: 3 calls per question limit — batch related queries
- `full_content: true` returns large output — use selectively
- `browser_snapshot` captures accessibility tree, not visual — `browser_take_screenshot` for visual
- `browser_find(text)` cheaper than full snapshot
