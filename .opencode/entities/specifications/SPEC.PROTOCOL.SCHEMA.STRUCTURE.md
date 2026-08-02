**Meta Protocol Schema** — every protocol entity has a fixed metadata schema and body section structure. Protocol frontmatter fields define identity, contract, and enforcement. Body sections define contract details, edge cases, enforcement rules, and applicability.

## Metadata — frontmatter fields

Ten frontmatter fields: `id` (required, `PROT.{DOMAIN}.{NAME}`), `title` (required, em-dash format), `source` (required, `assembler` for first-party), `summary` (required, one sentence), `protocol` (required, core contract), `enforcement` (required, `Sealed`, `Accord`, or `Formality`), `status` (required, `active`, `draft`, or `deprecated`), `priority` (required, 1–5), `tags` (required, inline array min 3), `reference` (optional, `REF.{DOMAIN}.{TOPIC}`).

## Body — content sections

Five body sections: `## Protocol` (required, contract with positive instructions), `## Gotchas` (recommended, antipatterns with redirects), `## Enforcement` (required, out-of-prompt compliance), `## Applicability` (required, scope + exclusions), `## See also` (required, related entities).

## Content rules

- `## Protocol` uses predominantly positive instructions (min 3:1 positive-to-negative ratio)
- `## Gotchas` pairs every hard stop with a positive redirect
- `## Enforcement` moves deterministic checks out of prompt into tool or convention
- Tags use inline array format `[tag1, tag2]`
- Protocol body states general contracts only, no references to concrete names

---
id: SPEC.PROTOCOL.SCHEMA.STRUCTURE
title: Protocol Schema — Protocol Metadata and Body Conventions
source: assembler
summary: "Protocol entities have a fixed frontmatter schema (id, title, source, summary, protocol, enforcement, status, priority, tags, reference) and body section structure (Protocol, Gotchas, Enforcement, Applicability, See also)."
specifies: Fixed frontmatter and body section schema for protocols
tags: [meta, protocol, schema, metadata, body, convention, specification, structure]
status: active
---
