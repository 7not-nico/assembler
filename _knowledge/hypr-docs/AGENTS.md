# Hyprland docs — AGENTS.md

## Domain

Study of Hyprland — Wayland compositor. Covers config syntax (Lua since 0.55), architecture, bindings, IPC, and ecosystem integration (waybar, walker, mako, kitty).

## Precedence chain — obligatory

`format/` → `precept/` → `procedure/` → `research/` → `concept/` → `note/` → `bitacora/` → `glossary/` → `schema/` → `script/` → `reference/` → `fixtures/` → `practice/`

Violating this order is prohibited. Precepts state the rule. Procedures state the steps. Both compose — neither supersedes the other.

Derivation: each layer derives from what precedes it, traced outward to a cognition dead end (`format/` — file shapes).

### Directory roles

`format/` — structural format definitions. Outermost — shapes govern how every other file is written.

`precept/` — action-domain rule files. Declarative. Governs all work.

`procedure/` — procedural chains, atomic per workflow. Numbered steps. Composes with precept.

`research/` — raw web research, captures, evidence. Feeds concept decomposition.

`concept/` — topic decomposition into sub-concepts. Organizes research into study anchors.

`note/` — project aspect documentation. Precedes bitacora, glossary, reference.

`bitacora/` — session walkthroughs. Name describes the work.

`glossary/` — atomic declarative term definitions. Primary registry data source.

`schema/` — SQL schema for glossary/registry tables. DB design derives from glossary terms.

`script/` — scripts for automation and DB population. Ruby loader targets schema tables.

`reference/` — conventions, exceptions. Distills from full study surface. Governs fixtures.

`fixtures/` — raw practice configs. Governed by reference conventions.

`practice/` — hands-on exercises. Terminal layer — drills validate the reference material.

`docs/` — copied skill catalog (browser, research, search, reasoning). Support layer, outside chain.

### Registry triad

`glossary/` → `schema/` → `script/` — data → container → loader. Each derives from the previous. Reversing any pair breaks meaning.

## Naming standards

| Layer | Pattern | Example |
|-------|---------|---------|
| `format/` | `{NAME}.md` | `frontmatter.md` |
| `precept/` | `action-domain.md` | `prefer-official-reference.md` |
| `procedure/` | `action-domain.md` | `research-wiki.md` |
| `research/` | `{topic}-{source}.md` | `configuring-wiki.md` |
| `concept/` | `{topic}.md` | `configuring.md` |
| `note/` | `ch{number}-{topic}.md` | `ch03-configuring.md` |
| `bitacora/` | `{number}-{description}.md` | `001-wiki-study.md` |
| `glossary/` | `{term}.md` | `dispatcher.md` |
| `schema/` | `{name}.sql` | `hypr.sql` |
| `script/` | `{action}-{subject}.rb` | `push-registry.rb` |
| `reference/` | `{name}.md` | `conventions.md` |
| `fixtures/` | `ch{number}-{aspect}.lua` | `ch01-basic.lua` |
| `practice/` | `{number}-{exercise}.md` | `001-binds-drill.md` |

## Skills

`docs/` — copied skill catalog:

- research — compose-web, orchestrate-research, study-foundations, search-papers
- browser — use-playwright-core, use-playwright-ai-mode, use-playwright-debug, use-playwright-network-storage, use-playwright-vision
- search/reference — use-parallel-search, use-exa, use-context-seven
- reasoning — read-maxims-protocols, guide-reasoning, report-outcomes
- system — query-nerdfont

## Delegation

Root provides patterns, terms, and shared substrate. This project owns Hyprland documentation study — understanding config syntax, architecture, and ecosystem conventions.
