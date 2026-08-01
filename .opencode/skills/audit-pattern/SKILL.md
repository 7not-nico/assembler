---
name: audit-pattern
description: Use this skill when auditing pattern files — checks every .opencode/entities/patterns/ file against IDENTITY.PATTERN and PROT.PATTERN.MORPHISM.DESIGN
state-profile: stateful-auditor
type: reference
related: [IDENTITY.PATTERN, PROT.PATTERN.MORPHISM.DESIGN, PROT.TOOL.AUTOMATON]
terms: [IDENTITY.PATTERN]
patterns: [NEX.TOOL.SEQUENCE, MAX.DRY]
---

**Procedure**

When auditing patterns:

0. **Self-audit** — enumerate this skill's own `**Rules**` block. For each rule, search patlib for a maxim, protocol, or pattern that encodes it. Flag rules with no sourcing entity.

1. **Load identity** — read `IDENTITY.PATTERN` via `read-projection`. Identity defines: group `composition`, ring `R1`, naming `PAT.{DOMAIN}.{SUBJECT}`, morphism design entity. Preceded by Protocols (R0). Precedes Nexus (R2). Audit against these values.

2. **Inventory** — locate every `.md` file under `.opencode/entities/patterns/`.

3. **Frontmatter fields** — every pattern must have `id`, `title`, `source`, `summary`, `morphism`, `enforcement`, `tags`, `status`, `priority`. Flag missing fields per file.

4. **ID format** — must match `PAT.{UPPERCASE.SEGMENTS}` (3 segments per SPEC.ENTITY.SEGMENT.COUNT — axiomatic/composition groups use 4, patterns are composition R1 and follow `PAT.{DOMAIN}.{SUBJECT}`). Flag malformed IDs.

5. **Morphism field** — `morphism:` must state the system morphism design. Per IDENTITY.PATTERN: patterns "prescribe how the system morphs — transform, recognize, generate, synchronize". Flag missing or generic morphism.

6. **Enforcement** — one of `Tool`, `Convention`, `Review`. Per enforcement value: `Tool` requires the tool to exist in project's `.opencode/tools/`. Manually verify existence.

7. **Tags** — minimum 3 entries, inline array format `[tag1, tag2]`. Per PROT.META.IDENTITY. Flag comma-joined or missing.

8. **Body convention** — per IDENTITY.PATTERN: each pattern "declares its morphism design in a `morphism:` field with corollary rules and applicability". Body must have `## Rules`, `## Applicability`, `## See also`. Flag missing sections.

9. **Illustration check** — per IDENTITY.PATTERN: "May be illustrated." If pattern has concrete named instances in body, verify paired ILL.* exists via `patlib_illustrations`. Run `patlib_illustrations --entity_id {PATTERN.ID}`.

10. **Cross-reference** — every ID in `## See also` must resolve via `patlib_get`. Flag unresolvable IDs.

11. **Ring ordering** — per IDENTITY.PATTERN: "Preceded by Protocols (Composition R0). Precedes Nexus (Composition R2)." Verify source and related respect this ordering.

12. **Report per file** — list each violation with file path.

13. **Summarize** — pass/fail count and compliance score.

**Gotchas**

- `enforcement: Tool` requires the tool to exist in a project's `.opencode/tools/` — manually verify existence. `audit-patterns` skips tool existence check
- Weak `morphism` values with no actionable content — structural check passes. Semantic review needed separately. Does the morphism tell a reader what the system does?
- `## See also` entries referencing freeform text or project-specific IDs — keep references to resolvable patlib IDs only; use `read-projection` to verify
- Group `composition`, ring `R1` — distinguish from protocols (R0) and nexus (R2). Patterns prescribe morphisms; protocols contract; nexus composes

**Rules**

- Frontmatter: id, title, source, summary, morphism, enforcement, tags, status, priority
- ID format: `PAT.{DOMAIN}.{SUBJECT}` — 3 segments uppercase
- Morphism field describes system transformation
- Tags: 3+ entries inline array
- Body sections: ## Rules, ## Applicability, ## See also
- Related entries resolve via `read-projection`
- Illustrated patterns have ILL.* paired entity
- Ring ordering respected: source from protocols, precedes nexus
- Report format: per-file violations with file path, then pass/fail count
