---
name: use-context-seven
description: Reference for Context7 MCP server — resolve library IDs and fetch documentation
state-profile: stateless
---

**Trigger** — library, framework, SDK, or API documentation query

**Procedure**

- 1. `resolve-library-id` with package name + search intent → get `/org/project` ID
- 2. `query-docs` with library ID + specific question about usage, API, or config
- 3. If answer insufficient, refine query — max 3 calls per question

**Rules**

- Resolve library ID before querying docs
- Pass `libraryId` in format `/org/project` or `/org/project/version`
- Single concept per query; multiple concepts → separate calls
- Max 3 `query-docs` calls per question

**Gotchas**

- Without prior `resolve-library-id`, the library ID format is unknown
- Version-specific docs require explicit version in library ID (`/org/project/version`)
- Exceeds 3 calls per question → API limit reached
- Sensitive data (API keys, credentials) excluded from query text
