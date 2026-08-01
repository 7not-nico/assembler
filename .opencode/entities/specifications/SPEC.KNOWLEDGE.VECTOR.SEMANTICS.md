**Knowledge Vector** — edges between entities carry directional semantics determined by ring group.

## Vector types

- `source` — derivation chain. All entities. Encyclopedic source points to the closest preceding entity — same ring when the chain continues, inner ring when the chain ends. Innermost ring has no source. Chronicle source points to any ring of any other grouping.
- `related` — sibling connection. Same ring, same group only. All entities.
- `references` — Protocol only. Targets Encyclopedic entities or sibling Protocols.
- Illustration — Pattern and Nexus only. No other entity type targets an illustration.

## Direction

- Axiomatic, Composition, Architectonic, or Chronicle entities may source into any Encyclopedic entity.
- Encyclopedic entities never source into Axiomatic, Composition, Architectonic, or Chronicle entities.
- Vectors cannot form cycles.
- LLM reason from outer to inner rings.
- Precedence traces outer → inner: `precedes:` points inward. What grounds an entity lies at an inner ring.
- Derivation propagates inner → outer: foundational meaning at inner rings flows outward to derived entities. `source:` traces backward along the derivation path.

## Rules

- `related` connects only within the same ring and same group.
- Protocol `references:` targets Encyclopedic entities or sibling Protocols only.
- Pattern and Nexus may be illustrated. No other entity type targets an illustration.

## Applicability

All entity classification and relationship decisions.

---
id: SPEC.KNOWLEDGE.VECTOR.SEMANTICS
title: Knowledge Vector — Edge Semantics in Rings
source: assembler
summary: "Edges between entities (source, related, references, illustration) carry directional semantics determined by ring group and entity type."
specifies: Edge types and directional constraints between entities
tags: [vector, edge, semantics, source, related, reference, illustration, knowledge, specification]
status: active
---
