---
description: Search the web via Exa with a query string
subtask: true
---

Search for `$ARGUMENTS`

1. `exa_web_search_exa` — query using `$ARGUMENTS` as natural language; prefer `site:.edu`, `site:.ac.*`, or `site:.gov` domain suffixes when the topic suits academic sources
2. If results empty or insufficient — `question` tool to ask user for refined query with stronger domain filters, then loop to step 1
3. `exa_web_fetch_exa` — fetch full content from top N results
4. **Source audit** — classify each result by domain suffix:
   - Academic: `.edu`, `.ac.*`, `.gov`, institutional `.org` (academic journals, museums, nonprofits)
   - Commercial: `.com`, `.co.*`, commercial `.org`
5. For each commercial-origin source, run a replacement query with `site:.edu` or `site:.ac.*` targeting the same finding. If academic equivalent found, replace the commercial entry. If none found after 2 attempts, keep but flag as `[commercial — no academic equivalent found]`
6. Calculate commercial-source ratio: `commercial_count / total_sources`. If ratio exceeds 30%, re-run search with `site:.edu` filter applied to the full query
7. Present results with summaries and source URLs, grouped by authority (academic first, commercial flagged)

**Report** — per-query:
- PASS — results returned with snippets, commercial ratio ≤30%
- WARN — sparse results, refinement prompt fired, or commercial ratio >30% after re-search
- FAIL — search error or empty after refinement, no academic sources found
- SKIP — user cancelled refinement

**Summary** — total results, top URLs, refinement rounds, commercial-source ratio.
