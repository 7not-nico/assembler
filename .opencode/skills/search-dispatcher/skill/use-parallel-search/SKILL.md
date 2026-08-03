---
name: use-parallel-search
description: Use this skill when using Parallel Search MCP server — it runs multi-query web searches and fetches pages
state-profile: stateless
nexus: NEX.INVESTIGATION.STAGE
---

## Tools

```
  Tool            Parameters                            Notes
  `web_search`    `objective`, `search_queries[]`, `session_id?`, `model_name?`  Run multi-query search; return excerpts
  `web_fetch`     `urls[]`, `objective?`, `full_content?`, `session_id?`  Extract focused content from URLs
```

## Gotchas

- Use the default excerpt mode — it answers most questions directly
- Issue multiple `search_queries` in one call — broad tasks benefit from parallel queries
- Fetch only when excerpts are insufficient — the default avoids large outputs
- Keep `session_id` stable across the conversation — changes reset rate-limit tracking
- Pass `full_content` only for full-page reads — large output may exceed tool limits
- Expect `model_name` for product analytics only — search behavior unaffected
