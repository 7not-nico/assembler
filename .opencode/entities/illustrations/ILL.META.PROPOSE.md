---
id: ILL.META.PROPOSE
title: "Entity Lifecycle — Propose and Audit a Pattern File"
source: PROT.META.IDENTITY
summary: "Walkthrough of the entity lifecycle (ABSENT → propose → CONFIRMED → audit → DIRTY → propose → CONFIRMED) applied to creating and fixing a pattern file."
illustration: "A new pattern starts absent. The propose skill generates a file (CONFIRMED). An audit finds a convention violation (DIRTY). A second propose call fixes the violation (CONFIRMED). Two transitions, three states."
illustrates: [PAT.META.ENTITY.LIFECYCLE]
tags: meta,walkthrough,entity,lifecycle,propose,audit
related: [PAT.META.LAYER.TRIGGER, PROT.SKILL.PROFILE]
---
## Rationale

Every patlib entity exists in one of three states (NOT_FOUND, DIRTY, CONFIRMED) with exactly two transitions. Propose is generative — it produces the ideal form regardless of prior state. Audit is verificatory — it reads and reports. Refactor is excluded as redundant: propose in DIRTY state produces the same output as propose in NOT_FOUND.

A new design convention needs formalization as a pattern. The entity lifecycle governs creation and maintenance through two transitions (propose, audit) and three states (ABSENT, DIRTY, CONFIRMED). The ABSENT state in this walkthrough maps to the initial state defined in the pattern definition — same semantics, different label.

## Walkthrough

### Step 1: ABSENT → propose → CONFIRMED

The pattern file has no corresponding file on disk. The `propose-pattern` skill generates a file at `.opencode/patterns/PAT.NEW.CONVENTION.md` with correct frontmatter, principle, rules, applicability, and See also. The file is saved.

State transition: ABSENT → CONFIRMED

```
$ propose-pattern --id PAT.NEW.CONVENTION --title "New Convention"
✓ File created: .opencode/patterns/PAT.NEW.CONVENTION.md
```

### Step 2: CONFIRMED → audit → DIRTY

An `audit-pattern` run discovers that the new file uses inline code syntax in its frontmatter `summary:` field — a convention violation.

State transition: CONFIRMED → DIRTY

```
$ audit-pattern PAT.NEW.CONVENTION
✗ Line 6: summary field contains backticks — use plain text only
```

### Step 3: DIRTY → propose → CONFIRMED

The same `propose-pattern` skill runs again. It reads the current file, detects the violation, and rewrites the summary field without backticks. The fix produces the same correct output whether the prior state is ABSENT or DIRTY.

State transition: DIRTY → CONFIRMED

```
$ propose-pattern --id PAT.NEW.CONVENTION --title "New Convention"
✓ File updated: PAT.NEW.CONVENTION.md — summary violation fixed
```

## State machine diagram

```
                  propose
ABSENT ──────────────────────┐
                             ├──▶ CONFIRMED
DIRTY ──── propose ─────────┘
              │
              │ audit
              ▼
           DIRTY ◀── audit ──┘
```

## Key insight

Propose is generative — it produces the ideal form regardless of prior state. The only difference between ABSENT and DIRTY: in DIRTY state, the propose output overwrites the existing file. Refactor is excluded as a third transition — propose handles correction when prior state is DIRTY.

## See also

- `PAT.META.ENTITY.LIFECYCLE` — the lifecycle pattern this illustrates
- `PAT.META.LAYER.TRIGGER` — rules proactive (prevent), skills reactive (detect and fix)
- `PROT.SKILL.PROFILE` — state-profiles for propose and audit skills
