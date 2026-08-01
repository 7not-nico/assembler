---
id: ILL.META.CHAIN
title: "Activation Model — Rule vs Skill Decision Walkthrough"
source: PROT.META.IDENTITY
summary: "Walkthrough of choosing the correct activation model for a file-naming convention: should it be a rule (proactive) or a skill (reactive)?"
illustration: "A file-naming convention takes two forms: as a rule it loads every session instructing all behavior; as a skill it waits for a naming-related task. The trigger model determines which form fits."
illustrates: [PAT.META.LAYER.TRIGGER]
tags: architecture,walkthrough,activation,rule,skill,trigger
related: [IDENTITY.RULE, IDENTITY.SKILL]
---
## Rationale

Rules and skills influence agent behavior through fundamentally different activation models. Rules are proactive — loaded every session, they shape every task before it begins. Skills are reactive — dormant until a matching trigger or explicit call. Choosing the wrong model causes either irrelevant instructions flooding every session (rule that should be skill) or silent drift (skill that should be rule).

A team wants to enforce a file-naming convention (`snake_case` for `.ts` files). Two activation models exist. Choosing the correct one determines whether the convention floods irrelevant sessions or stays dormant until needed.

## Walkthrough

### Step 1: Assess scope

| Question | Answer |
|----------|--------|
| Is the convention meaningful in every session? | Yes — file-naming shapes every write/edit operation |
| Does the convention require trigger detection? | No — always applies when writing files |
| Can the convention be ignored in some sessions? | No — silent naming drift grows over time |

Three "always" answers point to proactive model.

### Step 2: Assign activation model

| Model | Candidate | Verdict |
|-------|-----------|---------|
| Proactive (Rule) | RUL.FILE.SNAKE.CASE | Correct — loads every session, applies to all file operations |
| Reactive (Skill) | SKL.RENAME.TO.SNAKE.CASE | Wrong — would require explicit invocation; drift occurs between activations |

### Step 3: Rule implementation

```yaml
# .opencode/rules/yamls/file-snake-case.yaml
---
id: RUL.FILE.SNAKE.CASE
title: "Snake Case for TypeScript Files"
source: assembler
description: >
  All .ts files use snake_case naming. CamelCase and kebab-case excluded.
  Applies to new files and rename operations.
tags: [naming, convention, file]
---
```

The rule loads automatically every session. Every file write or rename is checked against the naming constraint.

### Step 4: Verify via counter-example

If the same content were encoded as a skill:

```markdown
# .opencode/skills/rename-snake-case/SKILL.md
## Steps
1. Detect files with non-snake-case names
2. Rename each file to snake_case
```

The skill stays dormant until explicitly loaded. In a session focused on schema design, zero file-rename triggers fire. The skill stays dormant. Naming drift accumulates undetected.

## Trigger model summary

| Aspect | Rule (proactive) | Skill (reactive) |
|--------|-----------------|-------------------|
| Load timing | Every session start | On trigger or explicit call |
| Scope | Universal — applies to all tasks | Conditional — applies to matching scenario |
| Can be silenced | Mid-session exclusion blocked; verify universal relevance before creating rule | Exclusion by no-trigger default |
| Failure mode | Floods irrelevant sessions | Drift via missed activation |
| Default when unsure | Only if universally applicable | Always — invokable on demand |

## Key insight

The trigger test: if a convention is meaningful in every session and always relevant, it belongs in a rule. If it has a detectable trigger condition or is situational, it belongs in a skill. The damage of a wrong choice is asymmetric: a misplaced rule floods every session; a misplaced skill stays dormant silently.

## See also

- `PAT.META.LAYER.TRIGGER` — the activation model this illustrates
- `IDENTITY.RULE` — rule entity identity
- `IDENTITY.SKILL` — skill entity identity
