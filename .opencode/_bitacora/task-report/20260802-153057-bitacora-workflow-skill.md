# bitacora-workflow skill

Timestamp: 2026-08-02 20260802-153057

## What was done

- Created the `bitacora-workflow` skill at `.opencode/skills/bitacora-workflow/SKILL.md` — it instantiates the bitacora record and follows it through: todo first, logged commands, report after.
- Grounded references via semantic search: `IDENTITY.BITACORA`, `RUL.TODO.TRACK`, `RUL.REPORT.WRITE`, `RUL.WORKFLOW.BITACORA.STDOUT`, `NEX.META.ORCHESTRATION`.
- Encoded both conventions: root `.opencode/_bitacora/` + `bitacora-log.sh`; dive `_codex/_bitacora/` + `run-logged.sh`.
- Applied user form constraints: small high-signal description, condensed, imperative register, affirmative framing, no tables.
- Followed the workflow through for this task — todo via `bitacora-create.sh`, close via `bitacora-close.sh`, both logged.

## Decisions

- House format: `.template/SKILL.md` + `manage-bash-flows` exemplar — frontmatter `name/description/state-profile/nexus`.
- Nexus: `NEX.META.ORCHESTRATION` — the search surfaced no dedicated record nexus.
- Gotchas → Target states: affirmative framing per `RUL.POSITIVE.FRAMING` and the communication rules.

## Open edges

- The skill registers at restart — opencode loads skills at start; this session's skill list lacks the new entry.

## Todo state

- `task-todo/2026-08-02--bitacora-workflow-skill.md` — completed; this report closes the record.
