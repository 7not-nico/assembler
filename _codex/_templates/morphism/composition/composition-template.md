---
id: TEMPLATE.COMPOSITION
title: Composition Template — Shared Binary Form
layer: morphism/composition/
purpose: "Atomic composition template: the shared-binary composition chain, declaration contract, and a session instance."
naming: action-domain.md
tags: [template, composition, morphism, binary]
status: active
---
# {ACTION}-{DOMAIN}.md

**Layer:** morphism/composition/
**Naming:** `action-domain.md` — code morphism, reusable structure.
**Composes with:** `morphism/shared-deps-binary.md` (base form); derived from `study/` + `fixture/` proof.

## Morphism

{One declarative sentence naming the reusable composition.}

## Composition

{Numbered step chain — declare → implement → build → ignore → consume → verify. State the invariant the composition preserves.}

## Declaration contract

{The main() shape — header comment, arity guard, positional args, Abs+EvalSymlinks, stdout/stderr, exit codes.}

## Verification

{How the composition proves correct — the check, the failure mode, the regression.}

## Instance

{The concrete project case that grounded the composition — date, file, outcome.}
