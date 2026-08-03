---
name: use-exa
description: Use this skill when using Exa MCP server — it performs semantic web search and clean content extraction from any URL
state-profile: stateless
nexus: NEX.INVESTIGATION.STAGE
---

## Tools

```
  Tool                  Parameters       Notes
  `web_search_exa`      `query`, `numResults?`  Search the web; return clean excerpts
  `web_fetch_exa`       `urls[]`, `maxCharacters?`  Read full pages; return clean markdown
```

## Gotchas

- Describe the ideal page in natural language — keyword-style queries produce weaker results
- Read excerpts before fetching — they usually answer directly
- Pass multiple related URLs in one fetch — one call covers the batch
- Bound fetch depth with `maxCharacters` — default 3000
- Expect clean markdown from `web_fetch_exa` — raw HTML excluded
