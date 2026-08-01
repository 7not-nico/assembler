---
id: PRE.PROJECTION.DERIVATION.SCOPE
title: Projection Derivation — Project Candidates from Encompassing Entities
source: assembler
summary: "An encompassing entity with sub-objects requiring structured reasoning is a project candidate — throw it forward into its own bounded context before ring derivation."
precept: "When an entity contains sub-objects that warrant individual reasoning, the entity is a project candidate. Throw it forward into a bounded context with own AGENTS.md, DB, and tools. Skip entity-type ring derivation entirely."
enforcement: Convention
tags: [ontology, derivation, project, scope, entity-classification, boundary]
status: active
priority: 1
---

**Projection Derivation** — project candidates from encompassing entities.

## Corollaries

- Encompassment triggers evaluation: if an entity contains sub-objects that each warrant individual reasoning, it is a project candidate. Detection precedes ring derivation
- Encyclopedic layer entities (Rings 1–3) are leaf types — they cannot contain reason-about-able sub-objects. Rings 1 and 2 define domains and ideas; Ring 3 assigns concrete labels. None provide the nesting structure needed for sub-object reasoning
- Project scaffolding follows standard project conventions — AGENTS.md, own boundary, own persistence, own tools
- Cyclical sub-objects form a domain; domain detection conventions guide scope separation. Project derivation applies to the encompassing entity, not the cycle members
- Once projected, delegation conventions govern entry into the new scope

## Applicability

All entity creation decisions where the scope contains sub-objects that require individual reasoning, tracking, or querying. Applied at declaration time — detect encompassment before choosing an entity type prefix.

Excluded for leaf entities with no sub-objects and purely enumerative sub-objects (flat lists without reasoning).
