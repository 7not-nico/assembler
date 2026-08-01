---
id: PRE.CLI.TO.MCP
title: CLI to MCP — Separation Then Unification
source: assembler
summary: First separate work into aspect-specific CLI tools with shared logic components. Then unify workflow aspects into a declared MCP server.
precept: First, separation of work — each CLI tool determines one aspect of a workflow, extracting shared logic into lib/ components. Then, unification of work — MCP server composes workflow-relevant aspects into a formalized workflow.
enforcement: Convention
tags: [mcp, cli, tooling, modularity, separation-of-concerns, unification, workflow, bun]
status: active
priority: 4
---

**CLI to MCP** — first separation of work, then unification of work.

## Corollaries

- Workflow identified before tooling begins
- Each CLI tool determines exactly one aspect of the workflow — no multi-aspect tools
- Tool begins as `bun run` entry point in `.opencode/tools/`
- Shared logic components in `.opencode/lib/` extracted as soon as a second tool needs them
- MCP declared only after shared logic components are composable and exercised via CLI
- MCP composes workflow capabilities — not all tools, only those forming the formalized workflow
- Scaffolding tools (idea test, implementation experiment) remain standalone CLI — never MCP'd
- MCP imports same `package.json` deps and shared logic components as the CLI tools
- A tool spanning multiple aspects signals a split — extract another shared logic component first

## Applicability

Any subproject developing tooling destined for MCP. Workflow toolchains follow this two-phase rhythm.
