---
id: ILL.META.TOPOLOGY
title: "Assembler Topology — Multi-Project Tool Composition Walkthrough"
source: PROT.META.IDENTITY
summary: "Walkthrough of the assembler's four properties (metadata-first, unidirectional, modular, non-linear) through a concrete research-and-sync session across two subprojects."
illustration: "A session across two subprojects demonstrates all four topology properties — each project owns its own DB and tools; the LLM composes read and write calls in session order with no fixed pipeline."
illustrates: [REF.META.PROJECT.TOPOLOGY]
tags: architecture,walkthrough,topology,composition,multi-project
related: [REF.META.DOMAIN.DIRECTORY, PROT.META.CATEGORY.VIEW, PROT.TOOL.SCOPE]
---
## Rationale

Two subprojects exist under `assembler/`. Each owns its own database, tools, and MCP servers. The LLM needs to look up a game in ludoteca, then write a note about it in category-theory.

## Directory layout

```
assembler/
  category-theory/
    .opencode/
      tools/read-selection.ts, tools/write-sync.ts
      lib/db.ts
    category-theory.db
    AGENTS.md
  ludoteca/
    .opencode/
      tools/read-game.ts
      lib/db.ts
    ludoteca.db
    AGENTS.md
```

Each project has its own `tools/` directory, its own `lib/db.ts`, and its own `.db` file. No project imports from another project's tools directory.

## Walkthrough

1. The LLM queries ludoteca for game data by calling `ludoteca/.opencode/tools/read-game.ts` — a read-only tool that opens `ludoteca.db` and returns matching rows.

2. The LLM formats the result and calls `category-theory/.opencode/tools/write-sync.ts` — a write-only tool that opens `category-theory.db` and inserts a note referencing the game.

3. The LLM calls `category-theory/.opencode/tools/read-selection.ts` to confirm the note was written.

## How each property manifests

| Property | In this session |
|----------|----------------|
| Metadata-first | Each tool carries `id:`, `source:`, `tags:` in its file; no external registry needed |
| Unidirectional | `read-game.ts` reads only; `write-sync.ts` writes only. No tool does both |
| Modular | Two independent `.db` files, independent `tools/`, no shared state beyond patlib.db (read-only) |
| Non-linear | The LLM chose the sequence: read → write → read. No fixed pipeline between tools |

## Key insight

The topology properties are invisible in a single-tool call. They emerge when composing across projects — the LLM reads from one project, writes to another, and reads again. Each call is independent. The sequence exists only in the session.

## See also

- `REF.META.PROJECT.TOPOLOGY` — the four properties this illustrates
- `PROT.META.CATEGORY.VIEW` — categorical mapping of objects and morphisms
- `REF.META.DOMAIN.DIRECTORY` — how subprojects emerge as containers
- `PROT.TOOL.SCOPE` — tools scoped by project directory
