## TODO-auto-sync-misses-agent-writes

Fix `auto-sync.ts` — add `tool.execute.after` handler so agent Write/Bash tool calls to term/protocol files trigger patlib sync.

### Finding

`auto-sync.ts` registers only `file.edited` hook. When the agent writes a term or protocol `.md` file via the Write tool, the file lands on disk but no sync fires. The patlib DB becomes stale until the agent explicitly calls `write-sync`. 

Comparison: `audit-events.ts` and `ref-integrity.ts` both register `file.edited` + `tool.execute.after` — they catch both manual and agent-driven changes. `auto-sync` is the odd plugin out.

### Changes

- Add `tool.execute.after` handler to `auto-sync.ts` that runs the same sync logic
- Filter `tool.execute.after` to relevant tool names (Write tool, or broader agent file-writing tools)
- Keep `file.edited` for manual editor saves
- Keep existing debounce for both hooks

Also update `ILL.PLUGIN.CANDIDATE.SCORING` which references `auto-sync` with `file.edited` only — note the gap or mark as resolved after fix.

### Verification

- Agent writes a term file via Write tool → `tool.execute.after` fires → `syncAll` runs
- User edits a term file in opencode editor → `file.edited` fires → `syncAll` runs
- Both paths logged

### Priority

high — data integrity: terms/protocols go out of sync on every agent write
