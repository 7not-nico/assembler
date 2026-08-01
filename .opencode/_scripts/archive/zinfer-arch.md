---
description: Audit .opencode/ structure and infer architectural consistency
subtask: true
---

Audit structure for `$ARGUMENTS`

1.  Read `.opencode/` recursively — list all files by directory grouping
2.  Read every `tools/*.ts` — trace imports from `_lib/`, categorize read/write
3.  Read every `commands/*.md` — check frontmatter, rule references, tool mentions
4.  Read every `rules/*.md` — verify each is active and referenced by at least one command
5.  Read schemas — verify tool queries match defined tables
6.  Read patterns and terms — validate ID format, YAML structure
7.  Detect anomalies — orphan files, `.bak` without counterparts, dead artifacts

**Report** — per-section:
- PASS — consistent
- WARN — deviation from convention
- FAIL — broken or contradictory
- SKIP — not applicable

**Summary** — total checks, count per verdict
