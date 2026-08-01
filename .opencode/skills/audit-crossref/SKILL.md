---
name: audit-crossref
description: Use this skill when running a full cross-region research audit — sweeps regions, fetches sources, compiles manifest. References NEX.INVESTIGATION.PIPELINE.STAGE for pipeline stages and SKL.SEARCH.GEO for search procedure
state-profile: hybrid
related: ["SKL.SEARCH.GEO", "SKL.AUDIT.INVESTIGATION", "NEX.INVESTIGATION.PIPELINE.STAGE"]
patterns: ["NEX.INVESTIGATION.PIPELINE.STAGE"]
---

**Procedure**

0. Determine topic — natural language query string, region list, per-region domain filters and native-language terms.

1. Search per region — `exa_web_search_exa` with native terms + domain filters, record title/URL/institution/language/snippet. Rate each query: PASS (5+ relevant) to fetch, WARN (1-4) to refine and retry once, FAIL to log to gaps and skip.

2. Fetch top results — `exa_web_fetch_exa` max 5 per region, maxCharacters 5000, log errors and misdirects.

3. Synthesize per region — structured format of sources with country, institution, key content, methodology, sample, language, year, tags. No tables — use bullet lists per RUL.STRUCTURAL.PREFERENCE.

4. Write manifest — `.opencode/investigations/{topic}-{scope}.md`, rule-format body, YAML back matter with `---` on both sides. Body: bold finding line, Pattern, Implication, Data. Raw source tables, prose, and `##` headers excluded. Back matter: id, title, summary, tags (inline array), tables (inline array).

5. Write schema — `schemas/db.sql`, 6 tables (regions, sources, researchers, meta_analyses, gaps, fundamentals). All TEXT PRIMARY KEY, single FK on sources.region_id, additive only.

6. Write seed — `schemas/seed.sql`, one INSERT per table, multi-row VALUES. Source IDs prefixed by region code, MA. for meta-analyses, GAP. for gaps, tags comma-joined.

7. Review — match manifest summary counts to seed row counts, check gaps list, verify back matter fields and delimiters.

**Gotchas**

- Region IDs are two-letter uppercase — always use uppercase in queries
- ZPD theory sources use ZPD. prefix, meta-analyses use MA. prefix, gaps use GAP. prefix
- Tags are comma-joined strings — grep for substring, verify context
- Schema additive only — ALTER TABLE ADD COLUMN. DROP excluded
- Back matter tags and tables use YAML inline arrays — [value1, value2]. Comma-joined excluded
- Manifest body must fit one screen — consensus only, no raw data tables
- Seed INSERTs must be executable SQLite — test with `sqlite3 :memory: < seed.sql`
- Commercial-only sources (.com) are a validation risk — flag entries with no academic equivalent
- Per NEX.INVESTIGATION.PIPELINE.STAGE: pipeline stages are sequential — skip stage if prior stage fails

**Rules**

- Body: rule format — bold first line, directive lines only. Prose, examples, and `##` headers excluded
- Back matter: exactly five fields — id, title, summary, tags, tables
- Schema: exactly six tables — extra tables require corresponding manifest section
- Seed: one INSERT per table — multi-row VALUES, single statement per table
- Region codes: authoritative only — invented codes excluded
- All fetched URLs recorded in seed for reproducibility
- Key claims supported only by commercial sources — flag. Note absent academic equivalent
- Pipeline stages sequential per NEX.INVESTIGATION.PIPELINE.STAGE

**See also**

- `.opencode/commands/xresearch-geo.md` — trigger command
- `.opencode/skills/search-geo/SKILL.md` — lower-level search/fetch procedure
- `.opencode/entities/investigations/` — example outputs
