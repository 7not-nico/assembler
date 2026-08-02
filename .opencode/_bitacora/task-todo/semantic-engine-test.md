# Semantic engine test — todo

Status: complete
Started: 2026-08-02
Report: `.opencode/_bitacora/task-report/20260802-semantic-engine-test.md`

## Tasks

- [x] Survey semantic engine tooling state (tools, Rust binary, DBs)
- [x] Run semantic-stats across tables
- [x] Run semantic-drift --check to assess embedding coverage
- [x] Embed missing/stale entities (skipped — drift showed none missing)
- [x] Run semantic-search test queries (3: general, technical, type-filtered)
- [x] Run semantic-eval metrics (default, passage, title, body configs)
- [x] Diagnose "stalled engine" — wrapper buffering, not an engine fault
- [x] Scaffold probe workflow in `.opencode/_shell/survey/semantic-engine-probe/`
- [x] Update AGENTS.md (semantic-purge, eval caveat, wrapper buffering)
- [x] Write bitacora report
