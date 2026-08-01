# 003 — Documentation Layout

**Date:** 2026-07-25T21:16:03-06:00
**Status:** Accepted

## Context

scripts/ needed documentation beyond what AGENTS.md covers. No convention existed for supplementary docs.

## Decision

Three documentation directories following ludoteca conventions:

| Directory | Prefix | Purpose |
|-----------|--------|---------|
| `docs/` | `ref-`, `flow-` | Uncovered reference and process docs |
| `dataflow/` | `ref-`, `flow-` | Data movement and pipeline documentation |
| `guides/` | `{topic}` | Implementation patterns and guides |

- `ref-` = static reference (schemas, maps, rules)
- `flow-` = process/pipeline documentation
- `guides/` uses plain topic naming

## Consequences

- AGENTS.md stays concise — links to docs instead of duplicating
- All three directories registered in SKL.REPORT.OUTCOMES skill
- `docs/ring-mapping.md` documents both ring systems and how they differ
- `dataflow/parse-validate-pipeline.md` documents the core data flow
- `guides/functional-programming.md` documents the lambda-based FP pattern
