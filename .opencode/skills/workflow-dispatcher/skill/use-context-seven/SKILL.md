---
name: use-context-seven
description: Use this skill when using Context7 MCP server — it resolves library IDs and fetches documentation for libraries and frameworks
state-profile: stateless
nexus: NEX.INVESTIGATION.STAGE
---

## Gotchas

- Resolve the library ID first with `resolve-library-id` — the exact ID format comes from that call
- Version-specific docs require explicit version in library ID (`/org/project/version`)
- Limit to 3 calls per question — the API caps at that bound
- Keep sensitive data (API keys, credentials) out of query text
