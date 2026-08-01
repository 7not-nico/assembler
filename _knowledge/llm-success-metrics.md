# LLM Success Metrics

## 1. Constraint & Prompt Composition Metrics

**Constraint Saturation Ceiling (k≤5–6):** Constraint count >5–6 decays accuracy exponentially. k=1 accuracy → ~58%. k=12 accuracy → asymptotic ~16% floor.

**Positive-to-Negative Instruction Ratio (3:1):** Prompt requires ≥3:1 positive:negative ratio. Negative proportion >40% triggers instruction-breakdown. Proportion >60% → static generation loops.

**Bridge Constraint Conflict Reduction (39%):** Bridge constraint introduction reconciles competing requirements through structured formatting or auxiliary directives. Result reduces constraint-violations 39%. Model retraining unnecessary.

## 2. Gotcha & Negative Constraint Risk Metrics

**Behavioral Priming Failure Rate (87.5%):** Soft negative constraints ("don't be verbose") fail 87.5% from semantic priming. Forbidden concept naming activates its token representation in context.

**Late-Layer FFN Override Contribution (12.5%):** Remaining 12.5% gotcha failures → late-layer FFNs (layers 23–27) drive. Mechanism generates +0.39 boost toward forbidden tokens. Suppression signals measure 4.4× weaker in failures vs successes.

**Prohibition Backfire Rate (+30–300% Vulnerability):** Prohibition framing ("NEVER use X") increases vulnerability or failure rate. Condition: user prompt names target term. Effect: Claude Sonnet 4 vulnerability doubles 20% → 50%.

## 3. Cross-Lingual & Structural Register Metrics

**Cross-Linguistic Variance Reduction (81%, p=0.029):** Imperative command conversion ("NEVER do X") → declarative S-A-O state statement ("System: X disabled"). Result reduces cross-linguistic compliance variance 81%.

**Semantic Bottleneck Safety Alignment (ASR: 24.7%→2.8%):** Safety or constraint anchoring at language-agnostic semantic bottleneck layer drops average Attack Success Rate (ASR) 24.7% → 2.8% across multilingual evaluations.

## 4. Syntactic & Mechanistic Priority Metrics

**Agreement Circuit Unit Overlap:** LLM hidden representations recruit shared, overlapping functional units for syntactic agreement:
- Determiner-Noun Agreement: 68.91% unit overlap — highest weight
- Subject-Verb Agreement: 40.29% unit overlap
- Anaphor Agreement: 23.10% unit overlap

**Semantic Role Compactness (89–92% in 28 Nodes):** Predicate-argument circuits concentrate 89–92% of attribution within 28 neural nodes.

**Definitional Processing Weight (31%):** Adjective modifiers (differentia_quality) account for 31% of high-impact definitional processing states in Definitional Semantic Role Analysis (DSRA).

**Animacy Feature Heads (22 Heads):** Animacy features causally drive structural choices (active vs passive). 22 dedicated attention heads mediate.

## Summary Table

| Domain | Metric | Threshold | Effect |
|--------|--------|-----------|--------|
| Capacity | Simultaneous Constraints | ≤5–6 rules | Prevents two-regime decay floor (~16%) |
| Ratio | Positive:Negative Framing | ≥3:1 | Prevents negative instruction cascade |
| Register | Imperative vs Declarative | Declarative (S-A-O) | 81% variance-reduction cross-lingual |
| Mechanics | Early Layer Alignment | Layers 1–7 (Nouns/Verbs) | 40–68% shared agreement circuit hooks |
| Gotcha Risk | Priming Avoidance | 0 forbidden tokens named | Prevents 87.5% semantic gravity well failures |
