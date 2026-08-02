Multiple task aspects process one at a time in batches with bounds; atomic procedures sequence before distinct aspects start in parallel.

Scope: task-level. Applies when a task requires two or more distinct aspects. Independent tool calls within one aspect run in parallel; the order constraint bounds aspect transitions and leaves call batches parallel.

Composes with `RUL.WORKFLOW.PRINCIPLE` — one of 11 workflow principles.
