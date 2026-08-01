# task-invariant-layer — the guideline for task-invariant/

**Layer:** guideline/
**Naming:** `task-invariant/guideline.md` — the layer's own constitution: taxonomy, file form, composition rules.
**Composes with:** every `task-invariant/{domain}-{constraint}.md` file; `_trove/AGENTS.md` precedence chain.

## Purpose

{one paragraph: what this layer declares — the catalog's always-true state facts — and how it relates to the other layers}

## Categorical aspects

{the axes along which predicate files classify, with a table of values}

```
axis       values
kind       placement | validity | keying | write-path | etiquette
strength   hard (machine-checkable) | soft (convention)
detector   file sweep | sqlite query | script linter | manual review
```

## Standard semantic form

{the exact block template every file in this layer carries — from `invariant-template.md`: Invariant / Formal / Violation signature / Enforced by / Instance}

## Composition rules

1. A predicate file never restates steps or structure from `task-fixture/` or `_scripts/`; it cites them.
2. Every predicate maps to at least one fixture harness that detects its violation.
3. New predicates land here before new acquisition work begins.

## Inventory

{file → category → enforced by / composes with}

```
invariants.md        — the 8 catalog predicates (I1–I8) → F1–F5 harnesses
{domain}-{constraint}.md — per-predicate records → task-fixture/
```

## Instance

{date, project, grounding}
