---
name: use-patlib
description: Reference for mcp-patlib MCP server — search, get, and validate patlib entities
state-profile: stateless
---

**Trigger** — patlib entity lookup, context gathering, or structural validation

**Procedure**

- 1. `search` with `type` to scope results — default to `terms` and `patterns` when scope unknown
- 2. `get` with entity ID to view full body
- 3. `validate` to check all entity files for structural issues

**Rules**

- Narrow search with `type`, `tag`, `query`, or `status` filters
- Entity ID format: prefix.domain.subject (`PAT.DRY`, `TERM.ORGANELLE`, `SKL.USE.PLAYWRIGHT.CORE`)
- Validate before write-sync to catch structural errors early

**Gotchas**

- `search` with no filters returns all entities of given type — use `limit` to cap results
- Entity types: `terms`, `patterns`, `skills`, `rules`, `protocols`, `abstractions`, `apologias`, `commands`, `persons`
- `patlib_validate` reports structural violations per file
