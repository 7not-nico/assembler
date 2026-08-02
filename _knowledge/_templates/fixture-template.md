---
id: TEMPLATE.FIXTURE
title: Fixture Template — Atomic Regression Harness Form
layer: fixture/
purpose: "Atomic regression-harness template: purpose, build/run commands, assertion set."
naming: action-domain-test.ext
tags: [template, fixture, regression]
status: active
---
# {action}-{domain}-test.{ext} — atomic fixture

**Layer:** fixture/
**Naming:** `{action}-{domain}-test.{ext}` — atomic regression harness.
**Composes with:** `study/{domain}-architecture.md`, `pattern/{morphism}.md`; rerun after any change in its domain.

## Header contract

Every fixture file carries a header comment block stating:

1. **Purpose** — the exact property proven (one sentence)
2. **Build/run commands** — compile + execute lines
3. **Proves** — the assertion set: expected output, exact dims, zero overrun, etc.

## Structure

```{ext}
// {action}-{domain}-test.{ext} — atomic fixture: {one-line purpose}
// Build: {command}
// Run:   {command}
// Proves {expected property} before any {integration step}.

{includes}
{constants — expected dims/values}
{main: assert each expectation, report PASS/FAIL per check, non-zero exit on any failure}
```

## Verification

{how the fixture reports — per-check PASS lines, aggregate result, exit code. What a rerun must show after a change}

## Instance

{date, project, outcome — the run that proved the component before integration}
