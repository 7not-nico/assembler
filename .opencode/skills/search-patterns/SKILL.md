---
name: search-patterns
description: Use this skill when searching pattern entities — it queries patlib for patterns by keyword, tag, semantic match, or full-text, then resolves full pattern details via read-projection or patlib_get
state-profile: stateless
related: ["PROT.SKILL.SCHEMA", "PROT.SEARCH.QUERY", "PROT.SEARCH.EMBEDDING"]
---
**Procedure**

1. **Keyword/tag search** — `patlib_search { type: "patterns", query?, tag? }` for exact matches on ID, title, tags
2. **Semantic search** — `patlib_vector_search { mode: "hybrid", type: "patterns", query }` for concept-level matching (3–7 word query per RUL.VECTOR.QUERY.HYBRID)
3. **Exact ID lookup** — `patlib_vector_search { mode: "keyword", type: "patterns", query }` for known entity names per RUL.VECTOR.QUERY.KEYWORD
4. **Full detail** — `read-projection { type: "patterns", id }` or `patlib_get { id, type: "patterns" }` for complete body including rules and applicability

**Fields** — pattern entities carry: `id` (PAT.*), `title`, `summary`, `principle` (actionable guidance), `enforcement`, `status` (active/draft), `priority` (1–5), `tags`. The `principle:` field contains the actionable guidance — what TO do.

**Rules**

- Pattern text composition: title×4 + summary×3 + principle×2 + body×1 per PROT.SEARCH.EMBEDDING
- Filter by `status: active` when production-only results needed — draft patterns may have incomplete content
- After search, inspect the full pattern via `read-projection` — the `## Rules` section contains numbered operational rules
- Fall back to `read-selection { type: "patterns" }` when MCP unavailable per RUL.USE.LOCAL.MCP.SERVERS

**Gotchas**

| Signal | Detection | Redirect |
|--------|-----------|----------|
| Draft pattern used for production | `status: draft` in results | Filter `status: active` — draft patterns may have incomplete or unvalidated content |
| Enforcement tool absent | `enforcement: Tool`; tool file absent | Verify `.opencode/tools/` contains the named tool — absent tool means manual enforcement |
| patlib_search returns no results | Search returns empty array | Broaden query — remove filter, use shorter terms, or switch to hybrid semantic mode |
| MCP server unreachable | `patlib_search` call fails | Fall back to `read-selection { type: "patterns" }` Custom IPC tool |
