---
id: TEMPLATE.PRECEPT.VERIFY.QALC
title: Verify-Qalc Precept Template — Quantitative Claim Verification
layer: precept/
purpose: "Every quantitative claim passes qalc verification before recording."
naming: verify-qalc.md
tags: [template, precept, qalc, metrics]
status: active
---
# verify-qalc.md

**Layer:** precept/
**Naming:** `verify-qalc.md` — declarative action-domain, atomic, one rule per file.
**Composes with:** study `{domain}-timing.md` (qalc-verified table); invariant `record-consistency.md`.

## Rule

Every quantitative claim passes `qalc -t "{claim}"` before recording.

## Scope

Task-level; every numeric value in study docs, reports, and fixtures.

## Order / Practice

1. The claim writes as one expression: `qalc -t "154*456"`.
2. The qalc result records beside the claim (the study carries the verified table).
3. A claim without a qalc check marks the record incomplete.
4. Metrics report in nanoseconds where timing: `date +%s%N` deltas.

## Example

```bash
qalc -t "4194304/70224"   # 59.72750057 — {device} frame rate
```

## Instance

{date, project, outcome — the study table that first carried verified values}
