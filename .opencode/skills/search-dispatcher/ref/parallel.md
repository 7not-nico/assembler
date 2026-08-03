# Parallel

**Route** — run multi-query web searches and fetch pages: issue broad objective with several queries, extract focused answers.

**Target** — load `use-parallel-search` before Parallel Search MCP work.

**Notes**

- Use the default excerpt mode — it answers most questions directly.
- Issue multiple `search_queries` in one call — broad tasks benefit from parallel queries.
- Fetch only when excerpts are insufficient — the default avoids large outputs.
- Keep `session_id` stable across the conversation — changes reset rate-limit tracking.
- Pass `full_content` only for full-page reads — large output may exceed tool limits.
