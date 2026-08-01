---
name: use-patlib
description: Use this skill when using mcp-patlib MCP server — it searches, gets, and validates patlib entities by ID and type
state-profile: stateless
type: reference
---

**Gotchas**

- `search` with no filters returns all entities of given type — use `limit` to cap results
- Entity types: `terms`, `patterns`, `skills`, `rules`, `protocols`, `abstractions`, `apologias`, `commands`, `persons`
- `patlib_validate` reports structural violations per file
