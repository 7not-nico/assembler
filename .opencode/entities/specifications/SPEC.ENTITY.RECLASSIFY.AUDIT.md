**Entity Reclassification** — an ID change requires a full cross-reference audit. Grep all files, update every match.

## Model

- Every entity ID (TERM.FOO, SPEC.DRY, etc.) may appear as a cross-reference in any other entity file.
- Cross-references use the full ID string in frontmatter fields (`related:`, `source:`, `patterns:`, `terms:`).
- Cross-references also appear in body text (`## See also` lists, prose references).
- An entity ID change produces stale references that produce sync errors, search failures, and broken navigation.

## Rules

- To reclassify an entity, grep all `.md` files in `entities/` for the exact old ID string.
- Update each match to the new ID. Partial matches (e.g. TERM.FOO matching within TERM.FOOBAR) also need a look.
- After the update, sync all entity types and verify cross-references via patlib lookup.
- Illustration files with embedded example IDs receive the update despite being prose examples.
- Protocol files that contain the old ID in example text or rule descriptions receive the update to match.
- Process longest IDs first to avoid artifacts of partial replacement (TERM.QUANTITATIVE before TERM.QUANTI).

## Applicability

Any entity ID change: reclassification (TERM→COG, TERM→CON), rename, umbrella restructure. Does not apply to content-only edits where the ID remains unchanged.

---
id: SPEC.ENTITY.RECLASSIFY.AUDIT
title: Entity Reclassification — Rename Requires Cross-Reference Audit
source: assembler
summary: "An entity ID change (type prefix TERM → COG, or full rename) creates stale cross-references. Every reclassification greps all entity files for the old ID and updates each match."
specifies: Cross-reference audit required before entity reclassification
tags: [entity, reclassification, cross-reference, audit, consistency, migration, specification]
status: active
---
