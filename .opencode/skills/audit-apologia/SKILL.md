---
name: audit-apologia
description: Use this skill when auditing apologia files — checks every APO.*.md file under .opencode/entities/apologias/ for structural and semantic compliance. No IDENTITY.APOLOGIA exists — references SPEC.ENTITY.ROUTING.TABLE for prefix convention
state-profile: stateful-auditor
related: [SPEC.ENTITY.ROUTING.TABLE, PROT.META.IDENTITY]
patterns: ["NEX.TOOL.SEQUENCE"]
---

**Procedure**

When auditing apologias:

1. **Load routing spec** — read `SPEC.ENTITY.ROUTING.TABLE` via `read-projection`. Confirms `APO.` prefix for apologia entities. No IDENTITY.APOLOGIA exists — identity definition is a known gap.

2. **Inventory** — locate every `APO.*.md` file under `.opencode/entities/apologias/`.

3. **Frontmatter** — must have `id`, `title`, `source`, `tags`, `related`. Flag missing fields.

4. **ID format** — must match `APO.{UPPERCASE.SEGMENTS}` per SPEC.ENTITY.ROUTING.TABLE. Flag malformed IDs.

5. **Tags** — minimum 3 entries, inline array format per PROT.META.IDENTITY. Flag comma-joined or missing.

6. **Related resolution** — run `read-projection` for each `related` entry, flag unresolvable IDs.

7. **Duplicate IDs** — flag if two files share the same `id`.

8. **Body convention** — apologia body is argumentative prose. Per convention: "An apologia defends boundaries." Body should argue for a position, not define a term. Flag definitions disguised as apologias.

9. **Report per apologia** — list each violation with `file:line`.

10. **Summarize** — pass/fail count and compliance score.

**Gotchas**

- An apologia without argumentation is a term masquerading as an apologia — flag definitions disguised as philosophical documents
- Frontmatter is YAML, body is prose — an apologia is meant to be read. Executable behavior excluded
- Related entries reference existing patlib entities — an apologia defends boundaries. Isolation creation excluded
- No IDENTITY.APOLOGIA exists — identity definition is a known gap. Until created, audit against SPEC.ENTITY.ROUTING.TABLE and convention

**Rules**

- Frontmatter requires id, title, source, tags, related
- ID must match `APO.{UPPERCASE.SEGMENTS}` per SPEC.ENTITY.ROUTING.TABLE
- Tags must have 3 or more entries in inline array format
- Related entries must resolve via `read-projection`
- No two apologias may share the same `id`
- Body is argumentative prose — not definitional or behavioral
- Report format: per-apologia violations with `file:line`, then pass/fail count
