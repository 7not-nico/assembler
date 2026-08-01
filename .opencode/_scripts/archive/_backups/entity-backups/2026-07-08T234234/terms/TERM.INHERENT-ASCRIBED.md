**Inherent–Ascribed Metadata Distinction** — every metadata attribute belongs to one of two provenance classes: inherent or ascribed. The class determines how the attribute is collected, trusted, and maintained.

**Inherent** — an attribute whose value follows from the entity's existence alone. Derivation is deterministic: a function of the entity and its context. No external authority or classification schema required. The attribute changes when the entity changes; otherwise it is correct by definition. A scanner is the natural collector.

**Ascribed** — an attribute whose value follows from a decision. Derivation requires an assigner: a person, rule engine, convention, or design choice. The value reflects what the entity *should be* under some schema, not what it *is*. The attribute is wrong when the decision changes, not when the entity changes. An assignment tool or convention engine is the natural collector.

**Principle** — never treat ascribed attributes as if they were inherent. They have different failure modes (wrong decision vs stale data), different automation paths (scanner vs convention engine), and different trust models (deterministic vs authoritative). Systems that conflate them silently produce stale or falsely automated metadata.

---
id: TERM.INHERENT-ASCRIBED
title: Inherent–Ascribed Metadata Distinction
source: assembler
tags: metadata,classification,architecture,provenance,data-governance
related: PAT.DRY
reference:
  - title: Mapped Docs — Label vs Flag
    url: https://opencode.ai/docs
  - title: Cloudera Atlas — Labels vs Classifications
    url: https://opencode.ai/docs
  - title: Horkan — Governance & Metadata
    url: https://opencode.ai/docs
---
