# scripts/ — Ring Analysis Scripts

## System

The runtime is bash-first: **Bash** (primary, `fixtures/` + launchers), **Go** (analysis engine, `_golib/`), **Rust** (legacy, `_rs/` + `_bin/`), **Ruby** (legacy, `_rb/` + `r*.rb`).
Bash forms binary imperative shells; command scripts wrap launch and pipeline boundaries (per `RUL.CODE.BASH.SHELLS`). Bash leads the scripting layer — launchers, wrappers, and fixtures run bash-first.
Go uses the standard library only. The build runs via `go build -o bin/assembler-cli ./cmd/assembler-cli` in `_golib/`.
Rust uses edition 2021. The build runs via `cargo build --release` in `_rs/` or `_bin/`.
Ruby uses stdlib only (`yaml`, `json`, `pathname`). Gems and builds stay out. `MAX.RUBY.ONLY` documents the constraint.

## Quick start

Bash leads the layer: `rs` (launcher), `fixtures/` (test fixtures), `survey/` (workflows).

```bash
_scripts/rs count            # Entities per type
_scripts/rs check id-match   # Validate id vs filename
_scripts/rs check precedes   # Cycle detection
_scripts/rs audit protocols  # Structural audit scoped to one type
_scripts/rs rings            # Show topology
```

The `rs` launcher (bash) execs the Go binary (`_golib/bin/assembler-cli`); the Rust binary serves as fallback.

## Bash (primary)

Bash scripts lead the scripting layer. They form binary imperative shells at the edge of the system (per `RUL.CODE.BASH.SHELLS`): the `rs` launcher, command wrappers, stdout pipelines, and the test fixtures under `fixtures/`. Bash wraps the Go/Rust/Ruby engines and shapes stdout for downstream consumers (per `NEX.ACQUIRE.PIPELINE`).

| File | Role |
|------|------|
| `rs` | Launcher — execs the Go binary, falls back to Rust |
| `fixtures/*.sh` | Test fixtures — exercise launchers, wrappers, audits, and survey workflows; emit KEY=value contract lines with `RESULT=pass\|fail:count` |
| `bitacora-log.sh` routes | Commands pipe through the stdout wrapper for provenance capture |

Fixtures run bash-first: shell scripts own audit and wrapper logic; Ruby fixtures remain legacy (`fixture-ruby-test.rb`).

## Go (analysis engine)

### Module

`_golib/` — module `assembler/scripts/golib`, go 1.26, stdlib-only (no external deps).

| Package | Role |
|---------|------|
| `cmd/assembler-cli` | CLI: list, count, check, audit {type}, rings |
| `internal/paths` | Upward root walk (ancestor containing `.opencode/entities`) |
| `internal/frontmatter` | ParseMetadata — leading frontmatter OR trailing backmatter |
| `internal/entity` | EntityEntry loader, IdentifierSet |
| `internal/patlib` | prefix→type map, ID-shape regex |
| `internal/rings` | 5-group ring topology, deterministic order |
| `internal/report` | FormatTable / FormatList |
| `internal/violation` | Fault + ReportFaults |
| `internal/check` | idmatch, ringmatch, source, precedes, stalerefs |

**Parity** — loads all 23 entity types including the encyclopedic ring (cognitions, concepts, terms) that the Rust frontmatter parser skipped. Go accepts a few files Ruby's YAML rejects (over-permissive by design — auditing more entities beats fewer).

### Naming conventions

| Category | Convention | Example |
|----------|-----------|---------|
| Structs | PascalCase + singular abstract noun | `Frontmatter`, `Fault`, `EntityEntry` |
| Functions | Exported PascalCase (Go idiom; camelCase house style adapts) | `CheckIDMatch`, `LoadEntities` |
| Unexported | camelCase | `parseBlock`, `fileStem` |
| Constants | PascalCase | `EntityPattern`, `PrefixToType` |

## Rust (legacy)

### Crates

| Crate | Location | Role |
|-------|----------|------|
| `assembler-scripts` (lib) | `_rs/` | 15 modules across 2 ring levels |
| `assembler-cli` (bin) | `_bin/` | CLI entry point; depends on `_rs/` + clap |
| `rust-lint` (bin) | `_rs/src/bin/` | Lints custom conventions |

**Known gap** — `r0_frontmatter` skips the encyclopedic backmatter format (cognitions et al. load 0); the Go parser supersedes it. `docs/ref-rust-modules.md` holds the module reference.

## Ruby (legacy)

16 pure lambda modules live under `_rb/` (ring 0). 48 `r*.rb` scripts compose them. `docs/ref-rb-modules.md` lists them fully.

6 audit wrapper scripts delegate to the `rs` binary (Go):
`r1-protocol-audit.rb`, `r1-maxim-audit.rb`, `r1-illustration-audit.rb`, `r1-nexus-audit.rb`, `r1-pattern-audit.rb`, `r1-person-audit.rb`.

### `r6-patlib-sync.rb` — root patlib.db sync (ring 6 DB-WRITE)

The script reconciles entity files → root `.opencode/patlib.db` (cross-project: the target is the assembler root DB, not `schema/schemas.db`).

```bash
ruby r6-patlib-sync.rb            # full sync — all 27 modules
ruby r6-patlib-sync.rb --type terms   # single table
ruby r6-patlib-sync.rb --dry      # preview targets, no writes
```

- **Coverage** — the sync covers 24 entity tables via uniform `tableSyncer` (frontmatter/backmatter parsing, `ON CONFLICT(id) DO UPDATE`, junction tables) + rules/commands (yaml) + skills (`SKILL.md` sections).
- **Dependency** — the sync depends on the `sqlite3` gem (precedent: `_rb/schema_db.rb`). It uses stdlib `yaml`/`json`/`pathname`; it reuses `_rb/loader`, `_rb/frontmatter`, `_rb/patlib`.
- **Cleanup keyed on parsed ids** — the stale-row `DELETE` uses frontmatter `id:` values, NOT filenames (filenames may differ: `per-acm.md` → id `PER.ACM`). Basename-keyed cleanup wiped persons rows — the fix landed 2026-07-30.
- **Naming** — `SPEC.CODE.ELEMENT.NAME` governs names: lambdas use camelCase agentive (`tableSyncer`, `ruleSyncer`), constants use PascalCase (`Root`, `DbPath`, `CommonRef`, `Config`), locals use singular concrete nouns.
- **Post-sync** — the agent runs `bun run .opencode/tools/semantic-embed.ts` (or `--type` scoped) then `semantic-drift --check` to reconcile the vector store.

## Directories

| Path | Content |
|------|---------|
| `_golib/` | Go module — analysis engine (lib packages + `cmd/assembler-cli`) |
| `_rb/` | Ruby lambda modules (16 files, legacy) |
| `_rs/` | Rust library (15 modules, legacy) |
| `_bin/` | Rust CLI crate (legacy) |
| `schema/` | Stores the SQLite DB + seed files |
| `survey/` | Holds 26 state analysis workflows (bash-first scripts) |
| `fixtures/` | Bash-first test fixtures (launchers, wrappers, audits) |
| `report/`, `report/conclusions/`, `report/errors/`, `report/walkthroughs/` | Stores script output |
| `docs/` | Stores reference docs for modules, entity types, violations |
| `knowledge/` | Stores Ruby reference files (114 core docs) |
| `todo/` | Tracks sessions |

## Ring system

Axiomatic (R0-R2) covers maxims, precepts, specs, identities, abstractions, algorithms, linguistics.
Encyclopedic (R0-R3) covers etymologies, cognitions, concepts, definitions, taxonomies, terms, bio, chem.
Composition (R0-R3) covers protocols, patterns, nexus, illustrations, references.
Architectonic (R0-R2) covers rules, commands, skills, tools.
Chronicle (R0-R2) covers persons, investigations, apologias, manifests, archives, notes.

## Survey

26 non-write workflows live under `survey/`. Each is `{qualifier}-{subject}/` with 1-4 scripts. `docs/` details the workflows.
