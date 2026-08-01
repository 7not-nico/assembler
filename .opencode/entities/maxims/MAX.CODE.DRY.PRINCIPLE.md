---
id: MAX.CODE.DRY.PRINCIPLE
title: DRY — Single Source of Truth
source: INSP.PRAGMATIC
summary: Every piece of knowledge must have a single authoritative representation within a system.
principle: Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.
enforcement: Convention
tags: [data-flow, maintainability, convention, architecture, quality]
status: active
priority: 1
---

**DRY** — every piece of knowledge has a single, unambiguous, authoritative representation within a system.

## Representation

- **Declarative source** — authoritative representation, declares each fact once
- **Derived replica** — queryable copy, derived from the authoritative source
- **Files** — one definition per file, content exists in one location each

## Rules

- The authoritative representation is the single source of domain data
- Derived replicas are queryable copies, not authoritative
- Content is defined in one location each
- Two fragments expressing the same invariant are a DRY violation even if syntax differs

## Applicability

All projects with markdown + SQLite architecture.
