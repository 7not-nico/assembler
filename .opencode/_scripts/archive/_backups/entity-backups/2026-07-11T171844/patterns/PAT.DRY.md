---
id: PAT.DRY
title: DRY — Single Source of Truth
source: INSP.PRAGMATIC
summary: Every piece of knowledge must have a single authoritative representation within a system.
principle: Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.
enforcement: Convention
tags: [data-flow, maintainability, convention, architecture, quality]
patterns: [PAT.ORTHOGONALITY, PAT.PLUGIN.IPC.TOOL, PAT.MUTATION.PATTERN]
terms: []
status: active
priority: 1
---

Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.

## Rules

- Frontmatter is the authoritative representation of domain data
- DB is a queryable replica derived from frontmatter
- Never write from DB back to frontmatter
- Content is defined in one `.md` file each
- Two fragments expressing the same invariant are a DRY violation even if syntax differs

## Applicability

All projects with markdown + SQLite architecture.

## See also

- PAT.ORTHOGONALITY
- PAT.PLUGIN.IPC.TOOL
- PAT.MUTATION.PATTERN
