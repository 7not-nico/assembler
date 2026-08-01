---
id: PROT.META.COMPOSITION
title: "Guided Composition — Prescribed Step Sequence"
source: NEX.META.CANVAS
summary: "Skills and commands prescribe their own execution sequence within the document. The executor follows the document structure — the document functions as the sole composition operator."
protocol: "Skills and commands prescribe their own execution sequence within the document. The executor follows the document structure. The document functions as the sole composition operator."
enforcement: Formality
tags: [architecture, classification, composition, workflow, convention]
status: active
priority: 2
---

A structural framework where execution sequence is prescribed by the document. The document encodes the steps; the executor follows them.

## Rules

1. **Each skill prescribes its execution sequence within the document** — steps, phases, and decision points are defined in order. The executor reads and follows. Governed by `PROT.SKILL.PROFILE` for state profile.

2. **Each command prescribes its execution sequence within the document** — verb-domain naming and numbered steps encode behavior. The executor reads and follows. Governed by `PROT.COMMAND.RULE` for command structure.

3. **The executor follows the document structure** — the document IS the composition. No external operator required.

4. **Skills declare `state-profile` in frontmatter** — per `PROT.SKILL.PROFILE`. The profile determines testing strategy, isolation guarantees, and dependency management.

5. **Commands follow verb-domain naming** — `CMD.{VERB}.{DOMAIN}` per `PROT.COMMAND.RULE`. The name encodes behavior scope.

6. **Compose guided compositions and morphisms at the agent level only** — a single execution context belongs to exactly one framework.

## Applicability

All skills (`.opencode/skills/*/SKILL.md`) and commands (`.opencode/commands/*.md` + `.opencode/commands/yamls/*.yaml`).

## See also

- `REF.META.ENTITY.FRAMEWORK` — entity framework classification protocol
- `PROT.SKILL.PROFILE` — skill state classification
- `PROT.COMMAND.RULE` — command convention protocol
- `PROT.TOOL.COMPOSITE` — tool morphism model (contrasting framework)
