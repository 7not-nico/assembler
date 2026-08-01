**Generated Tool** — an `.opencode/tools/` file produced by a scaffolding process rather than hand-written. Its structure is deterministic, its metadata annotations (`// @toolclass`) are schema-derived, and its compliance is automatically verifiable against the six constraints of PAT.GENERATED.COMPLIANCE. Differs from hand-written tools in that its entire surface is determined by the project's manifests — changes to manifests regenerate the tool rather than requiring manual edits.

---
id: TERM.GENERATED.TOOL
title: Generated Tool
source: assembler
tags: [tooling, generation, scaffolding, compliance, convention]
terms: []
patterns: [PAT.TOOL.GENERATION, PAT.GENERATED.COMPLIANCE, PAT.PLUGIN.IPC.TOOL]
related: []
reference:
  - title: PAT.TOOL.GENERATION — Tool Generation from Schema
    url: file:.opencode/patterns/PAT.TOOL.GENERATION.md
  - title: PAT.GENERATED.COMPLIANCE — Six Constraints for Scaffolded Tools
    url: file:.opencode/patterns/PAT.GENERATED.COMPLIANCE.md
  - title: PAT.PLUGIN.IPC.TOOL — Plugin IPC Tool Pattern
    url: file:.opencode/patterns/PAT.PLUGIN.IPC.TOOL.md
---