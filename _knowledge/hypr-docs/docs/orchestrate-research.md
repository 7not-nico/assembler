---
name: orchestrate-research
description: Use this skill when doing web research — it offers /xsearch for single-query or /xresearch-geo for cross-region surveys; chooses method, executes, and compiles results
state-profile: hybrid
related: ["SKL.SEARCH.GEO", "CMD.XSEARCH.WEB", "CMD.XRESEARCH.GEO"]
patterns: ["NEX.INVESTIGATION.PIPELINE.STAGE"]
---
**Procedure**

**1. Scope** — determine which tool to use
- Single concept or question → `/xsearch`
- Cross-region, cross-language, or systematic survey → `/xresearch-geo`
- Both: search first, then expand into cross-region survey

**2. Execute — `/xsearch`**
- Query patlib context: `patlib_search --query $ARGUMENTS --type patterns --type protocols --type terms` via mcp-patlib
  - Found entities: note as established context
  - Missing entities: flag but proceed
- Load command: delegate to `.opencode/commands/xsearch.md`
- Pass `$ARGUMENTS` as the query string
- Await report: PASS/WARN/FAIL/SKIP with summary

**3. Execute — `/xresearch-geo`**
- Load skill: `skill --name search-geo`
- Load command: delegate to `.opencode/commands/xresearch-geo.md`
- Pass `$ARGUMENTS` as the topic
- Await manifest path at `.opencode/investigations/{topic}-meta-audit.md`

**4. Synthesize** — combine outputs
- If both used: merge search findings into the manifest as a `single_query_searches` section
- Flag contradictions between search and survey results
- Cross-reference URLs for deduplication
- Replace commercial (.com) sources with academic (.edu, .ac.*) equivalents where available
- Flag key claims supported only by commercial references

**5. Log** — audit trail
- `mcp-log-search` for every search round (single or per-region)
- Record manifest path in the log summary

**Gotchas**

- `/xresearch-geo` is heavy — one region per round. Prefer `/xsearch` for quick answers
- `/xsearch` returns flat results — no cross-region breakdown. Upgrade to survey if gaps appear
- Both commands handle their own refinement loops — use only the built-in refinement per command
- Manifest writes only under `/xresearch-geo` — `/xsearch` output goes to conversation summary
- Commercial sources (.com) lack academic peer review — prefer .edu, .ac.* equivalents

**Rules**

- Choose scope first — run both after decision only
- Log every search to `mcp-log-search` — no exceptions
- Report per-method: PASS/WARN/FAIL/SKIP — consistent with command guidelines
- Manifest contains at minimum: topic, sources, method used, date
- Every key claim must cite at least one academic source — flag claims with only .com references
