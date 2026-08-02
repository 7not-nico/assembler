---
id: PROT.PROTOCOL.FILE.SCHEMA
title: "Protocol Identity — Technical Contract Domain"
source: assembler
summary: "Concrete schema table and field-level requirements for protocol files. Abstract rules live in PROT.META.IDENTITY."
protocol: "Protocol frontmatter follows a fixed field set with specific formats. Body sections follow a fixed set per PROT.LLM.SPECIFICATION. Abstract governance rules are in PROT.META.IDENTITY — this pattern documents the concrete field values."
enforcement: Tool
related: []
tags: [protocol, schema, architecture, domain, convention, llm-specification]
status: active
priority: 2
---

Concrete schema for protocol files. Abstract rules and governance conventions live in `PROT.META.IDENTITY`. This pattern documents the exact frontmatter field formats and body section requirements.

## Rules

### Frontmatter field formats

| Field | Required | Format |
|-------|----------|--------|
| `id` | Yes | `PROT.{DOMAIN}.{NAME}` uppercase dot-separated |
| `title` | Yes | `"Name — Subtitle"` with em-dash |
| `source` | Yes | `assembler` for first-party |
| `summary` | Yes | One-sentence description |
| `protocol` | Yes | The core technical contract statement |
| `enforcement` | Yes | `Tool`, `Convention`, or `Review` |
| `status` | Yes | `active`, `draft`, `deprecated` |
| `priority` | Yes | Integer 1–5 |
| `tags` | Yes | Inline array `[tag1, tag2, tag3]`, minimum 3 |

### Body sections

| Section | Required | Role |
|---------|----------|------|
| `## Protocol` | Yes | Contract — positive instructions, schema, scope narrowing |
| `## Rationale` | Yes | Design reasoning — why the protocol exists |
| `## Gotchas` | Recommended | Antipatterns paired with positive redirects |
| `## Enforcement` | Yes | Out-of-prompt compliance — tool or convention |
| `## Applicability` | Yes | When this protocol applies + exclusions |
| `## See also` | Yes | Related entities |

### Content requirements

- `## Protocol` uses predominantly positive instructions (min 3:1 positive-to-negative ratio per PROT.LLM.SPECIFICATION)
- `## Gotchas` pairs every hard stop with a positive redirect
- `## Enforcement` moves deterministic checks out of prompt into tool or convention
- Tags use inline array `[tag1, tag2]` — comma-separated strings excluded
- **Protocol body states general contracts only** — describe the contract using declarative register. Concrete named references belong in paired ILL.* illustrations. Reference patterns by entity ID.

## Abstract rules redirect

All abstract governance rules (frontmatter purpose, LLM spec compliance, body structure rationale) moved to `PROT.META.IDENTITY`. That protocol governs:
- Abstract definition of what a protocol is
- LLM spec compliance requirement (100/100 before sync)
- Body section rationale and enforcement
- Relationship to other entity types

This pattern documents only concrete field values and format requirements.

## Applicability

Use this schema table when creating a new protocol file. Reference `PROT.META.IDENTITY` for abstract governance rules.

Protocol use excluded for:
- General design principles — pattern layer handles these
- Concept definitions — term layer handles these
- Formal mathematical or CS concepts — abstraction layer handles these
- Workflow procedures — skill layer handles these
- Session-level instructions — rule layer handles these
- Per-project documentation — subprojects reference protocols, hosting excluded

## See also

- `ILL.PROTOCOL.STRUCTURE` — protocol file creation walkthrough
- `PROT.META.IDENTITY` — abstract governance rules (redirect target)
- `TERM.PROTOCOL` — definition of protocol vs pattern vs term
- `SPEC.ENTITY.ROUTING.TABLE` — ID prefix routing for entity types
- `PROT.LLM.SPECIFICATION` — contract + gotcha framing rules for LLM-facing content
- `PROT.META.NAMING.SCHEMA` — naming convention and prefix set
