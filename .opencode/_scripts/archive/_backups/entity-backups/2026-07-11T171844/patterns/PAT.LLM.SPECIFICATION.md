---
id: PAT.LLM.SPECIFICATION
title: LLM Specification — Contract the Shape, Gotcha the Antipattern
source: INV.LLM.SPEC.CONTRACT
summary: "Two complementary strategies for constraining LLM output — contraction (positive instructions, schemas, scope narrowing) and gotcha (negative constraints, hard stops, antipattern enumeration). Contract the shape first, then gotcha only antipatterns that survive out-of-prompt enforcement. Mechanistic, cross-lingual, and production evidence from 60+ studies across 100+ regions — see INV.LLM.SPEC.CONTRACT."
principle: Contract the output space with positive instructions and schemas; gotcha only genuine hard stops paired with out-of-prompt enforcement; use negative constraints only for hard stops — positive instructions shape behavior; negatives prime the forbidden concept via attention mechanism in late-layer processing. Imperative register fails cross-lingually. No universal constraint mechanism exists — different types processed at different neural depths. See meta-audit for evidence studies.
enforcement: Convention
tags: [llm, prompt-engineering, constraint, specification, reward-hacking, negation, cross-lingual, mechanism, safety]
patterns: []
terms: []
status: active
priority: 2
---

**LLM Specification** — two strategies compose: contract the output space, then gotcha the antipatterns.

## Rules

- Reframe every behavioral constraint as a positive instruction — tell the model what TO do instead of what to avoid
- Keep negative constraints only for hard stops — binary prohibitions with real consequences for violation
- Lead with positive instructions; place negatives at end of prompt section
- Maintain minimum 3:1 ratio of positive instructions to negative constraints
- Pair every hard stop with a positive redirect — what the model should do instead
- Ablate every added constraint — add nothing without measuring whether it helps. Remove what doesn't
- Move enforcement out of the prompt when the constraint is deterministically checkable
- For behavioral shaping, prefer schema/structured-output enforcement over prose instruction
- When a negative constraint is unavoidable, describe the prohibited region without naming the target — specify the boundary, let the model infer the content
- Prefer declarative register over imperative — "X: disabled" over "NEVER use X"
- Use bridge constraints to reconcile conflicting requirements — add auxiliary positive instructions that make primary constraints compatible
- Prefer structural constraints (length, format, keyword) over semantic constraints (tone, style) — structural constraints are processed in early layers and degrade more gracefully under load
- When constraints must compose, keep the total under 5-6 simultaneous — beyond this, independent failure accumulation causes exponential decay rather than pairwise conflict
- For reasoning models (CoT, RL-optimized), halve the constraint budget — reasoning capacity trades off with controllability

### Operator-specific sub-rules

- **Declarative semantic phrasing is the default register** — "X: required", "apply all constraints", "Y is disabled". Use simple structured NL, not raw operators, as the baseline across all models and languages. Declarative register reduces cross-lingual instruction variance by 81% (Mason 2026)
- **Never use conjunction (∩, &&, AND) for multi-constraint composition** — models do not reliably interpret ∩ as "apply both constraints." Fidelity is 0-21% across all tested models. Use declarative listing instead (MetaGlyph 2026)
- **Negation (NOT, !, ¬) is the most fragile operator** — 87.5% of negation failures are caused by priming: naming the forbidden word activates rather than suppresses it. The suppression signal is 4.4× weaker in failures. Use "X: disabled" or "X: excluded" instead (Semantic Gravity Wells 2026)
- **XOR is structurally unreliable** — correct reasoning chains produce wrong declared answers across all tested models at depth 7. Requires minimum 2 attention heads to compute. Models default to inclusive OR ~30% of the time (Rao 2026; LessWrong)
- **Implication (⇒) is model-specific** — 98.1% fidelity on Kimi K2, 0% on all other tested models. Only use if empirically validated on your target model (MetaGlyph 2026)
- **Membership (∈) works only on frontier models** — GPT-5.2: 91.3%; mid-sized instruction-tuned models (7-12B): 0%. Limit to simple selection tasks. Always test on target model before deployment (MetaGlyph 2026)
- **Logical connectives (therefore, however, but) are high-entropy fragility points** — single connective change derails 41% of correct reasoning chains, 1.75× more destructive than non-connective high-entropy tokens. Connectives constitute only 4-7% of generated tokens but control trajectory (Park & Lei 2026)
- **Operators and semantic constraints use different neural depths and compete** — structural constraints (operators) are processed in early layers; semantic constraints in late layers. No universal constraint-checking mechanism exists. Cross-task transfer is weak. Constraint satisfaction is dynamic monitoring during generation, not pre-generation planning (Rocchetti & Ferrara 2026)
- **Token reduction is the only proven benefit of operators** — compact constraint encoding shows no statistically significant improvement in constraint satisfaction rate. Effect size Cliff's δ < 0.01. The 71% token reduction is real but must be weighed against reliability costs (Tang 2026)
- **Hybrid (operators + NL) beats either alone** — compositional steering tokens plus natural language instructions achieves 62.9% accuracy vs 57.4% instructions-only on 3-behavior compositions. SoftPrompt-IR symbolic operators achieve 98% cross-model consensus on frontier models but 75-92% token reduction must be validated per deployment (ACL 2026 Steering Tokens; SoftPrompt-IR 2026)
- **Prefer pseudo-code (IF/ELSE) over raw notation** — conditional logic expressed as IF/ELSE yields +36% accuracy and -87% tokens in production prompts. Works across frontier models but test on target (Kryvolapov 2026)
- **Cross-lingual operator validation required** — imperative operators that work in English may compete in Spanish, flatten in French, and partially preserve in Mandarin. Test all operator instructions in every target language. Declarative register is the only reliably cross-lingual form (Mason 2026)
- **Operators fail under semantic override** — models revert to pretrained operator defaults despite explicit local redefinition. Even simple boolean gates fail when semantics are locally overridden. Always use out-of-prompt enforcement for critical operator constraints (Thota et al. 2026)
- **Models lack robust operator grounding** — they oscillate between structural reasoning and surface pattern matching with inconsistent handling of quantifiers and negation. Operator-level errors mediate approximately 40% of effects on downstream reasoning (Jiang et al., ACL 2026)

## Applicability

Any system prompt, agent configuration, or LLM instruction set where output must be constrained — agent definitions, tool descriptions, skill prompts, CLAUDE.md, AGENTS.md, API system prompts.

## See also

- RUL.ZERO.COPULA — related linguistic compression pattern
- RUL.DASH.PIVOT — related instruction-pattern convention
- Rocchetti & Ferrara (2026) — mechanistic evidence: constraint types at different neural depths
- CRGC — bridge constraints reconcile conflicts, reduce violations by 39%
- CSE — Constraint Saturation Evaluation: exponential decay beyond 5-6 constraints
