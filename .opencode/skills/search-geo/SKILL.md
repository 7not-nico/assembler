---
name: search-geo
description: Use this skill when searching research across geographic or language regions — it assesses, fetches, and compiles an indexed manifest from results
state-profile: hybrid
related: ["SKL.AUDIT.CROSSREF", "SKL.PROPOSE.INVESTIGATION", "SKL.ORCHESTRATE.RESEARCH"]
patterns: ["NEX.INVESTIGATION.PIPELINE.STAGE"]
---
**Procedure**

**0. Bootstrap** — create investigation directory
- Create `.opencode/investigations/{topic}/`
- Create `.opencode/investigations/{topic}/raw/` for per-region results

**1. Scope** — define region list and search parameters
- One region per round — language group or country cluster
- Set query per region — include native-language terms + domain filters
- Set max results per query (default 10), max fetches per query (default 5)

**2. Search** — run per region
- `exa_web_search_exa` — natural language query with native terms + domain suffix filters
- Record per result: title, URL, institution, language, snippet
- Rate per-query: PASS (≥5 relevant), WARN (1–4 relevant), FAIL (0 relevant)

**3. Assess** — per-query quality gate
- PASS → proceed to fetch
- WARN → refine query with alternative terms, retry once
- FAIL → skip region, log to gaps list

**4. Fetch** — full text from top N results
- `exa_web_fetch_exa` — batch URLs, maxCharacters 5000 per source
- On fetch error: log error code, note for retry
- On wrong content: log as misdirect, search for correct URL

**5. Synthesize** — per region
- Write to `raw/{region}.md` — full results: queries, PASS/WARN/FAIL rating, fetched sources table, per-region gaps
- Table format: source, country, institution, key content, methodology
- Note language of publication
- Flag gaps at region level

**6. Source audit** — quality gate before compilation
- List every source by domain suffix: .edu / .ac.* / .gov / .org-academic vs .com / .org-commercial / unknown
- For each commercial source, run a `exa_web_search_exa` replacement query (3–5 terms) with `site:.edu` or `site:.ac.*` filter targeting the same finding
- Academic equivalent found — replace commercial entry. Log replacement in gap notes
- Academic equivalent absent after 2 attempts — keep entry. Flag as `[commercial — academic equivalent absent]` in source table
- Calculate commercial-source ratio: `commercial_count / total_sources`
- Compilation: blocked when commercial ratio exceeds 30% — tag region as COMMERCIAL-HEAVY and return to Step 2 (Search) with stricter domain filters for that region

**7. Compile** — aggregate into indexed manifest
- Write to `.opencode/investigations/{topic}/meta-audit.md`
- Sections: Fundamentals, Meta-analyses, By Region, Gaps, Key Researchers by Region
- Each entry: source, key findings, methodology, sample, country, institution, DOI/URL

**8. Schema** — derive database schema and seed data from manifest
- Create `raw/schemas/db.sql` — one CREATE TABLE per entity. Shared entities (regions, researchers, gaps, meta_analyses) plus one per-anchor `{anchor}_sources` table with domain-specific columns (e.g., `model_type`, `primitives_covered`)
- Create `raw/schemas/{anchor-name}.sql` — one seed file per decomposed anchor. Each contains INSERT for its anchor, region data, researchers, and its anchor-specific sources table. Shared tables seeded once across files
- Tables use TEXT PRIMARY KEY for id-based lookup, INTEGER PRIMARY KEY AUTOINCREMENT for event-log tables
- Follow additive migration pattern — ALTER TABLE ADD COLUMN; DROP excluded

**9. Review** — validate completeness
- Check gap list — which regions returned nothing
- Check cross-cutting gaps — themes absent across all regions
- Flag underexplored intersections for future work

**Gotchas**

- Query quality determines result quality — use native-language terms. English-only translations insufficient
- Domain filters narrow to national research. English-language international journals from same country excluded from domain filter — supplement with topical queries
- Some regions publish in English under .com/.org — supplement domain filters with topical queries
- Fetch may fail on paywall sources — note DOI for manual retrieval
- WARN on first query is normal — one refinement round expected
- Log every search to `mcp-log-search` for audit trail
- Commercial sources (.com) lack academic peer review — prefer .edu, .ac.*, and institutional equivalents
- Source audit may fail independently per region — a PASS region can still be blocked at compile if commercial ratio exceeds threshold

**Rules**

**Per-query**
- One region per round — multi-region queries excluded
- Status labels: PASS / WARN / FAIL / SKIP — consistent usage in output
- Source limit per region: 10 max search, 5 max fetch
- Gap regions go in manifest — absence reports as finding
- All fetched URLs recorded in manifest for reproducibility
- Each region writes `raw/{region}.md` before compile

**Source quality**
- Academic sources preferred: .edu, .ac.*, institutional. Commercial sources (.com) secondary
- Commercial-only refs replaced with academic equivalents when available — log replacements to gap notes
- Commercial ratio > 30% blocks compilation — re-search region with stricter domain filters
- Academic-equivalent search attempt logged for every commercial source before retention

**Structure**
- Investigation root: folder `{topic}/` with `meta-audit.md` + `raw/`. File-root excluded
