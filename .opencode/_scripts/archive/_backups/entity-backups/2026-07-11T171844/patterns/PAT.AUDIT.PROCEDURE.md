---
id: PAT.AUDIT.PROCEDURE
title: Audit Procedure — Standard Validation Workflow
source: assembler
summary: "Every audit follows: inventory, structural checks, cross-reference check, duplicate check, report, summarize."
principle: "The audit procedure is uniform across entity types — enumerate, validate each field, cross-reference, report violations, summarize score."
enforcement: Convention
tags: [audit, validation, procedure, convention, workflow]
patterns: [PAT.ENTITY.LIFECYCLE]
terms: []
status: active
priority: 3
---

The audit procedure is uniform across entity types — enumerate, validate each field, cross-reference, report violations, summarize score.

## Context

Every entity type in AMANDA (patterns, terms, skills, rules, apologia, commands, tools) needs validation independent of its runtime behavior. The audit sequence is the same regardless of entity: inventory all files, check required fields and format rules, verify cross-references resolve, detect duplicates, and produce a per-entity violation report with an overall pass/fail score. Audit skills implement this template but adapt the specific field checks per entity type.

## Rules

- Every audit begins with an inventory of all files of the target type
- Required fields and format checks are per-entity-type but always present
- Cross-reference checks verify that every referenced patlib ID resolves
- Duplicate ID detection runs across all files of the type
- Report per-entity violations with file:line format
- Summarize with pass/fail count and compliance score
- Audit skills are stateful-auditor — they read and validate but never write

## Applicability

Any `.opencode/skills/audit-*` skill. The procedure template applies universally; only the specific field checks differ per entity type.

## See also

- SKL.AUDIT.RULE
- SKL.AUDIT.PATTERN
- SKL.AUDIT.TOOL
- SKL.AUDIT.SKILL
- SKL.AUDIT.TERM
- SKL.AUDIT.APOLOGIA
- SKL.AUDIT.INVESTIGATION
- SKL.AUDIT.COMMAND
- PAT.ENTITY.LIFECYCLE
