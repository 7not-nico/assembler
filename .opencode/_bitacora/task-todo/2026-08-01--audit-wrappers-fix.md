# Audit Wrappers Fix

Status: completed (2026-08-01)

## Tasks

- [x] diagnose: 6 wrappers call `rs audit <type>` — subcommand nonexistent (exit 2)
- [x] record before-state in task-stdout: `20260801-124904-audit-wrappers-before.log`
- [x] add `Audit { entity_type }` to `_bin/src/main.rs` (cmd_audit: id-match, ring-match, source, precedes; full-universe resolution, type-scoped fault filter)
- [x] build: `cargo build --release` in `_bin/` — passes (4.51s / 3.16s / 3.28s across rebuilds)
- [x] test all 6 wrapper types: protocols 0 faults, maxims 0, illustrations 0 entities, nexus 0, patterns 0, persons 12 (documented exceptions)
- [x] test invalid type error path — lists 23 valid types, exit 1
- [x] update docs/AGENTS.md quick start with `./rs audit {type}` — see below
- [x] write task report, close todo

## Context

- Broken: `r1-{protocol,maxim,illustration,nexus,pattern,person}-audit.rb` → `exec rs audit <type>`
- CLI surface was `list | count | check | rings` — no `audit`; now `audit {type}` added
- Fix approach: implement type-scoped `audit` (id-match, ring-match, source, precedes; full-universe resolution, type-scoped fault filter)
- Root cause beyond the subcommand: `_scripts/` moved under `.opencode/` after tooling was built — Rust `r2_paths.rs` and Ruby `paths.rb` both resolved entities to `.opencode/.opencode/entities`; rewrote both to walk upward to the ancestor containing `.opencode/entities`
- Source check false positive fixed: validates only entity-ID-shaped values (`r2_check_source.rs`); citations skip
- Stale-reference repairs: 7 renamed nexus IDs swept from protocols + patterns source fields; `PROT.META.IDENTITY` → `PROT.META.IDENTITY` swept across all entities
- Exec bits: `chmod +x` applied to 5 wrappers — all 6 verify `audit ok`
- Known exceptions (persons, 12): 8 id-match = documented filename convention (`per-acm.md` → `PER.ACM`, `_scripts/AGENTS.md` line 64); 4 source COG = false positives from Rust frontmatter parser gap (encyclopedic files lack `---` frontmatter → load 0 in Rust, 35 in Ruby)
- Git commit: CANCELLED per user instruction ("no git in here") — `_scripts/.git` remains zero-commit

## Follow-up todo

- Rust frontmatter parser gap: encyclopedic entities (cognitions, concepts, definitions, terms, taxonomies, biology) without `---` frontmatter load as 0 entities in the Rust loader — feeds `code-infrastructure` / `sync-module` backlog
