# Communication-Rules Fixture — Follow-up Tasks

Topic: communication-rules-followup
Status: open (written 2026-08-02, session close)

## Open edges

- [ ] reconcile the 5-file gap — patlib holds 79 rules while 84 .md files exist under `.opencode/rules/`; identify which five files lack entity rows and decide the fix (add frontmatter IDs or register the files)
- [ ] investigate the non-force embed path — `semantic-embed.ts --type rules` reports 0 embedded; the `--force` pass embeds 79; confirm the staleness check matches the sync hash updates
- [ ] commit the session changes — 84 rule files, `_scripts/AGENTS.md`, `fixture-communication-rules.sh`, the bitacora todo + report (on user request only)

## Whitelist watch

- [ ] review whitelist growth — `writing`, `gapping`, `deletion`, `classification`, `derivation` enter as rule-name echoes; a future rule that uses one as a genuine gerund or action noun passes silently
- [ ] add a documented exemption path — a comment block or per-token note in the fixture that records why each whitelist token stays exempt

## Fixture robustness

- [ ] lowercase prose before the scan — capitalized -ed words (e.g. "Applied") escape the lowercase-only patterns
- [ ] scan rule yaml metadata — the fixture audits only .md files; yamls hold summary fields that may carry action forms
- [ ] migrate `fixture-ruby-test.rb` to bash — `_scripts/AGENTS.md` now declares bash-first fixtures; Ruby fixtures remain legacy

## Doc consistency

- [ ] reconcile report paths — `workflow-report-write.md` cites `.opencode/reports/{timestamp}.md`; AGENTS.md stores reports under `.opencode/_bitacora/task-report/`

## Verify at session start

- [ ] run `bash .opencode/_scripts/fixtures/fixture-communication-rules.sh` — expect RESULT=pass:0
- [ ] run `semantic-drift.ts --check` — expect 0 missing, 0 stale
