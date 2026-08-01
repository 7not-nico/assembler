# Go Scripts Toolchain Port

Timestamp: 2026-08-01 151403

## What was done

Ported the entity-audit scripts toolchain from Rust to Go, per user decision ("derive new shared code in go instead"). Rust stays legacy alongside Ruby.

**Module** — `_opencode/_scripts/_golib/` (module `assembler/scripts/golib`, go 1.26, stdlib-only):

| Package | Files | Role |
|---------|-------|------|
| `cmd/assembler-cli` | main.go | CLI: list, count, check, audit {type}, rings |
| `internal/paths` | paths.go | upward root walk (`.opencode/entities` ancestor) |
| `internal/frontmatter` | frontmatter.go | ParseMetadata — leading frontmatter OR trailing backmatter |
| `internal/entity` | entity.go | EntityEntry loader, IdentifierSet |
| `internal/patlib` | patlib.go | prefix→type map, ID-shape regex |
| `internal/rings` | rings.go | 5-group topology, deterministic order |
| `internal/report` | report.go | FormatTable / FormatList |
| `internal/violation` | violation.go | Fault + ReportFaults |
| `internal/check` | 5 files | idmatch, ringmatch, source, precedes, stalerefs |

**Key fix — the encyclopedic gap.** The Rust parser (`r0_frontmatter`) carries `(?s)` DOTALL on its frontmatter regex; the initial Go port omitted it, so multi-line frontmatter blocks never matched (protocols et al. loaded 0). Context7 confirmed Go's `DotNL` flag and leftmost-first lazy semantics; one-line fix restored both formats. Backmatter format confirmed: 35/35 cognition files end with a closing `---`.

**Parity.** All 23 entity types load; counts match Ruby's reference loader: cognitions 35, concepts 62, terms 28, protocols 43, references 34, specifications 25, precepts 12, nexus 11, maxims 9, patterns 8, persons 8, illustrations 80, etc. Go loads 2 files Ruby rejects (over-permissive — accepted).

**New coverage surfaced.** Rust loaded illustrations as 0 (parser gap hid them); Go loads 80 with **57 source faults**. Persons source faults dropped 12→8 (COG refs now resolve — the 4 false positives gone; the 8 remaining are the documented filename-id convention).

**Audit results (Go CLI):** protocols 0 faults, maxims 0, nexus 0, patterns 0, persons 8 (documented), illustrations 57, investigations 4 (incl. `MANIFEST.*`-in-investigations ring-match anomaly).

## Decisions

- Go becomes the primary scripts runtime; Rust `_rs`/`_bin` and Ruby `_rb` stay legacy
- Stdlib-only (no YAML dependency) — lenient line-based field parser for the ~6 consumed keys; mirrors the Ruby stdlib constraint and the zero-dep `ann.go` precedent
- Over-permissive loading accepted (2-file diff vs Ruby) — auditing MORE entities beats fewer
- Go naming: exported PascalCase (idiomatic), documented deviation from the camelCase house style
- `rs` launcher repoint + AGENTS.md rewrite deferred to follow-up

## Open edges

- Illustrations 57 source faults — enumerate and disposition (feeds crossref-audit)
- Investigations 4 faults — `MANIFEST.AGENTSKILLS.SPEC.EVALUATION` ring-match + sources
- Repoint `rs` launcher to `_golib/bin/assembler-cli`
- Update `_scripts/AGENTS.md` + docs (`ref-rust-modules.md` → Go module table, quick start, naming)
- 2-file over-permissiveness diff (identities 35 vs 34, investigations 3 vs 2) — investigate only if strictness matters
- Rust frontmatter gap now moot — Go replaces it

## Todo state

- `task-todo/2026-08-01--go-scripts-toolchain.md` — completed (follow-ups listed)
- `task-todo/2026-08-01--audit-wrappers-fix.md` — completed
- `task-todo/2026-08-01--scripts-health-audit.md` — completed
- `task-todo/2026-08-01--bitacora-tooling.md` — completed

## Logs

- `task-stdout/20260801-135251-wrappers-build.log` — Rust build (prior)
- Go builds run inline this session (build + vet clean); no stdout log captured — noted for the follow-up session
