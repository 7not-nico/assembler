---
name: audit-term
description: Use this skill when auditing term files — checks every .opencode/entities/terms/ file against IDENTITY.TERM and PROT.TERM.SCHEMA
state-profile: stateful-auditor
type: reference
related: [IDENTITY.TERM, PROT.TERM.SCHEMA]
terms: [IDENTITY.TERM, TERM.TERM.NAMING.CONVENTION]
patterns: [NEX.TOOL.SEQUENCE, MAX.DRY]
---

**Procedure**

When auditing terms:

0. **Self-audit** — enumerate this skill's own `**Rules**` block. For each rule, search patlib for a maxim, protocol, or pattern that encodes it. Flag rules with no sourcing entity.

1. **Load identity** — read `IDENTITY.TERM` via `read-projection`. Identity defines: group `encyclopedic`, ring `R3`, naming `TERM.{NAME}`, vocabulary entry defining a project label. Internal terms source `assembler`; external terms source from CON.* or DEF.* ID. Audit against these values.

2. **Inventory** — locate every `.md` file under `.opencode/entities/terms/`.

3. **Frontmatter fields** — per IDENTITY.TERM and PROT.TERM.SCHEMA: must have `id`, `title`, `source`, `tags`, `reference`. `related` optional. Flag missing fields per file.

4. **ID format** — must match `TERM.{UPPERCASE.SEGMENTS}` (3 segments per encyclopedic group convention). Flag malformed IDs.

5. **Body format** — per IDENTITY.TERM: "Terms answer *what label*." Body uses bold opening line `**{Name}** — {definition}`. Flag tables, numbered steps, or behavioral instructions.

6. **Source validation** — per IDENTITY.TERM: "Internal terms source from `assembler`. External terms source from a CON.* or DEF.* ID." Validate source value matches term type. Flag `assembler` source for externally-referenced terms; flag missing CON.*/DEF.* source for external terms.

7. **Tags** — minimum 3 entries, inline array format per PROT.META.IDENTITY. Flag comma-joined or missing.

8. **Reference** — minimum 3 entries, each with `title` + `url`. Per PROT.TERM.SCHEMA.

9. **Resolve `related` entries** — run `read-projection` for each, flag unresolvable IDs.

10. **Cross-file duplicate IDs** — flag if two files share the same `id`.

11. **Report per file** — list each violation with `file:line`.

12. **Summarize** — pass/fail count and compliance score.

**Gotchas**

- Body text uses examples or illustrations — terms define; examples belong in patterns or reference notes. Write `**{Name}** — {current-state definition}`
- Body text includes historical context, past names, or renaming history — keep body current-state-only; move history to changelog or related pattern
- `source` value is freeform rather than project/org name — use `assembler` (project-specific), `general` (cross-domain), or the actual org name (external concepts)
- Per IDENTITY.TERM: terms answer *what label*. If the entity answers *what thing*, reclassify to DEFINITION. If *what idea*, reclassify to CONCEPT

**Rules**

- Frontmatter: id, title, source, tags, reference; related optional
- ID format: `TERM.{UPPERCASE.SEGMENTS}`
- Source matches term type: `assembler` for internal, CON.*/DEF.* for external
- Tags: 3+ entries inline array
- Reference: 3+ entries with title + url
- Body: bold opening line, current-state definition only
- No behavioral instructions, tables, or numbered steps in body
- Related entries resolve via `read-projection`
- No duplicate IDs
- Report format: per-term violations (`file:line`), then pass/fail count
