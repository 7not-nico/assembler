**Entity Reclassification** — ID change requires full cross-reference audit. Grep all files, update every match.

## Model

- Every entity ID (TERM.FOO, SPEC.DRY, etc.) may appear as a cross-reference in any other entity file.
- Cross-references use the full ID string in frontmatter fields (`related:`, `source:`, `patterns:`, `terms:`).
- Cross-references also appear in body text (`## See also` lists, prose references).
- Changing an entity's ID produces stale references that produce sync errors, search failures, and broken navigation.

## Rules

- Entity reclassification requires a grep of all `.md` files in `entities/` for the exact old ID string.
- Each match is updated to the new ID. Partial matches (e.g. TERM.FOO matching within TERM.FOOBAR) also require inspection.
- After updating, all entity types are synced and cross-references are verified via patlib lookup.
- Illustration files with embedded example IDs are updated despite being prose examples.
- Protocol files containing the old ID in example text or rule descriptions are updated to match.
- Longest IDs are processed first to avoid partial replacement artifacts (TERM.QUANTITATIVE before TERM.QUANTI).

## Applicability

Any entity ID change: reclassification (TERM→COG, TERM→CON), rename, umbrella restructuring. Does not apply to content-only edits where the ID remains unchanged.

---
id: SPEC.ENTITY.RECLASSIFY.AUDIT
title: Entity Reclassification — Rename Requires Cross-Reference Audit
source: assembler
summary: "Changing an entity's type prefix (TERM → COG) or ID creates stale cross-references. Every reclassification must grep all entity files for the old ID and update each match."
specifies: Cross-reference audit required before entity reclassification
tags: [entity, reclassification, cross-reference, audit, consistency, migration, specification]
status: active
---
