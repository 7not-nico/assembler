---
name: use-exa
description: Reference for Exa MCP server — semantic web search and clean content extraction
state-profile: stateless
---

**Trigger** — current information, news, people, companies, or general topic research

**Procedure**

- 1. `web_search_exa` with natural-language query describing the ideal result page
- 2. Answer from excerpts if sufficient
- 3. `web_fetch_exa` with batch URLs when excerpts insufficient

**Rules**

- Describe the ideal page; keywords excluded — semantic search
- Use `category:people` or `category:company` for people/company searches
- Batch multiple URLs in one `web_fetch_exa` call

**Gotchas**

- Keyword-style queries produce weaker results than natural-language descriptions
- `maxCharacters` controls fetch depth (default 3000)
- `web_fetch_exa` returns clean markdown; raw HTML excluded
