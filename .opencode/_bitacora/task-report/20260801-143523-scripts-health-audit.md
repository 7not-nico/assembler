# Scripts Health Audit

Timestamp: 2026-08-01 143523

## What was done

Assessed `.opencode/_scripts/` — dual runtime (Rust primary, Ruby legacy) — and resolved the defects found.

- **Rust (primary)** — `_rs/` 15 modules + `_bin/` CLI crate healthy; binary rebuilt; `list | count | check | rings | audit` all verified
- **Ruby (legacy)** — 16 `_rb/` lambda modules syntax-clean; `r0-entity-count.rb` verified working after path fix
- **Wrappers** — 6 `r1-*-audit.rb` bash shims repaired (see wrappers-fix report)
- **Sync** — `r6-patlib-sync.rb` dependency verified: sqlite3 gem 3.53.2 present; stale-row cleanup keyed on parsed ids (2026-07-30 fix) confirmed in AGENTS.md
- **Git hygiene** — `_scripts/.git` holds zero commits; per user instruction ("no git in here") the commit was cancelled; risk accepted by decision

## Findings

- Path-resolution bug affected both runtimes; fixed with upward root-walk (robust to relocations)
- Stale-reference wave: 7 renamed nexus IDs + `PROT.META.IDENTITY` repaired across entities
- **Rust frontmatter parser gap**: encyclopedic entities (no `---` frontmatter) load as 0 in Rust vs 35-62 in Ruby — largest remaining gap
- sqlite3 gem present — `r6-patlib-sync.rb` runnable
- No version control in `_scripts/` — accepted per user

## Decisions

- Git commit cancelled (user instruction)
- Audit findings beyond Tier 1 scope (parser gap, stale-refs sweep) tracked as open edges, not fixed here

## Open edges

- Rust frontmatter parser gap (encyclopedic entities) — feeds `code-infrastructure` / `sync-module` backlog
- `rs check stale-refs` body sweep
- `_scripts/AGENTS.md` quick start: add `audit` command line

## Todo state

- `task-todo/2026-08-01--scripts-health-audit.md` — completed
- `task-todo/2026-08-01--audit-wrappers-fix.md` — completed
- `task-todo/2026-08-01--bitacora-tooling.md` — completed

## Logs

- `task-stdout/20260801-124904-audit-wrappers-before.log`
- `task-stdout/20260801-135251-wrappers-build.log`
- `task-stdout/20260801-143523-*` (this closure)
