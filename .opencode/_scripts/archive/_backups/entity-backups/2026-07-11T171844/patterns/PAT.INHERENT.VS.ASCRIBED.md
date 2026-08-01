---
id: PAT.INHERENT.VS.ASCRIBED
title: Inherent–Ascribed — Ascribed Requires an Assigner
source: assembler
summary: Every metadata attribute belongs to one of two provenance classes — inherent (derived from entity existence) or ascribed (assigned by decision). The class determines collection, trust, and maintenance strategy.
principle: Ascribed attributes must be collected by their assigner. They have different failure modes (wrong decision vs stale data), different automation paths (scanner vs convention engine), and different trust models (deterministic vs authoritative). Systems that conflate them silently produce stale or falsely automated metadata.
enforcement: Convention
tags: [metadata, classification, architecture, provenance, data-governance, inherent, ascribed]
patterns: [PAT.DRY]
terms: [TERM.INHERENT-ASCRIBED]
status: active
priority: 3
---

Every metadata attribute belongs to one of two provenance classes: inherent or ascribed. The class determines how the attribute is collected, trusted, and maintained.

## Rules

- Inherent attributes are scraped automatically — requires zero external authority, scanner is the natural collector
- Ascribed attributes require an assigner — person, rule engine, convention, or design choice; a convention engine is the natural collector
- Inherent changes when the entity changes; ascribed changes when the decision changes
- Ascribed collected by scanner produces stale metadata — the scanner observes the entity, decision metadata requires the assigner
- Inherent collected by convention engine produces falsely automated metadata — the value follows from entity existence alone; decisions do not affect inherent values
- Systems that conflate the two classes accumulate silent decay — stale or falsely automated metadata proliferates without detection

## Applicability

Any system that collects, stores, or trusts metadata about entities — file systems, content registries, classification pipelines, governance tooling.

## See also

- TERM.INHERENT-ASCRIBED — definitions of each provenance class
- PAT.DRY — single authoritative representation principle
