---
description: Back up files before editing them, preserving directory structure with timestamped snapshots
subtask: true
---

Back up for `$ARGUMENTS`

1. Identify the file path(s) to be edited, relative to project root
2. Generate timestamp — `$(date +%Y-%m-%dT%H%M%S)`
3. Create backup path — `.opencode/backups/{timestamp}/{relative-path}`
4. Copy each file — `mkdir -p "$(dirname "$backup_path")" && cp "$source" "$backup_path"`
5. Proceed with edit
