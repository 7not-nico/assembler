---
name: propose-protocol
description: Use this skill when the user discusses a technical contract absent from patlib — it detects the absence and proposes creating a protocol for it
state-profile: hybrid
type: procedure
related: [SKL.VET.PROPOSAL]
patterns: [NEX.META.PROPOSAL, PROT.META.IDENTITY, MAX.DRY]
---

**Procedure**

When detecting a protocol:

0. **Classify the entity before proposing**:
   - Has authoritative external references to define a concept? → **term**, run `SKL.PROPOSE.TERM` instead
   - General design principle applicable across contexts? → **pattern**, run `SKL.PROPOSE.PATTERN` instead
   - Single-instance walkthrough of a pattern or protocol? → **illustration**, run propose workflow via `SKL.GUIDE.ARCHITECTURE` instead
   - Technical subsystem contract with enforcement rules and gotchas? → **protocol**, continue below

1. Check via `read-selection --type protocols` — skip if exact match exists
2. Search via `read-selection --type patterns` — find related patterns for applicability context and See also
3. Search via `read-selection --type protocols` — find related protocols for See also
4. Search via `read-selection --type terms` — find relevant terms for Rationale references
5. When missing — propose creation to the user, include suggested ID and related entities found
6. On confirmation — write `.opencode/protocols/PROT.{DOMAIN}.{NAME}.md` with frontmatter and required body sections
7. Run `write-sync --type protocols` to sync to patlib.db
8. Report the protocol ID

**Body template**

```
**Protocol**

1. {Positive rule} — {what to do}
2. {Positive rule} — {what to do}
3. {Positive rule} — {what to do}

**Rationale**

{declarative reasoning — why this protocol exists}

**Gotchas**

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| {violation} | {how to detect} | {positive — what to do instead} |

**Enforcement**

{out-of-prompt compliance — tool or convention check}

**Applicability**

{scope — when applied, when excluded}

**See also**

- {related entity by ID} — {brief description}
```

**Gotchas**

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Missing `protocol:` frontmatter field | Frontmatter lacks `protocol:` key | Add `protocol:` field with the core technical contract statement — replaces `principle:` used in patterns |
| Enforcement tool undeclared | `enforcement: Convention` with no body tool or mechanism reference | Declare the enforcement mechanism — Convention requires documented verification steps |
| Tags as comma-separated string | `tags: tag1,tag2,tag3` | Use inline array `[tag1, tag2, tag3]` per PROT.META.IDENTITY |
| Missing required body section | Section list lacks one of Protocol, Rationale, Gotchas, Enforcement, Applicability, See also | Add all six required sections — each serves a distinct role per PROT.LLM.SPECIFICATION |
| Protocol reads like a pattern | `protocol:` field states a general principle instead of a specific contract | Narrow to implementation-specific rules — general principles stay in `patterns/` domain |
| `## Protocol` section contains negative instructions | Instruction framed as a hard stop or prohibition | Recast as positive — "do X" or "use Y instead" per PROT.LLM.SPECIFICATION |

**Rules**

**Frontmatter**
- Required: id, title, source, summary, protocol, enforcement, status, priority, tags
- ID: `PROT.{DOMAIN}.{NAME}` uppercase dot-separated. Lowercase and hyphenation excluded
- Title: em-dash `{Name} — {Subtitle}`. Colon and dash excluded
- Enforcement: `Tool`, `Convention`, or `Review`
- Status: `active`, `draft`, or `deprecated`
- Priority: integer 1–5
- Tags: minimum 3, inline array `[tag1, tag2, tag3]`

**Body and workflow**
- Sections: `## Protocol`, `## Rationale`, `## Gotchas`, `## Enforcement`, `## Applicability`, `## See also`
- `## Protocol` uses positive instructions — ≥3:1 positive-to-negative per PROT.LLM.SPECIFICATION
- `## Gotchas` pairs each antipattern with a positive redirect — standalone negatives excluded
- `## Enforcement` describes out-of-prompt compliance — deterministic checks move into tool or convention
- After creation — run `write-sync --type protocols` before reporting complete
- Related entities from steps 2–4 populate `## See also`
