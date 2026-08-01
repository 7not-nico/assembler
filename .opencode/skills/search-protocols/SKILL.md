---
name: search-protocols
description: Use this skill when searching protocol entities — it queries patlib for protocols by keyword, tag, semantic match, or full-text, then resolves full contract details via read-projection or patlib_get
state-profile: stateless
related: ["PROT.SKILL.SCHEMA", "PROT.META.IDENTITY", "PROT.SEARCH.QUERY"]
---
**Procedure**

1. **Keyword/tag search** — `patlib_search { type: "protocols", query?, tag? }` for exact matches on ID, title, tags
2. **Semantic search** — `patlib_vector_search { mode: "hybrid", type: "protocols", query }` for concept-level matching (3–7 word query per RUL.VECTOR.QUERY.HYBRID)
3. **Exact ID lookup** — `patlib_vector_search { mode: "keyword", type: "protocols", query }` for known entity names per RUL.VECTOR.QUERY.KEYWORD
4. **Full detail** — `read-projection { type: "protocols", id }` or `patlib_get { id, type: "protocols" }` for complete contract body

**Fields** — protocol entities carry: `id`, `title`, `protocol` (core contract statement), `enforcement` (Tool/Convention/Review), `status` (active/draft/deprecated), `priority` (1–5), `tags`, `related`. The `protocol:` frontmatter field is the authoritative contract — body text contains supplementary rules and gotchas.

**Rules**

- Protocol body column is empty — content lives in `protocol:` frontmatter. Semantic search may under-index protocol content per PROT.SEARCH.EMBEDDING
- `patlib_search type: "protocols"` filters by type; omit type for cross-type search
- After finding results, inspect the full protocol via `read-projection` before applying its rules — the `protocol:` field and `## Protocol` section contain the actionable contract
- Fall back to `read-selection { type: "protocols" }` when MCP servers unavailable per RUL.USE.LOCAL.MCP.SERVERS

**Gotchas**

| Signal | Detection | Redirect |
|--------|-----------|----------|
| Protocol body empty | `read-projection` returns short body section | Check `protocol:` frontmatter field — that is the authoritative content |
| patlib_search returns default terms | Type flag omitted — `patlib_search` defaults to `terms` | Always pass `type: "protocols"` explicitly |
| Semantic search misses protocol content | Vector search returns low scores for protocol queries | Use `patlib_search` keyword or `patlib_vector_search mode: "keyword"` — FTS5 indexes the protocol column |
| MCP server unreachable | `patlib_search` call fails | Fall back to `read-selection { type: "protocols" }` Custom IPC tool |
