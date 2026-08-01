---
id: PAT.LLM.CONTENT
title: "LLM Specification — Contract the Shape, Gotcha the Antipattern"
source: NEX.META.CANVAS
summary: "Two strategies shape LLM output — contract (positive instructions, schemas) and gotcha (boundary examples, hard stops). Contract first, gotcha only antipatterns that survive out-of-prompt enforcement. Core rules: 3:1 positive-to-negative ratio, max 2 hard stops per section, max 6 constraints per segment."
morphism: "TRNS — contract the output space with positive instructions and schemas; apply boundary definitions only for genuine hard stops with out-of-prompt enforcement. Positive instructions shape behavior; negations activate the target concept through attention mechanisms. Use declarative register — it reduces cross-lingual instruction variance by 81%. Core rules alone; research-backed patterns in PAT.LLM.SPECIFICATION.ADVANCED."
enforcement: Convention
tags: [llm, prompt-engineering, constraint, specification, reward-hacking, negation, cross-lingual, mechanism, safety]
status: active
priority: 2
---

Two strategies compose: contract the output space, then gotcha the antipatterns.

## Rules

1. **Contract first** — define positive instructions and structural constraints before any boundary rules. Contract: "use positive framing" (shape); Gotcha: "avoid negated verbs" (boundary). Contract: "6 max per segment" (length); Gotcha: "agent constrains itself incorrectly" (edge case).

2. **Apply gotchas only for genuine hard stops** — gotchas define boundaries that survive out-of-prompt enforcement. Each gotcha must have a tool, test, or validator that catches the violation. Gotchas without enforcement leak to in-context pressure — ignore them.

3. **Positive-to-negative ratio floor 3:1** — per instruction, per section, per document. Use `[warn]` and `[error]` pattern matching to measure ratio. If ratio drops below 3:1, convert negative statements to positive: `"not supported"` → `"X: disabled"` declarative form.

4. **Max two hard stops per section** — beyond two hard stops, the section addresses too many antipatterns. Split into sub-sections or convert to positive structure.

5. **Max six constraints per segment** — this is the constraint budget. Beyond six, the LLM ignores trailing constraints. Prioritize: length constraints > format constraints > content constraints.

6. **Use declarative register** — state facts declaratively. Avoid modal hedges (`would`, `could`, `might`, `may`, `perhaps`). Use present tense affirmative statements.

## Enforcement

`mcp-spec-audit` enforces all core rules: positive-to-negative ratio, constraint budget, hard stop limits, declarative register. Run after every instruction file edit.

## Applicability

Apply this pattern when an LLM specification needs a structured output contract, boundary handling, or constraint budget.

## See also

- `PAT.LLM.SPECIFICATION.ADVANCED` — research-backed advanced patterns
- `RUL.LAMBDA.LINGUISTICS` — subject.verb notation, compatible with declarative register
- `RUL.ZERO.COPULA` — zero copula rule, compatible with declarative register
- `RUL.EXPLETIVE.DELETION` — drop dummy subjects, compatible with declarative register
