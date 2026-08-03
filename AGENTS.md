# AMANDA assembler — Agent Instructions

## Identity

This file is the agent instruction file for the assembler workspace root. It instantiates the delegation environment per `IDENTITY.AGENT`; it states only final absolute states per `RUL.AGENTS.STATE`; it stands self-contained per `SPEC.AGENTS.SELF.CONTAINED`.

## System

The assembler runs on Bun + TypeScript, executing source directly. Deps live in `.opencode/package.json`. The database uses `bun:sqlite`; migrations add columns (`ALTER TABLE ADD COLUMN`); existing tables and rows persist. `patlib.db` lives under `.opencode/`; subprojects keep their own `.db`. The directory runs as a git repository at `github.com/7not-nico/assembler`; `.gitignore` excludes runtime artifacts, codex clones, and binary media.

Subdirectories with their own agent instructions delegate before work inside them (per `RUL.PROJECT.DELEGATION`); `_atelier/` holds plain project folders whose subprojects delegate the same way. Knowledge projects follow the obligatory chain `precept/ → procedure/ → note/ → bitacora/ → glossary/ → reference/ → fixtures/`; new ones scaffold with `bash _knowledge/_templates/scaffold-knowledge.sh {name} "{domain}" [--with-skills]` (13-layer chain). Session reports land in `_knowledge/_templates/report/`.

Task reference: `.opencode/_bitacora/task-reference/query-patlib.md` (query flags), `entity-schema.md` (schema). Flow docs: `.opencode/_scripts/dataflow/semantic-engine.md`.

## Reports and todos

Bitacora files ALWAYS — every session, every task. Todo precedes work; report follows completion; both stay open while working. Records live under `.opencode/_bitacora/` (`task-audit/`, `task-plan/`, `task-reference/`, `task-report/`, `task-stdout/`, `task-survey/`, `task-todo/`).

- `.opencode/_bitacora/task-todo/{topic}.md` — persistent task lists, created BEFORE tasks start; status updates (`- [ ]` / `- [x]`) mark progress during tasks.
- `.opencode/_bitacora/task-report/{timestamp}-{topic}.md` — factual record at completion: what was done, decisions, open edges, todo state summary.

Every command pipes through `bash .opencode/_bitacora/bitacora-log.sh {name} -- {command}` → `task-stdout/{YYYYMMDD}-{HHMMSS}-{name}.log` with `# CMD:` header and exit status. Long-running commands buffer inner output to temp files replayed at completion — run long diagnostics directly to watch live progress.

## Tooling

Root `.opencode/tools/` hosts Shebang CLI tools (semantic engine), importing `../_lib/` (shared lib). Subproject `.opencode/tools/` hosts Shebang CLI or plugin IPC, importing `../lib/db`. Dependencies share one plane: `tools/{name}/node_modules` symlinks to `.opencode/node_modules` (declared in `.opencode/package.json`); `bun install` runs at the root plane only (per `REF.TOOL.NODE_MODULES.SHARED`). MCP servers follow the same symlink for SDK/zod deps. Archived toolchain and plugins sit in `_disabled/`; opencode.json registers active servers only; restoring an archived server requires moving the directory back and re-adding its registration.

### Semantic engine

- IPC: `embed-entity` (TRNS) — server loads at start; edits require restart.
- MCP server: `mcp-semantic` (`.opencode/tools/mcp-semantic/index.ts`) — exposes the workflow as agent tools (`semantic_search`, `semantic_stats`, `semantic_drift`, `semantic_embed`, `semantic_purge`, `semantic_eval`); deps via the shared node_modules symlink; registered in opencode.json.
- CLI (`bun run .opencode/tools/{name}.ts`): `semantic-embed [--type T] [--force]`, `semantic-stats [--type T]`, `semantic-drift [--type T] [--check]` (MISSING/STALE vs patlib.db), `semantic-eval [--k N] [--variant default|raw|passage] [--documents stored|title|body]` (MRR/Recall/Hit/NDCG over related-ID pairs), `semantic-purge [--type T] [--apply]` (dry-run → delete), `semantic-search --query TEXT [--k N] [--type T]`.
- Shared: `_lib/embed.ts` (model `Xenova/bge-small-en-v1.5`, 384-dim), `_lib/paths.ts`, `_lib/score.ts` (pure `score`/`unit`/`hit`), `_lib/ann.ts` (Rust ANN twins), `_lib/semantic-types.ts`/`semantic-format.ts` (pure) and `_lib/semantic-query.ts` (io) — MCP server libs. CLI tools spawn `_rustlib/target/release/assemble` (`score|hit|unit`, JSON over stdin/stdout) — safe in standalone processes (guarded by `import.meta.main`); IPC tools use in-process `_lib/score.ts`.
- Vector store: `.opencode/patlib-vector.db` — `embeddings(entity_type, entity_id, seq, field, vector, content_hash, model_version, source_file, source_mtime, updated)`, UNIQUE per `(entity_type, entity_id, seq, field)`, journal DELETE.
- Eval caveat: `--documents body` re-embeds content columns and returns metrics identical to `stored` (same source text); embedder truncates long inputs (20 KB → 165 ms). Probe workflow: `.opencode/_shell/survey/semantic-engine-probe/` (`run-probe.sh`).

## Entities

### Naming standards

| Location | Pattern | Rule |
|----------|---------|------|
| `.opencode/entities/patterns/` | `{PREFIX}.{DOMAIN}.{SUBJECT}.md` | 3-segment uppercase dotted ID. Pattern morphism entities. Frontmatter with `morphism:`. |
| `.opencode/entities/terms/` | `{PREFIX}.{DOMAIN}.{SUBJECT}.md` | 3-segment uppercase dotted ID. Terms. Backmatter. |
| `.opencode/commands/` | `yamls/{verb}-{domain}.yaml` | Verb-domain YAML registry. |
| `.opencode/entities/maxims/` | `{PREFIX}.{DOMAIN}.{SUBJECT}.md` | 3-segment uppercase dotted ID. Maxims. Frontmatter. |

## Delegation

This project owns the assembler workspace: root tooling, entity conventions, bitacora records, and the semantic engine.
