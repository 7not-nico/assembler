---
id: PROT.META.INDEX
title: "Skills — Derived Skill Index Protocol"
source: assembler
summary: "Every skill has a corresponding entry in the skills table, derived automatically from SKILL.md frontmatter at sync time. The skill ID is derived from the skill name."
protocol: "Every skill in .opencode/skills/*/SKILL.md declares name, description, and state-profile in frontmatter. These fields populate the skills table at sync time. The skill ID is derived: name → SKL.{UPPERCASE.NAME}. No dedicated files exist."
enforcement: Sealed
status: active
priority: 3
tags: [skill, index, derived, patlib, sync, convention]
related: [PROT.SKILL.PROFILE, ILL.META.SKILL.INDEX]
---

Every skill has a corresponding row in the `skills` table — no dedicated files needed.

## Protocol

1. **Every skill in `skills/*/SKILL.md` has a corresponding row in the `skills` table** — the table is the queryable entry point for skill discovery.

2. **Skill ID is derived** — `name.toUpperCase().replace(/-/g, '.')` → `SKL.{UPPERCASE.NAME}`. The `name` field in SKILL.md frontmatter is the single source of the derived ID.

3. **Body column populated from `description`** — the `body` column in the `skills` table equals the `description` field from skill frontmatter.

4. **State profile column populated from `state-profile`** — the `state_profile` column in the `skills` table equals the `state-profile` field from skill frontmatter.

5. **No dedicated files** — the `skills` table is populated by `write-sync --type skills`. No separate entity files exist for individual skill rows.

6. **Validate before sync** — a skill missing `description` or `state-profile` in frontmatter produces a broken skill row. Run read-validate before syncing.

## Gotchas

- Skill missing description in frontmatter: Add `description` field — body column becomes empty string (`skills` row exists but body column is NULL)
- Skill missing state-profile: Add `state-profile` field — state_profile column becomes NULL (`skills` row exists but state is unclassified)
- Skill name change breaks derived ID: Rename the directory and update `name` field — derived ID updates on next sync (Existing tools referencing the old SKL.* ID will break)

## Enforcement

`write-sync --type skills` populates the skills table on every run. The `read-validate` tool verifies all skills have `description` and `state-profile` in frontmatter. Missing fields are flagged before sync.

## Applicability

All AMANDA projects with `.opencode/skills/` directories — the skills table is the queryable entry point for skill discovery.

## See also

- `ILL.META.SKILL.INDEX` — walkthrough of skill metadata derivation
- `PROT.SKILL.PROFILE` — state-profile values and rules
- `CON.HORIZONTAL.PARTITIONING` — `read-selection` filters rows (selection)
- `CON.VERTICAL.PARTITIONING` — `read-projection` returns columns (projection)
