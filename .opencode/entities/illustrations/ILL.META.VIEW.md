---
id: ILL.META.VIEW
title: "Category View Walkthrough — Objects, Morphisms, and Composition in the Assembler"
source: PROT.META.IDENTITY
summary: "Walk through the assembler as a concrete category: trace a read command as an object, the read-projection tool as a morphism, patlib_search as composition, and AGENTS.md as identity declaration."
illustration: "An agent traces category-theoretic roles in the assembler — read-projection (morphism) acts on patlib entities (object), identity declared via id: frontmatter, composition chains tools via LLM as operator"
illustrates: [PROT.META.CATEGORY.VIEW]
tags: architecture,category-theory,morphism,composition,walkthrough
related: [REF.META.PROJECT.TOPOLOGY, PROT.TOOL.COMPOSITE, REF.META.DOMAIN.DIRECTORY]
---
## Rationale

The assembler forms a concrete category. Every directory, project, and file that holds entities is an object. Every tool that transforms or accesses these objects is a morphism. The LLM or human operator composes morphisms by chaining tool calls.

## Walkthrough

### Step 1: Object — a pattern file

`PAT.META.CATEGORY.VIEW.md` at `.opencode/patterns/` is an object in the category:

```
Location: .opencode/patterns/PAT.META.CATEGORY.VIEW.md
Type: Pattern (entity type determined by first ID segment PAT)
Role: Theorem — proven structure within the laws
Identity: id: PROT.META.CATEGORY.VIEW in frontmatter
```

The file is a container entity — it holds frontmatter metadata and body content. As an object, it occupies a position in the entity hierarchy: `patterns/` directory (domain) → `PROT.META.CATEGORY.VIEW` (entity).

### Step 2: Identity — frontmatter id

Every object declares self-reference via `id:` or `AGENTS.md`:

```yaml
id: PROT.META.CATEGORY.VIEW
```

The identity arrow `id_A` maps the object back to itself — the entity named `PROT.META.CATEGORY.VIEW` refers to exactly one file. No second entity shares this ID. Identity is structural: absence of `id:` is a gap.

### Step 3: Morphism — a query tool

`read-projection` is a morphism. It accepts an entity ID and returns its full content:

```
read-projection --type patterns --id PROT.META.CATEGORY.VIEW
```

Codomain: string (rendered markdown with frontmatter + body).
Domain: string (entity ID string).

The morphism arrow: `entity_id → rendered_content`.

### Step 4: Composition — chaining tools

The LLM composes morphisms by chaining tool calls:

```
patlib_search --type patterns --query "category theory"
  → returns PROT.META.CATEGORY.VIEW (0.68)
read-projection --type patterns --id PROT.META.CATEGORY.VIEW
  → returns full content
```

Arrow composition: `patlib_search ∘ read-projection`. The search tool returns an entity ID; the projection tool consumes that ID and returns content. The LLM bridges the two — human or LLM chooses which morphisms chain and in what order per rule 2.

### Step 5: Rules as laws

Category theory rules constrain how morphisms compose:

| Rule | Category analog | Assembler instance |
|------|----------------|--------------------|
| Morphisms compose externally | Arrow composition through operator | LLM chains `patlib_search → read-projection` |
| Objects are containers | Object holds entities | `.opencode/patterns/` contains `.md` files |
| Identity declared | Self-reference | `id:` frontmatter, `AGENTS.md` |
| Patlib is internal hom | Queryable index | `patlib.db` maps entity IDs to files |
| Composition acyclic | DAG constraint | `morphism → object` imports; tool-to-tool excluded |

## Key insight

The assembler IS a category (just like a concrete category). Every structural convention (entity ID, tool invocation, filesystem layout) maps to a categorical role. The mapping converts architecture questions to category-theory questions: Does every object have identity? Do morphisms compose? Is the graph acyclic? The category view provides a formal vocabulary for reasoning about the assembler's composition model.

## See also

- `PROT.META.CATEGORY.VIEW` — the category view this walkthrough illustrates
- `REF.META.PROJECT.TOPOLOGY` — unidirectional, modular, non-linear architecture
- `PROT.TOOL.COMPOSITE` — tool as morphism declaration
- `PROT.TOOL.AUTOMATON` — automaton classes as morphism types
- `REF.META.DOMAIN.DIRECTORY` — domain containers as objects
