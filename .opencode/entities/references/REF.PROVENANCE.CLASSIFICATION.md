---
id: REF.PROVENANCE.CLASSIFICATION
title: Inherent–Ascribed — Ascribed Requires an Assigner
source: PROT.META.DOMAIN
summary: Every metadata attribute belongs to one of two provenance classes — inherent (derived from entity existence) or ascribed (assigned by decision). The class determines collection, trust, and maintenance strategy.
ref: Ascribed attributes must be collected by their assigner. They have different failure modes (wrong decision vs stale data), different automation paths (scanner vs convention engine), and different trust models (deterministic vs authoritative). Systems that conflate them silently produce stale or falsely automated metadata.
related: []
tags: [metadata, classification, architecture, provenance, data-governance, inherent, ascribed]
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

- ILL.PROVENANCE.CLASSIFY — inherent vs ascribed walkthrough
- TERM.INHERENT-ASCRIBED — definitions of each provenance class
- MAX.CODE.DRY.PRINCIPLE — single authoritative representation principle
