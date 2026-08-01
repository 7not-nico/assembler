# Audit Wrappers Fix

Timestamp: 2026-08-01 143523

## What was done

Closed the Tier 1 thread: the 6 `r1-*-audit.rb` wrappers now work end-to-end.

1. **Implemented `rs audit {type}`** — added the `Audit { entity_type }` subcommand to `_bin/src/main.rs` + `cmd_audit()`. Runs id-match, ring-match, source, precedes scoped to one type; source/precedes resolve against the full entity universe; faults filter to the type. Invalid types error with the 23 valid names.
2. **Fixed path-resolution bug (root cause)** — `_scripts/` relocated under `.opencode/` after tooling was built; `r2_paths.rs` (Rust) and `paths.rb` (Ruby) both resolved entities to `.opencode/.opencode/entities`. Rewrote both to walk upward to the ancestor containing `.opencode/entities`. Ruby `r0-entity-count.rb` restored (35 cognitions, 62 concepts).
3. **Fixed source-check false positive** — `r2_check_source.rs` validates only entity-ID-shaped values; citation strings skip.
4. **Repaired stale references** — 7 renamed nexus IDs swept from `protocols/` + `patterns/` source fields; `PROT.META.IDENTITY` → `PROT.META.IDENTITY` swept across all entities (protocols + illustration bodies).
5. **Restored exec bits** — `chmod +x` on 5 wrappers (maxim, illustration, nexus, pattern, person).

## Verification

- Build: `cargo build --release` passes (4.51s / 3.16s / 3.28s)
- `rs audit` per type: protocols 0 faults, maxims 0, illustrations 0 entities, nexus 0, patterns 0, persons 12 (documented)
- Wrappers 6/6 execute `audit ok`
- Invalid type: `Error: unknown entity type 'nonsense' — valid: {23 types}`, exit 1

## Decisions

- Type-scoped `audit` over repointing wrappers to `check` — preserves type-scoping
- Path resolution: upward walk, not hardcoded hops — survives future moves
- Persons faults accepted as documented exceptions (8 id-match: filename convention `per-acm.md` → `PER.ACM`; 4 source: COG false positives from the Rust frontmatter gap)
- Git commit cancelled — user instruction ("no git in here"); `_scripts/.git` stays zero-commit

## Open edges

- **Rust frontmatter parser gap** — encyclopedic entities (cognitions, concepts, definitions, terms, taxonomies, biology) lack `---` frontmatter, so the Rust loader skips them (0 vs Ruby's 35 cognitions). Persons' COG source faults resolve once fixed. Feeds `code-infrastructure` / `sync-module` backlog.
- `rs check stale-refs` full-body sweep — follow-up for remaining stale body references
- `_scripts/AGENTS.md` quick-start section: add `./rs audit {type}` (docs currently list `count/check/rings`)

## Todo state

- `task-todo/2026-08-01--audit-wrappers-fix.md` — completed
- `task-todo/2026-08-01--scripts-health-audit.md` — completed
- `task-todo/2026-08-01--bitacora-tooling.md` — completed

## Logs

- `task-stdout/20260801-124904-audit-wrappers-before.log` — 6 wrappers failing (exit 2 / 126)
- `task-stdout/20260801-135251-wrappers-build.log` — first successful build
