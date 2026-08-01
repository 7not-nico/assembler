---
id: PAT.ENTITY.LIFECYCLE
title: Entity Lifecycle — Propose + Audit State Machine
source: assembler
summary: "Every patlib entity follows a two-transition lifecycle: propose handles NOT_FOUND (creation) and DIRTY (correction); audit verifies CONFIRMED compliance."
principle: "Every patlib entity follows a two-transition lifecycle — propose handles both NOT_FOUND and DIRTY states; audit verifies CONFIRMED compliance. Refactor is redundant: propose in DIRTY state produces the same output as propose in NOT_FOUND."
enforcement: Convention
tags: [architecture, lifecycle, convention, propose, audit, state-machine]
status: active
priority: 3
related: PAT.ACTIVATION.MODEL, PAT.SKILL.STATECLASS
---

Every patlib entity follows a two-transition lifecycle — propose handles NOT_FOUND and DIRTY; audit verifies CONFIRMED. Refactor is redundant.

## Context

Every entity in patlib exists in one of three states:

| State | Meaning | Detected by |
|-------|---------|-------------|
| **NOT_FOUND** | Entity doesn't exist | `read-selection` returns empty |
| **DIRTY** | Entity exists but fails audit | `audit-X` flags violations |
| **CONFIRMED** | Entity exists, audit passes | `audit-X` returns clean |

Two transitions move between these states:

```
                  propose
NOT_FOUND ──────────────────┐
                             ├──▶ CREATED (= CONFIRMED)
DIRTY ──── propose ─────────┘
              │
              │ audit
              ▼
          CONFIRMED ◀── audit ──┘
```

**Propose** is generative — it produces the ideal form of an entity, applying all conventions. Whether the prior state is NOT_FOUND (no existing file) or DIRTY (file exists but fails audit), the propose skill generates the same correct output. The only difference: in DIRTY state, the output file overwrites the existing one.

**Audit** is verificatory — it reads an existing entity and reports compliance. If violations are found, the entity transitions from CONFIRMED to DIRTY, triggering a new propose cycle.

**Refactor** is a redundant concept. It was introduced for skills because legacy skills predated the standard format. But architecturally, "refactor" is just "propose called when the prior state is DIRTY." The propose skill produces identical output regardless of prior state. A separate refactor skill duplicates the propose skill's logic.

The steadiest state is CONFIRMED — all entities should aim for this. NOT_FOUND is resolved by propose. DIRTY resolves by re-propose.

## Rules

- Every entity lifecycle uses exactly two transitions: **propose** (NOT_FOUND→CONFIRMED, DIRTY→CONFIRMED) and **audit** (CONFIRMED→DIRTY, CONFIRMED→CONFIRMED)
- Propose generates the ideal form — it applies all formatting conventions and structural requirements of the entity type
- Audit never writes — it verifies and reports only
- Refactor is not a third transition — propose handles correction when prior state is DIRTY
- The propose trigger extends to both NOT_FOUND (gap detected) and DIRTY (audit flagged violations)
- A propose skill for any entity type must check existence first — DRY applies to both new creation and re-creation
- After every propose, run the corresponding audit to confirm the new entity is CONFIRMED, not DIRTY

## Applicability

Any `.opencode/` entity management — patterns, terms, rules, skills, tools, apologias, investigations. The lifecycle applies universally across all entity types.

## See also

- `PAT.ACTIVATION.MODEL` — proactive rules vs reactive skills
- `PAT.SKILL.STATECLASS` — skill state-profile declaration
- `PAT.ASSEMBLER.ARCHITECTURE` — underlying architecture principles
- `propose-pattern`, `propose-term`, `propose-rule`, `propose-investigation` — existing propose skills
- `audit-pattern`, `audit-term`, `audit-rule`, `audit-skill`, `audit-tool`, `audit-investigation` — existing audit skills
