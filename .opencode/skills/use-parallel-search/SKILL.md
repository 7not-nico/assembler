---
name: use-parallel-search
description: Use this skill when using Parallel Search MCP server — it runs multi-query web searches and fetches pages
state-profile: stateless
nexus: NEX.INVESTIGATION.STAGE
---

**Gotchas**

- `full_content: true` returns large output — may exceed tool-output limits
- Default excerpt mode is sufficient for most answers
- `session_id` changes between conversations reset rate-limit tracking
- `model_name` for product analytics only; search behavior unaffected
