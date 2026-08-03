# Bitacora — knowledge record area

Records follow the `{?}-{concrete noun}` convention. Todo precedes work; report follows completion; both stay open while working. Every command output pipes into `task-stdout/`.

| Folder | Content |
|--------|---------|
| `task-todo/` | persistent task lists, `{YYYY-MM-DD}--{slug}.md` |
| `task-report/` | factual records, `{YYYYMMDD}-{HHMMSS}-{topic}.md` |
| `task-stdout/` | command logs from bitacora-log.sh / run-logged.sh |

## Tooling

| Script | Purpose |
|--------|---------|
| `bitacora-log.sh {name} -- {cmd}` | run a command, log output to task-stdout/ |
| `bitacora-create.sh {kind} {topic}` | scaffold a todo or report record |
| `bitacora-close.sh {todo} {topic}` | complete a todo, scaffold its report |
| `bitacora-find.sh {regex}` | locate records by topic with status |
| `bitacora-init.sh` | ensure the record skeleton exists |

Subprojects write command logs here through `script/run-logged.sh`; this folder hosts the shared record tooling.
