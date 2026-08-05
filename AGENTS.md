# AMANDA assembler — Agent Instructions

## Identity

- serves as the agent instruction file for the assembler workspace root
- instantiates the delegation environment per `IDENTITY.AGENT`
- states final absolute states per `RUL.AGENTS.STATE`
- stands self-contained per `SPEC.AGENTS.SELF.CONTAINED`

## System

- runs on Bun + TypeScript, executes source directly
- deps live in `.opencode/package.json`
- `patlib.db` lives under `.opencode/`; `bun:sqlite` powers the database
- migrations add columns (`ALTER TABLE ADD COLUMN`) per `SPEC.SCHEMA.MIGRATION.AUGMENT`
- existing tables and rows persist
- runs as a git repository at `github.com/7not-nico/assembler`
- `.gitignore` excludes runtime artifacts and binary media
- `_atelier/` holds plain project folders per `RING.DIRECTORY.TOPOLOGY`
- query flags live in `.opencode/_bitacora/task-reference/query-patlib.md`; schema in `entity-schema.md`
- flow docs live in `.opencode/_scripts/dataflow/semantic-engine.md`

## Reports and todos

- bitacora records live under `.opencode/_bitacora/` (`task-audit/`, `task-plan/`, `task-reference/`, `task-report/`, `task-stdout/`, `task-survey/`, `task-todo/`)
- `bitacora-workflow` skill sequences todo → log → report
- `.opencode/_bitacora/task-todo/{topic}.md` holds persistent task lists, created BEFORE tasks start
- status updates (`- [ ]` / `- [x]`) mark progress during tasks
- `.opencode/_bitacora/task-report/{timestamp}-{topic}.md` holds the factual record at completion: what was done, decisions, open edges, todo state summary
- every command pipes through `bash .opencode/_bitacora/bitacora-log.sh {name} -- {command}` → `task-stdout/{YYYYMMDD}-{HHMMSS}-{name}.log`
- wrapper writes provenance headers only (trace-free)
- `tracexec log -- {command}` enriches stdout of commands with the exec tree when exec-level detail matters

## Tooling

- root `.opencode/tools/` hosts Shebang CLI tools (semantic engine), importing `../_lib/` (shared lib)
- dependencies share one plane: `tools/{name}/node_modules` symlinks to `.opencode/node_modules`
- `bun install` runs at the root plane only (per `REF.TOOL.NODE_MODULES.SHARED`)
- MCP servers follow the same symlink for SDK/zod deps
- archived toolchain and plugins sit in `_disabled/`
- `opencode.json` registers active servers only
- tools declare `// @toolclass` per `SPEC.TOOL.CLASSIFICATION.AUTOMATON`
- language choice follows `SPEC.LANGUAGE.ROLE.MAP` + `RING.LANGUAGE.TOPOLOGY`
- `_scripts/` rings follow `RING.SCRIPT.TOPOLOGY`

### Semantic engine

- IPC: `embed-entity` (TRNS) — server loads at start; edits require restart
- MCP server: `mcp-semantic` (`.opencode/tools/mcp-semantic/index.ts`) — exposes the semantic workflow as agent tools; registered in opencode.json
- mode routing follows the `semantic-dispatcher` skill
- CLI (`bun run .opencode/tools/{name}.ts`): `semantic-embed`, `semantic-stats`, `semantic-drift [--check]`, `semantic-eval`, `semantic-purge [--apply]`, `semantic-search --query TEXT`
- shared: `_lib/embed.ts` (model `Xenova/bge-small-en-v1.5`, 384-dim), `_lib/score.ts` (pure `score`/`unit`/`hit`), `_lib/ann.ts` (Rust ANN twins), `_lib/semantic-query.ts` (io)
- CLI tools spawn `_rustlib/target/release/assemble` (`score|hit|unit`, JSON over stdin/stdout)
- IPC tools use in-process `_lib/score.ts`
- vector store: `.opencode/patlib-vector.db` — `embeddings(entity_type, entity_id, seq, field, vector, content_hash, model_version, source_file, source_mtime, updated)`, UNIQUE per `(entity_type, entity_id, seq, field)`, journal DELETE
- eval caveat: embedder truncates long inputs (20 KB → 165 ms)
- probe: `.opencode/_shell/survey/semantic-engine-probe/` (`run-probe.sh`)

## Entities

- entity groups and rings follow `SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY`
- ID segments follow `SPEC.ENTITY.SEGMENT.COUNT`
- routing follows `SPEC.ENTITY.ROUTING.TABLE`
- segment semantics follow `SPEC.ENTITY.DISCERNIBILITY.SEGMENT`

## Delegation

- owns the assembler workspace: root tooling, entity conventions, bitacora records, semantic engine
