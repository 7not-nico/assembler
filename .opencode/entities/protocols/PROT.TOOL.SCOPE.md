---
id: PROT.TOOL.SCOPE
title: "Tool Project Scope — Auto-Discovery Replaces Global Registration"
source: NEX.TOOL.CHOICE
related: []
summary: "Custom IPC tools are auto-discovered by OpenCode from .opencode/tools/ per-project. Same-named tools in different projects are distinct by scoping. No filename prefix, registration table, or global namespace needed."
protocol: "Custom IPC tools are scoped by their project directory. Each .opencode/tools/ directory defines its own tool namespace. Same-named tools in different projects are distinct by directory. No global naming, registration, or qualification needed."
enforcement: Formality
status: active
priority: 3
tags: [tooling, architecture, opencode, convention, scoping, ipc, plugin]
---

Custom IPC tools are auto-discovered by OpenCode from `.opencode/tools/` per project. Same-named tools in different projects are distinct by their containing directory.

## Protocol

1. **Directory is scope** — same-named tools in different projects are distinct by directory. Global uniqueness is unnecessary.
2. **Root tools track classification** — `assembler/.opencode/tools/` root tools may register archetypes (TRNS, RECG, etc.) in a manifest. Project-local tools are filesystem-scoped.
3. **Discover tools by filesystem scan** — project tools are discovered by listing `.opencode/tools/*.ts` files. No DB table or registration required.
4. **One direction per tool** — each tool reads OR writes. Compound operations compose via the LLM calling multiple tools or using a subagent.
5. **Namespace by project path** — `project-a/.opencode/tools/write-sync.ts` and `project-b/.opencode/tools/write-sync.ts` coexist without collision.
6. **Subproject tools are shebang CLI only** — subproject `.opencode/tools/` files start with a shebang line resolving to `bun`. Subproject tools exclude `export default tool({...})` named-export format. Custom IPC Tool format belongs in root `assembler/.opencode/tools/`. Subproject `lib/` modules resolve locally to support shebang CLI tools — root `_lib/` import paths resolve at root level only.

## Gotchas

- Tool in wrong project directory: Place the tool inside the project's `.opencode/tools/` directory — auto-discovery resolves by project context (Tool file placed outside its project's `.opencode/tools/`)
- Cross-project tool import: Extract shared logic to root `_lib/` — root tools and lib are shared, project tools are private (Tool in `project-a` imports from `project-b` tool or lib)
- Tool naming conflicts within same project: Each tool within a project must have a unique filename — within-project names are the collision boundary (Two files in the same `.opencode/tools/` with identical stem name)
- Project tool tries to register in global manifest: Subproject tools are filesystem-scoped — only root tools use manifest registration (Tool in subproject `.opencode/tools/` expects entry in root tool manifest)
- Custom IPC tool in subproject: Subproject tools use shebang CLI format. Root `_lib/` import paths resolve only from root — subproject `lib/` provides local CLI support. Promote to root if agent IPC access required (Subproject `.opencode/tools/` file uses `export default tool({...})`)

## Enforcement

`audit-tool` verifies each tool file is in the correct project directory. It flags cross-project imports, duplicate tool names within a project, registration attempts from subproject tools, and Custom IPC Tool format (`export default tool({...})`) in subproject `.opencode/tools/`.

## Applicability

Every AMANDA project with `.opencode/tools/` — any project using Custom IPC tools. Root tools and project tools follow the same scoping rules.

## See also

- `PROT.TOOL.DEFINITION` — implementation pattern for Custom IPC tools
- `PROT.TOOL.AUTOMATON` — automaton classification for each tool
- `MAX.CODE.ORTHOGONALITY.PRINCIPLE` — independent components operate without interference
- `REF.LIB.DIRECTORY.LAYER` — shared library convention
