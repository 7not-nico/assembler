`patlib_search`, `patlib_get`, `patlib_validate` (mcp-patlib) and `spec_audit`, `spec_audit_file` (mcp-spec-audit) carry entity access over manual entity file inspection or ad-hoc queries.

Scope: session-level. MCP tools take precedence over manual inspection.

Custom IPC tools (`read-selection`, `read-projection`) take over when MCP server unavailable.

Composes with `RUL.WORKFLOW.PRINCIPLE` — one of 11 workflow principles.
