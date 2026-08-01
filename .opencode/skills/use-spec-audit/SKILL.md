---
name: use-spec-audit
description: Use this skill when using mcp-spec-audit MCP server — it audits instruction files against PROT.LLM.SPECIFICATION rules
state-profile: stateless
type: reference
---

**Gotchas**

- `spec_audit_file` requires absolute path
- `spec_audit` accepts raw text — use for unsaved drafts
- Compliance score is 0-100; violations include line numbers for quick fixing
