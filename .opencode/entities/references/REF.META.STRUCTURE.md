---
id: REF.META.STRUCTURE
title: "Subproject Structure — Mandatory, Required, and Optional Directories"
source: PROT.META.IDENTITY
related: []
summary: "Every subproject under assembler/one-timers/ follows a tiered directory structure — mandatory tools/, lib/, AGENTS.md, opencode.json; required schemas/ if .db exists; optional plugins/, inspirations/, notes/. Derived from ludoteca as IaC template."
ref: "Every subproject under assembler/one-timers/ adheres to a tiered directory convention. Mandatory items present in all subprojects. Required items conditional on project features (DB, dependencies). Optional items added per project domain. Structure tiers: mandatory (tools, lib, AGENTS.md, opencode.json), required (package.json if dependencies, schemas if .db), optional (plugins, inspirations, notes)."
tags: [project, structure, bootstrap, convention, directory, subproject]
---

Tiered directory convention for all AMANDA subprojects. The structure follows the stratum data model — every directory is a domain; every file is an entity within its parent domain; file contents are entity properties. Domains sharing a parent directory share a plane.

## Protocol

1. **Directory structure mirrors entity model** — `.opencode/` directory tree forms a plane/domain/entity/property hierarchy. A directory is a domain. A file is an entity belonging to its parent domain. File contents are the entity's properties. Sibling directories under the same parent share a plane.

2. **ludoteca as IaC template** — `ludoteca/.opencode/` is the canonical template for new subprojects. New projects derive from it; they build from scratch excluded.

3. **Three structural tiers** — every subproject `.opencode/` organizes into mandatory, required, and optional tiers:

   | Tier | Item | Condition |
   |------|------|-----------|
   | Mandatory | `tools/` | Always present — three tool types: CLI tools (shebang files), MCP servers (subdirectories with index.ts), Custom IPC tools (export default tool({...}) at root only) |
   | Mandatory | `lib/` | Always present — shared dependency layer for tools/; tools import lib, cross-tool imports excluded |
   | Mandatory | `AGENTS.md` | Always present — project instructions |
   | Mandatory | `opencode.json` | Always present — opencode project config |
   | Required | `package.json` | Present when external dependencies needed. Omitted if bun builtins suffice |
   | Required | `bun.lock` + `node_modules/` | Present when `package.json` exists |
   | Required | `schemas/` | Present when `.db` exists — schema-only SQL tables (CREATE TABLE), no YAML frontmatter/backmatter .md files. Contains `schemas/seeds/` for seed data |
   | Required | `.db` file | Present per `PROT.SCHEMA.DATABASE.OWNERSHIP` criterion |
   | Optional | `plugins/` | Present when lifecycle hooks needed |
   | Optional | `inspirations/` | Domain reference materials |
   | Optional | `notes/` | Research notes and working memory |

4. **Mandatory items lack conditions** — tools/, lib/, AGENTS.md, and opencode.json exist in every subproject regardless of domain or features. Omission of any mandatory item is a structural violation.

5. **Required items follow condition** — package.json and schemas/ activate when their condition is met. A subproject with a `.db` file includes schemas/; an omission is a structural gap. A subproject with bun-external imports includes package.json.

6. **Optional items at project discretion** — plugins/, inspirations/, notes/ added per domain need. Adding an optional item requires no structural review.

7. **schemas/ contains schema-only SQL and seeds/** — `schemas/` holds SQL schema definition files (CREATE TABLE). These are schema-only tables — they have no corresponding .md files with YAML frontmatter or backmatter. Seed data for lookup and reference tables goes in `schemas/seeds/` with numeric prefix for sort order per the seed-driven init convention. Each seed file corresponds to one table, one table per file. The `.db` file sits alongside `.opencode/schemas/` at the project level.

8. **tools/ hosts three tool types** — the `.opencode/tools/` directory contains: (a) flat CLI tool files with shebang (`bun run`), (b) MCP server subdirectories (`tools/<server-name>/index.ts`), (c) Custom IPC tool files with `export default tool({...})` at root level only per `PROT.TOOL.MODEL`. All three types share the tools/ namespace. MCP servers and Custom IPC tools outside tools/ excluded.

9. **Subproject root mirrors `.opencode/` tiers** — project-level files (README.md, tests/, docs/) optional per project domain. Structural enforcement applies to `.opencode/` directories; project root directories outside `.opencode/` are discretionary.

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Missing mandatory item | Subproject `.opencode/` lacks tools/, lib/, AGENTS.md, or opencode.json | Add the missing item — every subproject includes all four mandatory items |
| New project built from scratch | Project bootstrap creates `.opencode/` from memory or another template | Copy from ludoteca/.opencode/ — the canonical template preserves conventions |
| schemas/ absent with .db present | `.db` file exists; schemas/ directory absent | Add schemas/ with SQL schema files — one `.sql` per table, sorted per `PAT.SCHEMA.SEED.RELOAD` |
| package.json absent with external imports | Tool or lib file imports from npm package; package.json absent | Add package.json with required dependencies — `bun install` generates bun.lock and node_modules |
| .db absent with schemas/ present | schemas/ directory exists; .db file absent | Add .db via initDB() or remove schemas/ if DB was removed per `PROT.SCHEMA.DATABASE.OWNERSHIP` |
| Optional item mistaken for mandatory | Plugin, inspiration, or notes directory treated as structural requirement | Optional items per project domain — no structural enforcement |

## Enforcement

`audit-project` (planned) walks each subproject `.opencode/` and verifies:
- All four mandatory items present
- Required items present when their condition is met
- Optional items flagged correctly

Manual review at project bootstrap and during periodic audits.

## Applicability

All subprojects under `assembler/one-timers/` with a `.opencode/` directory. Also applies to new projects created via `bootstrap-db` or `scaffold-tools` workflow. The tiered structure mirrors across subproject types.

Excluded for root `assembler/.opencode/` — root structure governed by separate protocols (entity scope, lib structure, tool classification).

## See also

- `ILL.META.PROJECT.SETUP` — subproject bootstrap walkthrough
- `PROT.SCHEMA.DATABASE.OWNERSHIP` — DB creation criterion; determines whether `.db` and schemas/ are required
- `PROT.LIB.DIRECTORY.LAYER` — lib module structure; subproject lib/ belongs in mandatory lib/
- `PROT.TOOL.MODEL` — tool type per project level; subproject tools use shebang CLI
- `PROT.META.ENTITY.ROOT` — entity directories at root; subproject structure excludes entity directories
- `PAT.SCHEMA.SEED.RELOAD` — sorted SQL seed file convention; applicable in schemas/
- `bootstrap-db` skill — project bootstrap workflow
