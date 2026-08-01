---
id: ILL.TERM.IDENTITY.SETUP
title: "Term Identity Walkthrough — Creating a New Vocabulary Entity"
source: PROT.TERM.SCHEMA
summary: "Walk through creating a TERM.MCP entry: declare frontmatter with id, title, source, tags; write a definition body; gather three references; add cross-reference related links; sync and verify."
illustration: "An agent creates a new TERM.MCP entity following the term identity protocol — frontmatter schema, body definition, minimum-3 references, related links, sync, and audit"
illustrates: [PROT.TERM.SCHEMA]
tags: term,vocabulary,definition,walkthrough,entity
related: [SPEC.ENTITY.ROUTING.TABLE, REF.META.REFERENCE.AUTHORITY, PROT.META.IDENTITY]
---
## Context

The patlib lacks a definition for the Model Context Protocol (MCP). The term needs a vocabulary entry at `.opencode/terms/TERM.MCP.md` following the protocol schema and body convention.

## Walkthrough

### Step 1: Write frontmatter

The agent creates `TERM.MCP.md` with required and optional fields per the schema table:

```yaml
---
id: TERM.MCP
title: "Model Context Protocol (MCP)"
source: anthropic
tags: protocol,llm,ai,tooling,json-rpc,integration,api,architecture
related: [PAT.MCP.READONLY, PROT.MCP.TRANSPORT, PROT.TOOL.DISCOVERY]
reference:
  - title: "Model Context Protocol Specification"
    url: "https://spec.modelcontextprotocol.io"
  - title: "MCP GitHub Repository"
    url: "https://github.com/modelcontextprotocol/specification"
  - title: "Anthropic MCP Documentation"
    url: "https://docs.anthropic.com/en/docs/build-with-claude/tool-use"
  - title: "OpenCode MCP Configuration"
    url: "https://opencode.ai/docs/mcp"
---
```

All fields present: `id`, `title`, `source`, `tags` (comma-separated, no spaces), `related`, `reference` (4 sources, above 3-minimum).

### Step 2: Write body

The first line follows the bold-title format with a 1-3 sentence definition:

```
```

This fits term scope — defines *what* MCP is. Walkthrough content (tool setup) belongs in illustration files. Procedural content (deploying an MCP server) belongs in skills.

### Step 3: Verify reference count

The agent counts `reference:` entries:

```
4 references — exceeds minimum 3 per protocol rule.
```

### Step 4: Add related links

The agent adds bidirectional cross-references:

```yaml
related: [PAT.MCP.READONLY, PROT.MCP.TRANSPORT, PROT.TOOL.DISCOVERY]
```

Each related protocol should link back to `TERM.MCP` in its own related field.

### Step 5: Sync and verify

```
write-sync --type terms
```

Audit:

```
audit-term
```

Expected output: `TERM.MCP passes all 6 checks` — frontmatter format, reference count, tag format, bold-title body, no procedural content, ID-file match.

## Key insight

The term schema enforces the *what* role through field requirements: `reference` grounds the definition in authoritative sources (minimum 3), `related` builds cross-links, and the body-first convention keeps the definition visible. Content rules prevent scope creep — examples, procedures, and formal notation belong in other entity types.

## See also

- `PROT.TERM.SCHEMA` — the term identity protocol this walkthrough illustrates
- `SPEC.ENTITY.ROUTING.TABLE` — ID prefix convention (`TERM.` prefix routing)
- `REF.META.REFERENCE.AUTHORITY` — reference source hierarchy for terms
- `PROT.META.IDENTITY` — analogous pattern for protocol entity identity
- `audit-term` — structural compliance checker
