# Remaining Work Queue

Status: in progress (2026-08-01) — handoff for next session

## Rules

- Pipe every command through `bash .opencode/_bitacora/bitacora-log.sh {name} -- {command}`
- Git: repo public at `github.com/7not-nico/assembler` (branch `main`); targeted `git add`, never `-A` (18G tree stalls); commit sweeps for logs

## Immediate housekeeping

- [ ] close 3 superseded todos: `execution-phases`, `rust-native-plan`, `vector-search-revive` (Rust-addon threads replaced by Go port)
- [ ] sweep session stdout logs + task reports into git (log sweep commit)

## Active thread: stale-ID resolution (`resolve-remaining-stale-protocol-ids`)

- [ ] broader waves: RUL.WRITING.CONVENTION (44), REF.LIB.DIRECTORY.LAYER (33), MAX.* (25), PAT.* (23), RUL.CAPTCHA.GATE (22), REF.LIB.PURITY.BOUNDARY (22) — map-or-create per ID (title-match check first, then create per PROT.META.IDENTITY schema)
- [ ] sandbox/template scope check on residual ~2020 stale-refs count
- [ ] final `rs audit` all types + `rs check stale-refs` sweep

## Backlog threads

- [ ] `embedding-improvement` — semantic search quality
- [ ] `classification-ratio` + `terms-classification` — feed several dependents
- [ ] `remaining-tasks` (22), `code-infrastructure` (22), `TODO-shared-deps-functional-core-cli-shell` (15), `TODO-complete-hook-scope-audit` (15), `post-migration-tasks` (15), `rules-skills-overhaul-remaining` (12), `maxim-error-devise` (10), `test-devise` (9)

## Repo hygiene

- [ ] periodic `git gc` (pack grows with unreachable objects)
- [ ] public-exposure review of bitacora record trail (optional scrub decision)

## State snapshot

- Go toolchain primary (`_golib/`), `rs` → Go binary; audits pass (protocols 47, 0 faults)
- Stale refs 2765 → 2020 across all waves + regex fix
- 31 commits on `main`, tree clean
- All 2026-08-01 threads closed: bitacora-tooling, scripts-health-audit, audit-wrappers-fix, go-scripts-toolchain, continue-session-queue, mcp-rom-acquire
