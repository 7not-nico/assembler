---
id: PROT.META.LLM.SPECIFICATION
title: LLM Specification — Contract the Shape, Gotcha the Antipattern
source: INV.LLM.SPEC.CONTRACT
summary: "Two complementary strategies for shaping LLM output — contraction (positive instructions, schemas, scope narrowing) and gotcha (boundary examples, hard stops). Contract the shape first, then gotcha only antipatterns that survive out-of-prompt enforcement. Core rules: positive-to-negative ratio floor 3:1, max hard stops per section 2, max constraints per segment 6. Research-backed advanced patterns in PROT.META.LLM.ADVANCED."
protocol: "Contract the output space with positive instructions and schemas; apply boundary definitions only for genuine hard stops with out-of-prompt enforcement. Positive instructions shape behavior; negations activate the target concept through attention mechanisms. Use declarative register — it reduces cross-lingual instruction variance by 81%. Core rules alone; research-backed patterns in PROT.META.LLM.ADVANCED."
enforcement: Convention
tags: [llm, prompt-engineering, constraint, specification, reward-hacking, negation, cross-lingual, mechanism, safety]
status: active
priority: 2
---

Two strategies compose: contract the output space, then gotcha the antipatterns.

## Core principles

- Reframe every behavioral constraint as a positive instruction — tell the model what TO do instead of what to avoid
- Keep negative constraints only for hard stops — binary prohibitions with real consequences for violation
- Lead with positive instructions; place negatives at end of prompt section
- Maintain minimum 3:1 ratio of positive instructions to negative constraints
- Pair every hard stop with a positive redirect — what the model should do instead
- Ablate every added constraint — measure whether it helps before keeping it

## Structural guidelines

- Move enforcement out of the prompt when the constraint is deterministically checkable
- For behavioral shaping, prefer schema/structured-output enforcement over prose instruction
- When a negative constraint is unavoidable, describe the prohibited region without naming the target — specify the boundary, let the model infer the content
- Prefer declarative register over imperative use — "X: excluded" serves as the default form
- Use bridge constraints to reconcile conflicting requirements — add auxiliary positive instructions that make primary constraints compatible
- Prefer structural constraints (length, format, keyword) over semantic constraints (tone, style) — structural constraints are processed in early layers and degrade more gracefully under load
- When constraints must compose, keep the total under 5-6 simultaneous — beyond this, independent failure accumulation causes exponential decay rather than pairwise conflict
- For reasoning models (CoT, RL-optimized), halve the constraint budget — reasoning capacity trades off with controllability

### Register and operator guidance

- **Declarative semantic phrasing is the default register** — "X: required", "apply all constraints", "Y: excluded". Use simple structured NL over raw operators. Declarative register reduces cross-lingual instruction variance by 81% (Mason 2026)
- **Conjunction composition**: use declarative listing for reliable multi-constraint composition. Conjunction operators show 0-21% fidelity (MetaGlyph 2026)
- **Negation**: apply "X: excluded" using declarative register. Negation operators activate the target concept through attention priming — 87.5% of negation failures originate from this mechanism. The suppression signal is 4.4× weaker in failures (Semantic Gravity Wells 2026)
- **Exclusive-or**: replace with explicit IF/ELSE or declarative listing. This operator requires minimum 2 attention heads to compute. Models default to inclusive OR approximately 30% of the time (Rao 2026; LessWrong)
- **Implication**: validate on target model before deployment. Implication achieves 98.1% fidelity on Kimi K2; 0% on all other tested models (MetaGlyph 2026)
- **Membership**: limit to simple selection tasks on frontier models. GPT-5.2 achieves 91.3%; mid-sized instruction-tuned models (7-12B) achieve 0% (MetaGlyph 2026)

## Applicability

Any system prompt, agent configuration, or LLM instruction set where output must be constrained — agent definitions, tool descriptions, skill prompts, CLAUDE.md, AGENTS.md, API system prompts.

## See also

- `PROT.META.LLM.ADVANCED` — research-backed advanced patterns: operator grounding, hybrid steering, cross-lingual validation
- `RUL.ZERO.COPULA` — related linguistic compression pattern
- `RUL.DASH.PIVOT` — related instruction-pattern convention
