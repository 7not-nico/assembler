# task-caching.md

Task caching skips execution when sources haven't changed — up-to-date check via last-modified comparison.

`sources` + `outputs` defined → mise skips when oldest output is newer than newest source. `!` excludes patterns, `\!` escapes literal bang, `outputs = { auto = true }` default with sources. Dependency invalidation: dep re-runs → dependent re-runs. Experimental `cache` property: key includes source contents, task def/args, env, cache.env values, command_inputs output, tool versions, dep artifact keys, OS/arch. `task_config.cache` scoped default; `task_config.input_groups` reusable `@group:` sources; `task_config.global_inputs` applies to all tasks.

## Grounding

| Research capture | Key claim |
|------------------|-----------|
| research/mise-tasks.md | "mise will skip executing tasks where the modification time of the oldest output file is newer than the modification time of the newest source file" |
| research/mise-tasks.md | "The cache key includes source contents, the task definition and arguments… and the operating system and architecture" |
| research/mise-tasks.md | dependency invalidation |

## Sub-concepts

- task-runner (parent)

## Distilled into

- note/ch05-tasks.md

## Precedes

(leaf)
