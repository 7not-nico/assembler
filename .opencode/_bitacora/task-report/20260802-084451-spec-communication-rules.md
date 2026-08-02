# Task report — Communication rules compliance pass on specifications

Date: 2026-08-02
Topic: spec-communication-rules
Status: completed

## Rule set

User directive (iterated 2026-08-02): apply communication rules to all 26 specification files.
Final rule set:

- Proper English — subject-first prose, active voice, present tense, finite verbs, root nouns
- Action nouns prohibited — gerunds and nominalizations (`-tion`, `-ment`, `-ance`, `-ion`) naming actions in prose
- `-ed` verbs prohibited — past tense, past participles, passive constructions

Labels retain action forms: entity-type names (Abstraction, Illustration, Reference, Definition, Investigation), titles, tags, headings, frontmatter fields, and code identifiers in backticks.

## What was done

1. Surveyed all 26 specs at `.opencode/entities/specifications/` against the rule set
2. Rewrote prose in every spec — full pass:
   - SOV subject-first register
   - Active voice, present tense, finite verbs
   - Gerunds to root nouns (`devising` → `design`, `Naming` → `The name`, `Shadowing` → `A shadow`)
   - Nominalizations to verbs (`An entity ID change produces`, `A table rebuild risks`, `Scripts verify`, `Scripts execute`)
   - `-ed` passives to active finite verbs (`is added` → `joins`, `is set` → `sets`, `declared` → `declaration sits`, `determined` → `that ... determines`, `formed` → `from`)
   - Representative fixes: `Cross-file reference resolution` → `Resolves cross-file references`; `Aggregate analysis across entity types` → `Analyzes across entity types`; `Mutations to the persistent store` → `Mutates the persistent store`; `Changing an entity's ID` → `An entity ID change`; `Rebuilding tables risks` → `A table rebuild risks`
3. Verified via `rg` sweeps — no `-ed` verb or action-noun remains in prose (remaining matches are code identifiers, labels, or entity-type names)

## Files changed

All 26 files under `.opencode/entities/specifications/` — full rewrites of prose body and `summary:` fields; entity IDs, titles, tags, and schema structure unchanged.

## Decisions

- Labels keep action forms — entity-type names, titles, tags, headings, frontmatter fields, and backtick code identifiers are exempt per `RUL.COMMUNICATION.PROSE.NOTATION` (labels carry nominalizations)
- `summary:` fields rewritten to match body register — summary is prose, not a label
- No entity renames — IDs and titles preserve existing identity and cross-references

## Logs

- `task-stdout/20260802-084431-comm-specs-sync2.log` — sync: 26 specifications, exit 0
- `task-stdout/20260802-084435-comm-specs-embed2.log` — embed: 26 embedded (force), exit 0
- `task-stdout/20260802-084446-comm-specs-drift2.log` — drift: 26 DB / 26 VEC, 0 missing, 0 stale, no drift, exit 0
- Prior-pass logs: `20260802-081827-comm-specs-sync.log`, `20260802-081831-comm-specs-embed.log`

## Open edges

- None. Todo state summary: all 4 tasks completed.
