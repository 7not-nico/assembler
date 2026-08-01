## TODO-terminology-hooks-and-fswatch

Update `TERM.OPENCODE.PLUGIN` with explicit hook list, and promote `TERM.FS.WATCH` from backup to active entity.

### Finding

**TERM.OPENCODE.PLUGIN** — describes plugins as responding to "session/file/permission events" without listing available hooks. The three-tier model requires naming each hook (`file.edited`, `tool.execute.before`, `tool.execute.after`, `shell.env`) with their trigger scopes.

**TERM.FS.WATCH** — exists only in `_backups/entity-backups/terms/TERM.FS.WATCH.md`. No active term defines `fs.watch`, yet it's the third pillar of the event detection model. Without it, the entity system has no formal definition for filesystem-level change monitoring distinct from plugin hooks.

### Changes

- **TERM.OPENCODE.PLUGIN** — add a "Lifecycle hooks" section listing each available hook and its trigger scope:
  - `file.edited` — opencode editor manual save (NOT agent Write/Bash)
  - `tool.execute.before` — before any agent tool execution
  - `tool.execute.after` — after any agent tool execution
  - `shell.env` — shell environment injection

- **TERM.FS.WATCH** — promote from backup to `.opencode/entities/terms/TERM.FS.WATCH.md`. Define it as "filesystem-level change notification via OS kernel (inotify on Linux). Detects write/rename/delete events from any source — unlike plugin hooks which are scoped to specific trigger paths." Distinguish from `file.edited` and `tool.execute.after` in the definition.

### Priority

high — missing term definitions leave the three-tier model ungrounded in the entity system

### Verification

- `read-selection --type terms --query "fs.watch"` returns the active term
- `read-projection --type terms --id TERM.OPENCODE.PLUGIN` shows the hooks list
