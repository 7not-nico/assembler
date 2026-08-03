# declare identity entity IDENTITY.AGENT — AGENTS.md instantiates delegation environment

Status: completed (2026-08-02)

## Tasks

- [x] Create todo file
- [x] Gather governing context (RUL.PROJECT.DELEGATION, SPEC.AGENTS.SELF.CONTAINED, RUL.AGENTS.STATE)
- [x] Inventory AGENTS.md instances and confirm no IDENTITY.AGENT precedent
- [x] Write .opencode/entities/identities/IDENTITY.AGENT.md (group: architectonic, ring: R0 — SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY names Agent at Architectonic Ring 0, the executable primitive foundation before Tool; encyclopedic R3 and architectonic R2 both rejected by the spec text)
- [x] Validate frontmatter against identity entity pattern (backmatter; YAML reference title had `Ring 0: Agent` colon+space — fixed to `Ring 0 Agent`)
- [x] Sync entity into patlib.db (r6-patlib-sync.rb --type identities → 35 rows)
- [x] Embed new entity in vector store (semantic_embed type identities → 1 embedded)
- [x] Verify semantic_stats shows 36 identities
- [x] Write report and close bitacora

## Context

- Identity semantics per user: AGENTS.md at a folder root instantiates a new delegation environment — the folder becomes a project with its own domain logic, DB, tools, and rules.
- Absolute-state property per user: each agent cites only the absolute state — no historical data, no change narratives; decisions and history belong in bitacora files (per RUL.AGENTS.STATE).
- Governing entities: RUL.PROJECT.DELEGATION (every directory with its own AGENTS.md counts as a project; sub-projects delegate to own domain logic, DB, tools; root provides patterns, terms, substrate), SPEC.AGENTS.SELF.CONTAINED (AGENTS.md describes only its own domain), RUL.AGENTS.STATE (AGENTS.md contains only final absolute states).
- Identity pattern: bolded lead sentence answering *what something IS*, then frontmatter (id, title, source, group, ring, naming, tags, related, reference).
- IDENTITY.* is the 2-segment exception per SPEC.ENTITY.SEGMENT.COUNT.
- 52 AGENTS.md instances; zero IDENTITY.AGENT precedents in entities/.

## Open edges

- Spec/code drift: `_rb/rings.rb` architectonic map lacks the Agent ring (rules R0, commands/skills R1, tools R2 vs spec agent R0, tool R1, commands/skills R2, rule R3); `r1-related-validate.rb` computes `IDENTITY.*` canonical ring as axiomatic R1 → 17 of 36 identities carry cross-group related flags (pre-existing, systemic). Decision deferred — updating the map touches every architectonic entity's validated ring.
- `bitacora-log.sh` wrapper path fails (exit 127) wrapping `bitacora-create.sh`/`bitacora-close.sh` — direct invocation works; tooling follow-up.
- `semantic_embed` skips unchanged rows (content-hash match) — `force: true` required after body edits.
- Close/verify pending: `bitacora-close.sh` needs the date-prefixed todo name `2026-08-02--declare-identity-entity-identity-agent-grounded-in-agents-md` (bare slug failed with "todo not found").
