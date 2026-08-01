# task-dependencies.md

Task dependencies order execution: depends (before), depends_post (after), wait_for (wait only, no scheduling).

`depends` — tasks run before; args/env can be passed; shared deps run once; parallel up to --jobs. `depends_post` — run after task + deps complete (e.g. postlint). `wait_for` — waits for scheduled tasks without adding them. Structured deps: `{ task, args?, env?, optional? }`; parent args forwarded via `{{usage.*}}` templates. Optional deps: `{ task = "//...:test", optional = true }`.

## Grounding

| Research capture | Key claim |
|------------------|-----------|
| research/mise-tasks.md | "depends: Tasks that must be run before this task" |
| research/mise-tasks.md | "depends_post: Like depends but these tasks run after this task and its dependencies complete" |
| research/mise-tasks.md | "wait_for does not add matching tasks to the run" |

## Sub-concepts

- task-runner (parent)

## Distilled into

- note/ch05-tasks.md

## Precedes

(leaf)
