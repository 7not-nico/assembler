---
name: use-parallel-search
description: Reference for Parallel Search MCP server — multi-query web search and page fetch
state-profile: stateless
---

**Trigger** — factual research, current information, documentation, troubleshooting questions

**Procedure**

- 1. `web_search` with `objective` + 2-3 `search_queries` in one call
- 2. Answer from excerpts if sufficient
- 3. `web_fetch` only when excerpts insufficient (conflicting, truncated, full-page needed)

**Rules**

- 2-3 related search queries per call rather than chaining
- `web_fetch` only after `web_search` excerpts prove insufficient
- `full_content: true` reserved for long articles or downstream summarization
- Reuse same `session_id` across conversation
- Pass `model_name` from active runtime metadata

**Gotchas**

- `full_content: true` returns large output — may exceed tool-output limits
- Default excerpt mode is sufficient for most answers
- `session_id` changes between conversations reset rate-limit tracking
- `model_name` for product analytics only; search behavior unaffected
