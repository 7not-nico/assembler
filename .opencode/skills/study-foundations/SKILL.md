---
name: study-foundations
description: Use this skill when studying uncharted topics — it composes xrequire-foundations, concept decomposition, and xresearch-geo into a learning pipeline
state-profile: hybrid
related: ["SKL.ORCHESTRATE.RESEARCH", "SKL.SEARCH.GEO"]
patterns: ["NEX.INVESTIGATION.PIPELINE.STAGE"]
---
**Procedure**

1. Run command `/xrequire-foundations` — pass topic inferred from context.
2. On WARN or FAIL — report gap to user. Ask: "Continue research or seed missing entities first?"
3. On user continue or PASS — decompose topic via question tool. Offer 4-6 sub-concepts derived from topic structure.
4. Log confirmed sub-concepts as query anchors.
5. Pass topic + anchors to `/xresearch-geo` for cross-region authoritative search. Prefer academic sources (.edu, .ac.*) over commercial (.com) — replace .com refs with academic equivalents.
   **After `/xresearch-geo` completes:** calculate commercial-source ratio across all regions. If > 20% across the compiled manifest, tag RESEARCH as COMMERCIAL-HEAVY WARN and run a secondary replacement pass before accepting.
   **Schema output** — decomposed anchors produce per-anchor seed files: `raw/schemas/{anchor-name}.sql` + shared `raw/schemas/db.sql`.
6. Report manifest path on completion.

**Gotchas**

- Running research before foundations — always complete `/xrequire-foundations` first; research scope depends on gap severity
- Decomposing too many sub-concepts — limit to 4-6; more than 8 dilutes research focus and causes query drift
- Passing the original broad topic to `/xresearch-geo` instead of decomposed anchors — use confirmed sub-concepts as query anchors; the broad topic frames the search, anchors scope it
- Skipping academic-source check risks citing non-peer-reviewed material — replace .com refs with .edu/.ac.* equivalents
- Commercial ratio check after research — 20% threshold is report-level WARN (softer than search-geo's 30% compile block). Two-tier enforcement catches edges where individual regions pass. Aggregate quality drifts separately

**Rules**

- Step order fixed — foundations → decompose → research. Reordering excluded
- Sub-concept count: 4-6, one question tool round per concept
- Research anchors must be logged before `/xresearch-geo` call
- RESEARCH status can be COMMERCIAL-HEAVY WARN even when all regions PASS — aggregate quality is a separate dimension from per-region availability

**Report — per step:**
- FOUNDATIONS — PASS, WARN, or FAIL
- DECOMPOSITION — PASS or SKIP
- RESEARCH — PASS or FAIL
