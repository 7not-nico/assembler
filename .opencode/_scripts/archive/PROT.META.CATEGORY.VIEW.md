---
id: PROT.META.CATEGORY.VIEW
title: "Category Theoretic View of the Assembler"
source: PROT.META.IDENTITY
related: [PROT.META.PROJECT.TOPOLOGY, PROT.META.DOMAIN.DIRECTORY]
summary: "The assembler is a concrete category: directory structures and projects are objects, IPC tools are morphisms, identity is self-reference (id: frontmatter, AGENTS.md), and the LLM plus user are the composition operator."
protocol: "The assembler forms a concrete category where objects represent containers (directories, projects, files), morphisms represent arrows between them (IPC tools, imports, references), and composition is external — performed by the LLM or human operator."
enforcement: Convention
tags: [architecture, category-theory, composition, morphism, meta]
archived: "Category theory framing of the assembler — intellectual model, not actionable as process or reference"
priority: 2
---

The assembler **is** a concrete category:

- **Objects** — domain containers (directories, projects, files, modules)
- **Morphisms** — IPC tools (read/write arrows between objects), file references, imports (`_lib/`)
- **Identity** — self-reference: `id:` metadata, `AGENTS.md` on itself
- **Composition** — the LLM + user choose which morphisms chain and in what order

Entity hierarchy within the category:

| Entity | Category role |
|--------|---------------|
| Tools (IPC) | Atomic morphisms — primary arrows |
| Imports, references | Cross-object morphisms |
| Extraction (decoupling) | Object-creation morphism |
| Skills | Composite morphisms — named chains `f ∘ g ∘ h` |
| Commands | Diagram schemas — prescribed paths user walks |
| Rules | Laws — constrain how morphisms compose |
| Patterns | Theorems — proven structures within the laws |
| Terms | Objects of discourse — named entities |
| Patlib | Internal hom — queryable index of available arrows and relations |

Patlib enables intelligent composition. LLM reads patlib → selects relevant patterns → composes tools → produces output.

## Rules

1. **Category membership is structural** — every tool, skill, command, rule, pattern, and term fills exactly one categorical role. An entity's type determines its role; role ambiguity indicates misclassification.

2. **Morphisms compose externally** — arrow composition proceeds through the LLM or human operator. Direct morphism-to-morphism imports excluded. Composition graph remains acyclic.

3. **Objects are containers** — every directory, project, and file that holds entities is an object in the category. Flat files without entities (config files, lock files) are outside the category.

4. **Identity is declared** — every object declares self-reference via `id:` frontmatter or `AGENTS.md`. Absence of identity is a structural gap.

5. **Patlib is the internal hom** — `patlib.db` provides the queryable index of available arrows (tools), theorems (patterns), and objects of discourse (terms).

## Applicability

Any AMANDA project or tool system where category theory provides precise semantics for composition, identity, and object relationships. Use when reasoning about tool chains, entity classification, or the assembly pipeline.

## See also

- `ILL.META.CATEGORY.VIEW` — category view walkthrough — objects, morphisms, composition
- `PROT.META.PROJECT.TOPOLOGY` — unidirectional, modular, non-linear architecture; category theory expressed through project structure
- `PROT.META.DOMAIN.DIRECTORY` — domain containers as objects; extraction morphism between objects
- `PROT.TOOL.COMPOSITE` — tool as morphism: declaration, object separation, composition, identity
- `PROT.TOOL.AUTOMATON` — automaton classes (RECG, TRNS, GENR, SGNL) as morphism types
- `PROT.TOOL.MODEL` — tool invocation as arrow domain/codomain resolution
