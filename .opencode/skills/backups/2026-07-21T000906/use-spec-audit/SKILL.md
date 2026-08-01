---
name: use-spec-audit
description: Reference for mcp-spec-audit MCP server — audit instruction files against PROT.LLM.SPECIFICATION
state-profile: stateless
---

**Trigger** — LLM-facing instruction file creation or edit requiring compliance verification

**Procedure**

- 1. `spec_rules` to check active rules and descriptions
- 2. `spec_audit_file` for existing files — pass absolute path
- 3. `spec_audit` for draft text before file save
- 4. Fix reported violations and re-audit until 100/100

**Rules**

- Score target: 100/100 before write-sync
- Fix all violations — negation patterns, expletive constructions, structural issues
- `spec_rules` first to understand audit criteria

**Gotchas**

- `spec_audit_file` requires absolute path
- `spec_audit` accepts raw text — use for unsaved drafts
- Compliance score is 0-100; violations include line numbers for quick fixing
