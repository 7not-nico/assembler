---
id: PAT.GENERATED.COMPLIANCE
title: Generated Tool Compliance — Six Constraints for Scaffolded Tools
source: assembler
summary: Every generated tool must satisfy crashOnError, .describe(), return string, // @toolclass, read/write separation, and no console.log
principle: Tools produced by scaffolding must meet the same quality standards as hand-written tools, enforced by six mandatory constraints derived from PAT.PLUGIN.IPC.TOOL, PAT.TOOLCLASS, and audit-tools checks
enforcement: Tool
tags: [tooling, compliance, generation, quality, audit, convention]
patterns: [PAT.TOOL.GENERATION, PAT.PLUGIN.IPC.TOOL, PAT.TOOLCLASS, PAT.SHARED.LIB]
terms: []
status: draft
priority: 4
---

Tools produced by scaffolding must meet the same quality standards as hand-written tools, enforced by six mandatory constraints derived from PAT.PLUGIN.IPC.TOOL, PAT.TOOLCLASS, and audit-tools checks.

## Context

When tools are generated from manifests rather than hand-crafted, there is a risk that they omit quality requirements that hand-written tools would naturally include. The six constraints defined here close the gap between generated and hand-written tools. They derive from the cross-check validation of the scaffold-tools skill against existing patterns and audit criteria.

## Rules

1. **crashOnError** — every `execute()` must call `crashOnError()` near the top, before DB or filesystem operations. From PAT.PLUGIN.IPC.TOOL rule 9.

2. **Args described** — every schema argument must have `.describe()`. Bare `.string()`, `.number()`, `.boolean()` calls without description are violations. From audit-tools check 7.

3. **Return string for output** — tools must `return` strings for LLM consumption. `console.log`, `console.error`, `process.stdout.write` are violations. From audit-tools check 8.

4. **Annotation at line 1** — every generated tool file must start with `// @toolclass <CODE>` on line 1, where CODE is one of RECG, TRNS, GENR, SGNL. From PAT.TOOLCLASS rules.

5. **Read/write separation** — tools read or write, not both in the same `execute()`. Write-sync is write (TRNS); read-selection and read-projection are read (RECG). From audit-tools check 3.

6. **Import only from lib** — tools import from `lib/` or `_lib/` only; cross-tool imports are prohibited. From audit-tools check 5.

## Applicability

All generated `.opencode/tools/*.ts` files in any AMANDA project. The constraints are enforced by `audit-tools`, not by the scaffolding tool itself — generated tools must pass audit.

## See also

- PAT.TOOL.GENERATION — the scaffolding process that produces generated tools
- PAT.PLUGIN.IPC.TOOL — plugin IPC pattern, source of constraints 1, 2, 3
- PAT.TOOLCLASS — tool classification, source of constraint 4
- PAT.SHARED.LIB — lib path convention, implicit in constraint 6
- SKL.AUDIT.TOOL — enforcement tool
- `scaffold-tools` skill — should embed these constraints in generated output
