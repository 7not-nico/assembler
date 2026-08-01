**Entity Segment Count** — entity ID segment count is determined by prefix convention per topological group.

## Rule

- Axiomatic group (MAX, PRE, SPEC): PREFIX.DOMAIN.SUBJECT.ASPECT — 4 segments. Identity is the exception: IDENTITY.{NAME} — 2 segments (domainless per IDENTITY.SCHEMA naming).
- Composition group (PROT, PAT, NEX, ILL, REF): PREFIX.DOMAIN.ASPECT — 3 segments.
- Encyclopedic group (COG, CON, DEF, TAX, TERM, BIO, CHE): PREFIX.DOMAIN.SUBJECT — 3 segments, all required.
- Architectonic group (RUL, CMD, SKL, TOOL): PREFIX.DOMAIN.SUBJECT — 3 segments.
- Chronicle group (PER, INV, APO, MAN, ARC, NTE): PREFIX.DOMAIN.SUBJECT — 3 segments.

## Exceptions

- 2-segment IDs (PREFIX.SUBJECT) are invalid for all entity types except IDENTITY.* — every entity must have at least a DOMAIN segment.
- `CMD.{VERB}.{DOMAIN}` follows its own 3-segment verb-domain convention.
- Linguistics (LING.*) and Abstractions (ABS.*) follow their own naming conventions per ring placement.

## Applicability

All patlib entities.

---
id: SPEC.ENTITY.SEGMENT.COUNT
title: Entity Segment Count — Segment Count Per Ring Group
source: assembler
summary: "Axiomatic group requires 4 segments. Composition group requires 3 segments. Encyclopedic, Architectonic, and Chronicle groups require 3 segments. IDENTITY.* is the exception at 2 segments."
specifies: Entity ID segment counts per topological group
tags: [entity, segment, count, naming, ring, group, specification]
status: active
---
