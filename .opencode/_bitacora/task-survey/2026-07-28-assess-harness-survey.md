# Harness Assessment Survey

## Core Evaluation Dimensions
- Observability of edits
- Attribution of changes
- Transferability across models
- Performance improvement (e.g., pass@1 delta)
- Maintenance overhead (tokens, upkeep)

## Scoring
- 5‑point Likert per dimension

## Metrics
- Δ pass@1
- Context token reduction
- Regression incident count
- Audit compliance score

## Data Collection
- Run `patlib_validate` on harness files
- Use `read-projection` on protocol contracts
- Capture logs via `mcp-log-search`

## Timeline & Ownership
- Week 1: Deploy survey template
- Week 2: Gather scores
- Week 3: Analyze & report
- Owner: Harness Working Group

---

*Qualifiers*: This survey is a lightweight first pass; a deeper longitudinal study is recommended for production‑grade assurance.