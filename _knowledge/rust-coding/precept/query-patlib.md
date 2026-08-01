Before any task, query patlib via `patlib_search`/`patlib_get`/`patlib_validate` (mcp-patlib) for entity context. Default to patterns, terms, and maxims when task scope unknown.

Scope: session-level. Resets per task.
Fallback: use `read-selection` / `read-projection` Custom IPC tools when MCP unavailable.
Composes with: `RUL.QUERY.PATLIB.CONTEXT`
