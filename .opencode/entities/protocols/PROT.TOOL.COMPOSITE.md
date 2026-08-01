---
id: PROT.TOOL.COMPOSITE
title: "Tool Morphism — Category Theory Model for Tool Architecture"
source: NEX.TOOL.CHOICE
related: [PROT.TOOL.AUTOMATON]
summary: "Every tool is a morphism. Declare tool via // @toolclass identity. Separate shared objects (lib/) from proprietary objects (tool file). Compose morphisms via LLM or Architect chaining. Keep composition graph acyclic."
protocol: "Every tool in .opencode/tools/ declares its role as a morphism via // @toolclass at line 1. Shared object logic extracts to lib/; proprietary logic stays in the tool file. LLM or Architect composes morphisms by sequential chaining. Direct morphism-to-morphism imports excluded. Composition graph remains acyclic."
enforcement: Formality
status: active
priority: 2
tags: [tooling, architecture, category-theory, morphism, composition, identity, convention]
---

Category theory model for the AMANDA tool system. Every tool is a morphism.

## Protocol

1. **Declare tool as morphism** — every `.opencode/tools/` file declares its role as a morphism. The morphism input type and output type follow from the tool's function signature. Use `// @toolclass <CODE>` at line 1 to declare the morphism's behavioral class per `PROT.TOOL.AUTOMATON`.

2. **Separate object domains** — place shared logic in `lib/` modules. Keep proprietary logic in the tool file. Shared objects are dependencies importable across morphisms. Proprietary objects are private to the tool and preserve orthogonality per the orthogonality principle. Import graph follows morphism → object direction (tool imports lib).

3. **Compose via external agent** — chain morphisms using LLM or Architect as the composition operator. Sequential application: tool B receives tool A's output as input. Direct morphism-to-morphism imports are excluded. All composition routes through agent-level orchestration.

4. **Declare identity per morphism** — each tool receives exactly one identity via `// @toolclass <CODE>` at line 1. The identity preserves the morphism's behavioral contract. Multiple annotations per tool excluded. Identity scope follows behavior class per `PROT.TOOL.AUTOMATON`.

5. **Classify identity as shared or individual** — shared identities group morphisms by behavioral class (RECG, TRNS, GENR, SGNL). Individual identities distinguish unique morphisms within the same class. Both identity types use the same `// @toolclass` declaration mechanism.

6. **Maintain acyclic composition graph** — the morphism graph forms a directed acyclic graph. Cycles between tools are excluded. Dependencies flow morphism → object only. Lib modules as objects sit outside the composition graph.

## Gotchas

- Tool imports another tool directly: Extract shared logic to `lib/` — morphisms compose externally, direct imports excluded (Import path targets a `tools/` file)
- lib module imports a tool: `lib/` is the object domain — objects have no morphism awareness. Extract the needed logic into `lib/` instead (Import path from `lib/` targets a `tools/` file)
- Tool with multiple `// @toolclass` annotations: Each morphism has exactly one identity. Remove the duplicate annotation (Line 1 has two RECG/GENR/etc annotations)
- Composition treated as automatic: Composition requires an external agent (LLM or Architect). Tools compose via sequential agent calls; internal imports excluded (Workflow assumes tool A calls tool B internally)
- Proprietary object used across tools: Extract to `lib/` — shared objects belong in lib, proprietary objects stay in the tool file (Private constant or function duplicated in two tool files)

## Enforcement

`audit-tool` verifies: tool-to-tool imports excluded, lib-to-tool imports excluded, exactly one `// @toolclass` annotation per tool present. Diagram composition paths during workflow design to confirm acyclic structure.

## Applicability

All tools in `.opencode/tools/` across root and subproject levels. The morphism model applies to all three tool types: CLI (shebang), Custom IPC, and MCP servers (though MCP servers are morphism containers, each tool registered via `server.tool()` is a sub-morphism).

Excluded for:
- `lib/` modules — they are objects; morphism classification excluded
- `plugins/` — plugins are lifecycle hooks; their registered `tool:` hooks are morphisms
- Configuration files (opencode.json, package.json, AGENTS.md) — describe the category; morphism classification excluded

## See also

- `PROT.TOOL.AUTOMATON` — automaton classes (RECG, TRNS, GENR, SGNL) serve as identity types
- `REF.LIB.DIRECTORY.LAYER` — lib as shared object domain; tools import from lib
- `MAX.CODE.ORTHOGONALITY.PRINCIPLE` — one thing per tool; morphisms are independent, compose externally
- `REF.LIB.DEPENDENCY.DIRECTION` — unidirectional dependency; morphism depends on object (tool depends on lib)
- `PROT.LIB.CONTRACT` — lib modules declare exports and purity; object contract for morphism consumers
- `REF.META.PROJECT.TOPOLOGY` — unidirectional, modular, non-linear system; morphism model formalizes modularity
