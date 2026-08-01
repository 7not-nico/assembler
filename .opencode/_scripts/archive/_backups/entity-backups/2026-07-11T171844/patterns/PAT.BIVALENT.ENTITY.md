---
id: PAT.BIVALENT.ENTITY
title: Bivalent Entity — Entity As Domain, Domain As Entity
source: assembler
summary: Every entity carries two simultaneous roles — entity-of-parent and domain-for-children — enabling recursive stratification without extraction.
principle: Every entity is bivalent. It acts as an entity (member of its parent domain) and as a potential domain (container for sub-entities). Nesting extends to arbitrary depth; each level classifies the next.
enforcement: Convention
tags: [architecture, entity, domain, recursion, stratification, containment]
related: [RUL.ZERO.COPULA]
status: active
priority: 2
---

**Bivalent Entity** — every entity occupies two roles simultaneously. Looking upward: entity within a domain. Looking downward: domain that may contain entities, which are themselves bivalent. Leaf entities with no sub-entities terminate the recursion; their child role is empty, not absent.

## Context

Most entity systems assign each entity to exactly one domain. A concept lives in mathematical reasoning; a glossary entry lives in verbal reasoning. The domain is a container; the entity is content — one-directional.

Bivalent Entity inverts this. The same classification that groups entities also serves as the next level's domain. An arm (metadata layer) contains lines (domains). Lines contain entries (entities). Each entry is itself an arm — a classifier for the next stratum. No choosing "domain or entity" — always both.

## Rules

1. **Bivalence required** — every entity serves as entity-of-parent and domain-for-children. Neither role is optional. A leaf entity carries an empty child container.

2. **Arm as metadata stratum** — each nesting level classifies the level below. The arm is metadata for content below and content for the arm above.

3. **Arbitrary depth** — recursion extends through any number of levels. No fixed limit.

4. **ID encodes descent** — each dot-separated segment descends one level. `DOMAIN.SUBDOMAIN.ENTITY.SUBENTITY` traces the stratum path. Every segment after the entity-type prefix is contextual — domain or entity depending on position.

5. **Extraction per Domain Container** — when a sub-domain accumulates weight, extract to sibling per `PAT.DOMAIN.CONTAINER`. Bivalent Entity is default; extraction optimizes for density.

## Applicability

Use when entities nest at arbitrary depth and the domain-entity distinction is contextual rather than fixed.

Not applicable for flat entity types with no nesting hierarchy or single-attribute domain membership. Use single-level entity systems for those cases.

## See also

- `PAT.DOMAIN.CONTAINER` — single-level domain containers; extraction sibling to Bivalent Entity
- `PAT.ENTITY-TYPE-ROUTING` — first segment routing; Bivalent Entity extends routing to all subsequent segments
- `PAT.UMBRELLA.TERMS` — flat hierarchy via related links; Bivalent Entity allows deeper nesting where umbrella is limited to one level
- `PAT.INHERENT.VS.ASCRIBED` — domain membership is ascribed (design decision), not inherent
- `RUL.ZERO.COPULA` — related linguistic compression; both patterns reduce structural overhead
