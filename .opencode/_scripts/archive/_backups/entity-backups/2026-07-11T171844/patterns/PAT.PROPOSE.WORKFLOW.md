---
id: PAT.PROPOSE.WORKFLOW
title: Proposal Workflow — Standard Creation Workflow
source: assembler
summary: "Every proposal follows: detect gap, check existence, search related, write files, sync, report."
principle: "Creating new patlib entities follows a consistent detect-check-search-write-sync cycle."
enforcement: Convention
tags: [proposal, workflow, creation, convention, scaffolding]
patterns: [PAT.DRY, PAT.ENTITY.LIFECYCLE]
terms: []
status: active
priority: 3
---

Creating new patlib entities follows a consistent detect-check-search-write-sync cycle.

## Context

Every creation action in AMANDA — whether a pattern, term, skill, rule, or tool — follows the same sequence: detect the gap (trigger), confirm no existing entity covers it (existence check), find related entities for cross-referencing (search), write the source files (write), register in the database (sync), and report the new ID. The propose-* skills implement this template, adapting only the file format and sync target per entity type.

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

- SKL.PROPOSE.PATTERN
- SKL.PROPOSE.TERM
- SKL.PROPOSE.RULE
- SKL.PROPOSE.TOOL
- SKL.PROPOSE.COMMAND
- SKL.PROPOSE.INVESTIGATION
- PAT.DRY
- PAT.ENTITY.LIFECYCLE
