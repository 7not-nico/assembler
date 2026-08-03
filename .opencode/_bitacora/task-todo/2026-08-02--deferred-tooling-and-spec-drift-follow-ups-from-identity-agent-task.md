# deferred tooling and spec-drift follow-ups from IDENTITY.AGENT task

Status: in progress (2026-08-02)

## Tasks

- [ ] Resolve `_rb/rings.rb` architectonic ring drift: spec (SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY) names Agent R0 / Tool R1 / Command-Skill R2 / Rule R3; code map holds rules R0 / commands-skills R1 / tools R2 and no Agent ring. Decide whether the spec ordering is authoritative for all architectonic types or only the Agent identity; update map and re-run `r1-related-validate.rb` (17 of 36 identities currently flagged cross-group, pre-existing).
- [ ] Fix `bitacora-log.sh` wrapper exit 127 wrapping `bitacora-create.sh`/`bitacora-close.sh` (direct invocation works; wrapper path fails — tracexec inner-pass issue suspected).
- [ ] Harden `bitacora-close.sh` argument handling: accept bare slug and date-prefixed-without-extension; only the full filename with `.md` currently works.
- [ ] Add parse-failure + sync-coverage check to the audit suite (separate todo: `2026-08-02--add-parse-failure-and-sync-coverage-check-to-audit-suite.md`) — 20 entity files carry no metadata block; `r6-patlib-sync.rb` skips them silently.
- [ ] Decide `semantic_embed` content-hash behavior: unchanged rows skip by design; document `force: true` requirement near the CLI/MCP tool docs or add a `--stale` flag that re-embeds when source mtime changes.

## Context

- All items deferred from the IDENTITY.AGENT declaration session (2026-08-02). Core task closed; these are follow-ups that touch shared tooling and validated rings — each deserves its own focused session.
- Reference report: `.opencode/_bitacora/task-report/20260802-181546-declare-identity-entity-identity-agent-grounded-in-agents-md.md`.
- Reference entity: `.opencode/entities/identities/IDENTITY.AGENT.md` (architectonic R0, per spec).
- Fixed during the session: IDENTITY.BITACORA.md YAML `{?}` parse break (quoted scalar) — the silent-skip class of bug remains the audit gap tracked above.
