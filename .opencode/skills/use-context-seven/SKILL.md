---
name: use-context-seven
description: Use this skill when using Context7 MCP server — it resolves library IDs and fetches documentation for libraries and frameworks
state-profile: stateless
type: reference
---

**Gotchas**

- Without prior `resolve-library-id`, the library ID format is unknown
- Version-specific docs require explicit version in library ID (`/org/project/version`)
- Exceeds 3 calls per question → API limit reached
- Sensitive data (API keys, credentials) excluded from query text
