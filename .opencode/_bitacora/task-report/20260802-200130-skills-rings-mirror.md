# Skills + rings mirror into rust-docs

## Done

- Created `_knowledge/rust-docs/skills/` — mirrored all 12 live skill sources: 10 from `.opencode/skills/` (knowledge-languages, playwright-dispatcher, reason-invariants, reason-quantitative, reason-verbal, refactor-skill, search-dispatcher, semantic-dispatcher, study-foundations, workflow-dispatcher), plus `~/.agents/skills/find-skills` and `~/.claude/skills/omarchy`. 29 SKILL.md files total, including nested dispatcher skills (playwright/search/semantic/workflow `skill/` subdirs).
- Created `_knowledge/rust-docs/rings/` — mirrored 5 ring-topology specifications from `.opencode/entities/specifications/`: SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY, SPEC.CODE.RING.TOPOLOGY, SPEC.DIRECTORY.RING.TOPOLOGY, SPEC.LANGUAGE.RING.TOPOLOGY, SPEC.CODE.ELEMENT.NAME.
- Extended `_knowledge/rust-docs/AGENTS.md` with `## Anchored skills` and `## Ring specifications` sections.

## Decisions

- Excluded `.backups/` and `.template/` skill dirs — archived, not live.
- Excluded built-in `customize-opencode` skill — no filesystem location.
- Mirrored whole skill directories (not flattened SKILL.md) — preserves nested dispatcher structure.
- Mirrored 5 SPEC files — the ring-topology family the root AGENTS.md references; full 26-file specifications set stays at source.
- Copies are read-only references; live skill set remains authoritative at sources.

## Open edges

- Skills DB (`patlib.db`) rows for the 29 mirrored SKILL.md files already exist (reconciled 19:43:04); no re-embed needed for copies since copies carry same frontmatter ids.
- `~/.claude/skills/omarchy` + `~/.agents/skills/find-skills` copies are user-home sourced — future updates to those homes require re-mirror.

## Todo state

- `2026-08-02--mirror-live-skills-into-rust-docs.md` — all tasks complete.

## Follow-up (20:05-20:07)

- Enumerated the full skill catalog in `_knowledge/rust-docs/AGENTS.md` `## Anchored skills` — all 30 SKILL.md files listed by family (semantic 7, search 3, playwright 6, reasoning 3, workflow 6, study/language 2, home 3).
- Corrected SKILL.md count 29 → 30: `omarchy/` arrives as a symlink (`~/.claude/skills/omarchy` → `~/.local/share/omarchy/default/omarchy-skill`), which bare `find` skips; `find -L` reveals the 30th file. AGENTS.md notes the symlink.
- Logs: `task-stdout/20260802-200539-skills-inventory.log`, `task-stdout/20260802-200753-skills-count-follow.log`.

## Logs

- `task-stdout/20260802-200054-skills-copy.log` (copy, exit 0)
- `task-stdout/20260802-200106-rings-copy.log` (rings copy, exit 0)
- `task-stdout/20260802-200112-skills-rings-verify.log` (counts)
- `task-stdout/20260802-200122-skills-rings-treecheck.log` (tree diff, all OK)
