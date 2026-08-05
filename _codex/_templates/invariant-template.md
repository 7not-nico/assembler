---
id: TEMPLATE.INVARIANT
title: Invariant Template — State Predicate Form
layer: invariant/
purpose: "Always-true state predicate template: invariant, formal, violation signature, enforcement."
naming: domain-constraint.md
tags: [template, invariant, predicate]
status: active
---
# {Domain}-{constraint} — {short title}

**Layer:** invariant/
**Naming:** `{domain}-{constraint}.md` — always-true state predicate.
**Composes with:** {links to enforcing layers; forbidden to restate them}
**Category:** {subsystem} × {kind} × {strength} × {detector}

## Invariant

{one declarative predicate sentence — the state fact}

## Formal

{plain-prose declaration: the state fact, its negation (the forbidden state), and what the forbidden state means}

## Violation signature

{the observable symptom or check that detects the forbidden state}

## Enforced by

{links to precept/morphism/procedure files that keep the system inside the invariant's allowed states}

## Instance

{date, incident, outcome}

---

Layer form and categorical axes: `guideline/invariant-layer.md`. Composition rules: an invariant file never restates steps/structure/rules from enforcing layers; it always cites them.
