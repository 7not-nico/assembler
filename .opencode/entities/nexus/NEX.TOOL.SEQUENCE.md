---
id: NEX.TOOL.SEQUENCE
title: Audit Procedure — Standard Validation Workflow
source: assembler
summary: "Every audit follows: inventory, structural checks, cross-reference check, duplicate check, report, summarize."
composition: "The audit procedure is uniform across entity types — enumerate, validate each field, cross-reference, report violations, summarize score."
enforcement: Convention
related: []
tags: [audit, validation, procedure, convention, workflow]
status: active
priority: 3
---

The audit procedure is uniform across entity types — enumerate, validate each field, cross-reference, report violations, summarize score.

## Rules

- Every audit begins with an inventory of all files of the target type
- Required fields and format checks are per-entity-type but always present
- Cross-reference checks verify that every referenced patlib ID resolves
- Duplicate ID detection runs across all files of the type
- Report per-entity violations with file:line format
- Summarize with pass/fail count and compliance score
- Audit skills are stateful-auditor — reads and validate only; writes disabled

## Applicability

Any `.opencode/skills/audit-*` skill. The procedure template applies universally; only the specific field checks differ per entity type.

## See also

- ILL.TOOL.AUDIT.SCAN — audit procedure walkthrough
- SKL.AUDIT.RULE
- SKL.AUDIT.PATTERN
- SKL.AUDIT.TOOL
- SKL.AUDIT.SKILL
- SKL.AUDIT.TERM
- SKL.AUDIT.APOLOGIA
- SKL.AUDIT.INVESTIGATION
- SKL.AUDIT.COMMAND
- PAT.META.ENTITY.LIFECYCLE
