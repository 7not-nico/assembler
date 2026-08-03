# agents-skills-template-conversion

Status: completed (2026-08-03)
Created: 2026-08-03

## Goal

Convert all 28 skills and 45 AGENTS.md files to the categorical-junction template (BULLET.template.md ground), and all CLI entities to the bullet-junction format.

## Tasks

- [x] Backup all 28 skill files to `.backups/2026-08-03T123655`
- [x] Convert 28 SKILL.md files — ## headings, junction bullets, description fixes
- [x] Verify skills: PASS=28 FAIL=0
- [x] Backup all 45 AGENTS.md files to `/tmp/opencode/agents-backup-2026-08-03T124940`
- [x] Convert 45 AGENTS.md files — tables→code blocks, numbered→bullets, bold strip, period strip
- [x] Hand-write structural cases: `_knowledge/AGENTS.md` (empty), rust-docs, homophones, neovim-repo, a01-harness-llm, depot/scripts, CR-news
- [x] Verify AGENTS.md: COMPLIANT=45 FAIL=0

## Decisions

- Context7 verified Ruby `Find.find` + `chomp` idioms before the fixed conversion
- Tables become `text` code blocks; prose paragraphs become junction bullets; inline bold stripped
- Backup precedes every conversion batch; restore available at backup paths

## Reports

- task-report to be written at completion
