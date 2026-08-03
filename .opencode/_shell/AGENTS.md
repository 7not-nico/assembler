# _shell/ — Shell Scripting Layer

## System

The `_shell/` directory hosts the assembler root's bash-first scripting layer. Bash forms binary imperative shells at the edge of the system (per `RUL.CODE.BASH.SHELLS`); each script wraps a launch or pipeline boundary. Survey workflows live under `survey/{qualifier}-{subject}/` with atomic stage scripts and an orchestrator. Engine helpers (TS/Rust/Go) sit alongside where a model or native binary does the work; bash orchestrates, the helper executes

The layer routes every command through `.opencode/_bitacora/bitacora-log.sh` for provenance capture (header, live-to-file output, exit status). Long-running commands buffer inner output to temp files replayed at completion — run long diagnostics directly to watch live progress

## Quick start

```bash
bash .opencode/_shell/survey/semantic-engine-probe/s01-body-lengths.sh   # per-table body length stats
bash .opencode/_shell/survey/semantic-engine-probe/run-probe.sh 2         # full probe: lengths → embedder → body eval
```

## Structure

```text
| Path | Role |
|------|------|
| `survey/semantic-engine-probe/` | Semantic engine health probe — body lengths, embedder long-input cost, bounded body eval |
| `survey/semantic-engine-probe/s01-body-lengths.sh` | sqlite3 body-length stats per table (mirrors `loadDocuments`, 2000-char column cap) |
| `survey/semantic-engine-probe/s02-embed-probe.ts` | TS helper — times long-input embedding (truncation evidence, keyed lines) |
| `survey/semantic-engine-probe/s03-eval-body.sh` | Bounded `semantic-eval --documents body` run (timeout-guarded, `RESULT=pass\|fail`) |
| `survey/semantic-engine-probe/run-probe.sh` | Orchestrator — runs s01 → s02 → s03 sequentially |
| `verify-rules-declarative.sh` | Scans `.opencode/rules/*.md` for non-declarative directive forms (`must`/`should`/`never`/`do not`/`always`/`avoid`/`!`); strips quoted examples and entity-ID refs; keyed stdout, exit 1 on violations |
```

## Conventions

- Naming — stage scripts `s{NN}-{verb}-{noun}.sh`; orchestrators `run-{noun}.sh`
- Atomic units — one task per script (per `MAX.ATOMIC.CONCERN`); the orchestrator composes
- Keyed stdout — stages emit `KEY=value` lines for downstream consumers (per `NEX.ACQUIRE.PIPELINE`)
- Root resolution — `ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"` from survey depth; adjust per script depth
- Purity contract — TS helpers declare `// exports:`, `// purity:`, `// depends-on:` (per `PROT.LIB.CONTRACT`); pure formatting stays out of I/O modules
- Dependencies — scripts use stdlib + `sqlite3`; TS helpers resolve `@huggingface/transformers` from `.opencode/node_modules` (upward walk)
- Project rule — a directory with its own AGENTS.md counts as a project; read it before working inside (per `RUL.PROJECT.DELEGATION`)

## Survey

Workflows under `survey/` follow `{qualifier}-{subject}/` with 1-4 stage scripts each. New surveys scaffold: create the folder, write atomic stage scripts, write an orchestrator, run through `bitacora-log.sh`, report under `.opencode/_bitacora/`
