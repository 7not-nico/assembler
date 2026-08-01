---
name: propose-pattern
description: Use this skill when the user discusses a design convention absent from patlib — it detects the absence and proposes creating a pattern for it
state-profile: hybrid
type: procedure
related: [SKL.VET.PROPOSAL]
terms: [IDENTITY.PATTERN]
patterns: [NEX.META.PROPOSAL, MAX.DRY]
---

**Procedure**

When detecting a pattern:

0. **Classify the entity before proposing**:
   - General design principle applicable across contexts? → **pattern**, continue below
   - Single-instance walkthrough of a pattern or protocol? → **illustration**, run propose workflow via `SKL.GUIDE.ARCHITECTURE` instead
   - Technical subsystem contract with enforcement rules and gotchas? → **protocol**, run `SKL.PROPOSE.PROTOCOL` instead

1. Check via `read-selection` — skip if the pattern already exists
2. Search via `read-selection --type protocols` and `read-selection --type terms` — find relevant protocols and terms the pattern should reference
3. Search via `read-selection --type patterns` — find related patterns for `## See also`
4. Search via `read-selection --type rules` and `read-selection --type skills` — find related rules/skills for `## See also`
5. When missing — propose creation to the user, include related protocols, terms, patterns, rules/skills found
6. On confirmation — write `.opencode/patterns/PAT.{ID}.md` with related entities listed in `## See also`
7. Run `write-sync` to sync the new pattern to `patlib.db`
8. Report the pattern ID

**Gotchas**

- Always check `read-selection` before proposing — duplicates violate DRY
- ID uppercase dot-separated, prefixed with PAT. — lowercase and hyphenation excluded
- Title uses em-dash format: `{Name} — {Subtitle}` — colon and dash excluded
- Minimum 3 tags
- Patterns can have optional sections (Context, Migration) — match structure to the pattern's domain

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Proposing a protocol as a pattern | Entity has enforcement rules, gotchas, or implementation-specific rules. Framed as a principle | Run `SKL.PROPOSE.PROTOCOL` — protocols use `protocol:` frontmatter with gotchas section |

- Related entities from steps 2–4 populate the `## See also` section
- After writing — run `write-sync` to sync to `patlib.db`, or the pattern won't appear in queries

**Rules**

**Frontmatter**
- Required: id, title, source, summary, principle, enforcement, tags, status, priority
- Enforcement: Tool, Convention, or Review
- Status: active, draft, or deprecated
- Priority: 1 (highest) to 5 (lowest)

**Body**
- Opening statement repeats principle. Optional sections as needed
- Required sections: `## Rules`, `## Applicability`, `## See also`
- `## See also` lists related terms, patterns, rules, and skills by ID
