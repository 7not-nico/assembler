---
id: PROT.ILLUSTRATION.SCHEMA
title: "Illustration Identity — Walkthrough Entity Protocol"
source: NEX.META.PROPOSAL
summary: "Defines the illustrations/ directory and ILL.* entity type — schema, body convention, and content rules. Cross-reference scope (illustration-to-entity links) governed by PROT.ILLUSTRATION.CROSSREF.SCOPE."
protocol: "An illustration walks through a single instance of a pattern or protocol. Location: illustrations/ILL.*.md with ILL.* ID prefix. Cross-reference links via illustration_entities junction table per PROT.ILLUSTRATION.CROSSREF.SCOPE."
enforcement: Sealed
status: active
priority: 2
tags: [illustration, walkthrough, entity-type, schema, patlib]
related: [PROT.ILLUSTRATION.CROSSREF.SCOPE, PROT.TERM.SCHEMA, SPEC.ENTITY.DISTINCTION.BOUNDARY]
---

The illustration domain holds walkthrough files that trace a single concrete instance of a pattern or protocol. Illustrations walk through *instances*. Terms define *what*. Patterns prescribe *how*. Protocols state contracts.

## Protocol

### Schema

Every illustration file requires eight frontmatter fields: `id` (required, `ILL.{DOMAIN}.{SUBJECT}.{ASPECT}` uppercase dot-separated), `title` (required, human-readable name), `summary` (required, one-sentence description), `illustration` (required, single declarative statement describing the walkthrough), `illustrates` (required, array of entity IDs — synced to `illustration_entities` junction per `PROT.ILLUSTRATION.CROSSREF.SCOPE`), `tags` (required, comma-separated, no spaces), `source` (required, `assembler` for first-party), `related` (optional, entity ID array).

### Body convention

First line: `**{Title}** — {1-3 sentence description}`. Required body sections:

- `## Context` or `## Rationale` — `## Context` for maxim illustrations (situation/scene). `## Rationale` for pattern illustrations (design justification). Default: `## Context`
- `## Walkthrough` — step-by-step trace through the instance. Named entities, file paths, code snippets
- `## Key insight` — what this instance reveals about the illustrated pattern or protocol
- `## See also` — related entities, at minimum the illustrated pattern or protocol

### Content rules

- Tags: comma-separated — spaces excluded
- `illustrates:` references at least one existing entity ID — must resolve via patlib
- `illustrates:` synced to `illustration_entities` junction per `PROT.ILLUSTRATION.CROSSREF.SCOPE`
- Walkthrough section names concrete entities — file names, function names, tool names
- Key insight states one lesson — multiple insights split into separate illustrations
- See also includes the illustrated pattern or protocol as the first entry
- Body section name depends on `illustrates` entity type: `## Context` for maxims (situation), `## Rationale` for patterns (design justification)

## Gotchas

- Illustration body lacks named entities: Name the specific file, function, or tool being walked through (Walkthrough uses generic "a tool" or "the function" without naming)
- `illustrates:` references nonexistent ID: Verify target entity exists before linking (Entity ID in `illustrates:` array absent from patlib)
- Illustration without Context section (maxim): Add `## Context` — establishes the situation (Body starts directly with walkthrough steps)
- Illustration without Rationale section (pattern): Add `## Rationale` — establishes the design justification (Body starts directly with walkthrough steps)
- Illustration without Key insight: Add `## Key insight` — states what the instance reveals (Body ends without a lesson section)
- Illustration describes a general principle: Reclassify as pattern — illustrations trace instances; patterns prescribe how (Walkthrough defines a concept rather than tracing an instance)
- Tags contain spaces: Comma-separated without spaces: `lib,module,contract` (`tags: lib, module, contract` with space after comma)

## Enforcement

`audit-*` tools verify every illustration file against this protocol: frontmatter fields present and correctly formatted, `illustrates:` references resolve to valid entity IDs, body includes all four required sections. ID-filename mismatch triggers sync failure. Cross-reference integrity enforced per `PROT.ILLUSTRATION.CROSSREF.SCOPE`.

## Applicability

All illustration entities across all projects at root scope (`source: assembler`).

Excluded for:
- Patterns — pattern layer prescribes *how*
- Terms — term layer defines *what*
- Protocols — protocol layer states contracts

## See also

- `PROT.ILLUSTRATION.CROSSREF.SCOPE` — junction table cross-reference, sync, and reverse lookup
- `IDENTITY.ILLUSTRATION` — illustration entity identity
- `SPEC.ENTITY.ROUTING.TABLE` — ID prefix convention for all entity types
- `REF.META.NAMING.SCHEMA` — naming convention with ILL prefix examples
- `SPEC.ENTITY.DISTINCTION.BOUNDARY` — entity type boundary definitions
- `PROT.TERM.SCHEMA` — analogous term entity protocol
- `SPEC.ENTITY.DISTINCTION.BOUNDARY` — entity classification heuristic
