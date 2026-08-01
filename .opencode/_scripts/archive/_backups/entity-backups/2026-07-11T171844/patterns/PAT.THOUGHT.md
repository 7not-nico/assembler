---
id: PAT.THOUGHT
title: "Skills — Derived Skill Index"
source: assembler
summary: Every skill has a corresponding entry in the skills table, derived automatically from SKILL.md frontmatter at sync time — no dedicated files.
principle: >
  Every skill in `.opencode/skills/*/SKILL.md` must always have `name`,
  `description`, and `state-profile` in frontmatter. These fields populate the
  `skills` table at sync time. The skill ID is derived: `name` →
  `SKL.{UPPERCASE.NAME}`. No dedicated files exist.
enforcement: Tool
tags: [skill, index, derived, patlib, sync, convention]
patterns: [PAT.SKILL.STATECLASS,PAT.OPENCODE.THOUGHT]
terms: [TERM.HORIZONTAL.PARTITIONING,TERM.VERTICAL.PARTITIONING]
related: []
status: active
priority: 3
---

Every skill has a corresponding row in the `skills` table — no dedicated files needed.

## Context

The original `PAT.OPENCODE.THOUGHT` required per-skill `.md` files in `_thoughts/`. This created sync surface with no benefit: the content was a restyle of the skill's own `description` field. The replacement derives all skill metadata directly from `skills/*/SKILL.md` frontmatter at sync time.

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

- `PAT.OPENCODE.THOUGHT` — superseded pattern
- `PAT.SKILL.STATECLASS` — state-profile values and rules
- `TERM.HORIZONTAL.PARTITIONING` — `read-selection` filters rows (selection)
- `TERM.VERTICAL.PARTITIONING` — `read-projection` returns columns (projection)
