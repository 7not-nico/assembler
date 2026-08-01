# task-runner.md

The task runner executes project tasks defined in `[tasks]` or standalone scripts, with the full mise environment (tools + env) active.

Run via `mise run {task}` (or `mise {task}` if no command conflict). Tasks inherit tools/env from mise.toml. Task env vars: MISE_ORIGINAL_CWD, MISE_CONFIG_ROOT, MISE_MONOREPO_ROOT (monorepo only), MISE_TASK_NAME, MISE_TASK_DIR, MISE_TASK_FILE. Parallel dependency building by default. Monorepo support via `monorepo_root = true` + target path syntax; remote git includes (`git::<proto>://<url>//<path>?ref=<ref>`).

## Grounding

| Research capture | Key claim |
|------------------|-----------|
| research/mise-tasks.md | "tasks launched with mise will include the mise environment—your tools and env vars" |
| research/mise-tasks.md | "building dependencies in parallel—by default with no configuration required" |
| research/mise-tasks.md | MISE_* task env vars |
| research/mise-tasks.md | monorepo_root + git includes |

## Sub-concepts

| # | Sub-concept | Anchored by |
|---|-------------|-------------|
| 1 | task-dependencies | research/mise-tasks.md |
| 2 | task-caching | research/mise-tasks.md |
| 3 | task-arguments | research/mise-tasks.md |

## Distilled into

- note/ch05-tasks.md

## Precedes

task-dependencies, task-caching, task-arguments
