# declare identity entity IDENTITY.AGENT grounded in AGENTS.md

Timestamp: 2026-08-02 20260802-181546

## What was done

- Created bitacora todo; gathered governing context (RUL.PROJECT.DELEGATION, SPEC.AGENTS.SELF.CONTAINED, RUL.AGENTS.STATE); inventoried 52 AGENTS.md instances and read five representative files (root, `_codex/`, `_knowledge/rust-coding/`, `.opencode/_scripts/`, `_depot/`).
- Wrote `.opencode/entities/identities/IDENTITY.AGENT.md` — self-contained description of AGENTS.md as a declarative instruction file at a folder root: absolute present state only, no history; communication-rules prose (declarative register, subject-first, active voice, finite verbs); no citation of other instruction files; instantiates a delegation environment for the folder it governs.
- Synced into `patlib.db` via `r6-patlib-sync.rb --type identities` (35 rows; row `IDENTITY.AGENT` confirmed).
- Embedded into vector store (forced re-embed after body revision; 35 identities embedded; 36 total in `patlib-vector.db`).
- Validated with agent-only semantic search (type `identities`): `IDENTITY.AGENT` ranks #1 on all query shapes — "agent" (0.7616), "AGENTS.md declarative instruction file absolute state" (0.8053), "communication rules prose declarative register finite verbs" (0.7287), "delegation environment project folder root who acts" (0.6891).
- Wrote full report; recorded open edges in both report and todo; closed the todo via `bitacora-close.sh`.
- Follow-up repair (post-close): drift check surfaced `IDENTITY.BITACORA.md` missing from `patlib.db` (36 files, 35 rows, 1 stale vector). Root cause: `naming: {?}-{concrete noun} subfolders` — unquoted `{?}` is a YAML flow-mapping key indicator, breaking `YAML.safe_load`; sync skipped the file silently. Fixed by quoting the scalar (`'{?}-{concrete noun} subfolders'`), re-synced (36 rows), forced re-embed (36 vectors). Final state: 36 files = 36 rows = 36 vectors, 0 missing, 0 stale.
- Parse-failure audit across all 421 entity files: 20 files carry no metadata block at all (6 investigations, 3 linguistics `stud.*.writing`, 11 notes) — plain content documents, not YAML breakage; the sync silently skips them (structural gap, distinct from the BITACORA parse bug).

## Decisions

- Ring placement: `group: architectonic`, `ring: R0` — `SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY` names Agent at Architectonic Ring 0 (Ring 0: Agent / Ring 1: Tool / Ring 2: Command, Skill / Ring 3: Rule), the executable primitive foundation before Tool. Encyclopedic R3 and Architectonic R2 rejected by the spec text.
- Body content per user direction: description concerns only the AGENTS.md file itself and stands on its own — no ecosystem framing (bitacora, ring ordering, tool precedence), no redundancies, high signal for semantic search.
- Absolute-state property per user: each AGENTS.md cites only the absolute state — no historical data, no change narratives.
- Communication-rules property per user: AGENTS.md prose follows the communication rules — declarative register, subject-first structure, active voice, finite verbs.
- YAML reference title reworded from `Architectonic Ring 0: Agent` to `Architectonic Ring 0 Agent` — colon+space breaks `YAML.safe_load` (backmatter parse).

## Open edges

- Spec/code drift: `_rb/rings.rb` architectonic map lacks the Agent ring (rules R0, commands/skills R1, tools R2 vs spec agent R0, tool R1, commands/skills R2, rule R3). `r1-related-validate.rb` computes `IDENTITY.*` canonical ring as axiomatic R1 → 17 of 36 identities carry cross-group related flags today (pre-existing, systemic, not caused by this entity). Decision deferred: updating `_rb/rings.rb` touches every architectonic entity's validated ring.
- `bitacora-log.sh` wrapper path fails (exit 127) wrapping `bitacora-create.sh`/`bitacora-close.sh` — direct invocation works. Tooling follow-up pending.
- `semantic_embed` skips unchanged rows (content-hash match) — `force: true` required after body edits.
- Close mechanics: `bitacora-close.sh` requires the full todo filename including `.md` suffix (`2026-08-02--declare-identity-entity-identity-agent-grounded-in-agents-md.md`); bare slug and date-prefixed-without-extension both fail with "todo not found".
- Silent-skip behavior: `r6-patlib-sync.rb` drops files that fail `ParseMetadata` without warning — the BITACORA case proved it. 20 entity files (6 investigations, 3 `stud.*.writing` linguistics, 11 notes) carry no metadata block and never reach `patlib.db` (`notes` table: 0 rows for 11 files). Whether these should gain entity metadata is a governance decision. Per `RUL.AUTOMATE.BEFORE.FIX`, a parse-failure/coverage check tool belongs in the `rs`/`r1-*` audit suite before further one-off fixes.

## Todo state

Completed. Todo file `.opencode/_bitacora/task-todo/2026-08-02--declare-identity-entity-identity-agent-grounded-in-agents-md.md` closed via `bitacora-close.sh` — status reads `completed (2026-08-02)`, all 8 tasks marked done. The close scaffolded this report; the earlier duplicate report `20260802-181326-declare-identity-entity-identity-agent-grounded-in-agents-md.md` was removed. Follow-up repair (BITACORA fix, vector reconcile, parse audit) recorded post-close in this report's done items and open edges.
