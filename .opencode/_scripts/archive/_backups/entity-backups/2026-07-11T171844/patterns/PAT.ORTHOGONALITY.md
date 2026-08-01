---
id: PAT.ORTHOGONALITY
title: Orthogonality — One Thing Per Tool
source: INSP.PRAGMATIC
summary: Changes to one component should not affect unrelated components.
principle: Changes to one component should not affect unrelated components.
enforcement: Convention
tags: [architecture, tooling, separation, design, maintainability]
patterns: [PAT.DRY, PAT.PLUGIN.IPC.TOOL, PAT.SHARED.LIB, PAT.MUTATION.PATTERN]
terms: []
status: active
priority: 2
---

Changes to one component should not affect unrelated components.

## Context

Orthogonality is the property that modifying one aspect of a system has no side effect on other aspects. In AMANDA's tool architecture, this means each `.opencode/tools/` file is independent: it reads from `_lib/` but never imports another tool. Adding a feature means adding one file, not touching three. The metric: how many files change when adding a new feature.

## Rules

- Each tool does exactly one thing
- No tool imports another tool — tools import only from shared lib, not from other tools
- Adding a tool is adding one file — no cascade
- A change to one tool never requires a change to another tool with the same interface
- Read and write are always separate tools, not combined

## Applicability

Any project with multiple tools or scripts — the orthogonality check is the number of files touched per feature.

## See also

- PAT.DRY
- PAT.PLUGIN.IPC.TOOL
- PAT.SHARED.LIB
- PAT.MUTATION.PATTERN
