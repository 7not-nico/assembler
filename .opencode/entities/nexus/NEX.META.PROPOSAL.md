---
id: NEX.META.PROPOSAL
title: Proposal Workflow — Standard Creation Workflow
source: assembler
summary: "Every proposal follows: detect gap, check existence, search related, write files, sync, report."
composition: "Creating new patlib entities follows a consistent detect-check-search-write-sync cycle."
enforcement: Convention
related: []
tags: [proposal, workflow, creation, convention, scaffolding]
status: active
priority: 3
---

Creating new patlib entities follows a consistent detect-check-search-write-sync cycle.

## Rules

- Detection always precedes existence check — gap analysis is a mandatory gate
- Existence checks run against both filesystem (glob) and database (read-selection)
- Related entity search informs the new entity's cross-references
- Written files must follow entity-specific format conventions
- write-sync is mandatory before reporting complete
- Proposed entities without write-sync are invisible to query tools
- After proposal, the corresponding audit skill should validate

## Applicability

Any `.opencode/skills/propose-*` skill. The template applies universally; only file format, directory, and sync target differ per entity type.

## See also

- `ILL.META.PROPOSAL.WORKFLOW` — proposal walkthrough — creating NEX.TOOL.LAYER.CHOICE
- SKL.PROPOSE.PATTERN
- SKL.PROPOSE.TERM
- SKL.PROPOSE.RULE
- SKL.PROPOSE.TOOL
- SKL.PROPOSE.COMMAND
- SKL.PROPOSE.INVESTIGATION
- MAX.CODE.DRY.PRINCIPLE
- PAT.META.ENTITY.LIFECYCLE
