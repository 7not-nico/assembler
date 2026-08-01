# Scripts Health Audit — 2026-08-01

Status: completed (2026-08-01)

## Task

Assess `.opencode/_scripts/` state: Rust primary, Ruby legacy, wrappers, sync, git hygiene.

## Sequence

- [x] Survey structure and conventions (AGENTS.md, docs)
- [x] Verify Rust binary: commands run, counts correct (`count`, `rings`, `list`, `check id-match` all pass)
- [x] Verify Ruby legacy: syntax OK (16 `_rb/` modules); `r0-entity-count.rb` works after path fix (35 cognitions, 62 concepts)
- [x] Verify 6 audit wrappers — BROKEN, now FIXED (see `2026-08-01--audit-wrappers-fix.md`; `rs audit` implemented, exec bits restored)
- [x] Verify `r6-patlib-sync.rb` dependencies — sqlite3 gem 3.53.2 present
- [x] Check git hygiene — `_scripts/.git` holds ZERO commits; commit CANCELLED per user ("no git in here")
- [x] Write task report to `task-report/`

## Findings

- Rust binary healthy after path-resolution fix: protocols 43, refs 34, specs 25, precepts 12, nexus 11, maxims 9, persons 8, patterns 7
- Path bug: `_scripts/` relocated under `.opencode/`; Rust + Ruby hardcoded old layout; both fixed with upward root-walk
- 6 wrappers dead on arrival; `audit` subcommand implemented + exec bits restored; all 6 now report `audit ok` (persons: 12 documented exceptions)
- Stale-reference wave: 7 renamed nexus IDs + `PROT.META.IDENTITY` → `PROT.META.IDENTITY` repaired across entities
- New gap discovered: Rust frontmatter parser skips encyclopedic entities (no `---` frontmatter) — cognitions load 0 in Rust vs 35 in Ruby
- Git: no version control per user decision; risk accepted by instruction

## Reports

- `task-report/20260801-{stamp}-audit-wrappers-fix.md`
- Logs: `task-stdout/20260801-124904-audit-wrappers-before.log`, `{stamp}-wrappers-build.log`
