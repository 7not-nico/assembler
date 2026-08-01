# yazi-docs — AGENTS.md

## Domain

Study of Yazi — Rust terminal file manager. Covers config (yazi.toml, keymap.toml, theme.toml), plugins, and CLI usage.

## Precedence chain — obligatory

Learning Precedence Chain governs all work. Each layer completes before advancing to the next.

`format/` → `precept/` → `procedure/` → `research/` → `concept/` → `note/` → `bitacora/` → `glossary/` → `schema/` → `script/` → `reference/` → `fixtures/` → `practice/`

Violating this order is prohibited. Precepts state the rule. Procedures state the steps. Both compose — neither supersedes the other.

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

### Registry triad

`glossary/` → `schema/` → `script/` — data → container → loader. Each derives from the previous.

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
| `schema/` | `{name}.sql` | `registry.sql` |
| `script/` | `{action}-{subject}.rb` | `push-registry.rb` |
| `reference/` | `{name}.md` | `conventions.md` |
| `fixtures/` | `ch{number}-{aspect}.{ext}` | `ch01-basic.conf` |
| `practice/` | `{number}-{exercise}.md` | `001-binds-drill.md` |

## Skills

`docs/` — copied skill catalog (support layer, outside chain).

## Delegation

Root provides patterns, terms, and shared substrate. This project owns Study of Yazi — Rust terminal file manager. Covers config (yazi.toml, keymap.toml, theme.toml), plugins, and CLI usage. study.
