**Tool Morphism** — every tool is a morphism. Declare tool via `// @toolclass` identity. Separate shared objects (lib/) from proprietary objects (tool file). Compose morphisms via LLM or agent chaining. Keep composition graph acyclic.

## Rules

- Declare tool as morphism — every `.opencode/tools/` file declares its role as a morphism via `// @toolclass <CODE>` at line 1.
- Separate object domains — place shared logic in `lib/` modules. Keep proprietary logic in the tool file. Shared objects are dependencies importable across morphisms.
- Compose via LLM chaining — morphisms compose sequentially: tool A output → tool B input. The LLM or agent operator composes by selecting morphisms and feeding outputs to inputs.
- Keep graph acyclic — morphism composition graph must remain acyclic. No morphism may directly or indirectly depend on its own output.

## Applicability

All tools in `.opencode/tools/`.

---
id: SPEC.TOOL.MORPHISM.COMPOSITE
title: Tool Morphism — Category Theory Model for Tool Architecture
source: assembler
summary: "Every tool is a morphism declared via // @toolclass. Shared objects extract to lib/. Morphisms compose via LLM chaining. Composition graph remains acyclic."
specifies: Morphism model for tool composition
tags: [tooling, architecture, category-theory, morphism, composition, convention, specification]
status: active
---
