---
name: search-maxims
description: Use this skill when searching maxim entities — it queries patlib for maxims by keyword, tag, or semantic match, then resolves full maxim body via read-projection or patlib_get
state-profile: stateless
related: ["PROT.SKILL.SCHEMA", "PROT.MAXIM.SCHEMA", "MAX.PRECEDENCE.DERIVATION", "PROT.SEARCH.QUERY"]
---
**Procedure**

1. **Keyword/tag search** — `patlib_search { type: "maxims", query?, tag? }` — maxims tagged by domain (architecture, quality, tooling, batch, entity)
2. **Semantic search** — `patlib_vector_search { mode: "hybrid", type: "maxims", query }` for principle-level matching (3–7 word query per RUL.VECTOR.QUERY.HYBRID)
3. **Exact ID lookup** — `patlib_vector_search { mode: "keyword", type: "maxims", query: "MAX.DRY" }` — use keyword mode for known entity names per RUL.VECTOR.QUERY.KEYWORD
4. **Full detail** — `read-projection { type: "maxims", id }` or `patlib_get { id, type: "maxims" }` for complete body with rules, applicability, and see-also

**Fields** — maxims carry: `id` (MAX.*), `title`, `summary`, `principle` (aphoristic statement), `enforcement`, `priority` (1–5), `tags`, `status`. Maxims are Ring 0 architectonic — the highest-level guidance per MAX.KNOWLEDGE.CLASSIFICATION.

**Rules**

- Maxims are Ring 0 per MAX.KNOWLEDGE.CLASSIFICATION — they ground all other entity types. Read maxims before protocols per outer→inner reasoning
- `priority` field signals application order: 1=foundational (DRY, ORTHOGONALITY), 5=situational
- After search, inspect the full maxim body via `read-projection` — the `## Rules` section contains the operational interpretation
- Some maxims derive from external inspirations (`source: INSP.PRAGMATIC`) — check `source` field for origin attribution
- Fall back to `read-selection { type: "maxims" }` when MCP unavailable per RUL.USE.LOCAL.MCP.SERVERS

**Gotchas**

| Signal | Detection | Redirect |
|--------|-----------|----------|
| Maxim ID misidentified as pattern | `MAX.*` prefix confused with `PAT.*` | Distinguish by prefix — `MAX.*` for maxims (Ring 0), `PAT.*` for patterns (Ring 5) |
| patlib_search returns no maxims | `--type maxims` flag omitted — default returns terms | Always pass `type: "maxims"` explicitly |
| Low-priority maxim applied before high-priority | `priority: 5` rule applied before `priority: 1` rule | Order application by priority — 1 before 5 per MAX.PRECEDENCE.DERIVATION |
| MCP server unreachable | `patlib_search` call fails | Fall back to `read-selection { type: "maxims" }` Custom IPC tool |
