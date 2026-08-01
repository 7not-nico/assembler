---
name: remind-research
description: Remind to use Exa Web Search and Context7 MCP for current documentation, best practices, and anti-patterns
state-profile: stateless
related: [TERM.MCP]
---
**Trigger** — any technology inquiry, library question, API syntax, configuration, or debugging pattern

**Procedure**

Before answering from training memory:

1. Check if a Context7 library ID exists — use `context7_resolve-library-id`
2. If ID exists — use `context7_query-docs` for API syntax, configuration, version migration, debugging patterns
3. If no ID — use `exa_web_search_exa` for news, blog posts, community discussions, real-world usage, anti-patterns
4. When both apply — use both sources

**Gotchas**

- Context7 can fail silently — always verify the library ID is correct before querying
- Exa results may be stale — cross-check dates when time-sensitive
- Never skip research even if you think you know the answer — training data is outdated
- Don't confuse Context7 docs with actual library source — docs may lag behind releases

**Rules**

- Context7 is primary for documented library APIs — use when matching ID exists
- Exa is primary for general research and anti-patterns — use when no Context7 ID
- When both apply — use both, don't pick one
