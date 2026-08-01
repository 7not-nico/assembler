---
id: PAT.DEPENDENCY.RESOLVE
title: "Nested .opencode/ Dependency Sync — Version consistency across project hierarchies"
source: NEX.LIB.STACK
summary: "Version alignment: required across all .opencode/package.json files for every shared dependency. Bun resolves modules upward through the directory tree — parent .opencode/node_modules/ shadows child when versions diverge."
morphism: "TRNS — every .opencode/package.json in the project tree specifies the same major version for any dependency shared across nested .opencode/ directories."
enforcement: Convention
tags: [dependencies, bun, module-resolution, project-structure]
status: active
priority: 3
---

Shared dependency major version: identical across all `.opencode/package.json`. Bun module resolution walks upward — parent `node_modules/` shadows child when versions differ. Version mismatch: obscure runtime errors (e.g., `bun:sqlite` binding type error from `js-yaml` v4 vs v5).

**Gotcha.** Stale lockfiles shadow the upgrade. `bun.lock` and `package-lock.json` pin old versions even after `package.json` edit. Both lockfiles: deleted before reinstall when versions conflict.

## Rules

- **Pre-change scan, post-change sync** — `grep` both `.opencode/package.json` files for shared dependency names before adding or changing one. After change: `bun install` in every affected `.opencode/`, then `read-validate`
- **Lockfiles: cleared on conflict** — both `bun.lock` and `package-lock.json`: deleted before reinstall when versions diverge. Stale pins: the sole cause of phantom version mismatches
- **Major version: identical across tree** — minor and patch differ freely; major must match. Parent v4 + child v5: parent shadows, child specifier ignored
- **Validation on change** — after any dependency change: `read-validate` in all affected `.opencode/` directories

## Diagnosis

`bun -e "import {load} from 'js-yaml'; console.log(typeof load)"` — output version mismatches `.opencode/package.json` specifier → parent shadowing active.

## Applicability

Nested `.opencode/` trees — root (`/home/eddyr/assembler/.opencode/`) and subprojects (`study-sessions/thoughtlog/.opencode/`, `ludoteca/.opencode/`). Standalone `.opencode/` directories without parent: unaffected.

## See also

- `REF.TOOL.NODE_MODULES.SHARED` — shared node_modules convention; parent shadowing affects both planes
- `REF.LIB.DIRECTORY.LAYER` — library symlink convention; parent shadows child on version mismatch
- `REF.SCHEMA.DATABASE.OWNERSHIP` — additive-only DB migration; dependency version pinning parallels DB schema stability
- `REF.META.PROJECT.STRUCTURE` — subproject directory tiers; nested .opencode/ trees follow tiered structure
