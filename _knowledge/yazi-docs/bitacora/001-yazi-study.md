# 001-yazi-study.md

**Date:** 2026-07-31
**Source:** yazi-rs.github.io — official Yazi docs (26.5.6)

## Objective

Test the `_knowledge/_templates/` scaffold on a real project — study Yazi file manager docs into a new knowledge-chain project.

## Session walkthrough

1. **Scaffold test** — ran `scaffold-knowledge.sh yazi-docs "Study of Yazi..."`; hit sed delimiter bug (domain contained `/`) → fixed scaffold to `|` delimiter; re-ran successfully
2. **Verify** — structure + AGENTS.md domain injection + push script + test term → `schema/yazi_docs.db` created
3. **Precepts** — wrote 3: prefer-official-reference, cite-versioned-docs (26.5.6), search-before-navigate
4. **Config study** — fetched yazi.toml/keymap.toml/theme.toml pages via parallel-search; wrote ch01-overview, ch02-yazi-toml, ch03-keymap, ch04-theme
5. **Plugins** — plugins/overview + tips pages; plugins/development 404'd (URL moved) → recovered via overview; wrote ch05-plugins
6. **Glossary** — 8 terms (yazi-toml, keymap-toml, theme-toml, init-lua, plugin, flavor, prepend-keymap, yazi); pushed → DB: 8 terms + 5 notes
7. **Reference** — conventions.md compiled from notes (config layout, mixing, all file surfaces, plugins)
8. **Fixtures** — ch02-yazi.toml, ch03-keymap.toml, ch05-init.lua practice configs

## Method notes

- Template system reused end-to-end — scaffold → precepts → notes → glossary → DB push → reference → fixtures
- Parallel-search excerpts sufficient for most config pages; no Playwright needed (static docs)
- 404 recovery: plugins/development moved; overview + tips covered the topic

## Outcomes

Chain complete through fixtures: precept (3) → procedure (0) → note (5) → bitacora (1) → glossary (8, in DB) → reference (1) → fixtures (3). Template proven on second project.

## Open edges

- `procedure/` empty — could add `configure-yazi.md`, `install-plugins.md`
- Image preview (Chafa/Überzug++) per-terminal setup not fully covered (referenced in ch01)
- Fixtures unverified against running Yazi
- `concept/` + `research/` layers unused this session (direct note-writing from excerpts)
