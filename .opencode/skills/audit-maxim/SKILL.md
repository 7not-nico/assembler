---
name: audit-maxim
description: Use this skill when auditing maxim files — checks every .opencode/entities/maxims/ file against IDENTITY.MAXIM and PROT.MAXIM.SCHEMA
state-profile: stateful-auditor
type: reference
related: [IDENTITY.MAXIM, PROT.MAXIM.SCHEMA, SPEC.MAXIM.LINE.JUNCTION]
terms: [IDENTITY.MAXIM]
patterns: [NEX.TOOL.SEQUENCE, PROT.MAXIM.SCHEMA]
---

**Procedure**

When auditing maxims:

0. **Self-audit** — enumerate this skill's own `**Rules**` block. For each rule, search patlib for a maxim, protocol, or pattern that encodes it. Flag rules with no sourcing entity.

1. **Load identity** — read `IDENTITY.MAXIM` via `read-projection`. Identity defines: group `axiomatic`, ring `R0`, naming `MAX.{DOMAIN}.{SUBJECT}.{ASPECT}`, source always external. Audit against these values.

2. **Inventory** — locate every `.md` file under `.opencode/entities/maxims/`.

3. **Frontmatter fields** — per IDENTITY.MAXIM and PROT.MAXIM.SCHEMA: every maxim must have `id`, `title`, `source`, `summary`, `principle`, `enforcement`, `tags`, `status`, `priority`. Flag missing fields per file.

4. **ID format** — must match `MAX.{UPPERCASE.SEGMENTS}` (4 segments per SPEC.ENTITY.SEGMENT.COUNT). Flag malformed IDs.

5. **Body format** — body uses bullet lists only. Flag markdown tables, numbered lists, or field-level schema declarations.

6. **Section structure** — body must have `## Rules`, `## Applicability` sections. `## See also` is excluded per MAX.WRITING.NEGATIVE.SPACE — flag if present.

7. **Source attribution** — `source:` field must attribute external origin (`INSP.PRAGMATIC`, `INSP.SCHELL`, published works). Maxims source externally per IDENTITY.MAXIM — flag missing or `assembler` source.

8. **Group and ring** — verify consistency with IDENTITY.MAXIM: group `axiomatic`, ring `R0`. No `precedes` between maxims (orthogonal per IDENTITY.MAXIM).

9. **Report per file** — list each violation with file path.

10. **Summarize** — pass/fail count and compliance score.

**Gotchas**

- Table in body — markdown tables belong in protocols or references. Maxims use bullet lists. Convert accordingly.
- Field-level spec in body — schema declarations belong in identity protocols. Extract to the relevant `PROT.*.md`.
- Numbered steps in body — sequential procedures belong in skills or commands. Reclassify to appropriate entity type.
- Principle and summary mismatch — `principle:` states the core aphorism; `summary:` is a shorter form. They must express the same idea at different lengths.
- `##` headers in body — use `**bold**` section headers for visual consistency per RUL.WRITING.CONVENTION.
- See also present — maxims must not have `## See also` per MAX.WRITING.NEGATIVE.SPACE. Remove it.
- Source missing or `assembler` — maxims are externally sourced per IDENTITY.MAXIM. Project-internal principles use patterns or rules, not maxims.

**Rules**

- `principle:` field is a single declarative sentence stating the core aphorism
- Source attributes external origin when principle comes from outside `assembler`
- Rules section uses bullet lists only — no numbered steps, no tables
- Applicability section describes where the principle applies in generalized terms
- See also excluded from maxims — links belong in protocols and patterns
- Max 6 rules per segment — split into subsections if more needed
- ID format: `MAX.{DOMAIN}.{SUBJECT}.{ASPECT}` — 4 segments uppercase
- Group: `axiomatic`, Ring: `R0` — no precedes declarations
