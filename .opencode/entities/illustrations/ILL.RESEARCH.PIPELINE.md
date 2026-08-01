---
id: ILL.RESEARCH.PIPELINE
title: "Geo Research — Cross-Region Survey Pipeline"
source: PROT.META.COMPOSITION
summary: "Walkthrough of running a cross-region research survey from foundations check through synthesis."
illustration: "A cross-region survey on regulatory sandbox frameworks runs through foundations check, decompose, search, synthesize, and manifest stages."
illustrates: [NEX.INVESTIGATION.PIPELINE.STAGE]
tags: research,walkthrough,pipeline,survey,cross-region,geography
related: [NEX.INVESTIGATION.PIPELINE.STAGE, SKL.SEARCH.GEO, SKL.ORCHESTRATE.RESEARCH]
---
## Rationale

Ad-hoc research produces incomplete results — stages get skipped, gaps go unfilled. A fixed pipeline gates each stage (foundations → decompose → search → synthesize), ensuring no methodological gap remains. Skills like `SKL.STUDY.FOUNDATIONS` and `SKL.ORCHESTRATE.RESEARCH` implement stages of this pipeline.

A researcher needs to survey regulatory sandbox frameworks across four regions: North America, Europe, Latin America, and East Asia. Each region has different legal frameworks, academic traditions, and language sources.

## Walkthrough

1. **Foundations check** — search patlib for existing entities related to regulatory sandboxes. The search returns zero matches — the topic is uncharted.

2. **Decompose** — break the topic into four dimensions: legal framework, implementation approach, adoption rate, and academic coverage. Each dimension maps to a section in the manifest.

3. **Search each region** — run `SKL.SEARCH.GEO` for each region. Each round produces a per-region summary:

   - **NA**: US regulatory sandbox at federal level. SEC and CFTC frameworks. Academic sources: law reviews.
   - **EU**: GDPR sandbox, AI Act regulatory framework. Multiple member-state variations.
   - **LATAM**: Mexico and Brazil leading sandbox adoption. Spanish and Portuguese sources.
   - **EA**: Japan and Singapore frameworks. FSA regulatory approach. English and Japanese sources.

4. **Synthesize across regions** — identify common patterns (all regions require consumer protection measures) and divergences (EU mandates AI-specific frameworks; LATAM uses existing financial law).

5. **Write manifest files** — create `investigations/regulatory-sandbox/meta-audit.md` with bold findings, pattern/implication/data pairs, and YAML metadata. Create `schemas/db.sql` and `schemas/seed.sql`.

6. **Audit** — run `SKL.AUDIT.INVESTIGATION` to verify structural compliance.

## Key insight

The pipeline separates research from writing. Foundations check prevents duplicating existing knowledge. Regional decomposition makes searches focused and comparable. The cross-region synthesis surfaces patterns invisible in a single-region study. The manifest is the single source of truth for the investigation.

## See also

- `NEX.INVESTIGATION.PIPELINE.STAGE` — research pipeline pattern
- `SKL.SEARCH.GEO` — cross-region search skill
- `SKL.ORCHESTRATE.RESEARCH` — research orchestration skill
- `PAT.RESEARCH.PIPELINE` — systematic investigation workflow
