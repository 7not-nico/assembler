---
id: PAT.PLUGIN.CANDIDATE.EVALUATION
title: "Plugin Candidate Evaluation — Applied Scoring"
source: assembler
summary: "Seven-criteria scoring framework for plugin candidates. Each criterion encodes a structural requirement."
principle: "Every plugin scores against the same seven criteria. A score below six reveals where to refine. Exceptions are documented and bounded."
enforcement: Convention
tags: [plugin, evaluation, scoring, pattern, decision]
status: active
priority: 3
---

Every plugin candidate scores against the same seven criteria from `PROT.PLUGIN.CANDIDATE`. The table mirrors the criteria framework. Each row shows which criteria the candidate meets or misses.

## Rules

- Every existing and proposed plugin scores against the same seven-column table
- Criterion 3 (one hook) carries a documented exception for validation plugins per `PAT.PLUGIN.VALIDATION`
- Criterion 5 (purity boundary) marks zero when the plugin calls `initDB()` directly with no separation layer
- A score below six means refine the candidate

## Applicability

Any plugin evaluation during design review. The scoring structure applies uniformly across all candidates. New plugin proposals include a table with the candidate row.

## See also

- `ILL.PLUGIN.CANDIDATE.SCORING` — walkthrough of scoring a plugin candidate
- `PROT.PLUGIN.CANDIDATE` — governing seven-criteria protocol
- `PAT.PLUGIN.VALIDATION` — validation plugin pattern, exception to criterion 3
- `PAT.PLUGIN.DIRECTION` — write-only constraint
