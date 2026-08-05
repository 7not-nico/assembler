# scripts/ — Ring Analysis Scripts

## System

- Runtime: bash-first — Bash (primary), Perl (secondary), Go (analysis engine, `_golib/`), Rust (legacy fallback, `_rs/` + `_bin/`)
- Scripting: bash + perl only — ruby scripts and `_rb/` modules sit archived in `.archive/`
- Bash forms binary imperative shells; command scripts wrap launch and pipeline boundaries per `RUL.CODE.BASH.SHELLS`
- Perl carries text transforms — format conversion, inline-bold strip, embed diagnostics
- Perl pure modules sit in `_pl/` — ring 0 (PURE), no I/O, contract headers per `RING.SCRIPT.TOPOLOGY`
- Go uses the standard library only; the build runs via `go build -o bin/assembler-cli ./cmd/assembler-cli` in `_golib/`
- Rust uses edition 2024; the build runs via `cargo build --release` in `_rs/` or `_bin/`

## Quick start

Bash leads the layer — `rs` (launcher), `fixtures/` (test fixtures), `survey/` (workflows)

```bash
_scripts/rs count            # Entities per type
_scripts/rs check id-match   # Validate id vs filename
_scripts/rs check precedes   # Cycle detection
_scripts/rs audit protocols  # Structural audit scoped to one type
_scripts/rs rings            # Show topology
```

The `rs` launcher (bash) execs the Go binary (`_golib/bin/assembler-cli`); the Rust binary serves as fallback

## Scripting (bash + perl)

Bash and perl lead the scripting layer. Bash forms binary imperative shells at the system edge per `RUL.CODE.BASH.SHELLS` — the `rs` launcher, command wrappers, stdout pipelines, and the test fixtures under `fixtures/`. Perl carries the text transforms that bash handles poorly — byte-level strip, format conversion, stage diagnostics. Both wrap the Go/Rust engines and shape stdout for downstream consumers per `NEX.ACQUIRE.PIPELINE`

```text
| File | Role |
|------|------|
| `rs` | Launcher — execs the Go binary, falls back to Rust |
| `audit-format-compliance.sh` | Audits skills + AGENTS.md against the categorical-junction template |
| `convert-skill-format.pl` | Converts skill bodies to the canonical format |
| `strip-inline-bold.pl` | Strips inline bold from bullet bodies |
| `embed-diagnose.pl` | Diagnoses embedding stages |
| `migrate-skill-metadata.sh` | Migrates skill metadata (write — backup first) |
| `sync-cli-entities.sh` | Syncs `.opencode/entities/cli/*.md` into the patlib.db cli table (ring 6 DB-WRITE, `--dry` flag) |
| `parse-cli-backmatter.pl` | Emits SQL upsert for one CLI entity file (ring 2 LOCAL-READ; requires `_pl/backmatter.pl`) |
| `_pl/backmatter.pl` | Pure backmatter transform — backmatter → SQL parts (ring 0 PURE, no I/O) |
| `fixtures/*.sh` | Test fixtures — exercise launchers, wrappers, audits, survey workflows; emit KEY=value contract lines with `RESULT=pass\|fail:count` |
```

Fixtures run bash-first — shell scripts own audit and wrapper logic. Every fixture carries a contract header (`# exports:`, `# purity:`, `# depends-on:`, `# ring: N`) per `PROT.LIB.CONTRACT` + `RING.SCRIPT.TOPOLOGY`. Ring classes: 0 (PURE) stdout emitters, 2 (LOCAL-READ) source/entity/CLI probes, 4 (LOCAL-WRITE) wrapper exercisers. Non-fitting fixtures (ruby-based, stale archived-ruby calls, non-fixtures) sit in `.archive/fixtures/`

## Go (analysis engine)

### Module

`_golib/` — module `assembler/scripts/golib`, go 1.26, stdlib-only (no external deps)

```text
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
```

Parity — loads all 23 entity types including the encyclopedic ring (cognitions, concepts, terms) that the Rust frontmatter parser skipped. Go accepts a few files Ruby's YAML rejects (over-permissive by design — auditing more entities beats fewer)

### Naming conventions

```text
| Category | Convention | Example |
|----------|-----------|---------|
| Structs | PascalCase + singular abstract noun | `Frontmatter`, `Fault`, `EntityEntry` |
| Functions | Exported PascalCase (Go idiom; camelCase house style adapts) | `CheckIDMatch`, `LoadEntities` |
| Unexported | camelCase | `parseBlock`, `fileStem` |
| Constants | PascalCase | `EntityPattern`, `PrefixToType` |
```

## Rust (legacy)

### Crates

```text
| Crate | Location | Role |
|-------|----------|------|
| `assembler-scripts` (lib) | `_rs/` | 15 modules across 2 ring levels |
| `assembler-cli` (bin) | `_bin/` | CLI entry point; depends on `_rs/` + clap |
| `rust-lint` (bin) | `_rs/src/bin/` | Lints custom conventions |
```

Known gap — `r0_frontmatter` skips the encyclopedic backmatter format (cognitions et al. load 0); the Go parser supersedes it. `docs/ref-rust-modules.md` holds the module reference

## Ruby (archived)

- The `r*.rb` ring scripts (r0-r6) and the audit wrappers sit in `.archive/`
- The `_rb/` lambda modules (16 files) sit in `.archive/_rb/`
- The patlib sync (`r6-patlib-sync.rb`) reconciled entity files → root `.opencode/patlib.db`; the bash/perl replacement covers the cli table (`sync-cli-entities.sh` + `parse-cli-backmatter.pl` + `_pl/backmatter.pl`), other tables pending
- Remaining ruby lives in: `survey/` (65 workflows), `knowledge/` (44 reference docs), `spec/` (6 test specs), `template/rN-script-template.rb`; the ruby fixture `fixture-ruby-test.rb` sits archived in `.archive/fixtures/`
- The `rs audit {type}` command replaces the archived audit wrappers — one path for every type

## Directories

```text
| Path | Content |
|------|---------|
| `.archive/` | Archived ruby — ring scripts, `_rb/` modules, old templates, non-fitting fixtures (`.archive/fixtures/`) |
| `_golib/` | Go module — analysis engine (lib packages + `cmd/assembler-cli`) |
| `_pl/` | Perl pure modules — ring 0 (PURE), contract headers, require-loaded by io entries |
| `_rs/` | Rust library (15 modules, legacy) |
| `_bin/` | Rust CLI crate (legacy) |
| `schema/` | Stores the SQLite DB + seed files |
| `survey/` | 26 state analysis workflows (ruby-legacy, pending bash/perl conversion) |
| `fixtures/` | Bash-first test fixtures — 27 live, each with purity/ring contract header (`# exports:`, `# purity:`, `# depends-on:`, `# ring: N`); ring classes 0 (PURE) / 2 (LOCAL-READ) / 4 (LOCAL-WRITE) |
| `spec/` | Ruby test specs (legacy) |
| `report/`, `report/conclusions/`, `report/errors/`, `report/walkthroughs/` | Stores script output |
| `docs/` | Stores reference docs for modules, entity types, violations |
| `knowledge/` | Stores reference files (114 core docs) |
| `todo/` | Tracks sessions |
```

## Ring system

Axiomatic (R0-R2) covers maxims, precepts, specs, identities, abstractions, algorithms, linguistics
Encyclopedic (R0-R3) covers etymologies, cognitions, concepts, definitions, taxonomies, terms, bio, chem
Composition (R0-R3) covers protocols, patterns, nexus, illustrations, references
Architectonic (R0-R2) covers rules, commands, skills, tools
Chronicle (R0-R2) covers persons, investigations, apologias, manifests, archives, notes

## Survey

26 non-write workflows live under `survey/`. Each is `{qualifier}-{subject}/` with 1-4 scripts. The workflows run ruby today; bash/perl conversion stands pending. `docs/` details the workflows
