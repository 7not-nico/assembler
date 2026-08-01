---
name: audit-umbrella-terms
description: Use this skill when verifying umbrella term relationships — it checks shared prefixes, bidirectional links, flat hierarchy, and enumeration against PROT.TERM.SCHEMA rules
state-profile: stateful-auditor
related: []
patterns: [NEX.TOOL.SEQUENCE, PROT.TERM.SCHEMA]
---

**Procedure**

1. **Load rules** — `read-projection` on `PROT.TERM.SCHEMA`
2. **Read terms** — every `TERM.*.md` under `.opencode/terms/`
3. **Build graph** — parse `related` field into adjacency map
4. **Detect umbrellas** — candidate when `related` has ≥3 term IDs sharing a contiguous prefix segment. Generic cross-references excluded
5. **Check each umbrella**:
   - **Rule 2**: every child's `related` includes umbrella's ID — flag orphans
   - **Rule 3**: shared ID prefix segment — flag mismatches
   - **Rule 4a**: umbrella body enumerates all children — flag missing enumeration
   - **Rule 4b**: child body distinguishes from siblings — flag verbatim-identical sentences
   - **Rule 5**: flat hierarchy — child in multiple umbrellas flagged
6. **Report per umbrella** — violations with `file:line`, rule number, description
7. **Summarize** — pass/fail count per umbrella, overall score

**Gotchas**

- Hub term with 3+ peers lacks shared prefix — umbrella status excluded. The prefix heuristic is essential
- Rule 1 (creation order) — explicitly excluded from audit. Static files excluded from order capture
- Rule 4b checks are structural, stylistic excluded — flag verbatim-identical or semantically duplicate defining sentences. Legitimate variation excluded from flagging
- Non-term IDs in `related` (PAT.*, TERM.MACHINE.LEARNING) — child link status excluded. Skip in umbrella detection
- Empty or missing `related` — umbrella candidate status excluded. Skip without error

**Rules**

**Frontmatter**
- Required fields: `name`, `description`, `state-profile` — additional fields excluded
- `state-profile`: one of `stateless`, `stateful-reader`, `stateful-writer`, `stateful-auditor`, `hybrid`

**Audit scope**
- Umbrella candidate requires shared prefix across ≥3 term IDs in `related`
- Each PROT.TERM.SCHEMA rule maps to one check (Rule 1 excluded)
- Non-term IDs in `related` — excluded from umbrella checks
- Rule 4b flags verbatim-identical or semantically duplicate defining sentences only
- Report per umbrella: `file:line` with rule number, description
