---
id: NEX.META.SKILL.INDEX
title: "Skills — Derived Skill Index"
source: assembler
summary: Every skill has a corresponding entry in the skills table, derived automatically from SKILL.md frontmatter at sync time — no dedicated files.
composition: Every skill in `.opencode/skills/*/SKILL.md` must always have `name`, `description`, and `state-profile` in frontmatter. These fields populate the `skills` table at sync time. The skill ID is derived; `name` → `SKL.{UPPERCASE.NAME}`. No dedicated files exist.
enforcement: Tool
tags: [skill, index, derived, patlib, sync, convention]
related: []
status: active
priority: 3
---

Every skill has a corresponding row in the `skills` table — no dedicated files needed.

## Rules

- Every skill in `skills/*/SKILL.md` has a corresponding row in the `skills` table
- Skill ID derived: `name.toUpperCase().replace(/-/g, '.')` → `SKL.{UPPERCASE.NAME}`
- `body` = `description` from skill frontmatter
- `skill` = `name` from skill frontmatter
- `state_profile` = `state-profile` from skill frontmatter
- No dedicated files — table populated by `write-sync --type skills`
- A skill missing `description` or `state-profile` in frontmatter produces a broken skill row — validate before sync

## Applicability

All AMANDA projects with `.opencode/skills/` directories — the skills table is the queryable entry point for skill discovery.

## See also

- `ILL.META.SKILL.INDEX` — walkthrough of skill metadata derivation
- `PROT.SKILL.PROFILE` — state-profile values and rules
- `CON.HORIZONTAL.PARTITIONING` — `read-selection` filters rows (selection)
- `CON.VERTICAL.PARTITIONING` — `read-projection` returns columns (projection)
