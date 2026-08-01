---
id: PROT.META.IDENTITY
title: "Entity Identity — Metadata and Body Protocol"
source: NEX.META.PROPOSAL
summary: "Every entity identity protocol documents two categories: metadata (frontmatter fields) and body (content sections). Protocol entities declare technical contracts with fixed frontmatter and body sections. Other entity types (maxim, rule) follow the same metadata + body pattern. LLM spec compliance required before sync."
protocol: "Every entity identity protocol documents two categories: metadata (frontmatter fields) and body (content sections). By SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY, every entity type has an identity protocol defining its field schema and content conventions. For protocol (PROT.*) entities: ID uses PROT.{DOMAIN}.{NAME}, frontmatter includes id, title, source, summary, protocol, enforcement, status, priority, tags (min 3) and optional reference, body includes Protocol, Gotchas (recommended), Enforcement, Applicability, See also. LLM spec compliance required before sync."
enforcement: Sealed
status: active
priority: 1
tags: [meta, entity, identity, convention, entity-type, schema]
related: []
---

Every entity identity protocol documents two categories: metadata (frontmatter fields) and body (content sections). By SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY, every entity type in every group (Axiomatic, Encyclopedic, Composition, Architectonic, Chronicle) has an identity protocol that defines its field schema and content conventions. This document is the meta-protocol that governs those identity protocols — it establishes the pattern.

The protocol (PROT.*) entity type follows this pattern with its own concrete identity protocol below. Other entity identity protocols — PROT.MAXIM.SCHEMA, PROT.RULE.SCHEMA — follow the same metadata + body pattern with type-specific fields and sections.

## Protocol

### ID and naming

Rule 1 — ID uses `PROT.{DOMAIN}.{NAME}` — uppercase dot-separated. The first segment after PROT. is the domain from the canonical set per `REF.META.NAMING.SCHEMA`.

Rule 2 — Entity group names use the `-ic` suffix (Greek `-ikos` → Latin `-icus`), meaning "pertaining to" or "of the nature of." The suffix marks the formal character of the group: Axiomatic (pertaining to axioms), Encyclopedic (pertaining to comprehensive knowledge), Architectonic (pertaining to systematic structure). Chronicle (from Greek *chronika* "of time") follows the same semantic pattern, Composition is the exception — named for its composing role rather than its formal nature.

Rule 3 — Entity directory names under `entities/` are plural nouns — `abstractions/`, `cognitions/`, `protocols/`, `terms/`; except for sciences (`biology/`, `chemistry/`) which are fields of study (singular), Nexus is both singular and plural (Latin 4th declension).

### Metadata — frontmatter fields

Ten frontmatter fields: `id` (required, `PROT.{DOMAIN}.{NAME}` uppercase dot-separated), `title` (required, em-dash format), `source` (required, `assembler` for first-party), `summary` (required, one sentence), `protocol` (required, core contract), `enforcement` (required, `Tool`, `Convention`, or `Review`), `status` (required, `active`, `draft`, or `deprecated`), `priority` (required, 1–5), `tags` (required, inline array min 3), `reference` (optional, `REF.{DOMAIN}.{TOPIC}`).

### Body — content sections

Each protocol body uses five content sections:

- **## Protocol** (required) — contract: positive instructions, schema, and scope narrowing.
- **## Gotchas** (recommended) — antipatterns paired with positive redirects.
- **## Enforcement** (required) — out-of-prompt compliance via tool or convention.
- **## Applicability** (required) — when this protocol applies plus exclusions.
- **## See also** (required) — related entities.

### Content rules

- `## Protocol` uses predominantly positive instructions (min 3:1 positive-to-negative ratio per `PROT.LLM.SPECIFICATION`)
- `## Gotchas` pairs every hard stop with a positive redirect
- `## Enforcement` moves deterministic checks out of prompt into tool or convention
- Tags use inline array `[tag1, tag2]` — use comma-separated format exclusively in `commands/yamls/` YAML files
- Protocol body states general contracts only — describe the contract using declarative register. Concrete named references belong in paired `ILL.*` illustrations. Reference patterns by entity ID.
- When `reference:` is present, the reference entity provides detailed specification. The protocol body supplies the contract and actionable rules.

## Gotchas

- Frontmatter missing required field: Add the missing field — id, title, source, summary, protocol, enforcement, status, priority, tags all required (Validation tool flags absent field)
- Body section absent: Add all five required sections (Section list misses one of Protocol, Gotchas, Enforcement, Applicability, See also)
- Gotchas section missing antipattern pairs: Pair each antipattern with a redirect — what to do instead (Hard stop without positive redirect)
- Spec audit below 100: Fix violations before sync — positive framing, ratio, register (Violation from mcp-spec-audit)
- Protocol body names concrete entities: Move named content to a paired illustration. Protocol keeps abstract rule (Plugin or file name appears in numbered rules)

## Enforcement

`mcp-spec-audit` runs before each sync. Protocol PRs pass 100/100. `read-validate` confirms frontmatter structure matches protocol entity type directory.

## Applicability

All protocol files within the AMANDA assembler ecosystem — every `.md` file in `.opencode/protocols/`.

Use patterns for general design principles, terms for operational labels, cognitions for knowledge domains, concepts for ideas, definitions for physical things, abstractions for formal mathematical or CS concepts, skills for workflow procedures, rules for session-level instructions, and subproject-level documentation for per-project content.

## See also

- `PROT.LLM.SPECIFICATION` — contract + gotcha framing rules
- `REF.META.NAMING.SCHEMA` — naming convention with prefix set
- `SPEC.ENTITY.ROUTING.TABLE` — entity prefix routing table
- `SPEC.ENTITY.DISTINCTION.BOUNDARY` — protocol vs pattern boundary
- `ILL.PROTOCOL.STRUCTURE` — protocol file creation walkthrough
- `IDENTITY.PROTOCOL` — protocol entity identity
- `PROT.MAXIM.SCHEMA` — maxim identity protocol (metadata + body)
- `PROT.RULE.SCHEMA` — rule identity protocol (metadata + body)
