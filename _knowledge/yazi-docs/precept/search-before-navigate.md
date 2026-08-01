# search-before-navigate.md

Search before navigation — no blind browser jumps.

## Rule

Before opening any docs page:
1. `parallel-search_web_search` 2-3 focused queries — locate the canonical page
2. Fetch excerpts — answer directly if sufficient
3. `parallel-search_web_fetch` specific URLs — if excerpts insufficient
4. Playwright navigate — only for dynamic/JS-rendered content

## Exception

Known canonical URLs (from docs nav, notes, cross-refs) may be fetched directly via `web_fetch` — skip search when target is certain.

## Why

Search excerpts usually answer directly. Reduces browser load, keeps context lean.
