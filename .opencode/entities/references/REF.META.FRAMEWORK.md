---
id: REF.META.FRAMEWORK
title: "Entity Framework Classification — Morphism vs Guided Composition"
source: PROT.META.IDENTITY
related: [PROT.TOOL.COMPOSITE, PROT.SKILL.PROFILE, PROT.META.COMPOSITION, PROT.COMMAND.RULE, PROT.PERSON.SCHEMA]
summary: "Every executable entity type belongs to exactly one structural framework. Tools are morphisms (category-theory arrow, composed externally). Skills and commands are guided compositions (document prescribes sequence, executed internally)."
ref: "Every executable entity in the AMANDA ecosystem belongs to exactly one framework class. Tools are morphisms. Skills are guided compositions. Commands are guided compositions. The framework determines composition mechanism, testing strategy, and structural conventions."
tags: [architecture, classification, entity, taxonomy, convention]
---

Every executable entity type in AMANDA belongs to exactly one structural framework. The framework determines how the entity composes, executes, and declares its behavior.

## Protocol

1. **Every executable entity type belongs to exactly one framework** — the framework determines composition mechanism, execution model, and structural conventions.

2. **Tools are morphisms** — each tool is a category-theory arrow (object → object). Morphisms are atomic, declare identity via `// @toolclass`, and compose via external agent chaining. Governed by `PROT.TOOL.COMPOSITE`.

3. **Skills are guided compositions** — each skill prescribes its own execution sequence within the document. Steps, phases, and decision points are defined in order. The executor reads and follows. Governed by `PROT.SKILL.PROFILE` for state profile and the guided composition pattern for structural semantics.

4. **Commands are guided compositions** — each command prescribes a structured workflow within the document. Verb-domain naming convention encodes behavior. The executor reads and follows the prescribed sequence.

5. **Framework determines composition mechanism** — morphisms compose externally via agent chaining (`tool A → tool B`). Guided compositions compose internally via document structure (step 1 → step 2 → step 3). No cross-framework composition within a single execution context.

6. **Framework determines convention set** — morphisms follow tool classification (`PROT.TOOL.AUTOMATON`), morphism identity (`PROT.TOOL.COMPOSITE`), and invocation model (`PROT.TOOL.MODEL`). Guided compositions follow state classification (`PROT.SKILL.PROFILE`) and verb-domain naming (command convention).

## Framework comparison

| Dimension | Morphism | Guided Composition |
|-----------|----------|--------------------|
| Entity types | Tools | Skills, Commands |
| Composition | External (agent chains) | Internal (document prescribes) |
| Identity | `// @toolclass` / `PROT.TOOL.AUTOMATON` | Entity ID in frontmatter |
| State awareness | Automaton class (RECG/TRNS/GENR/SGNL) | State profile (skills) or flags (commands) |
| Test strategy | Unit test per morphism, integration per chain | Validate per step sequence, end-to-end per workflow |
| Governing protocols | `PROT.TOOL.COMPOSITE`, `PROT.TOOL.AUTOMATON` | `PROT.SKILL.PROFILE`, `PROT.COMMAND.RULE`, guided composition pattern |

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Tool structured as guided composition | Tool with embedded step-by-step sequence in comments | Extract steps to a skill or command. Tools are atomic morphisms — one input, one output, no internal sequence |
| Skill structured as morphism | Skill with single atomic action and no sequence | Convert to tool. A skill is a guided composition — must prescribe a sequence of steps |
| Cross-framework import | Morphism imports guided composition (or vice versa) | Extract shared logic to `lib/`. Frameworks compose at the agent level only |
| Entity type assigned to wrong framework | New entity type absent from framework table | Add to protocol or create new framework class |

## Applicability

All executable entity types in the AMANDA ecosystem:

| Entity type | Framework | Since |
|-------------|-----------|-------|
| Tools (`.opencode/tools/*.ts`) | Morphism | v1 |
| Skills (`.opencode/skills/*/SKILL.md`) | Guided composition | v1 |
| Commands (`.opencode/commands/yamls/*.yaml`) | Guided composition | v1 |

Passive data entities (patterns, terms, persons, protocols, abstractions, linguistics) are outside this classification. They have no execution model — data, behavior excluded.

## Enforcement

`read-validate` and `audit-tool` verify framework-appropriate conventions per entity type. Cross-framework violations are flagged as warnings. Framework assignment is by entity type directory — no frontmatter or annotation changes needed.

## See also

- `ILL.META.FRAMEWORK.SORT` — morphism vs guided composition walkthrough
- `PROT.TOOL.COMPOSITE` — category theory morphism model for tools
- `PROT.SKILL.PROFILE` — state classification for skills
- `PROT.META.COMPOSITION` — guided composition pattern
- `PROT.COMMAND.RULE` — command convention protocol
- `PROT.TOOL.AUTOMATON` — automaton class classification
- `CON.TOOLCLASS.AUTOMATON` — automaton class definitions
