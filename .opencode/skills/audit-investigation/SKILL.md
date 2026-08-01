---
name: audit-investigation
description: Use this skill when auditing investigation meta-audit files — checks every *meta-audit.md under .opencode/entities/investigations/ for structural and semantic compliance. No IDENTITY.INVESTIGATION exists — references NEX.INVESTIGATION.PIPELINE.STAGE for pipeline convention
state-profile: stateful-auditor
related: [NEX.INVESTIGATION.PIPELINE.STAGE, SPEC.ENTITY.ROUTING.TABLE, SKL.SEARCH.GEO]
patterns: ["NEX.TOOL.SEQUENCE"]
---

**Procedure**

When auditing investigations:

1. **Load pipeline spec** — read `NEX.INVESTIGATION.PIPELINE.STAGE` via `read-projection`. Defines the investigation pipeline stages. No IDENTITY.INVESTIGATION exists — identity definition is a known gap.

2. **Locate** — find every `*meta-audit.md` under `.opencode/entities/investigations/`.

3. **Read** — load each investigation file.

4. **Check YAML** — `---` delimiters required before AND after block. Fields: `id`, `title`, `summary`, `tags`, `tables`. Location: front matter, back matter, or embedded mid-file.

5. **Check ID** — ID prefix `INV.` per SPEC.ENTITY.ROUTING.TABLE. Other valid prefixes vary by domain: `ZPD.`, `EN.`, `CN.`, `JP.`.

6. **Check opening** — bold line `**{Finding}** —` with em-dash.

7. **Check expanded sections** — `## Fundamentals`, `## Meta-analyses`, `## By Region`, `## Gaps` mandatory when expanded format. Optional: `## Per-Region Summary`, `## Key Researchers by Region`.

8. **Check IDs** — source IDs prefixed by region code; meta-analysis IDs prefixed `MA.`; gap IDs prefixed `GAP.`.

9. **Check schema dir** — verify sibling `schemas/` contains `db.sql` and `seed.sql`.

10. **Check db.sql** — 6 standard tables: regions, sources, researchers, meta_analyses, gaps, fundamentals.

11. **Check seed.sql** — one INSERT per table, multi-row VALUES, ID prefix pattern.

12. **Check gap status** — values: `native_surveys_absent`, `sources_absent`, `surfaced_disabled`, `searched_disabled`. Severity: `high`, `medium`, `low`.

13. **Check inline SQL** — flag SQL code blocks in body (extract to `schemas/`).

14. **Check duplicate IDs** — flag files sharing same `id` in YAML.

15. **Flag missing YAML** — files without YAML `id` excluded from cross-reference.

16. **Report per file** — violations with `file:line`.

17. **Summarize** — pass/fail count and score.

**Gotchas**

- YAML delimiter `---` required before AND after block — single delimiter excluded
- Two structural styles: **rule format** (bold finding + Pattern/Implication/Data + YAML block) and **expanded format** (bold finding + YAML block + `##` sections). Both valid
- Inline SQL in markdown body — flag for extraction to `schemas/`. Audit passes regardless — flag only, fail excluded
- Prefix convention varies by domain: `INV.` for investigations, `ZPD.` for ZPD audits, `EN.`/`CN.`/`JP.` for model-training
- `tables` field in YAML must match body section headers — flag mismatch
- `tags` uses inline array format — `[tag1, tag2]`; comma-joined strings excluded
- Schema at `investigations/schemas/` — each schema lives alongside its markdown per investigation
- No IDENTITY.INVESTIGATION exists — identity definition is a known gap. Until created, audit against NEX.INVESTIGATION.PIPELINE.STAGE and convention

**Rules**

- YAML block: 5 required fields (id, title, summary, tags, tables)
- Body opens with `**{Finding}** —` bold line
- Rule-format files may omit expanded sections
- Expanded-format files require `##` section headers (Fundamentals, Meta-analyses, By Region, Gaps); Per-Region Summary and Key Researchers optional
- Source IDs prefixed by region/domain code
- Meta-analysis IDs prefixed `MA.`; gap IDs prefixed `GAP.`
- Schema directory contains `db.sql` + `seed.sql`
- `db.sql` has 6 standard tables: regions, sources, researchers, meta_analyses, gaps, fundamentals
- `seed.sql` uses one INSERT per table, multi-row VALUES
- Investigation files with duplicate `id` excluded — bare markdown also excluded
- Report format: per-file violations (`file:line`), then pass/fail count
