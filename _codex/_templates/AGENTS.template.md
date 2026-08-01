---
id: TEMPLATE.AGENTS
title: AGENTS Template — Project Instructions Bootstrap
layer: agents
purpose: "Bootstraps a project's AGENTS.md: domain, structure, toolchain, records."
naming: AGENTS.md
tags: [template, agents, bootstrap]
status: active
---
# {PROJECT-NAME} — AGENTS.md

## Domain

{domain statement}

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

```
format/     {NAME}.md                    e.g. frontmatter.md
precept/    {action}-{domain}.md         e.g. prefer-official-reference.md
procedure/  {action}-{domain}.md         e.g. research-wiki.md
research/   {topic}-{source}.md          e.g. configuring-wiki.md
concept/    {topic}.md                   e.g. config-hierarchy.md
note/       ch{NN}-{topic}.md            e.g. ch03-configuring.md
bitacora/   {NNN}-{description}.md       e.g. 001-wiki-study.md
glossary/   {term}.md                    e.g. dispatcher.md
schema/     {name}.sql                   e.g. registry.sql
script/     {action}-{subject}.rb        e.g. push-registry.rb
reference/  {name}.md                    e.g. conventions.md
fixtures/   ch{NN}-{aspect}.{ext}        e.g. ch01-basic.conf
practice/   {NNN}-{exercise}.md          e.g. 001-binds-drill.md
```

Full ruleset: `reference/naming-conventions.md`.

## Skills

`docs/` — copied skill catalog (support layer, outside chain).

## Delegation

Root provides patterns, terms, and shared substrate. This project owns {domain} study.
