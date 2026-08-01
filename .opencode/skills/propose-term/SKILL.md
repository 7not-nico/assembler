---
name: propose-term
description: Use this skill when the user discusses a topic or tool absent from patlib — it detects the absence and proposes creating a term for it
state-profile: hybrid
type: procedure
related: [SKL.VET.PROPOSAL]
terms: [IDENTITY.TERM, TERM.TERM.NAMING.CONVENTION]
patterns: [NEX.META.PROPOSAL, MAX.DRY]
---

**Procedure**

When detecting a term:

0. **Classify the entity before proposing**:
   - Has authoritative external references to define a concept? → **term**, continue below
   - Single-instance walkthrough of a pattern or protocol? → **illustration**, run `SKL.GUIDE.ARCHITECTURE` instead
   - General design principle applicable across contexts? → **pattern**, run `SKL.PROPOSE.PATTERN` instead
   - Technical subsystem contract with enforcement rules and gotchas? → **protocol**, run `SKL.PROPOSE.PROTOCOL` instead

1. Infer ID from discussion, then check via `read-projection --type terms --id TERM.{ID}` — skip if exact match exists
2. Search via `read-selection --type terms --tag X` — find related terms to reference in body
3. Search via `read-selection --type patterns` and `read-selection --type protocols` — find relevant patterns and protocols to reference in body
4. Search via `read-selection --type rules` and `read-selection --type skills` — find relevant rules/skills to populate `related:` field
5. When missing — propose creation to the user, include related terms, patterns, protocols, and rules/skills found
6. On confirmation — write `.opencode/terms/TERM.{ID}.md` with populated `related:` and `reference:` fields
7. Run `write-sync` to sync the new term to `patlib.db`
8. Report the term ID

**Gotchas**

- Always check `read-projection` for exact ID match before proposing — duplicates violate DRY
- ID uppercase dot-separated, prefixed with TERM. — lowercase and hyphenation excluded
- Minimum 3 tags
- Reference is YAML object list — minimum 3 entries with title and url
- Terms and patterns go in body or `## See also` prose — backmatter excluded

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Proposing a protocol as a term | Entity has enforcement rules and gotchas. Framed as a concept definition | Run `SKL.PROPOSE.PROTOCOL` — protocols use `protocol:` frontmatter |
| Proposing a pattern as a term | Entity has a general principle. Framed as a concept | Run `SKL.PROPOSE.PATTERN` — patterns use `principle:` frontmatter |

- Rules/skills from step 4 populate the term's `related:` field
- After writing — run `write-sync` to sync to `patlib.db`, or the term won't appear in queries

**Rules**

- Body starts with `**{TermName}** —` followed by a 1-3 sentence definition
- Backmatter: id, title, source, tags, related, reference
- Field order: `related:` first, `reference:` second
- Reference entries require title and url — both mandatory
- `related:` is populated from skills/rules discovered in step 4
- Related terms and patterns go in the body paragraph — backmatter excluded
