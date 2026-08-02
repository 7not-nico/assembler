---
name: reason-quantitative
description: Use this skill when performing QR-based analysis — it encodes situations into quantitative structure, models relationships, reasons, and communicates results
state-profile: hybrid
nexus: NEX.META.CANVAS
---
**Procedure**

1. **Scope quantities** — identify measurable variables in the situation. Ask: what can be counted, measured, compared, or expressed numerically? List each quantity with its unit and range.

2. **Model relationships** — encode connections between quantities. Express as equations, inequalities, ratios, proportions, rates, or logical constraints. Use pseudo-code notation (→ for relationships, :: for types).

3. **Reason from structure** — apply mathematical and logical rules to the model. What does the structure imply? Solve, derive, or simulate. Document assumptions and their effect on conclusions.

4. **Check against context** — does the quantitative result make sense in the original situation? Boundary check: test extreme values, verify units, assess precision against decision requirements.

5. **Communicate** — present quantities, model, reasoning chain, and conclusion. Use structured format (table, key-value pairs). State confidence and remaining assumptions.

**Gotchas**

- Scope too many quantities — limit to 5-7 core variables per analysis pass; more causes model drift and analytic paralysis
- Build model before calculating. Jumping to calculation without encoding produces numerically correct results that mismatch context
- Implicit units or ranges — every variable must have an explicit unit and plausible range before modeling begins
- Overprecision — match output precision to input measurement precision. Report at input precision level — 3 significant figures from 1-significant-figure input excluded
- Calculating before encoding — complete Step 2 (model) before Step 3 (reason); reordering breaks the reasoning chain
- Single-variable quantity list — scope 2+ entries; one variable can't form a relationship structure
- Orphan quantities in relationships — reference only variables from the scoped quantity list
- Precision omitted from the communicate step — state significant figures or a confidence interval explicitly
