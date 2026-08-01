---
name: use-entity-audit
description: Reference for mcp-entity-audit MCP server — audit files against PAT.ENTITY.DISTINCTION rules
state-profile: stateless
---

**Trigger** — protocol or pattern entity creation or edit requiring classification compliance

**Procedure**

- 1. `entity_audit_all` for bulk audit — checks all patterns and protocols
- 2. `entity_audit_file` for single file audit by absolute path
- 3. `entity_audit` for draft text before file save — specify `type` (`protocol` or `pattern`)

**Rules**

- Classifies entities as protocol (applied example) or pattern (abstract rule)
- Bulk audit before batch operations on multiple entity files
- Single-file audit during individual entity creation

**Gotchas**

- `entity_audit_all` returns aggregate report across all `.opencode/` files
- `entity_audit` requires `type` parameter — `protocol` or `pattern`
- Absolute path required for `entity_audit_file`
