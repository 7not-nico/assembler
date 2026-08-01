**Naming Convention** — entity ID format and suffix selection rules for patlib term registration.

## Protocol

### 1. ID Format

1. **Hierarchical dot-separated pattern** — IDs use uppercase segments: `{DOMAIN}.{SPECIFIC}`. Broad domains use a single segment; sub-domains extend with additional segments.
2. **Shared prefixes group related terms** — `TERM.AUDIT.*`, `TERM.PLANE.*`, `TERM.FM.*` all share a prefix.
3. **Title is human-readable** — capitalised text, independent of the ID.
4. **Source field** — `assembler` for project-specific terms, `general` for cross-domain concepts.
5. **Apologia prefix** — `APO.*` for philosophical boundary documents.

### 2. Suffix Selection

6. **Register by aspect** — for Latin-derived word triplets, map suffix to sense:
   - `-ence`/`-ance`/`-ience`: state, result, concrete instance (punctual, achieved)
   - `-ency`/`-ancy`/`-iency`: systemic property, abstract quality, ongoing regime (atelic, continuous)

   | Triplet family | Adjective | State/Result | System/Regime |
   |---|---|---|---|
   | 2nd/3rd/4th conj. | `-ent` | `-ence` | `-ency` |
   | 1st conjugation | `-ant` | `-ance` | `-ancy` |
   | 3rd-io/4th variant | `-ient` | `-ience` | `-iency` |

7. **Exclude -ent/-ant/-ient** — use only the noun forms as term names. Nominalize the participial adjective to `-ence`/`-ance`/`-ience` or `-ency`/`-ancy`/`-iency`.

8. **Collapse to dominant** — where only one noun form is standard English (`resistance`, `intelligence`), register that form regardless of semantic fit.

9. **Document the choice** — when registering a two-form pair, include a note in the term body explaining which suffix was chosen and why.

## Rationale

- Deterministic ID format enables automated validation, routing, and cross-referencing
- Consistent prefix grouping makes related entities discoverable by ID pattern
- The `-ent`/`-ant`/`-ient` form fills an adjectival role — registering it as a term conflates property with entity
- The noun distinctions reflect real aspectual differences in their Latin parents (`-entia`/`-antia`/`-ientia` as result vs activity)
- Consistent suffix selection prevents synonym-clutter in the ID space
- Both families follow the same aspectual split — treating them uniformly reduces cognitive load

## Gotchas

| Antipattern | Detection | Redirect |
|---|---|---|
| Unknown ID prefix | Prefix absent from controlled vocabulary — validator rejects | Add prefix to route table |
| Mismatch between ID prefix and directory | File path differs from prefix's mapped directory | Place file in correct directory |
| Duplicate ID across files | Two files share same `id:` | Rename one ID to unique value |
| Registering `-ent`/`-ant`/`-ient` as term | Term body uses an adjective as core referent | Nominalize to the noun form |
| Both suffix forms exist with only one standard | `resilience` (standard) vs `resiliency` (rare); `resistance` vs `resistancy` | Register dominant form — collapse rule |
| Pseudo-pairs with divergent meaning | `emergence` vs `emergency` — distinct concepts | Register both as separate terms |

## Enforcement

Manual review during term and protocol audit. Tool may later validate ID format against the route table and flag `-ent`/`-ant`/`-ient` nominalizations or missing collapse-rule application.

## Applicability

Use when registering any patlib term entity.

Suffix rules apply to Latin-derived -ent/-ence/-ency, -ant/-ance/-ancy, and -ient/-ience/-iency triplets. Inapplicable to Greek-derived suffixes (-ism, -logy, -ic) or non-Latin roots.

## See also

- `PROT.CORE.ENTITY.ROUTING` — ID routing to directories and DB tables
- `TERM.SKILL.NAMING.CONVENTION` — parallel convention for skill identifiers
- `COG.LINGUISTICS` — suffix etymology and morphology
- `IDENTITY.TERM` — term entity identity

---
id: LING.NAMING.CONVENTION
title: Naming Convention — ID Format and Suffix Selection
source: SPEC.ENTITY.DISCERNIBILITY.SEGMENT
related:
  - PROT.CORE.ENTITY.ROUTING
  - TERM.SKILL.NAMING.CONVENTION
  - COG.LINGUISTICS
tags: convention, naming, terms, linguistics, suffix
reference: []
---
