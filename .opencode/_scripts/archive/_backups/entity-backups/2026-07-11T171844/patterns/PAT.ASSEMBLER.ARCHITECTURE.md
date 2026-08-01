---
id: PAT.ASSEMBLER.ARCHITECTURE
title: Assembler Architecture — Unidirectional, Modular, Non-Linear
source: assembler
summary: The assembler is a unidirectional, modular, non-linear system — tools serve one direction each, projects are self-contained, and control flow is ad-hoc via the LLM, not a fixed pipeline.
principle: Tools do one thing — read or write, one direction per tool. Projects own their own DB and tools. Tools call no other tools. The LLM composes them.
enforcement: Convention
tags: [architecture, design, opencode, convention, unidirectional, modular, non-linear]
patterns: [PAT.TOOL.PROJECT.SCOPE, PAT.PLUGIN.IPC.TOOL, PAT.ORTHOGONALITY, PAT.MUTATION.PATTERN]
terms: []
status: active
priority: 2
---

The assembler is not a monolith, a pipeline, or a framework. It is four properties.

### Metadata-first

Every entity carries its own metadata inline. A tool's classification lives in its source file (`// @toolclass TRNS`). A definition's properties live in its frontmatter (`id:`, `chapter:`, `statement:`). An impression's metadata lives in its backmatter (`---` block). No external registry, no second DB. The file IS the authoritative record. Any database (e.g., `patlib.db`) is a derived cache, not the source of truth.

- **Tools**: `// @toolclass <CODE>` at line 1 of `.opencode/tools/*.ts`
- **Entities**: YAML frontmatter in `.md` files
- **Impressions**: YAML backmatter in `.md` files
- **Manifests**: Generated from annotations, not hand-maintained

### Unidirectional

Every IPC tool is a reader or a writer — not both. A `write-sync` writes to its project's DB. A `read-selection` reads from it. Tools serve one direction.

Composition happens at the LLM level: the agent calls the writer, then the reader, in whichever order the task requires. Tools do not import or call each other — if two actions are needed, the LLM makes two tool calls.

### Modular

Every project under `assembler/` is independent. It owns:

- Its own `bun:sqlite` database
- Its own `.opencode/tools/` (discovered by directory, not registered globally)
- Its own `AGENTS.md` defining workflow

No runtime cross-project imports. No shared state. The only cross-project reference point is `patlib.db` (patterns/terms/skills) — which is read-only for all projects. A project does not depend on another project's database or tools.

### Non-Linear

Tool execution has no fixed order, pipeline, DAG, or event chain. Each tool is a standalone entry point. The LLM decides which tool to call and when, based on the current task. There is no implicit control flow between `.opencode/tools/` files — the only sequence is the one the agent constructs in that session.

### Connection to category theory

The architecture mirrors the definition of a category (DEF.CAT) from Simmons Ch1 (CHAP.CH1): **projects** are objects, **IPC tools** are morphisms (unidirectional, domain→codomain), and the **LLM** is the composition operation — choosing which arrows compose and in which order, ad-hoc. The assembler is a concrete category.

## Examples

- `category-theory/` has its own DB, its own tools (`write-sync`, `read-selection`, etc.), its own schema — nothing depends on it, it depends on nothing but patlib (read-only)
- Root `.opencode/tools/` (patlib tools) coexist with project `.opencode/tools/` (category-theory tools) — same filenames, different scopes, no conflict
- To sync a chapter and then read it: the LLM calls `write-sync`, inspects the result, then calls `read-selection` — two independent calls, not a pipeline

## Rules

1. **One tool, one direction** — reads or writes, each tool has exactly one direction.
2. **No tool imports, only LLM composes** — tools call no other tools; only the LLM composes tool calls.
3. **Each project owns its own DB** — the only shared DB is patlib.db, read-only.
4. **Each call is independent** — no fixed control flow between tools.
5. **Discovered by directory** — project tools are enumerated by the filesystem, not a registration table.

## Applicability

Every project under `assembler/`. The architecture IS the property of being an AMANDA project.

## See also

- PAT.TOOL.PROJECT.SCOPE — tools scoped by project directory, no global registration
- PAT.PLUGIN.IPC.TOOL — implementation pattern for IPC tools
- PAT.ORTHOGONALITY — independent components don't interfere
- PAT.MUTATION.PATTERN — append vs upsert, determines tool direction
