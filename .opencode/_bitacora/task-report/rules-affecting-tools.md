# Rules Affecting Tool Behavior

Rules in `.opencode/rules/` that influence tool creation, validation, or agent behavior.

## Rules That Enforce Tool Structure

```
workflow-automate-before-fix.md       →  Agent workflow, Create tool before one-off edit
code-function-signature.md            →  Lib modules, All functions must have contract blocks
writing-structural-preference.md      →  All code, Consistent patterns over one-off solutions
workflow-use-local-mcp-servers.md     →  Agent workflow, Prefer local MCP over remote
workflow-project-delegation.md        →  Agent workflow, Read sub-project AGENTS.md before working inside
workflow-query-patlib-context.md      →  Agent workflow, Use patlib_vector_search first — STALE: server disabled
```

## Rules That Reference Disabled Tooling

```
workflow-query-patlib-context.md  →  patlib_vector_search (mcp-patlib-vector) — Server disabled, moved to _disabled/
```

## Rules That Affect Tool LLM Response Format

```
writing-declarative-assertion.md    →  State findings as assertions, not suggestions
writing-positive-framing.md         →  Frame as positive guidance
writing-essential-first.md          →  Lead with essential info
writing-constraint-budget.md        →  Stay under token limit
system-illustration-scope.md        →  Include concrete examples
```

## Boolean Logic Rules (Used by Query Construction)

```
logic-and.md     →  Conjunction in queries
logic-or.md      →  Disjunction in queries
logic-not.md     →  Negation in queries
logic-nor.md     →  NOR logic
logic-nand.md    →  NAND logic
logic-xor.md     →  XOR logic
logic-xnor.md    →  XNOR logic
```

## Linguistic Rules (Agent Communication Style)

```
writing-zero-copula.md              →  Omit linking verbs
writing-gapping.md                  →  Omit repeated verbs
writing-asyndeton.md                →  Omit conjunctions
writing-left-edge-deletion.md       →  Omit left-edge words
writing-expletive-deletion.md       →  Omit expletives
writing-domain-zero-anaphora.md     →  Omit domain-zero references
writing-acronymic-anaphora.md       →  Use acronyms for known entities
writing-resultative-compounding.md  →  Use resultative compounds
writing-dash-pivot.md               →  Dash for pivots
writing-lambda-linguistics.md       →  Lambda notation for conciseness
writing-pseudo-code-notation.md     →  Pseudo-code for logic
```
