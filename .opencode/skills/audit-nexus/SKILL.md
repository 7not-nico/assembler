---
name: audit-nexus
description: Use this skill when auditing nexus entity files — checks every NEX.*.md file under .opencode/entities/nexus/ against IDENTITY.NEXUS and PROT.NEXUS.COMPOSITION.BINDING
state-profile: stateful-auditor
type: reference
related: [IDENTITY.NEXUS, PROT.NEXUS.COMPOSITION.BINDING, NEX.TOOL.SEQUENCE, MAX.ENTITY.ONTOLOGY, MAX.KNOWLEDGE.CLASSIFICATION]
terms: [IDENTITY.NEXUS, TERM.NEXUS]
patterns: [NEX.TOOL.SEQUENCE]
---

**Procedure**

When auditing nexus:

0. **Self-audit** — enumerate this skill's own `**Rules**` block. For each rule, search patlib for a maxim, protocol, or pattern that encodes it. Flag rules with no sourcing entity.

1. **Load identity** — read `IDENTITY.NEXUS` via `read-projection`. Identity defines: group `composition`, ring `R2`, naming `NEX.{DOMAIN}.{SUBJECT}`, composition binding entity. Nexus states what composes — entities, layers, morphisms, and their binding relationships. Preceded by Patterns (R1). Precedes Illustrations and References (R3). Audit against these values.

2. **Inventory** — locate every `NEX.*.md` file under `.opencode/entities/nexus/`.

3. **Frontmatter fields** — per IDENTITY.NEXUS: every nexus must have `id`, `title`, `source`, `summary`, `composition`, `enforcement`, `related`, `tags`, `status`, `priority`. Flag missing fields per file.

4. **ID format** — per IDENTITY.NEXUS naming: `NEX.{UPPERCASE.SEGMENTS}` (3 segments per composition group convention). Flag malformed IDs.

5. **Title format** — must contain em-dash `—` between name and subtitle. Flag missing em-dash.

6. **Tags** — minimum 3 entries, inline array format `[tag1, tag2, tag3]`. Per PROT.META.IDENTITY. Flag comma-joined or missing.

7. **Composition field** — per IDENTITY.NEXUS: "Nexus states what composes — entities, layers, morphisms, and their binding relationships. Each nexus uses `composition:` frontmatter field." Flag missing or generic composition descriptions.

8. **Ring ordering** — per IDENTITY.NEXUS: "Preceded by Patterns (Composition R1). Precedes Illustrations and References (Composition R3). Morphism pipeline: protocol contracts, pattern prescribes, nexus composes." Verify source references patterns, related references illustrations/references where applicable.

9. **Body structure** — body opens with `**{Title}** —` bold line matching frontmatter title. Per IDENTITY.NEXUS: "Nexus is the only entity type that declares composition." Body may include prose paragraphs — not strictly bullet-only like maxims.

10. **Cross-reference** — run `read-projection` for each `related` entry. Flag unresolvable IDs.

11. **Duplicate ID** — flag if two files share the same `id`.

12. Report per nexus — list each violation with `file:line`.

13. Summarize — pass/fail count and compliance score.

**Gotchas**

- `composition:` is the defining field — analogous to `principle:` in patterns or `protocol:` in protocols. Missing composition means the nexus doesn't declare what it binds
- Tags use inline array `[tag1, tag2]`. Comma-separated format excluded per PROT.META.IDENTITY
- `related` field optional — missing and empty `related: []` both valid. Flagging excluded for either case
- Nexus body may include prose paragraphs — not strictly bullet-only like maxims. The bold opening line is the only structural requirement
- Section headers in body use `##` — no restriction compared to maxims
- Ring ordering: protocols R0 → patterns R1 → nexus R2 → illustrations/references R3. Verify source and related respect this chain

**Rules**

- 10 required frontmatter fields: id, title, source, summary, composition, enforcement, related, tags, status, priority
- ID format: `NEX.{UPPERCASE.SEGMENTS}` — uppercase dot-separated
- Title requires em-dash `—`
- Tags: 3+ entries, inline array format
- Composition field describes what the nexus composes per IDENTITY.NEXUS
- Body opens with `**{Title}** —` matching backmatter title
- Ring ordering respected: preceded by patterns, precedes illustrations/references
- Duplicate IDs across `.opencode/entities/nexus/` excluded
- Related entries resolve via `read-projection`
- Report format: per-nexus violations (`file:line`), then pass/fail count
