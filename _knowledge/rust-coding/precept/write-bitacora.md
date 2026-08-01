Every session writes a bitacora entry to `bitacora/{number}-{description}.md`. Entry includes date, session overview, completed items, key decisions, open edges.

Scope: session-level. Trigger on session end.
Fallback: none — bitacora is obligatory.
Composes with: precedence chain — `note/` → `bitacora/` → `glossary/` → `reference/` → `fixtures/`
