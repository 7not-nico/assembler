---
id: PROT.TERM.SCHEMA
title: Term Identity — Vocabulary Entity Protocol
source: NEX.META.PROPOSAL
summary: "Defines the terms/ directory and TERM.* entity type — schema, body convention, enforcement, and relationship to patterns, protocols, abstractions, and skills."
protocol: "A term defines a vocabulary entry for the system. type: internal for project-invented labels (source: assembler). type: external for labels pointing to a universal concept or definition (source: CON.* or DEF.* ID). Location: terms/TERM.*.md with TERM.* ID prefix. Sync: name-to-name into terms table."
enforcement: Sealed
tags: [term, vocabulary, definition, reference, patlib, entity-type]
status: active
priority: 2
---

The term domain holds vocabulary entries that define project labels. Terms answer *what label*. Cognitions answer *what domain*. Concepts answer *what idea*. Definitions answer *what thing*. Patterns answer *how*. Illustrations walk through *instances*. Protocols state contracts. Skills provide procedures. Abstractions formalize mathematical concepts.

## Protocol

### Schema

Every term file requires seven backmatter fields: `id` (required, `TERM.{NAME}` uppercase dot-separated), `title` (required, human-readable name), `source` (required, `assembler` for internal labels; CON.* or DEF.* ID for external labels), `type` (required, `internal` or `external`), `related` (optional, entity ID array — other TERM.* IDs only), `tags` (required, comma-separated, no spaces), `reference` (required, array of `{title, url}`; minimum 3).

### Body convention

First line: `**{Title}** — {1-3 sentence definition}`. Optional subsections follow. Content placement: definition lives in term body, walkthrough and examples in illustration body, how-to instructions in skill or command body, formal rules with symbols in abstraction body.

### Content rules

- `type: internal` — project-invented label with no universal referent. source must be `assembler`.
- `type: external` — labels a universal concept or definition. source must be a valid COG.*, CON.*, or DEF.* ID (the vector points upward per SPEC.KNOWLEDGE.VECTOR.SEMANTICS).
- Tags: comma-separated — spaces excluded
- References: minimum 3 authoritative sources with URL+title
- Related: limited to other TERM.* IDs — horizontal layer only
- Sync: name-to-name into `terms` table — DB cache, file is source of truth

## Gotchas

- Type field missing: Add `type: internal` or `type: external` (`type:` absent from backmatter)
- Type mismatch with source: internal requires `source: assembler`; external requires source as CON.* or DEF.* ID (`type: internal` with source pointing to CON.*/DEF.*; or `type: external` with `source: assembler`)
- Related links to non-TERM entities: related is horizontal — link only to other TERM.* IDs (related array contains COG.* or CON.* or DEF.* IDs)
- Term body contains example enumeration: Move examples to a paired illustration body ("E.g." list or numbered examples in first paragraph)
- Term body contains procedural steps: Move procedure to a skill or command body ("First, then, finally" sequence)
- Term body contains formal notation or inference rules: Move to abstraction body (Math symbols, formal logic, composition rules)
- Less than 3 references: Add authoritative sources — textbooks, papers, official docs (`reference:` array length < 3)
- Tags contain spaces: Replace with hyphenated form: `architecture,design-principle` (`tags: architecture, design principle` with space in "design principle")
- Related links point to nonexistent IDs: Verify target exists before linking (Cross-reference target absent from patlib)
- ID field mismatches filename: Match filename prefix to id value (File named `TERM.FOO.md`; id field value: `TERM.BAR`)
- Term and pattern define the same concept: Add bidirectional related link; ensure term defines *what*, pattern prescribes *how* (Both files exist, neither references the other)

## Enforcement

`audit-terms` verifies every term file against this protocol: frontmatter fields present and correctly formatted, minimum 3 references, tag format compliance, body starts with bold-title convention. ID-filename mismatch triggers sync failure.

## Applicability

All term entities across all projects at root scope (`source: assembler`).

Excluded for:
- Patterns — pattern layer prescribes *how*
- Illustrations — illustration layer walks through *instances*
- Protocols — protocol layer states contracts
- Abstractions — abstraction layer hosts formal mathematical concepts
- Skills — skill layer provides procedures
- Commands — command layer documents workflows
- Rules — rule layer defines session-level instructions

## See also

- `PROT.TERM.SCHEMA` — term identity protocol
- `IDENTITY.TERM` — term entity identity
- `PROT.COGNITION.SCHEMA` — cognition entity protocol
- `PROT.CONCEPT.SCHEMA` — concept entity protocol
- `PROT.DEFINITION.SCHEMA` — definition entity protocol
- `PROT.META.IDENTITY` — protocol entity identity (analogous pattern)
- `SPEC.ENTITY.ROUTING.TABLE` — ID prefix convention for all entity types
- `REF.META.REFERENCE.AUTHORITY` — reference source hierarchy by entity type
- `SPEC.ENTITY.DISTINCTION.BOUNDARY` — protocol-pattern boundary
- `audit-term` skill — structural compliance checker
