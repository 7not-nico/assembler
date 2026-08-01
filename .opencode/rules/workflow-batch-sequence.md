Multiple task aspects process one at a time in bounded batches; atomic procedures sequence before parallel initiation of distinct aspects.

Scope: task-level. Applies when a task requires two or more distinct aspects. Independent tool calls within one aspect run in parallel; the sequencing constraint bounds aspect transitions, not call batching.

Composes with `RUL.WORKFLOW.PRINCIPLE` — one of 11 workflow principles.
