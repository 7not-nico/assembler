---
id: TEMPLATE.AGENTS
title: AGENTS Template — Project Instructions Bootstrap
layer: agents
purpose: "Bootstraps a project's AGENTS.md: domain, lean chain, toolchain, sources."
naming: AGENTS.md
tags: [template, agents, bootstrap]
status: active
---
# {PROJECT-NAME} — AGENTS.md

## Domain

{domain statement}

## Precedence chain — obligatory

Learning Precedence Chain governs all work. Each layer completes before advancing to the next.

`precept/` → `concept/` → `reference/` → `fixture/`

`script/` runs parallel — automation and registry population serve any layer.

Violating this order is prohibited. Precepts state the rule. Concepts organize the study. Reference distills the verified truth. Fixtures practice the material.

### Directory roles

`precept/` — action-domain rule files. Declarative. Governs all work. Naming: `{action}-{domain}.md` e.g. `prefer-official-source.md`.

`concept/` — topic decomposition into sub-concepts. Organizes the study into anchors. Every concept arising from the study gets written — none skipped. Naming: `{topic}.md` e.g. `ownership.md`.

`reference/` — distilled conventions and citations from canonical sources. Verbatim quotes with claim mapping. Governs fixtures. Naming: `{name}.md` e.g. `conventions.md`.

`fixture/` — practice code per study unit. Raw learning material. Governed by reference. Naming: `{unit}-{topic}.{ext}` e.g. `ch04-ownership.rs`.

`script/` — automation and registry population. Naming: `{action}-{subject}.rb` e.g. `push-registry.rb`. `run-logged.sh` logs any command into `_knowledge/_bitacora/task-stdout/` — `bash run-logged.sh {name} -- {command}`.

## Layer semantics (governing rule)

```text
concept/    EVERY concept arising from study gets written — none skipped
reference/  CITATIONS from canonical sources — verbatim quotes, claim mapping
fixture/    compilable practice material — toolchain must accept each file
```

## Toolchain

{Language/runtime toolchain versions. Fixtures compile or run with the stated commands.}

## Sources

{Canonical references for all claims — official docs first. Archived prior studies hold cross-reference material — consult, do not copy verbatim.}

## Skills

`skills/` — anchored skill catalog (support layer, outside chain). Copies stay read-only references — live skills live at the sources.

## Delegation

Root provides patterns, terms, and shared substrate. This project owns {domain} study.
