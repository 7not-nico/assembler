---
name: audit-protocol
description: Use this skill when auditing protocol files — checks every .opencode/entities/protocols/ file against IDENTITY.PROTOCOL and PROT.META.IDENTITY
state-profile: stateful-auditor
related: [IDENTITY.PROTOCOL, PROT.META.IDENTITY, PROT.LLM.SPECIFICATION]
terms: [IDENTITY.PROTOCOL]
---

**Procedure**

When auditing protocols:

0. **Self-audit** — enumerate this skill's own `**Rules**` block. For each rule, search patlib for a maxim, protocol, or pattern that encodes it. Flag rules with no sourcing entity.

1. **Load identity** — read `IDENTITY.PROTOCOL` via `read-projection`. Identity defines: group `composition`, ring `R0`, naming `PROT.{DOMAIN}.{NAME}`, technical contract entity. Preceded by Axiomatic entities (SPEC/MAX/PRE). In morphism pipeline: protocol contracts, pattern prescribes, nexus composes. Audit against these values.

2. **Inventory** — locate every `PROT.*.md` file under `.opencode/entities/protocols/`.

3. **Frontmatter** — must have all 9 required fields: `id`, `title`, `source`, `summary`, `protocol`, `enforcement`, `status`, `priority`, `tags`. `related` optional — cross-ref check if present.

4. **ID format** — per IDENTITY.PROTOCOL naming: `PROT.{DOMAIN}.{NAME}` uppercase dot-separated. 3 segments per composition group convention. Flag malformed IDs.

5. **Title format** — must contain em-dash `—` between name and subtitle.

6. **Enforcement** — one of `Sealed`, `Accord`, `Formality` per IDENTITY.PROTOCOL. Flag invalid values.

7. **Status** — one of `active`, `draft`, `deprecated`.

8. **Priority** — integer 1–5.

9. **Tags** — minimum 3 entries, inline array format `[tag1, tag2, tag3]`. Per PROT.META.IDENTITY.

10. **Body sections** — required: `## Protocol`, `## Enforcement`, `## Applicability`, `## See also`. `## Gotchas` recommended.

11. **Gotchas section** — if present, every antipattern must pair with a positive redirect per PROT.LLM.SPECIFICATION.

12. **Content ratio** — `## Protocol` must maintain ≥3:1 positive-to-negative per RUL.POSITIVE.NEGATIVE.RATIO.

13. **Protocol field** — per IDENTITY.PROTOCOL: "each protocol carries a `protocol:` frontmatter field stating the core contract". Flag missing or generic contract statement.

14. **Precedes check** — per IDENTITY.PROTOCOL: "Preceded by Axiomatic entities (SPEC/MAX/PRE)". Verify source references SPEC, MAX, or PRE entities. Flag if missing.

15. **Resolve `related` entries** — run `read-projection` for each, flag unresolvable IDs.

16. **Resolve cross-file duplicate IDs** — flag if two files share the same `id`.

17. Report per protocol — list each violation with `file:line`.

18. Summarize — pass/fail count and compliance score.

**Gotchas**

- `protocol:` frontmatter field must state the core technical contract. General design principles excluded — those belong in patterns
- `enforcement: Convention` requires a body tool reference — flag absent unless `audit-lib` or similar described
- Tags use inline array `[tag1, tag2]`. per PROT.META.IDENTITY. Comma-separated format excluded
- `related` field optional — missing and empty `related: []` both valid. Flagging excluded for either case
- Group composition R0 — protocols are the first composition layer. Source from axiomatic (MAX/SPEC/PRE), precede patterns (R1)

**Rules**

- 9 required frontmatter fields: id, title, source, summary, protocol, enforcement, status, priority, tags; related optional
- ID format: `PROT.{DOMAIN}.{NAME}` — uppercase dot-separated
- Title requires em-dash `—`
- Enforcement: `Sealed`, `Accord`, or `Formality`
- Status: `active`, `draft`, or `deprecated`
- Priority: integer 1–5
- Tags: 3+ entries, inline array format
- Protocol field declares core contract
- Sections: `## Protocol`, `## Enforcement`, `## Applicability`, `## See also` (required); `## Gotchas` (recommended)
- Gotchas pair each antipattern with a positive redirect
- `## Protocol` maintains ≥3:1 positive-to-negative instruction ratio
- Preceded by axiomatic entities — source references SPEC/MAX/PRE
- Duplicate IDs across `.opencode/entities/protocols/` excluded
- Related entries resolve via `read-projection`
- Report format: per-protocol violations (`file:line`), then pass/fail count
