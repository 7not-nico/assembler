# Communication-Rules Fixture and Corpus Pass

Topic: communication-rules-fixture
Status: completed (2026-08-02)

## Tasks

- [x] survey rules corpus — locate rule files, scan prose for -ed/-ing/-tion candidates to calibrate exempt tokens
- [x] create `fixture-communication-rules.sh` — bash-first audit of `.opencode/rules/*.md` prose, emits KEY=value + RESULT
- [x] write fixture in communication-rules-compliant style (proper English, SOV, no action nouns, no -ed verbs in its own prose)
- [x] show violations in stdout — per-file token detail
- [x] remediate all 84 rule files to comply — communication-*, writing-*, code-*, workflow-*, philosophy-*, singles
- [x] rerun fixture to RESULT=pass:0
- [x] update `_scripts/AGENTS.md` — prioritize bash scripts (bash-first doctrine, Bash (primary) section)
- [x] sync rules — `r6-patlib-sync.rb --type rules` (79, exit 0)
- [x] embed rules — `semantic-embed.ts --type rules --force` (79, exit 0)
- [x] drift check — `semantic-drift.ts --check` (0 missing, 0 stale)
- [x] write task report referencing log files

## Context

- User directive (2026-08-02): new fixture; all rules apply communication rules; use bitacora stdout; prioritize bash scripts in `_scripts`.
- Rule set per `RUL.COMMUNICATION.PROPER.ENGLISH` + the spec pass precedent: proper English, active voice, present tense, finite verbs, root nouns; prose excludes action nouns and -ed verb forms; labels retain original forms.
