# language-dispatcher-skill

Timestamp: 2026-08-02 20260802-155604

## What was done

- Upgraded `knowledge-ruby` into the `knowledge-languages` dispatcher skill.
- Created `reference/` with five per-language files: `bash.md`, `ruby.md`, `go.md`, `rust.md`, `typescript.md`.
- Rewrote `SKILL.md` as the dispatcher: match the language → read the reference → apply the role test → apply the ring test.
- Cited the governing specs in every file: `SPEC.LANGUAGE.ROLE.MAP` (role), `SPEC.LANGUAGE.RING.TOPOLOGY` (ring), `SPEC.CODE.ELEMENT.NAME` (naming, incl. agentive `{vowel}r` + shadow drop).
- Preserved the ruby knowledge map in `reference/ruby.md` — atomic files under `_knowledge/ruby/` + official docs.
- Removed the superseded `knowledge-ruby/` folder.
- Followed the bitacora workflow through: todo, logged commands, close, report.

## Decisions

- **Five files** — the user listed five languages (bash/shell, ruby, go, rust, typescript) despite the "4 files" count; the list carries authority.
- **Rename to `knowledge-languages`** — the dispatcher identity replaces the ruby-only name; folder matches skill name per skill schema.
- **Form per the communication rules** — imperative register, SOV/active sentences, affirmative framing (target states), root nouns instead of action nouns, condensed, no tables.
- **Spec citations** — each role/ring/naming line names its governing spec; naming follows `SPEC.CODE.ELEMENT.NAME` noun classes and shadow prevention.

## Open edges

- The new skill registers at restart — opencode loads skills at start; this session's list lacks the entry.
- `_knowledge/ruby/` atomic files remain the authoritative ruby source; `reference/ruby.md` routes to them.

## Todo state

- `task-todo/2026-08-02--language-dispatcher-skill.md` — completed; this report closes the record.
