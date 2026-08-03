# agents-skills-template-conversion

Timestamp: 2026-08-03 13:09:11

## What was done

- Backed up 28 skill files to `.opencode/skills/.backups/2026-08-03T123655` (byte-identical, diff-verified)
- Converted all 28 SKILL.md files to the categorical-junction template: `**Header**` → `## Header`, numbered steps → junction bullets, inline bold stripped, code blocks preserved
- Fixed 2 description prefixes to `Use this skill when...`: `reason-invariants`, `bitacora-workflow`
- Verified skills: PASS=28 FAIL=0 via compliance audit (name/description/state-profile, ## headings, no bold/num/tables)
- Backed up all 45 AGENTS.md files to `/tmp/opencode/agents-backup-2026-08-03T124940`
- Converted 45 AGENTS.md files: md tables → `text` code blocks (newline-safe), bold headers → `##`, numbered steps → junction bullets, inline bold stripped, trailing periods stripped (42 files)
- Hand-wrote 7 structural cases: `_knowledge/AGENTS.md` (was empty), `rust-docs`, `homophones`, `neovim-repo/neovim`, `a01-harness-llm`, `depot/scripts`, `CR-news-outlets`
- Verified AGENTS.md: COMPLIANT=45 FAIL=0 via clean audit (excludes code-fence content)

## Decisions

- `BULLET.template.md` + `DECLARATIVE.template.md` govern junction-bullet bodies; `IMPERATIVE.template.md` governs directive bodies
- Context7 verified Ruby `Find.find` (traverses hidden dot-dirs) and `String#chomp` (newline-safe) before the fixed conversion
- Tables convert to `text` code blocks per RUL.WRITING.STRUCTURAL.PREFERENCE — code blocks take precedence over md tables
- Trailing periods removed from junction lines per the junction convention
- Backup precedes every conversion batch; restore available at both backup paths

## Open edges

- Conversion scripts live in `/tmp/opencode/` — not persisted in the workspace toolchain
- `related: []` arrays in CLI entities still pending patlib links
- Skills and AGENTS.md conversions complete; no patlib registration pushed

## Follow-up — audit tooling persisted

- `audit-format-compliance.sh` persisted at `.opencode/_scripts/` — bash-only format auditor (literal-regex awk counters, fence-aware, `--root/--kind/--exit`); final run: PASS=75 FAIL=0 (30 skills + 45 AGENTS.md)
- `strip-inline-bold.pl` + `convert-skill-format.pl` persisted at `.opencode/_scripts/` — perl converters, contract headers added, syntax verified
- Perl idioms grounded via context7 (`/websites/perldoc_perl_5_42_0`): `s///` capture substitution, in-place editing
- Audit precision refined: inline-bold check excludes backtick-quoted content (`**` glob syntax in `use-playwright-network-storage` was a false positive)
- Atelier camera-comparison skills (2) converted from old format (bold headers + numbered steps + tables) to the categorical-junction template
- Logs: `20260803-131739-skills-perl-run.log`, `20260803-131817-skills-perl-check.log`, `20260803-131919-audit-tool-verify5.log`, `20260803-132005-perl-persist.log`, `20260803-132043-perl-final-verify.log`

## Todo state

- `task-todo/agents-skills-template-conversion.md` — all items completed, Status: completed
- Logs cited in `task-stdout/`: `20260803-123655-skills-backup.log`, `20260803-124040-skills-convert-format.log`, `20260803-125815-agents-convert-fixed.log`, `20260803-130623-agents-strip-periods.log`, `20260803-130800-agents-final-verify.log`, and 12+ related

## Follow-up — CLI related removal

- `related: []` removed from all five CLI entities (RIPGREP, PANDOC, TRACEXEC, COREUTILS, SED) via perl one-liner; grep verifies 0 remaining
- `related: []` removed from `_templates/CLI.template.md` for consistency
- CLI frontmatter now: id, title, type, source, precedes, tags, reference
- Other entity groups (protocols, etc.) keep `related:` — out of CLI scope
- Logs: `20260803-132152-cli-related-scan.log`, `20260803-132201-cli-related-remove.log`

## Follow-up — CLI patlib registration

- Migration: `.opencode/_schemas/29-cli.sql` — `cli` table mimics the `.md` metadata (id, title, type, body, source, tags, reference, precedes, created, modified; no `related` column per user)
- Sync: added `["cli", "cli", backParser, %w[id title body type source precedes tags reference created modified], nil]` to `r6-patlib-sync.rb`; live sync: "Synced 5 cli."
- Row fidelity: verified via bash+sqlite script (body junction content, reference JSON URL arrays, metadata all correct)
- Embedding: 5 embeddings present in patlib-vector.db (384-dim, model Xenova/bge-small-en-v1.5); the "0 entities embedded" report was the already-present skip (`if (record && !force) continue`), not a failure
- Diagnostic: perl `embed-diagnose.pl` replicated the embedder's stages — discovery YES, columns survive Meta filter (title/body/precedes), 5 rows, 5 embeddings; verdict COMPLETE
- Confirmed via semantic_stats: cli table, COUNT 5, DIM 384
- Logs: `20260803-134055-embed-diagnose-run.log`, `20260803-134122-embed-diagnose-run2.log`, `20260803-134216-embed-diagnose-final.log`
