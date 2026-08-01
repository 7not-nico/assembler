---
name: use-exa
description: Use this skill when using Exa MCP server — it performs semantic web search and clean content extraction from any URL
state-profile: stateless
type: reference
---

**Gotchas**

- Keyword-style queries produce weaker results than natural-language descriptions
- `maxCharacters` controls fetch depth (default 3000)
- `web_fetch_exa` returns clean markdown; raw HTML excluded
