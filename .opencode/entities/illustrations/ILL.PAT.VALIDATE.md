---
id: ILL.PAT.VALIDATE
title: "Broken Window — Validating a Sync Pipeline at Every Gate"
source: SPEC.ENTITY.DISTINCTION.BOUNDARY
summary: "A sync pipeline skips validation on an intermediate step. A corrupted entity propagates to the DB. The restore: add validation gates at every intermediate step."
illustration: "A write-sync tool omits validation on the staging step — a broken YAML frontmatter passes through to the DB. The fix inserts validation gates before write, before commit, and after commit."
illustrates: [MAX.BROKEN.WINDOW.CASCADE]
tags: walkthrough,validation,pipeline,sync,data-integrity
related: [PAT.DRY, PAT.ORTHOGONALITY, NEX.TOOL.SEQUENCE]
---
## Context

`MAX.BROKEN.WINDOW.CASCADE` states that a small issue left unfixed invites more. In data pipelines, a skipped validation at one step lets corrupted data propagate to the next — each downstream consumer operates on bad input, producing more bad output. The fix is structural: insert validation gates so no step can pass bad data forward.

## Walkthrough

### Step 1: The pipeline has no intermediate validation

A `write-sync` pipeline reads markdown frontmatter, transforms it, and writes to SQLite. The pipeline has three steps — read, transform, write. Validation runs only at the end, after the write:

```
read markdown → parse frontmatter → INSERT INTO db → validate
```

### Step 2: A corrupted entity passes through

An entity file has a broken YAML frontmatter — a missing closing `---` delimiter. The parser silently truncates the frontmatter at the next `---` in the body, producing a partial entity with fields from the body text misparsed as metadata. The partial entity reaches the DB. The end-of-pipeline validation checks only that rows exist — it does not detect malformed fields.

### Step 3: Three validation gates replace one

The agent adds validation at every intermediate step:

```
read → validate-parse → transform → validate-transform → INSERT → validate-row → commit
```

- **validate-parse**: checks frontmatter parses fully, all required fields present
- **validate-transform**: checks transformed entity matches the target schema
- **validate-row**: checks the inserted row against expected values

### Step 4: Each gate catches a failure class

| Gate | Position | Catches |
|------|----------|---------|
| validate-parse | After parse | Broken YAML, missing required fields |
| validate-transform | After transform | Schema mismatch, field type errors |
| validate-row | After INSERT | SQL constraints, FK violations |

### Step 5: The fix propagates zero failures

The next corrupted entity hits validate-parse — it fails immediately. No downstream step sees bad input. The agent fixes the YAML, reruns, the entity passes all three gates, and reaches the DB clean.

## Key insight

A single validation gate at the end of a pipeline is a broken window — it signals that intermediate quality is optional. Each intermediate step that receives unchecked input is a window multiplier: one corrupted file produces N downstream corruptions. Three gates catch three classes of failure independently, and each gate validates only the output of its step — no gate depends on another gate's result.

## See also

- `MAX.BROKEN.WINDOW.CASCADE` — the maxim this illustrates
- `PAT.DRY` — single authoritative schema for validation rules
- `PAT.ORTHOGONALITY` — each validation gate is independent
- `NEX.TOOL.SEQUENCE` — auditing follows a similar validation sequence
