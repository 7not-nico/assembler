Every task begins with `patlib_vector_search` (mcp-patlib-vector) for semantic search, then `patlib_search` (mcp-patlib) for keyword/tag queries against `patlib.db`.

Rule: `patlib_vector_search` via mcp-patlib-vector precedes `patlib_search` — semantic search finds entities by meaning when keyword/tag queries miss them. Querying all active patterns, protocols, and terms serves as the default when task scope is unknown.

Scope: session-level, resets per task.

Fallback: Custom IPC tools `read-selection` / `read-projection` take over when MCP server unavailable.

Composes with `RUL.WORKFLOW.PRINCIPLE` — one of 11 workflow principles.
