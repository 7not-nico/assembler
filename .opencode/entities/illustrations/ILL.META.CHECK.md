---
id: ILL.META.CHECK
title: "Naming Schema — PREFIX, DOMAIN, SUBJECT, ASPECT Validation"
source: PROT.META.IDENTITY
summary: "Walkthrough of validating an entity ID against REF.META.NAMING.SCHEMA rules: check PREFIX against registered set, DOMAIN against canonical set, SUBJECT and ASPECT as singular nouns."
illustration: "Three candidate IDs run through the four-step naming check. PROT.LIB.CACHE.POLICY passes all checks. PROT.TOOL.VALIDATE.PIPELINE fails at SUBJECT verb form. PAT.NEW.ITEM fails PREFIX validation — ITEM domain absent from canonical set."
illustrates: [REF.META.NAMING.SCHEMA]
tags: naming,walkthrough,validation,schema,convention
related: [REF.META.NAMING.SCHEMA, REF.META.RENAME.REGISTRY, PROT.META.DOMAIN]
---
## Context

Three candidate entity IDs need validation against REF.META.NAMING.SCHEMA. The naming check follows four steps: PREFIX, DOMAIN, SUBJECT, ASPECT.

## The four-step check

1. Check PREFIX is a valid entity type
2. Check DOMAIN is in the canonical set (IDs with 3+ segments)
3. Check SUBJECT is a singular noun
4. Check ASPECT is a singular noun

## Walkthrough

### Candidate 1: PROT.LIB.CACHE.POLICY

| Check | Value | Verdict |
|-------|-------|---------|
| PREFIX | `PROT` | ✓ Valid — registered protocol prefix |
| DOMAIN | `LIB` | ✓ Canonical — in the domain set |
| SUBJECT | `CACHE` | ✓ Singular noun |
| ASPECT | `POLICY` | ✓ Singular noun |
| **Result** | | **PASS — valid ID** |

### Candidate 2: PROT.TOOL.VALIDATE.PIPELINE

| Check | Value | Verdict |
|-------|-------|---------|
| PREFIX | `PROT` | ✓ Valid |
| DOMAIN | `TOOL` | ✓ Canonical |
| SUBJECT | `VALIDATE` | ✗ Verb form — must be noun; rename to `VALIDATION` |
| ASPECT | `PIPELINE` | ✓ Singular noun |
| **Result** | | **FAIL — SUBJECT violation** |

Correction: `PROT.TOOL.VALIDATION.PIPELINE`

### Candidate 3: PAT.ITEM.STATUS

| Check | Value | Verdict |
|-------|-------|---------|
| PREFIX | `PAT` | ✓ Valid |
| DOMAIN | `ITEM` | ✗ Absent from canonical domain set. Valid domains include META, LIB, SCHEMA, TOOL, COMMAND, etc. |
| SUBJECT | `STATUS` | ✓ Singular noun |
| ASPECT | — | Missing third segment for four-segment ID |
| **Result** | | **FAIL — DOMAIN violation** |

Correction: `TERM.ITEM.STATUS` (as a term, which has no DOMAIN segment)

## Reference

### Valid prefixes

| Prefix | Entity type |
|--------|-------------|
| `PROT` | Protocol |
| `PAT` | Pattern |
| `ILL` | Illustration |
| `TERM` | Term |
| `CMD` | Command |
| `SKL` | Skill |
| `MAX` | Maxim |
| `PER` | Person |
| `APO` | Apologia |
| `ABS` | Abstraction |
| `LNG` | Linguistics |
| `INV` | Investigation |

## Key insight

The naming check is deterministic — given a candidate ID, the validation steps produce a pass/fail for each segment. Failed IDs go to REF.META.RENAME.REGISTRY for the canonical corrected form. The four-step check catches verb forms (VALIDATE → VALIDATION), non-canonical domains (ITEM → TERM), and missing aspects.

## See also

- `REF.META.NAMING.SCHEMA` — the naming protocol this illustrates
- `REF.META.NAMING.SCHEMA` — applied naming examples
- `REF.META.RENAME.REGISTRY` — historical record of corrected IDs
- `PROT.META.DOMAIN` — canonical domain set
