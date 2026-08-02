---
id: PROT.LLM.SPECIFICATION
title: "LLM Specification — Instruction Contract for LLM-Facing Documents"
source: assembler
related: [PROT.SKILL.SCHEMA, PROT.RULE.SCHEMA]
summary: "LLM-facing instruction blocks follow a declarative, positive-framed register with structured output shapes and bounded constraint counts."
protocol: "Instruction blocks state the desired action in declarative register. Positive framing leads; prohibitions carry no weight. Output shape specifies keys and limits positively. Simultaneous constraints stay within 5-6 per block. Positive-to-negative instruction ratio holds at 3:1 minimum."
enforcement: Review
status: active
priority: 2
tags: [llm, specification, instruction, register, constraint, positive-framing]
---

LLM-facing documents — rules, protocols, skill instructions — carry one contract: state what to do, declare the shape, bound the load. The instruction block governs how the agent reads requirements.

## Protocol

1. **Declarative register carries instructions** — facts and required states read as declarations. Imperative forms carry no instruction weight.
2. **Positive framing leads** — each directive names the desired action first. The actionable path opens the response.
3. **Output shape specifies positively** — required keys and response bounds appear as explicit declarations.
4. **Constraint count bounds at 5-6 per block** — simultaneous requirements stay within the saturation threshold.
5. **Positive-to-negative ratio holds at 3:1 minimum** — negative constructions stay under 40% of the block.
6. **Desired state names the rule** — prohibitions phrase as the state that holds: "X: disabled" over "do not use X".

## Gotchas

- Hard stop without redirect: pair every exclusion with the positive action that replaces it.
- Imperative prohibition list: convert to declarative state declarations.
- Output shape in prose: declare the exact keys, counts, and limits.
- Constraint pile-up: split into ≤5-6 per block or sequence the requirements.
- Negative-dominant block: raise the positive count to hold the 3:1 ratio.

## Enforcement

Review — the `validate-spec` skill and `mcp-spec-audit` check instruction files against this contract. Violations surface as framing, ratio, or register findings.

## Applicability

Applies to every LLM-facing instruction artifact — rules, protocols, skills, command steps, agent instructions. Excluded: user-facing prose outside instruction context, and internal notation registers.

## See also

- `PROT.RULE.SCHEMA` — rule entity structure
- `PROT.SKILL.SCHEMA` — skill document structure
- `RUL.WRITING.POSITIVE.FRAMING`, `RUL.WRITING.DECLARATIVE.OVER.IMPERATIVE` — composing conventions
