---
id: PAT.LLM.SPECIFICATION
title: LLM Specification — Contract the Shape, Gotcha the Antipattern
source: INV.LLM.SPEC.CONTRACT
summary: "Two complementary strategies for constraining LLM output — contraction (positive instructions, schemas, scope narrowing) and gotcha (negative constraints, hard stops, antipattern enumeration). Contract the shape first, then gotcha only antipatterns that survive out-of-prompt enforcement. Mechanistic, cross-lingual, and production evidence from 60+ studies across 100+ regions — see INV.LLM.SPEC.CONTRACT."
principle: Contract the output space with positive instructions and schemas; gotcha only genuine hard stops paired with out-of-prompt enforcement; never use negative constraints for behavioral shaping — they prime the forbidden concept via attention mechanism in late-layer processing. Imperative register fails cross-lingually. No universal constraint mechanism exists — different types processed at different neural depths. See meta-audit for evidence studies.
enforcement: Convention
tags: [llm, prompt-engineering, constraint, specification, reward-hacking, negation, cross-lingual, mechanism, safety]
status: active
priority: 2
---

**LLM Specification** — two strategies compose: contract the output space, then gotcha the antipatterns.

## Rules

- Reframe every behavioral constraint as a positive instruction — tell the model what TO do, not what NOT to do
- Keep negative constraints only for hard stops — binary prohibitions with real consequences for violation
- Lead with positive instructions; place negatives at end of prompt section
- Maintain minimum 3:1 ratio of positive instructions to negative constraints
- Pair every hard stop with a positive redirect — what the model should do instead
- Ablate every added constraint — add nothing without measuring whether it helps. Remove what doesn't
- Move enforcement out of the prompt when the constraint is deterministically checkable
- For behavioral shaping, prefer schema/structured-output enforcement over prose instruction
- When a negative constraint is unavoidable, describe the prohibited region without naming the target — specify the boundary, not the content
- Prefer declarative register over imperative — "X: disabled" over "NEVER use X"
- Use bridge constraints to reconcile conflicting requirements — add auxiliary positive instructions that make primary constraints compatible
- Prefer structural constraints (length, format, keyword) over semantic constraints (tone, style) — structural constraints are processed in early layers and degrade more gracefully under load
- When constraints must compose, keep the total under 5-6 simultaneous — beyond this, independent failure accumulation causes exponential decay rather than pairwise conflict
- For reasoning models (CoT, RL-optimized), halve the constraint budget — reasoning capacity trades off with controllability

## Applicability

Any system prompt, agent configuration, or LLM instruction set where output must be constrained — agent definitions, tool descriptions, skill prompts, CLAUDE.md, AGENTS.md, API system prompts.

## See also

- RUL.ZERO.COPULA — related linguistic compression pattern
- RUL.DASH.PIVOT — related instruction-pattern convention
- Rocchetti & Ferrara (2026) — mechanistic evidence: constraint types at different neural depths
- CRGC — bridge constraints reconcile conflicts, reduce violations by 39%
- CSE — Constraint Saturation Evaluation: exponential decay beyond 5-6 constraints
