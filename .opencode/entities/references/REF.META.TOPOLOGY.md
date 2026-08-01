---
id: REF.META.TOPOLOGY
title: Assembler Architecture — Unidirectional, Modular, Non-Linear
source: PROT.META.IDENTITY
summary: The assembler is a unidirectional, modular, non-linear system. Tools serve one direction each. Projects are self-contained with their own DB, tools, and MCP servers. Control flow is ad-hoc via the LLM.
ref: Tools do one thing — read or write, one direction per tool. Projects own their own DB and tools. The LLM composes tool calls. Tools remain independent.
related: []
tags: [architecture, design, opencode, convention, unidirectional, modular, non-linear]
---

The assembler uses four properties: metadata-first, unidirectional, modular, and non-linear.

### Metadata-first

Every entity carries its own metadata inline. A tool's classification lives in its source file (`// @toolclass TRNS`). A definition's properties live in its frontmatter (`id:`, `chapter:`, `statement:`). An impression's metadata lives in its backmatter (`---` block). The file IS the authoritative record, external registry excluded. Any database (e.g., `patlib.db`) is a derived cache with the file as source.

- **Tools**: `// @toolclass <CODE>` at line 1 of `.opencode/tools/*.ts`
- **Entities**: YAML frontmatter in `.md` files
- **Impressions**: YAML backmatter in `.md` files
- **Manifests**: Generated from annotations, hand-maintenance excluded

### Unidirectional

Every IPC tool serves one direction — read or write. A `write-sync` writes to its project's DB. A `read-selection` reads from it. Each tool has exactly one direction.

Composition happens at the LLM level: the agent calls the writer, then the reader, in whichever order the task requires. Tools remain independent — the LLM composes separate tool calls for each action.

### Modular

Every project under `assembler/` is independent. It owns:

- Its own `bun:sqlite` database
- Its own `.opencode/tools/` (discovered by directory, global registration excluded)
- Its own MCP servers in `opencode.json` (discovered by config, parallel to IPC tools)
- Its own `AGENTS.md` defining workflow

Cross-project imports and shared state are excluded. The only cross-project reference point is `patlib.db` (patterns/terms/skills) — read-only for all projects. Each project uses its own database and tools independently.

### Non-Linear

Tool execution uses standalone entry points with ad-hoc sequencing. Each tool is a standalone entry point. The LLM decides which tool to call and when, based on the current task. Implicit control flow between `.opencode/tools/` files is excluded — the only sequence is the one the agent constructs in that session.

### Connection to category theory

The architecture mirrors the definition of a category (DEF.CAT) from Simmons Ch1 (CHAP.CH1): **projects** are objects, **IPC tools** are morphisms (unidirectional, domain→codomain), and the **LLM** is the composition operation — choosing which arrows compose and in which order, ad-hoc. The assembler is a concrete category. Full categorical mapping in PAT.META.CATEGORY.VIEW.

## Examples

- `category-theory/` has its own DB, its own tools (`write-sync`, `read-selection`, etc.), its own schema — dependencies limited to patlib (read-only)
- Root `.opencode/tools/` (patlib tools) coexist with project `.opencode/tools/` (category-theory tools) — same filenames, different scopes, no conflict
- To sync a chapter and then read it: the LLM calls `write-sync`, inspects the result, then calls `read-selection` — two independent calls, pipeline excluded

## Rules

1. **One tool, one direction** — reads or writes, each tool has exactly one direction.
2. **One direction per tool** — LLM composes all tool calls; tools remain independent.
3. **Each project owns its own DB** — the only shared DB is patlib.db, read-only.
4. **Each call is independent** — no fixed control flow between tools.
5. **Discovered by directory** — project tools are enumerated by the filesystem, registration table excluded.
6. **MCP servers discovered by config** — `opencode.json` entries register MCP servers, parallel to filesystem-based IPC discovery.

## Applicability

Every project under `assembler/`. The architecture IS the property of being an AMANDA project.

## See also

- ILL.META.TOPOLOGY.WALK — concrete multi-project session walkthrough
- PROT.TOOL.SCOPE — tools scoped by project directory, no global registration
- PROT.META.CATEGORY.VIEW — full categorical mapping of the assembler
- PROT.TOOL.DEFINITION — implementation pattern for Custom IPC tools
- PROT.TOOL.DISCOVERY — MCP server auto-discovery, config-based parallel to IPC
- MAX.CODE.ORTHOGONALITY.PRINCIPLE — independent components remain isolated
- PROT.LIB.MUTATION.STRATEGY — append vs upsert, determines tool direction
