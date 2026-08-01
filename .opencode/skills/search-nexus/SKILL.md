---
name: search-nexus
description: Use this skill when searching nexus entities — it queries patlib for nexi by keyword, tag, or semantic match, then resolves the composition chain and related entities via read-projection
state-profile: stateless
related: ["PROT.SKILL.SCHEMA", "MAX.ENTITY.ONTOLOGY", "PROT.SEARCH.EMBEDDING", "PROT.TOOL.MORPHISM"]
---
**Procedure**

1. **Keyword/tag search** — `patlib_search { type: "nexus", query?, tag? }` — nexi tagged by domain (pipeline, workflow, composition, seed, acquisition)
2. **Semantic search** — `patlib_vector_search { mode: "hybrid", type: "nexus", query }` for composition-level matching (3–7 word query per RUL.VECTOR.QUERY.HYBRID)
3. **Exact ID** — `read-projection { type: "nexus", id }` or `patlib_get { id, type: "nexus" }` — shows full nexus body, composition chain, and related entities
4. **Cross-reference** — for a given pattern or entity, search nexi that reference it: `patlib_search { type: "nexus", query: "PAT.FOO" }` or `read-selection { type: "nexus", query: "PAT.FOO" }`

**Fields** — nexus entities carry: `id` (NEX.*), `title`, `summary`, `nexus` (composition description), `composition` (morphism chain), `status`, `tags`, `related`. The `nexus:` field describes the composition role; `composition:` field maps the morphism chain.

**Rules**

- Nexus entities bind morphisms into compositions per MAX.ENTITY.ONTOLOGY — they are the highest architectonic entity after maxims (Ring 3)
- Composition flows outer→inner: the outer nexus cites the inner entities it composes per MAX.ENTITY.ONTOLOGY Rule 49
- Search by tag when looking for domain-specific compositions (e.g. `tag: "pipeline"`, `tag: "seed"`, `tag: "acquisition"`)
- After finding a nexus, run `read-projection` on each entity in its composition chain to understand the full morphism graph
- Composition graphs must remain acyclic per PROT.TOOL.MORPHISM Rule 6
- Fall back to `read-selection { type: "nexus" }` when MCP unavailable per RUL.USE.LOCAL.MCP.SERVERS

**Gotchas**

| Signal | Detection | Redirect |
|--------|-----------|----------|
| patlib_search returns no nexus results | `type` flag omitted or `nexus` unsupported by tool | Use `read-selection { type: "nexus" }` Custom IPC as fallback — supports nexus type |
| Composition chain has cycle | Traversing `composition:` field returns to a visited entity | Flag as cycle — composition graphs must be DAGs per PROT.TOOL.MORPHISM |
| Nexus misinterpreted as pattern | `NEX.*` prefix confused with `PAT.*` | Distinguish by prefix — `NEX.*` for compositions (binds morphisms), `PAT.*` for morphism prescriptions |
| Entity in composition chain unresolvable | `read-projection` on composition entity returns nonexistent | Flag broken reference — the entity may be deleted or reclassified per MAX.ENTITY.RECLASSIFY |
| MCP server unreachable | `patlib_search` call fails | Fall back to `read-selection { type: "nexus" }` Custom IPC tool |
