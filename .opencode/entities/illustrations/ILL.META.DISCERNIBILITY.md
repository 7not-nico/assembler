---
id: ILL.META.DISCERNIBILITY
title: "Entity Discernibility Walkthrough — Segment Progression in Practice"
source: PROT.META.IDENTITY
summary: "Walk through the four-segment identity progression: how each Latin separation verb maps to an ID segment, using real protocol IDs."
illustration: "An agent validates protocol IDs against the discernibility principle — tracing PROT.SCHEMA.FORMAT through all four segments, examining a two-segment exception, and identifying a violation where an ASPECT carries no load."
illustrates: [SPEC.ENTITY.DISCERNIBILITY.SEGMENT]
tags: meta,discernibility,walkthrough,naming,entity,validation
related: [REF.META.NAMING.SCHEMA, REF.META.ENTITY.DUALITY, PROT.META.DOMAIN]
---
## Context

Every protocol in the AMANDA ecosystem has an ID following `PREFIX.DOMAIN.SUBJECT.ASPECT`. The discernibility principle states that each segment must resolve ambiguity left by the prior segments. The agent walks through six examples — valid configurations and violations.

## Walkthrough

### Step 1: Differentia in action

Three entity files in the codebase share the same DOMAIN.SUBJECT.ASPECT suffix:

| Entity type | File location | ID |
|-------------|---------------|-----|
| Protocol | `.opencode/protocols/PROT.SCHEMA.FORMAT.md` | `PROT.SCHEMA.FORMAT` |
| Pattern | `.opencode/patterns/PAT.SCHEMA.SEED.FORMAT.md` | `PAT.SCHEMA.SEED.FORMAT` |
| Illustration | `.opencode/illustrations/ILL.SCHEMA.SEED.FORMAT.md` | `ILL.SCHEMA.SEED.FORMAT` |

The PREFIX acts as a differentia — carrying apart entity types into separate directories with distinct lifecycles and conventions. Without the prefix, the three files would collide.

### Step 2: Distinct in action

Within the `PROT.` prefix, the DOMAIN segment separates functional areas:

| ID | Domain | Subject matter |
|-----|--------|---------------|
| `PROT.SCHEMA.FORMAT` | SCHEMA | Database schema conventions |
| `PROT.LIB.SEED.FORMAT` | LIB | Library-level seed formatting |
| `PROT.META.SEED.FORMAT` | META | Meta-level seed format governance |

Each domain constrains the protocol to a different enforcement layer. The DOMAIN pricks apart what the PREFIX left unified.

### Step 3: Cernere in action

Within the `PROT.SCHEMA.` domain, the SUBJECT segment sifts narrower topics:

| ID | Subject |
|-----|---------|
| `PROT.SCHEMA.FORMAT` | SEED |
| `PROT.SCHEMA.MIGRATION.FORMAT` | MIGRATION |
| `PROT.SCHEMA.JUNCTION.FORMAT` | JUNCTION |
| `REF.SCHEMA.FOLDER` | (no aspect needed — 2-segment exception) |

SEED, MIGRATION, JUNCTION, and FOLDER each describe a discrete schema topic. A hypothetical `PROT.SCHEMA.DATE.FORMAT` would sit beside `PROT.SCHEMA.FORMAT` — both at the same subject depth.

### Step 4: Determinant in action

Within `PROT.SCHEMA.SEED.`, the ASPECT bounds completely:

| ID | Aspect | Role |
|-----|--------|------|
| `PROT.SCHEMA.FORMAT` | FORMAT | File structure and bulk INSERT format |
| `REF.SCHEMA.SEED.MUTATION` | MUTATION | Prefix-based mutation strategy |
| `NEX.SCHEMA.PIPELINE` | PIPELINE | Compute-execute layer split |

Three sibling ASPECTs under SEED. FORMAT, MUTATION, and PIPELINE each describe a distinct dimension of seed data handling. The agent reads all three, verifies each carries a unique concern, and concludes the ASPECT earns its place.

### Step 5: Two-segment exception

`REF.SCHEMA.FOLDER` has only two segments — PREFIX and DOMAIN. Why no SUBJECT or ASPECT?

- Adding a generic SUBJECT like `STRUCTURE` would carry zero discriminative load (FOLDER already implies structure)
- Adding an ASPECT like `ROOT` or `LAYOUT` would be ornamental — no sibling exists to distinguish from

FOLDER as the DOMAIN uniquely identifies the protocol about schema folder layout. The omitted segments carry no load.

### Step 6: Violation — ornamental ASPECT

The agent encounters `REF.SCHEMA.DATE.PRECISION`. DATE has no sibling subjects — no other protocol under `PROT.SCHEMA.DATE.ASPECT` exists. PRECISION is the only ASPECT of DATE.

Per the discernibility principle, PRECISION carries zero discriminative load. The fix: drop to `PROT.SCHEMA.DATE` (three-segment). If a future `PROT.SCHEMA.DATE.FORMAT` or `PROT.SCHEMA.DATE.RANGE` appears, PRECISION earns its place and the 4-segment form restores.

## Key insight

Discernibility is a load test, a naming style guide excluded. Each segment carries or fails its discriminative weight. The four Latin verbs track a progression from physical separation (carrying apart) to abstract bounding (setting limits), and every entity ID should follow that gradient: type → area → topic → bound.

## See also

- `SPEC.ENTITY.DISCERNIBILITY.SEGMENT` — the maxim this walkthrough illustrates
- `REF.META.NAMING.SCHEMA` — mechanical segment rules
- `ILL.META.NAMING.SCHEMA` — naming validation walkthrough
- `PROT.META.DOMAIN` — canonical domain set; domains must be mutually discernible
- `ILL.META.STRATUM.MAP` — the four data strata
