**Entity Distinction** — three principle entity types (protocol, pattern, maxim) use generalized terms only. References to concrete names belong in illustrations alone.

## Content boundary

- Protocol body uses generalized terms only — plugin names, file paths, scores, and concrete evaluations belong in illustrations.
- Pattern body uses generalized terms only — concrete names, file paths, and specific instances belong in the paired illustration.
- Maxim body uses generalized terms only — concrete examples belong in the paired illustration.
- Illustration body names specific entities — every illustration references at least one concrete file, protocol ID, or code path. An illustration without name references requires a class change.

## Decision tree

- Technical contract with enforcement → Protocol
- Design principle with corollary rules → Pattern
- Universal truth with external origin → Maxim
- Concrete walkthrough of a principle entity → Illustration
- Both abstract rules AND concrete examples → Principle entity + Illustration

## Comparison

Protocol uses `PROT.*` prefix, `protocol:` field, Contract + enforcement content, excludes concrete examples, sources `assembler`, enforces via Sealed, Accord, or Formality.
Pattern uses `PAT.*` prefix, `morphism:` field, Morphism design + rules content, excludes concrete examples, sources `assembler`, enforces via Convention.
Maxim uses `MAX.*` prefix, `principle:` field, Categorization + corollaries content, excludes concrete examples, sources external (INSP.*), enforces via Convention.
Illustration uses `ILL.*` prefix, `illustration:` + `illustrates:` fields, step-by-step content, requires concrete examples, sources `assembler`, no enforcement.

## Applicability

All PROT.*, PAT.*, MAX.*, and ILL.* entities across all projects.

---
id: SPEC.ENTITY.DISTINCTION.BOUNDARY
title: Entity Distinction — Protocol, Pattern, Maxim, Illustration Content Boundary
source: assembler
summary: "Protocol, pattern, and maxim bodies use generalized terms only. Concrete names, paths, scores, and specific instances belong in the paired illustration."
specifies: Content boundary between PROT/PAT/MAX/ILL entity types
tags: [entity, classification, architecture, convention, writing, specification, boundary]
status: active
---
