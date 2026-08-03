# add parse-failure and sync-coverage check to audit suite

Status: in progress (2026-08-02)

## Tasks

- [ ] Design the check: for each entity directory, parse every `.md` with ParseMetadata; report files that fail YAML or carry no metadata block
- [ ] Add coverage comparison: file count per directory vs patlib.db row count per table (drift = silent skip)
- [ ] Wire into the `rs` / `r1-*` audit suite (per RUL.AUTOMATE.BEFORE.FIX — detect before one-off fixes)
- [ ] Run against current state: expect 20 metadata-less files reported (6 investigations, 3 stud.*.writing, 11 notes)
- [ ] Decide governance: should metadata-less files gain entity frontmatter, or stay plain documents with an explicit exclusion list
- [ ] Write report and close

## Context

- Root cause discovered during IDENTITY.AGENT declaration: `IDENTITY.BITACORA.md` broke `YAML.safe_load` via unquoted `{?}` in `naming:` — the sync skipped the file silently; drift showed 1 missing DB row + 1 stale vector.
- The BITACORA bug class is fixed (quoted scalar), but the silent-skip behavior remains: `r6-patlib-sync.rb` drops files that fail ParseMetadata without warning.
- Audit scan of 421 entity files found 20 with no metadata block at all: 6 investigations, 3 linguistics `stud.*.writing`, 11 notes (`notes` table: 0 rows for 11 files). These are plain content documents, not YAML breakage — a structural gap awaiting a governance decision.
- Same YAML bug class as IDENTITY.AGENT's `Architectonic Ring 0: Agent` (colon+space) — recurring pattern justifies a detection tool.
- Existing audit surface: `rs check` (Go binary), `r1-entity-ring-validate.rb`, `r1-related-validate.rb`, `r1-source-validate.rb`, `r0-schema-validate.rb`.
