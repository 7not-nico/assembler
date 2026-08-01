---
id: REF.TOOL.SHARED
title: Shared Node Modules — Single Canonical Dependency Store
source: PROT.TOOL.DEFINITION
summary: All projects share a single root .opencode/node_modules/ via symlinks, eliminating per-project dependency duplication.
ref: One canonical dependency store at root. Every sub-project symlinks to it. No per-project bun install.
tags: [dependencies, architecture, dry, infrastructure, tooling]
---

One canonical dependency store at root. Every sub-project symlinks to it.

## Rules

1. **Root `node_modules/` is canonical** — `@opencode-ai/plugin` + `js-yaml` install here. All projects resolve from one copy.
2. **Sub-projects symlink** — each `.opencode/node_modules` → depth-adjusted `../../../.opencode/node_modules`. Use `scaffold-tools` or manual symlink creation instead of per-project `bun install`.
3. **`verify-deps --repair` fixes drift** — broken symlinks, real-directory fallbacks, or wrong targets detected and repaired automatically.
4. **Scaffold-tools generates symlinks** — new projects get symlink instead of install.

## Limitations

- Projects requiring distinct dependency versions across subprojects fall outside this pattern scope. Bun alias feature provides version pinning at the import level for those cases.

## Applicability

Any project with `.opencode/node_modules/` under assembler root.

## See also

- MAX.CODE.DRY.PRINCIPLE — single source of truth
- PROT.META.DATA.STRATUM — planes group domains
- scaffold-tools skill — symlink generation for new projects
- `.opencode/tools/verify-deps.ts` — verify + repair symlinks
