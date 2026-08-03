# Bash Flows

**Route** — turn manual or repeated workflow steps into atomic, programmatically managed bash flows: detect the flow, scaffold atomic scripts, compose orchestrators, pipe through bitacora logging.

**Target** — load `manage-bash-flows` before scripting multi-step work.

**Notes**

- Detect the flow — list the manual steps in order, one script per step.
- Separate phases per `NEX.META.ORCHESTRATION` — complete all reads before any write.
- Scaffold from `_templates/atomic-script-template.sh` — keep the contract header.
- Compose the orchestrator per `NEX.ACQUIRE.PIPELINE` — feed keyed lines forward, stop on failure.
- Pipe every command through the log wrapper — `run-logged.sh` or `bitacora-log.sh`.
