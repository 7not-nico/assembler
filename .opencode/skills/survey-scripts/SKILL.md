---
name: survey-scripts
description: Use this skill when creating surveys under .opencode/_scripts/survey/ — it follows the survey workflow: check template/ for boilerplate, knowledge/ for Ruby reference, survey/ examples for patterns, and writes reports into report/
state-profile: stateless
related: ["RUL.REPORT.WRITE", "RUL.TODO.TRACK", "RUL.RUBY.FUNCTIONAL"]
patterns: ["MAX.ATOMIC.CONCERN", "MAX.DRY", "MAX.RUBY.ONLY"]
terms: ["IDENTITY.MAXIM", "IDENTITY.SCRIPT"]
---

**Procedure**

0. **Self-audit** — before creating a new survey, check existing surveys in `survey/` for overlap. If the subject has an existing survey, add scripts to it instead of creating a new directory.

1. **Name the survey** — `{qualifier}-{subject}/` under `survey/`. Qualifier describes the analysis mode; subject describes what it targets. Examples:
   - `tool-layer-survey/` — tool layer classification
   - `dep-inventory-survey/` — dependency inventory vs declared
   - `entity-segment-count/` — segment count compliance
   - `person-identity/` — person identity compliance

2. **Create directory** — `survey/{qualifier}-{subject}/` with 1–4 Ruby scripts. Each script handles one concern per MAX.ATOMIC.CONCERN.

3. **Name scripts** — `sNN-description.rb` where NN is a zero-padded sequence number (s01, s02, s03). Description is hyphen-separated. The ring label uses `s` for survey (read-only analysis).

4. **Header** — every script starts with:
   ```ruby
   #!/usr/bin/env ruby
   # ring: 1 (LOCAL-READ) — short descriptor
   # survey: {qualifier}-{subject}
   ```

5. **Use template/** — copy `template/rN-script-template.rb` as starting point for entity-based surveys. Adapt for non-entity scans (filesystem, JSON, lockfiles) by using Ruby stdlib directly — `json`, `pathname`, `fileutils`.

6. **Use knowledge/** — reference `knowledge/` for Ruby functional programming patterns:
   - `knowledge/lambda-stabby.md` — stabby lambda syntax (`->()`)
   - `knowledge/pathname-patterns.md` — Pathname file globbing
   - `knowledge/enumerable-chain.md` — Enumerable chaining patterns
   - `knowledge/string-formatting.md` — string formatting conventions

7. **Use survey/ examples** — reference existing surveys for structure patterns:
   - `dep-inventory-survey/s01-dep-declared-vs-used.rb` — pure lambdas, IO/effect separation, classification tables
   - `dep-inventory-survey/s02-dep-symlink-audit.rb` — filesystem traversal, pass/fail metric, repair guidance
   - `tool-layer-survey/s01-tool-layer-survey.rb` — entity body scanning with `_rb/` modules
   - `tool-layer-survey/s02-boundary-violations.rb` — composition claim detection rules

8. **Separate pure from IO** — define lambdas at top (pure transformations), run main logic after, output at end:
   ```ruby
   # Pure: transformation functions
   ExtractImports = ->(text) { ... }
   ClassifyImport = ->(path) { ... }
   
   # IO: read operations
   GlobFiles = ->(dir) { Dir.glob(...) }
   
   # --- Main ---
   data = GlobFiles.call(target)
   # process, classify, output
   ```

9. **Output to stdout** — surveys are read-only. Write structured output to stdout:
   - Use `SEPARATOR = "─" * 72` for section dividers
   - Group results by classification
   - End with summary counts
   - Use ✓/✗ status indicators for pass/fail

10. **Write reports** — after running, route output to `report/`:

    | Result | Path | Format |
    |--------|------|--------|
    | All pass, summary data | `report/conclusions/{survey}-{script}-{timestamp}.txt` | Plain text |
    | Violations or failures | `report/errors/{survey}-{script}-{timestamp}.txt` | Plain text |
    | Multi-step process trace | `report/walkthroughs/{survey}-{timestamp}.md` | Markdown |

    Timestamp format: `date -Iseconds` or `YYYY-MM-DDTHH:MM:SS±HH:MM`

11. **Update todo** — track survey scripts in `todo/{timestamp}.md` with pending/in-progress/completed status per script.

**Survey types** (from `survey/` inventory — 25 existing):

| Type | Count | Pattern |
|------|-------|---------|
| Entity compliance | 12 | Scan entity files, validate fields, report violations |
| Migration scope | 6 | Cross-reference old vs new conventions, identify candidates |
| Identity audit | 4 | Check identity definitions, missing types, body redundancy |
| Infrastructure scan | 3 | Scan filesystem, JSON, lockfiles — non-entity targets |

Choose the pattern that matches your subject. Infrastructure scans (like `dep-inventory-survey`) use Ruby stdlib directly instead of `_rb/` entity modules.

**Gotchas**

- Surveys are **read-only** — never write or modify files. Read-only analysis only.
- Paths in survey scripts under `survey/{qualifier}-{subject}/` go up 3 levels to reach `assembler/` root: `__dir__` + `"..", "..", ".."`. (The `dep-inventory-survey` scripts have a bug: they use 4 `..` levels instead of 3.)
- Scripts use `ruby` interpreter, not `bun` — they are `.rb` files.
- For non-entity surveys, `_rb/` modules (paths, frontmatter, report) may not apply. Use Ruby stdlib directly: `json`, `pathname`, `fileutils`, `stringio`.
- Write reports manually by redirecting stdout: `ruby s01-script.rb > report/conclusions/s01-$(date -Iseconds).txt`
- `survey/` is for analysis scripts only. Actions (migrations, renames, writes) belong in `r*-*.rb` scripts under `.opencode/_scripts/`.

**Rules**

- Every survey directory has 1–4 scripts
- Every script has a unique `sNN-` prefix within its survey
- No survey script writes files — output goes to stdout only
- Reports route to `report/` manually or via pipe
- Pure lambdas defined before IO sections
- Ruby stdlib only — no gems, no external runtimes
- New survey first checks existing surveys for overlap
