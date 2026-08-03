# Context Seven

**Route** — resolve library IDs and fetch documentation for libraries and frameworks via the Context7 MCP server.

**Target** — load `use-context-seven` before library-doc lookups.

**Notes**

- Resolve the library ID first with `resolve-library-id` — the exact ID format comes from that call.
- Include the version for version-specific docs — `/org/project/version`.
- Limit to 3 calls per question — the API caps at that bound.
- Keep sensitive data out of query text — API keys and credentials excluded.
