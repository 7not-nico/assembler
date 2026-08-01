# task-arguments.md

Task arguments define the CLI interface of a task via the `usage` field (TOML tasks only).

`usage` spec: `arg "<file>" help="..." default="src/main.rs"`; flags `flag "-p --profile <profile>" env="BUILD_PROFILE"`. Values available as `${usage_file?}` in run scripts and `{{usage.file}}` templates. Env vars can satisfy required args. **Tera template functions (arg(), option(), flag()) in run scripts are deprecated — removed in 2027.5.0; migrate to `usage` field.** `raw_args` bypasses mise's usage parser (e.g. `mise run task -- --help`).

## Grounding

| Research capture | Key claim |
|------------------|-----------|
| research/mise-tasks.md | "More advanced usage specs can be added to the task's usage field. This only applies to toml-tasks" |
| research/mise-tasks.md | "Using Tera template functions (arg(), option(), flag()) in run scripts is deprecated and will be removed in mise 2027.5.0" |
| research/mise-tasks.md | env var support for args/flags |

## Sub-concepts

- task-runner (parent)

## Distilled into

- note/ch05-tasks.md

## Precedes

(leaf)
