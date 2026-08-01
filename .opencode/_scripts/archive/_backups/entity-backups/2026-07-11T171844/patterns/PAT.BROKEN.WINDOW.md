---
id: PAT.BROKEN.WINDOW
title: Broken Window — Validate at Every Gate
source: INSP.PRAGMATIC
summary: A small issue left unfixed invites more. Validate at every gate.
principle: A small issue left unfixed invites more. Validate at every gate to prevent systemic decay.
enforcement: Convention
tags: [quality, validation, maintenance, discipline, convention]
patterns: [PAT.DRY, PAT.ORTHOGONALITY, PAT.PLUGIN.IPC.TOOL]
terms: []
status: active
priority: 3
---

A small issue left unfixed invites more. Validate at every gate to prevent systemic decay.

## Context

The Broken Window theory holds that visible signs of neglect encourage further neglect. In codebases, an unfixed lint warning, an un-validated sync step, or a temporarily skipped check signals that quality standards are optional. Each broken window lowers the threshold for the next one. The fix: validate at every gate, never defer.

## Rules

- Fix broken windows immediately — no temporary shortcuts
- Validate runs before every sync
- No broken window is left open across a session boundary
- When introducing a new warning, fix two old ones first

## Applicability

Any project with data pipelines, content sync, or multi-step workflows where intermediate errors compound.

## See also

- PAT.DRY
- PAT.ORTHOGONALITY
- PAT.PLUGIN.IPC.TOOL
