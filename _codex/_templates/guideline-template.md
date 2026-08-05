---
id: TEMPLATE.GUIDELINE
title: Guideline Template — Layer Constitution Form
layer: guideline/
purpose: "Layer-constitution template: taxonomy, file form, composition rules."
naming: guideline/layer.md
tags: [template, guideline, constitution]
status: active
---
# {Layer}-layer — the guideline for {layer}/

**Layer:** guideline/
**Naming:** `guideline/{layer}.md` — the layer's own constitution: taxonomy, file form, composition rules.
**Composes with:** every `{layer}/{domain}-{constraint}.md` file; `_codex/_templates/precedence-chain.md`.

## Purpose

{one paragraph: what this layer declares and how it relates to the other layers}

## Categorical aspects

Every file in this layer classifies along four orthogonal axes:

| Axis | Values | Meaning |
|------|--------|---------|
| {Axis 1} | {value} / {value} / {value} | {what the axis constrains} |
| {Axis 2} | {value} / {value} | {the logical character} |
| {Axis 3} | {value} / {value} / {value} | {how the property is preserved} |
| {Axis 4} | {value} / {value} / {value} | {how violation is detected} |

Example (invariant layer): subsystem × kind × strength × detector.

### Formal kinds

- **{kind-1}** — {bad states unreachable: the forbidden state never occurs}
- **{kind-2}** — {a mapping holds: one value always equals another across states}
- **{kind-3}** — {lifetime/order property: one thing outlives or precedes another}
- **{kind-4}** — {shape property: the code/config routes through one point}

### Strengths (ascending fragility)

- **by-{strength-1}** — {impossible to violate without editing code}
- **by-{strength-2}** — {a precondition check prevents the violating transition}
- **by-{strength-3}** — {a post-hoc check rejects the bad outcome}
- **by-{strength-4}** — {a scan detects drift: violation silent until the audit runs}

## Standard semantic form

Every `{layer}/` file carries exactly these blocks — nothing more, nothing less:

```text
# {Domain}-{constraint} — {short title}

**Layer:** {layer}/
**Naming:** `{domain}-{constraint}.md`
**Composes with:** {links to enforcing layers; forbidden to restate them}
**Category:** {subsystem} × {kind} × {strength} × {detector}

## {Invariant/Predicate}

{one declarative predicate sentence — the state fact}

## Formal

{the plain-prose declaration: the state fact, its negation (the forbidden state), and what the forbidden state means}

## Violation signature

{the observable symptom or check that detects the forbidden state}

## Enforced by

{links to precept/morphism/procedure files that keep the system inside the invariant's allowed states}

## Instance

{date, incident, outcome}
```

## Composition rules

{numbered rules governing what files in this layer may and may not contain — especially what they must not restate from other layers}

Example (invariant layer):
1. A file keeps steps, structure, and rules in their owning layers — procedure/morphism/precept hold them. Repetition collides with those layers.
2. A file always cites its enforcing layers — the Enforced by block is mandatory.
3. Every file carries exactly one predicate — atomicity per `MAX.ATOMIC.CONCERN`.
4. A candidate that describes conduct classifies as a precept. The test: does it assert a state fact, or command an action?
5. A candidate that describes how classifies as a pattern; steps form a procedure. Invariants own only the predicate + detector.

## Inventory

{table: file → category → enforced by / composes with}

## Non-{layer}s (excluded)

{what the layer excludes: conduct → precept, structure → pattern, steps → procedure}

## Instance

{date, project, grounding}
