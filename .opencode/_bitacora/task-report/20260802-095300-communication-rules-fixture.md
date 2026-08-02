# Task report — communication-rules fixture and corpus pass

Date: 2026-08-02
Topic: communication-rules-fixture
Status: completed

## Rule set

The corpus follows the communication rules: proper English, subject-first prose, active voice, present tense, finite verbs, root nouns. Prose excludes action nouns (gerunds, nominalizations) and -ed verb forms. Labels keep original forms: entity-type names, titles, tags, headings, frontmatter fields, backtick code identifiers, quoted forms, status states.

## What the fixture does

The fixture at `.opencode/_scripts/fixtures/fixture-communication-rules.sh` audits rule prose against these rules. It runs bash-first per `_scripts/AGENTS.md`. It strips exempt contexts (backticks, quotes, bold labels, headings, fences, label prefixes, hyphenated compounds, suffix-name lists), scans prose for three classes (-ed verbs, gerunds, action-noun suffixes), and applies whitelists of root nouns, entity labels, and rule-name echoes. It emits KEY=value lines with per-file violation tokens and a final RESULT=pass|fail:count.

## Before/after

| Run | TOTAL | VIOLATED |
|-----|-------|----------|
| v1 first scan | 164 | 64 |
| v2 whitelist pass | 133 | 59 |
| v3 communication family | 110 | 48 |
| v4 writing family | 68 | 27 |
| v5 writing cleanup | 67 | 26 |
| bash fixture | 49 | 16 |
| final pass | 0 | 0 |

The final run reports RULES=84, VIOLATED=0, ED=0, GERUNDS=0, NOMINALS=0, TOTAL=0, RESULT=pass:0. The pass proceeds family by family: communication-* (13), writing-* (22), code-* (9), workflow-* (10), philosophy-* (4), singles (3).

## Decisions

- The fixture runs bash-first; the Ruby core retires (per `_scripts/AGENTS.md` doctrine and the user directive).
- Whitelists hold root nouns, entity labels, and rule-name echoes; they name things, not actions.
- Hyphenated compounds, suffix-name lists, and scope labels stay exempt.
- `writing`, `gapping`, `deletion`, `classification`, `derivation` enter the whitelist as rule-name echoes.
- `directed`, `undirected`, `completed`, `pending` enter as mode and status labels.
- Rule prose keeps structure, IDs, titles, and labels; only prose changes.

## Files changed

- All 84 files under `.opencode/rules/*.md` — prose rewrites; IDs, titles, tags, yaml metadata unchanged.
- `.opencode/_scripts/AGENTS.md` — bash-first doctrine, Bash (primary) section, Go (analysis engine) retitle.
- `.opencode/_scripts/fixtures/fixture-communication-rules.sh` — new fixture.
- `.opencode/_scripts/fixtures/fixture-communication-rules.rb` — retires; bash owns the audit.

## Logs

- task-stdout/20260802-092354-fixture-comm-rules.log — first scan, TOTAL 164
- task-stdout/20260802-092932-fixture-comm-rules-2.log — whitelist pass, TOTAL 133
- task-stdout/20260802-*fixture-comm-rules-3.log — communication family, TOTAL 110
- task-stdout/20260802-*fixture-comm-rules-4.log — writing family, TOTAL 68
- task-stdout/20260802-*fixture-comm-rules-5.log — writing cleanup, TOTAL 67
- task-stdout/20260802-*fixture-comm-rules-6.log — token detail in stdout
- task-stdout/20260802-*fixture-comm-rules-bash.log — bash fixture, TOTAL 49
- task-stdout/20260802-*fixture-comm-rules-bash2.log — workflow + philosophy + singles, TOTAL 1
- task-stdout/20260802-*fixture-comm-rules-pass.log — RESULT=pass:0
- task-stdout/20260802-094801-comm-rules-sync.log — sync 79 rules, exit 0
- task-stdout/20260802-094841-comm-rules-embed.log — embed 0 (pre-force)
- task-stdout/20260802-*comm-rules-embed-force.log — embed 79 (force), exit 0
- task-stdout/20260802-*comm-rules-drift.log — drift 0 missing, 0 stale
- task-stdout/20260802-*comm-rules-drift2.log — drift 0 missing, 0 stale (post-force)

## Open edges

- patlib holds 79 rules while 84 .md files exist under `.opencode/rules/`; five files lack entity rows (the fixture scans files, not the DB).
- The non-force embed reports 0; the force pass embeds 79. The drift check shows 0 missing, 0 stale.

## Todo state summary

All 11 todo items complete.
