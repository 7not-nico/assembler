# anchor-workflow.md

**Layer:** format/ — command definition template (CMD.ANCHOR.WORKFLOW pattern)
**Purpose:** documents the anchor-workflow command — a skill-picking mechanism that places skills into subproject `docs/` as flattened markdown.

## Command identity

```
id:          CMD.ANCHOR.WORKFLOW
title:       Anchor Workflow
description: Anchor all work to a set of skills, plus patlib MCP per RUL.QUERY.PATLIB.CONTEXT and CAPTCHA handling per RUL.CAPTCHA.GATE
source:      assembler
tags:        [workflow, anchor, skills, mcp, research, captcha, entity]
```

## Core set (7 anchored skills)

```
1. compose-web               web research composition (search → fetch → Context7 → Playwright → log)
2. report-outcomes           write conclusions to report/, errors, walkthroughs, todo per MAX.ATOMIC.CONCERN
3. use-playwright-core       browser navigation, snapshot, find/click/type, evaluate/screenshot
4. knowledge-ruby            Ruby functional programming knowledge lookup
5. read-maxims-protocols     read MAX.* then PROT.* then RUL.* before every task
6. acquire-assets            JSTOR image acquisition via Playwright + curl, assets.db registration
7. declare-grounded-entity   web research validation → precedence derivation → paper acquisition → entity write-sync
```

## Procedure — pick skills for a subproject

```
1. Read the subproject AGENTS.md — domain determines which skills anchor
2. Select the anchored skills that match the domain (subset per project)
3. Copy each skill's SKILL.md into subproject docs/ as {skill-name}.md (flattened)
4. Add docs/ catalog to the subproject AGENTS.md Skills section, grouped by domain
5. Invoke the anchored skills at task start — the agent operates under them for the session
```

## Selection by domain

```
docs study     compose-web, use-playwright-core, use-playwright-*, study-foundations,
               use-parallel-search, use-exa, use-context-seven, read-maxims-protocols,
               guide-reasoning, report-outcomes
code study     compose-web, knowledge-ruby, read-maxims-protocols, report-outcomes, guide-reasoning
asset acquire  compose-web, use-playwright-core, acquire-assets, report-outcomes
```

## Implementation

```
bash _templates/copy-skills.sh {dest-docs-dir} {skill-name}...
wired into scaffold-knowledge.sh --with-skills
```

## Composes with

```
- RUL.QUERY.PATLIB.CONTEXT — patlib query before tasks
- RUL.CAPTCHA.GATE — CAPTCHA pause/resume flow
- precept/search-before-navigate.md — search first, browse second
```
