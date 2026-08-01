**Guided Composition** — a structural framework where execution sequence is prescribed by the document. The document encodes the steps; the executor follows them. Skills and commands are guided compositions.

## Rules

- Each skill prescribes its execution sequence within the document — steps, phases, and decision points are defined in order. The executor reads and follows.
- Each command prescribes its execution sequence within the document — verb-domain naming and numbered steps encode behavior. The executor reads and follows.
- The executor follows the document structure — the document IS the composition. No external operator required.
- Skills declare `state-profile` in frontmatter per the skill state classification.
- Commands follow verb-domain naming — `CMD.{VERB}.{DOMAIN}`. The name encodes behavior scope.
- Compose guided compositions and morphisms at the agent level only — a single execution context belongs to exactly one framework.

## Applicability

All skills (`.opencode/skills/*/SKILL.md`) and commands (`.opencode/commands/*.md` + `.opencode/commands/yamls/*.yaml`).

---
id: SPEC.DOCUMENT.COMPOSITION.GUIDED
title: Guided Composition — Prescribed Step Sequence
source: assembler
summary: "Skills and commands prescribe their own execution sequence within the document. The executor follows the document structure — the document functions as the sole composition operator."
specifies: Guided document-execution framework for skills and commands
tags: [architecture, classification, composition, workflow, convention, specification, guided]
status: active
---
