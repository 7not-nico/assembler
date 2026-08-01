---
name: judge-semantic
description: Use this skill when evaluating a proposed entity — it checks whether the proposal duplicates or overlaps existing patlib content at the semantic level
state-profile: hybrid
related: ["SKL.VET.PROPOSAL"]
patterns: ["MAX.PROGRAMMING.DELIBERATELY"]
---
**Procedure**

When evaluating semantic overlap:

1. Extract — from the proposal, extract key noun phrases and domain terms
2. Query — run `read-selection` across all types with extracted terms, including variants
3. Compare — classify each result as Exact, Overlap, Related, or Distinct
4. Evidence — for non-distinct results, cite the specific fragment that overlaps
5. Verdict — if any Exact or Overlap exists, fail. Related = recommend reference. Distinct = pass.

**Gotchas**

- Semantic overlap ≠ exact ID match — `TERM.PROGRAMMING.BY.COINCIDENCE` and `MAX.PROGRAMMING.DELIBERATELY` related and distinct — both valid
- A term overlaps a pattern conceptually (what vs how) — flag as related. Overlap classification excluded
- When uncertain, default to Distinct — false positives block creation, false negatives are recoverable
- Subroutine of SKL.VET.PROPOSAL — runs standalone or feeds into check 3

**Rules**

- Query uses extracted terms — proposal ID alone insufficient
- Each result classified into one of four categories
- Evidence cites specific content — generic similarity excluded
- Default to Distinct when uncertain
- Report per-result classification with evidence, then pass/fail count
