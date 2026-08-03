# mirror live skills into rust-docs

Status: complete (2026-08-02)

## Tasks

- [x] Query entity context (semantic search) for live skill set
- [x] Survey live skill sources across workspace + home roots
- [x] Copy all live skills into `_knowledge/rust-docs/skills/`
- [x] Verify copy integrity (tree + SKILL.md count)
- [x] Write report and close todo

## Context

- Target: `_knowledge/rust-docs/skills/` (empty dir exists)
- Sources: `.opencode/skills/` (10 live dirs + nested dispatcher skills), `~/.agents/skills/find-skills`, `~/.claude/skills/omarchy`
- Built-in `customize-opencode` has no filesystem location — excluded from copy
- Exclude `.backups/`, `.template/` — archived, not live
