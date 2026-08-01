# Bitacora Tooling

Status: completed (2026-08-01)

## Tasks

- [x] repurpose `_codex/_templates/shell/` templates for bitacora records
- [x] write `bitacora-init.sh` (skeleton + README, from copy-templates.sh)
- [x] write `bitacora-slugify.sh` (slug helper, from slugify.sh)
- [x] write `bitacora-create.sh` (record scaffolder, from scaffold-knowledge.sh)
- [x] write `bitacora-log.sh` (task-stdout logging, from run-logged.sh)
- [x] test all four: init, slug, create, log (exit propagation verified)
- [x] write task report via `bitacora-create.sh report`

## Context

- Source: `_codex/_templates/shell/` — 8 templates, 4 repurposed
- Home: `.opencode/_bitacora/` per user instruction
- Convention: todo `{YYYY-MM-DD}--{slug}.md`, others `{YYYYMMDD}-{HHMMSS}-{slug}.md`
- Open edge: tools normally live in `.opencode/tools/`; placement here is user-directed
