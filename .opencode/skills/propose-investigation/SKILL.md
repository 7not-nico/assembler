---
name: propose-investigation
description: Use this skill when a topic requires cross-region research — it automatically detects the need and proposes creating an investigation meta-audit with schemas and propose creating an investigation meta-audit with schemas
state-profile: hybrid
related: ["SKL.SEARCH.GEO", "SKL.AUDIT.INVESTIGATION"]
patterns: ["NEX.META.PROPOSAL", "NEX.INVESTIGATION.PIPELINE.STAGE"]
---
**Procedure**

When proposing an investigation:

1. Infer topic-slug from discussion, glob `.opencode/investigations/{topic-slug}/`
   — skip if exists (no duplicate investigations)
2. Search via `read-selection --type terms` and `--type patterns` — find related
   entities the investigation should reference
3. Delegate to `search-geo` skill for cross-region research — one region per
   round, compile per-region results
4. On results received — construct 3 files:
   a. `meta-audit.md` — bold finding + Pattern/Implication/Data + YAML block
      (id: `MANIFEST.{TOPIC-SLUG}`, title, summary, tags, tables) + `##` sections
   b. `schemas/db.sql` — 6 standard tables: regions, sources, researchers,
      meta_analyses, gaps, fundamentals
   c. `schemas/seed.sql` — INSERT per table, multi-row VALUES, region-prefixed IDs
5. Propose creation to user with manifest preview
6. On confirmation — write all 3 files
7. Delegate to `audit-investigation` for post-proposal validation
8. Report: PASS/FAIL/WARN per check, manifest ID

**Gotchas**

- Always check existing investigations first — duplicates violate DRY
- ID in YAML block uses `MANIFEST.{UPPERCASE.SEGMENTS}` format
- Source IDs prefixed by region code: `NA.`, `EU.`, `LATAM.`, `EA.`, etc.
- Meta-analysis IDs prefixed `MA.`; gap IDs prefixed `GAP.`
- Tags use YAML inline array: `[tag1, tag2]`
- `tables` field in YAML must match actual `##` section headers
- Two structural styles: **rule-format** (bold + Pattern/Implication/Data + YAML,
  no sections) and **expanded-format** (bold + YAML + sections). Choose based on
  content depth.
- Schemas dir sibling to meta-audit.md — nested placement excluded
- After writing — run `audit-investigation`; fix any violations before reporting

**Rules**

- YAML block: id, title, summary, tags, tables (all 5 required)
- Body starts with `**{Finding}** —` bold line
- Expanded-format requires `##` sections: Fundamentals, Meta-analyses,
  By Region, Gaps (all required); Per-Region Summary, Key Researchers,
  Top URLs (optional)
- Source IDs prefixed by region code
- `db.sql` must have 6+ tables: regions, sources, researchers, meta_analyses,
  gaps, fundamentals
- `seed.sql` must have one INSERT per table, multi-row VALUES
- Gap status values: `native_surveys_absent`, `sources_absent`, `surfaced_disabled`,
  `searched_disabled`
- Gap severity values: `high`, `medium`, `low`
- Each source entry: id, region_id, title, institution, language (minimum)
- After creation — delegate to audit-investigation before reporting complete
