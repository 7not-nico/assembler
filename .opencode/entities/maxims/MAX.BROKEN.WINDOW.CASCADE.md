---
id: MAX.BROKEN.WINDOW.CASCADE
title: Broken Window — Validate at Every Gate
source: INSP.PRAGMATIC
summary: A small issue left unfixed invites more. Validate at every gate.
principle: A small issue left unfixed invites more. Validate at every gate to prevent systemic decay.
enforcement: Convention
tags: [quality, validation, maintenance, discipline, convention]
status: active
priority: 3
---

**Broken Window** — validate at every gate; small issue left unfixed invites systemic decay.

## Decay

- **Broken window** — small issue left unfixed, invites more issues
- **Validation** — runs before every critical operation, catches issues at the gate
- **Repair** — permanent fixes only, completes within the current work session

## Rules

- Fix broken windows immediately — permanent fixes only
- Validate runs before every sync
- Close every broken window within the current session boundary
- When introducing a new warning, fix two old ones first

## Applicability

Any project with data pipelines, content sync, or multi-step workflows where intermediate errors compound.
