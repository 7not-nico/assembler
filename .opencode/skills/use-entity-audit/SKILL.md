---
name: use-entity-audit
description: Use this skill when using mcp-entity-audit MCP server — it audits files against PAT.ENTITY.DISTINCTION rules
state-profile: stateless
type: reference
---

**Gotchas**

- `entity_audit_all` returns aggregate report across all `.opencode/` files
- `entity_audit` requires `type` parameter — `protocol` or `pattern`
- Absolute path required for `entity_audit_file`
