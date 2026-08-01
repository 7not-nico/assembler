# AMANDA assembler — Agent Instructions

## System

The assembler runs on Bun and TypeScript. It executes source directly. Dependencies live in `.opencode/package.json`.
The database uses `bun:sqlite`. Migrations add columns (`ALTER TABLE ADD COLUMN`); existing tables and rows persist.
`patlib.db` lives under `.opencode/` and stores assembler entities. Subprojects maintain their own `.db` under `.opencode/`.
The directory runs as a git repository at `github.com/7not-nico/assembler`. The `.gitignore` file excludes runtime artifacts, codex clones, and binary media.
The `.opencode/_bitacora/task-reference/` folder stores query flags, schema details, and lookup tables. AGENTS.md references these files.
The `.opencode/_scripts/dataflow/` directory stores flow documentation. The `semantic-engine.md` file documents embed/search logic flow.
The `_knowledge/rust-coding/` project has its own AGENTS.md. Delegation precedes work inside it. The learning precedence chain is obligatory: `precept/` → `procedure/` → `note/` → `bitacora/` → `glossary/` → `reference/` → `fixtures/`. Precepts and procedures compose; each complements the other.
The `_knowledge/_templates/` directory stores knowledge-project bootstrap templates. New projects scaffold with `bash _knowledge/_templates/scaffold-knowledge.sh {name} "{domain}" [--with-skills]`. The scaffold creates the full 13-layer chain (`format/ → precept/ → procedure/ → research/ → concept/ → note/ → bitacora/ → glossary/ → schema/ → script/ → reference/ → fixtures/ → practice/`), AGENTS.md, per-layer boilerplate, SQL schema, and a Ruby registry push script. The `--with-skills` flag copies the anchored skill set (browser, research, search, reasoning) into `docs/` per CMD.ANCHOR.WORKFLOW. The `_knowledge/hypr-docs/` project uses the extended chain as its reference implementation.
The `_knowledge/_templates/report/` directory stores session reports for bootstrapped knowledge projects. Every session writes a session report (precept `write-report.md`): what was done, decisions, errors found, findings, open edges, todo state. Errors and findings feed template fixes — the improvement loop.
The `_codex/` project explores codebases deeply. It has its own AGENTS.md, a shared `_templates/` toolchain, and a `_bitacora/` record area. Repos fetch shallow into `{repo}-repo/{repo}/`; dive projects carry their own AGENTS.md.
The `_atelier/` domain holds plain project folders — `a01-harness-llm/`, `common/`, `one-timers/`, `pythontts-cli/`, `study-sessions/`. Projects with their own AGENTS.md delegate before work inside them, per the project-delegation rule.

## Reports and todos

The agent writes bitacora files ALWAYS — every session, every task. Todo precedes work; report follows completion. Both stay open while working. All records live under `.opencode/_bitacora/` — every subfolder follows the `{?}-{concrete noun}` naming convention: `task-audit/`, `task-plan/`, `task-reference/`, `task-report/`, `task-stdout/`, `task-survey/`, `task-todo/`.
The `.opencode/_bitacora/task-todo/{topic}.md` file holds persistent task lists, one per project/topic. Work creates the todo BEFORE tasks start — it plans the task sequence. Work uses the todo DURING tasks — status updates (`- [ ]` / `- [x]`) mark progress as tasks complete. Each task begins from its todo entry.
The `.opencode/_bitacora/task-report/{timestamp}-{topic}.md` file stores the factual record — metrics, findings, decisions, before/after data — and the task reports: what was done, decisions, open edges, todo state summary. The agent writes the report at completion.
The `.opencode/_bitacora/task-audit/`, `.opencode/_bitacora/task-plan/`, and `.opencode/_bitacora/task-survey/` folders hold audit logs, plan documents, and survey records.
Every command the agent runs passes through `bash .opencode/_bitacora/bitacora-log.sh {name} -- {command}`. The script writes the log file into `.opencode/_bitacora/task-stdout/`. The file name takes the form `{YYYYMMDD}-{HHMMSS}-{name}.log`. The `# CMD:` header holds the exact command line. Output streams live to the terminal and into the file. The script appends the exit status. Reports reference each log file.
Report and todo updates accompany task completion; they are deliverables, first-class outputs. Every finished task carries a todo entry and a completed-task report; both mark finished work.

## Tooling

Root `.opencode/tools/` hosts active tools. They are Shebang CLI (semantic engine). They import from `../_lib/` (shared lib modules).
Subproject `.opencode/tools/` hosts Shebang CLI or plugin IPC. They run with `bun run <file>` or auto-discover. They import from `../lib/db`.
Root tools host the semantic engine (details below). The former sync/read/MCP toolchain (`write-sync`, `sync-watch`, `read-selection`, `read-projection`, `read-validate`, `mcp-log-search`, `mcp-features`, `mcp-compare`, `mcp-verify`) sits archived under `.opencode/tools/_disabled/` with matching `_lib/_disabled/` modules (`db.ts`, `sync.ts`, `read-entities.ts`, etc.).
Plugins: all 8 archived under `.opencode/plugins/_disabled/` (`audit-events`, `auto-sync`, `bash-guard`, `burst-alert`, `cmd-audit`, `log-mcp`, `ref-integrity`, `session-saver`). Config carries plugin registrations when present; the directory discovers plugins; moving files back restores them.

Semantic engine (root):

- IPC tools: `embed-entity` (TRNS — embed patlib entities). The server loads them at start; edits require a restart.
- CLI tools:
  - `semantic-embed` — runs `bun run .opencode/tools/semantic-embed.ts [--type TABLE] [--force]`
  - `semantic-stats` — runs `[--type TABLE]`
  - `semantic-drift` — runs `bun run .opencode/tools/semantic-drift.ts [--type TABLE] [--check]`; detects MISSING/STALE embeddings vs patlib.db
  - `semantic-eval` — runs `bun run .opencode/tools/semantic-eval.ts [--k N] [--variant default|raw|passage] [--documents stored|title|body]`; reports MRR/Recall/Hit/NDCG metrics over related-ID pairs, sequential batches
- Search tool: `semantic-search` (`bun run .opencode/tools/semantic-search.ts --query TEXT [--k N] [--type TABLE]`). Rust ANN top-k via shared `_lib/ann.ts`; CLI usage applies. It spawns safely in standalone CLI processes (guarded by `import.meta.main`). IPC tools use in-process `_lib/score.ts`. The Rust-pipe spawn path runs from the CLI.
- Shared: `_lib/embed.ts` (model `Xenova/bge-small-en-v1.5`, 384-dim), `_lib/paths.ts`, `_lib/cli.ts`, `_lib/score.ts` (pure `score`/`unit`/`hit`), `_lib/ann.ts` (Rust ANN endpoints `score`/`hit`/`unit` — CLI-tool twins of `_lib/score.ts`).
- Vector store: `.opencode/patlib-vector.db` — schema `embeddings(entity_type, entity_id, seq, field, vector, content_hash, model_version, source_file, source_mtime, updated)`, UNIQUE per `(entity_type, entity_id, seq, field)`. Journal mode: DELETE — the store skips WAL and sidecar files.
- ANN backend: `_rustlib/target/release/assemble` verbs `score|hit|unit` (JSON over stdin/stdout).

## Entities

### Naming standards

| Location | Pattern | Rule |
|----------|---------|------|
| `.opencode/entities/patterns/` | `{PREFIX}.{DOMAIN}.{SUBJECT}.md` | 3-segment uppercase dotted ID. Pattern morphism entities. Frontmatter with `morphism:`. |
| `.opencode/entities/terms/` | `{PREFIX}.{DOMAIN}.{SUBJECT}.md` | 3-segment uppercase dotted ID. Terms. Backmatter. |
| `.opencode/commands/` | `yamls/{verb}-{domain}.yaml` | Verb-domain YAML registry. |
| `.opencode/entities/maxims/` | `{PREFIX}.{DOMAIN}.{SUBJECT}.md` | 3-segment uppercase dotted ID. Maxims. Frontmatter. |

`.opencode/_bitacora/task-reference/query-patlib.md` holds query flags and gotchas.
`.opencode/_bitacora/task-reference/entity-schema.md` holds schema details.
