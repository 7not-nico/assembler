---
id: PAT.RESEARCH.PIPELINE
title: "Research Pipeline — Systematic Investigation Workflow"
source: assembler
summary: "Every research task flows through: foundations check, decompose, search, synthesize."
principle: "Research is a multi-stage pipeline where each stage gates the next, ensuring no gaps in methodology."
enforcement: Convention
tags: [research, pipeline, methodology, workflow, systematic]
patterns: []
terms: []
status: active
priority: 3
---

Research is a multi-stage pipeline where each stage gates the next, ensuring no gaps in methodology.

## Context

Ad-hoc research produces incomplete results. The Research Pipeline formalizes the sequence: check what patlib already knows about a topic (foundations), decompose the topic into sub-concepts (decomposition), survey across geographic/language regions (search), and compile findings into a manifest (synthesize). Each stage is optional but the sequence is fixed — later stages assume earlier ones have run. Skills like `SKL.STUDY.FOUNDATIONS` and `SKL.ORCHESTRATE.RESEARCH` implement stages of this pipeline.

## Rules

- Foundations check runs first — research only what patlib does not already cover
- Decomposition produces query anchors for the search stage
- Search is cross-region by default — single-region searches are an explicit choice
- Synthesis produces a manifest with sources, gaps, and regions
- Each stage gates the next — each stage must run before the next can proceed
- Research results are always written to a manifest — conversation-only results are incomplete

## Applicability

Any topic research task — cross-region surveys, single-concept queries, systematic literature reviews, or gap analysis.

## See also

- SKL.STUDY.FOUNDATIONS
- SKL.ORCHESTRATE.RESEARCH
- SKL.SEARCH.GEO
- SKL.AUDIT.CROSSREF
- CMD.XREQUIRE.FOUNDATIONS
- CMD.XRESEARCH.GEO
- CMD.XSEARCH.WEB
