# agentskills.io criteria for skill creation

## Add what the agent lacks, omit what it knows

Focus on what the agent *wouldn't* know without your skill: project-specific conventions, domain-specific procedures, non-obvious edge cases, and the particular tools or APIs to use. Don't explain general concepts.

## Design coherent units

Encapsulate a coherent unit of work that composes well with other skills. Skills scoped too narrowly force multiple skills to load for a single task. Skills scoped too broadly become hard to activate precisely.

## Aim for moderate detail

Concise, stepwise guidance with a working example tends to outperform exhaustive documentation. When you find yourself covering every edge case, consider whether most are better handled by the agent's own judgment.

## Progressive disclosure

Keep `SKILL.md` under 500 lines and 5,000 tokens — just the core instructions the agent needs on every run. Move detailed reference material to separate files in `references/` or similar directories. Tell the agent *when* to load each file.

## Favor procedures over declarations

Teach the agent *how to approach* a class of problems, not *what to produce* for a specific instance. The approach should generalize even when individual details are specific.

## Provide defaults, not menus

When multiple tools or approaches could work, pick a default and mention alternatives briefly rather than presenting them as equal options.

## Gotchas sections

The highest-value content in many skills is a list of gotchas — environment-specific facts that defy reasonable assumptions. These aren't general advice but concrete corrections to mistakes the agent will make without being told otherwise.

## Calibrating control

Match the specificity of your instructions to the fragility of the task. Give the agent freedom when multiple approaches are valid. Be prescriptive when operations are fragile, consistency matters, or a specific sequence must be followed.

## Validation loops

Instruct the agent to validate its own work before moving on. The pattern is: do the work, run a validator, fix any issues, and repeat until validation passes.

## Plan-validate-execute

For batch or destructive operations, have the agent create an intermediate plan in a structured format, validate it against a source of truth, and only then execute.

## Bundling reusable scripts

If the agent independently reinvents the same logic each run, that's a signal to write a tested script once and bundle it in `scripts/`.
