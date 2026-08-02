---
id: TEMPLATE.PRECEPT.RECORD.METRICS
title: Record-Metrics Precept Template — Metrics in Every Report
layer: precept/
purpose: "Every task-report carries a metrics section with quantitative values."
naming: record-metrics.md
tags: [template, precept, metrics, report]
status: active
---
# record-metrics.md

**Layer:** precept/
**Naming:** `record-metrics.md` — declarative action-domain, atomic, one rule per file.
**Composes with:** invariant `record-consistency.md` (todo/report discipline).

## Rule

Every task-report carries a metrics section with quantitative values.

## Scope

Report-level; every session and task report.

## Order / Practice

1. Metrics table per task domain: build, tests, acquisitions, fixtures, backups.
2. Timing reports in nanoseconds (`date +%s%N`); sizes in bytes; counts exact.
3. Before/after columns where a change alters a value.
4. A report without metrics marks the task incomplete.

## Example

```text
| Metric | Before | After |
|--------|--------|-------|
| Warnings | 1 ({file}) | 0 |
| {suite} | {n}/{n} | {n}/{n} |
```

## Instance

{date, project, outcome — the first report to carry a before/after metrics table}
