---
id: TEMPLATE.BROWSE.PLAYWRIGHT
title: Browse-Playwright Template — Browser Navigation Chain
layer: procedure/
purpose: "Browser step chain: search first, browse second, snapshot before acting."
naming: action-domain.md
tags: [template, browse, playwright]
status: active
---
# browse-playwright.md

**Layer:** procedure/
**Naming:** `action-domain.md` — procedural chain, atomic per workflow, numbered steps.
**Composes with:** `precept/search-before-navigate.md` (search first, browse second).

## Workflow

Capture web page content via Playwright into a research capture or note — for dynamic/JS-rendered pages where search excerpts and `web_fetch` are insufficient.

## Steps

```
1. Search     parallel-search_web_search 2-3 focused queries; locate canonical URL; review excerpts
2. Navigate   playwright_browser_navigate(url) to the target page
3. Snapshot   playwright_browser_snapshot to read the accessibility tree (page structure, refs)
4. Evaluate   playwright_browser_evaluate(fn) to fetch contents (DOM data, text, JSON) — primary extraction
5. Find       playwright_browser_find(text) to move within the page / locate specific elements by ref
6. Tabs       playwright_browser_tabs to manage multiple pages: open new tab, select, close; parallel study
7. Interact   browser_click / browser_type / browser_fill_form / browser_select_option; wait with browser_wait_for
8. Extract    browser_take_screenshot (visual record), browser_network_requests (API inspection) — supplementary
9. Write      record findings into research/{topic}-{source}.md or note/ch{NN}-{topic}.md per their templates
10. Close     browser_close or continue to next target
```

## Verify

```
1. Note carries source header with URL + capture date + version
2. Extracted tables/code blocks verbatim — no paraphrase of config examples
3. Claims traceable to evaluated content or snapshot element
```

## Gotchas

```
- browser_evaluate returns page data — primary for content fetch; snapshot is structural reference
- browser_find(text) cheaper than full browser_snapshot — prefer for targeted movement
- browser_snapshot captures accessibility tree — use browser_take_screenshot for visual
- Tabs persist across calls — close unused tabs to bound session
- CAPTCHA-gated academic sites — pause, report blocked URL, prompt user to solve (RUL.CAPTCHA.GATE)
- Playwright runs locally — RAM/CPU resource limits apply
```
