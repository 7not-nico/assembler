# mise-tasks.md

**Source:** https://mise.jdx.dev/tasks/ + /tasks/task-configuration + /tasks/toml-tasks (2026-07-31), 2026.7.0
**Method:** parallel-search web_fetch excerpts

## Extract (verbatim)

> "You can define tasks in `mise.toml` files or as standalone shell scripts. These are useful for things like running linters, tests, builders, servers… tasks launched with mise will include the mise environment—your tools and env vars defined in `mise.toml`."

> "My favorite features about mise's task runner: building dependencies in parallel—by default with no configuration required; last-modified checking to avoid rebuilding when there are no changes—requires minimal config; `mise watch` to automatically rebuild on changes—no configuration required, but it helps"

> "Tasks are defined in the `[tasks]` section of the `mise.toml` file. [tasks.build] description = 'Build the CLI' run = 'cargo build'. You can then run the task with `mise run build` (or `mise build` if it doesn't conflict with an existing command)."

> "Environment variables passed to tasks: MISE_ORIGINAL_CWD — The original working directory from where the task was run. MISE_CONFIG_ROOT — The directory containing the `mise.toml` file where the task was defined… MISE_MONOREPO_ROOT — The root of the monorepo (the directory containing the config with `monorepo_root = true`). Only set inside a monorepo. MISE_TASK_NAME — The name of the task being run. MISE_TASK_DIR — The directory containing the task script. MISE_TASK_FILE — The full path to the task script."

> "depends: Tasks that must be run before this task. This is a list of task names or aliases. Arguments can be passed to the task, e.g.: `depends = ["build --release"]`. If multiple tasks have the same dependency, that dependency will only be run once. mise will run whatever it can in parallel (up to --jobs) through the use of `depends` and related properties."

> "depends_post: Like `depends` but these tasks run _after_ this task and its dependencies complete. For example, you may want a `postlint` task that you can run individually without also running `lint`."

> "wait_for: Similar to `depends`, it will wait for these tasks to complete before running. Unlike `depends`, `wait_for` does not add matching tasks to the run; it only waits for them when they are already scheduled."

> "tools: Tools to install and activate before running the task. This is useful for tasks that require a specific tool to be installed or a tool with a different version. It will only be used for that task, not dependencies."

> "sources: Files or directories that this task uses as input, if this and `outputs` is defined, mise will skip executing tasks where the modification time of the oldest output file is newer than the modification time of the newest source file."

> "cache: experimental — The cache key includes source contents, the task definition and arguments, resolved task environment, the values (or absence) of variables named in `cache.env`, command-input output, resolved tool versions, dependency artifact keys, and the operating system and architecture."

> "usage: More advanced usage specs can be added to the task's `usage` field. This only applies to toml-tasks. [tasks.test] usage = 'arg "<file>" help="The file to test" default="src/main.rs"' run = 'cargo test ${usage_file?}'"

> "Using Tera template functions (arg(), option(), flag()) in run scripts is deprecated and will be removed in mise 2027.5.0. Versions >= 2026.5.0 will show a deprecation warning. Please migrate to using the `usage` field instead."

> "Monorepo: mise supports monorepo-style task organization with target path syntax. Enable it by setting `monorepo_root = true` in your root `mise.toml`."

> "task_config.includes: Remote Git Includes experimental — URL format: `git::<protocol>://<url>//<path>?ref=<ref>`; Required: protocol (ssh or https), url, path; Optional: ref (branch, tag, commit)."

> "task.output: prefix – (default if jobs > 1) print by line with the prefix of the task name; interleave – (default if jobs == 1 or all tasks run sequentially) print output as it comes in. Choices: prefix, interleave, keep-order, replacing, timed, quiet, silent."

## Claims surfaced

| # | Claim | Concept |
|---|-------|---------|
| 1 | Tasks in [tasks] or standalone scripts; mise env included | concepts/task-runner.md |
| 2 | depends/depends_post/wait_for ordering + parallel | concepts/task-dependencies.md |
| 3 | sources/outputs up-to-date skip; cache experimental | concepts/task-caching.md |
| 4 | usage field replaces deprecated Tera functions | concepts/task-arguments.md |
| 5 | monorepo_root + remote git includes | concepts/task-runner.md |

## Feeds

- concepts/task-runner.md, concepts/task-dependencies.md, concepts/task-caching.md, concepts/task-arguments.md
- reference/site-citations.md
