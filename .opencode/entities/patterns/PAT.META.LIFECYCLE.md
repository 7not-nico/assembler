---
id: PAT.META.LIFECYCLE
title: Entity Lifecycle — Propose + Audit State Machine
source: NEX.META.PROPOSAL
summary: "Every patlib entity follows a two-transition lifecycle: propose handles NOT_FOUND (creation) and DIRTY (correction); audit verifies CONFIRMED compliance."
morphism: "TRNS — every patlib entity follows a two-transition lifecycle — propose handles both NOT_FOUND and DIRTY states; audit verifies CONFIRMED compliance. Refactor is redundant: propose in DIRTY state produces the same output as propose in NOT_FOUND."
enforcement: Convention
tags: [architecture, lifecycle, convention, propose, audit, state-machine]
status: active
priority: 3
---

Every patlib entity follows a two-transition lifecycle — propose handles NOT_FOUND and DIRTY; audit verifies CONFIRMED. Refactor is redundant.

## Rules

- Every entity lifecycle uses exactly two transitions: **propose** (NOT_FOUND→CONFIRMED, DIRTY→CONFIRMED) and **audit** (CONFIRMED→DIRTY, CONFIRMED→CONFIRMED)
- Propose generates the ideal form — it applies all formatting conventions and structural requirements of the entity type
- Audit verifies and reports only — writing is outside the audit scope
- Refactor is excluded as a third transition — propose handles correction when prior state is DIRTY
- The propose trigger extends to both NOT_FOUND (gap detected) and DIRTY (audit flagged violations)
- A propose skill for any entity type must check existence first — DRY applies to both new creation and re-creation
- After every propose, run the corresponding audit to confirm the new entity is CONFIRMED; DIRTY excluded as endpoint

## Applicability

Any `.opencode/` entity management — patterns, terms, rules, skills, tools, apologias, investigations. The lifecycle applies universally across all entity types.

## See also

- `ILL.META.LIFECYCLE.PROPOSE` — propose-and-audit walkthrough
- `PAT.META.LAYER.TRIGGER` — proactive rules vs reactive skills
- `PROT.SKILL.PROFILE` — skill state-profile declaration
- `REF.META.PROJECT.TOPOLOGY` — underlying architecture principles
- `propose-pattern`, `propose-term`, `propose-rule`, `propose-investigation` — existing propose skills
- `audit-pattern`, `audit-term`, `audit-rule`, `audit-skill`, `audit-tool`, `audit-investigation` — existing audit skills
