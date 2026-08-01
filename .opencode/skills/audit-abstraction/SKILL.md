---
name: audit-abstraction
description: Use this skill when auditing abstraction files — checks every ABS.*.md file under .opencode/entities/abstractions/ for structural and semantic compliance. No IDENTITY.ABSTRACTION exists yet — references SPEC.ENTITY.ROUTING.TABLE for prefix convention
state-profile: stateful-auditor
related: [SPEC.ENTITY.ROUTING.TABLE, PROT.COGNITION.SCHEMA]
patterns: ["NEX.TOOL.SEQUENCE"]
---

**Procedure**

When auditing abstractions:

1. **Load routing spec** — read `SPEC.ENTITY.ROUTING.TABLE` via `read-projection`. Confirms `ABS.` prefix for abstraction entities. Absence of IDENTITY.ABSTRACTION is a known gap — abstractions lack an identity definition.

2. **Inventory** — locate every `ABS.*.md` file under `.opencode/entities/abstractions/`.

3. **Backmatter** — must include all 5 fields: `id`, `title`, `source`, `tags`, `reference`. Per SPEC.ENTITY.ROUTING.TABLE and abstraction convention. Flag missing fields.

4. **ID prefix** — starts with `ABS.` per SPEC.ENTITY.ROUTING.TABLE. Flag malformed prefixes.

5. **Body opening** — `**{Name}** —` (bold name, space, em-dash). Flag missing or misformatted.

6. **Tags** — 3+ entries; `reference` — 3+ entries each with `title` + `url`.

7. **Content boundary** — abstraction body defines formal systems only (symbolic notation, inference rules). Move illustrative content or teaching examples to associated patterns.

8. **Related resolution** — verify each `related` entry resolves via `read-projection`.

9. **Duplicate IDs** — confirm no duplicate `id` across files.

10. **Report per abstraction** — list each violation with `file:line`.

11. **Summarize** — pass/fail count and compliance score.

**Gotchas**

- Abstraction body defines a general concept without formal rules — write a `TERM.*` entry and reference it from `related`
- Abstraction body includes behavioral instructions or constraints — write a `PAT.*` entry and reference it from `related`
- Body text omits the bold em-dash opening — add `**{Title}** —` matching the YAML title
- Reference entries without `title` — include both `title` and `url` for every entry
- No IDENTITY.ABSTRACTION exists — identity definition is a known gap. Until created, audit against SPEC.ENTITY.ROUTING.TABLE and convention

**Rules**

- Backmatter includes all 5 fields: id, title, source, tags, reference
- ID prefix: `ABS.` per SPEC.ENTITY.ROUTING.TABLE
- Body opens with `**{Title}** —` matching backmatter title
- Tags: 3+ entries; Reference: 3+ entries, each with title + url
- Body defines formal systems — no general-concept definitions (→ terms) or behavioral instructions (→ patterns)
- Related entries resolve via `read-projection`
- No two abstractions share the same `id`
- Report format: per-abstraction violations with `file:line`, then pass/fail count
