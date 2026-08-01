---
id: REF.META.AUTHORITY
title: "Reference Authority — Textbooks for Terms, Papers for Patterns"
source: PROT.META.IDENTITY
related: []
summary: "Entity references match the entity semantic role: terms cite textbooks as primary sources; patterns cite seminal papers as primary sources."
ref: "Term reference sections use textbooks as primary sources. Pattern reference sections use seminal papers as primary sources."
tags: [convention, reference, citation, entity, methodology, authority]
---

Entity references match the entity semantic role. Terms cite textbooks as primary sources. Patterns cite seminal papers as primary sources. Textbooks represent peer-reviewed consensus distilled for learners. Seminal papers provide original formulations and formalisms that underpin design principles.

## Protocol

1. Term reference sections use textbooks as primary sources. Seminal papers supplement as secondary references.
2. Pattern reference sections use seminal papers as primary sources. Textbooks supplement as secondary references.
3. Each reference section provides at least one primary source matching its entity type.
4. Every reference uses a stable citable URL — DOI, ACM DL, or institutional archive.

## Gotchas

- Term lists only papers: Add a textbook as primary (Reference section has papers only, no textbook)
- Pattern lists only textbooks: Add a seminal paper as primary (Reference section has textbooks only, no paper)
- Non-authoritative source as primary: Replace with textbook or paper (Reference cites a blog or tutorial)
- Commercial URL without stable archive: Use DOI or publisher permalink (Reference links to vendor page)
- Reference without identifier: Add DOI or stable URL (Reference has title only)

## Enforcement

Audit tools verify each reference section. Terms require at least one textbook as primary. Patterns require at least one seminal paper as primary. Reference URLs resolve to stable archives.

## Applicability

All `.opencode/terms/` entity files and `.opencode/patterns/` entity files within the AMANDA assembler ecosystem.

## See also

- `SPEC.ENTITY.DISTINCTION.BOUNDARY` — entity type classification rule
- `PROT.META.PROJECT.TOPOLOGY` — underlying architecture principles
