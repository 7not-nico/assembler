Every command output pipes into `_bitacora/task-stdout/` logs. The log wrapper (`bitacora-log.sh` / `run-logged.sh`) writes the timestamped file with a `# CMD:` header, streams output live, and appends the exit status.

Scope: command-level. Applies to every command the agent runs. Reports reference each log file.

Composes with `RUL.WORKFLOW.PRINCIPLE` — one of 11 workflow principles.
