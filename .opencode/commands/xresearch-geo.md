---
description: Survey research on a topic systematically across geographic/language regions
subtask: true
---

Survey for `$ARGUMENTS`

1. Load skill: `skill --name search-geo`
2. Follow the procedure: scope, search, assess, fetch, synthesize, source-audit, compile, schema, review
3. Report per-region: PASS/WARN/FAIL, total sources, gaps
 4. Write `.opencode/investigations/{topic}-meta-audit.md`
 5. Confirm path to manifest in output
6. Source audit — after synthesize, before compile. For each commercial-origin source, run an academic-equivalent search (site:.edu / .ac.*). Compilation: blocked when commercial ratio exceeds 30%. When blocked, return to search phase with stricter domain filters. Log replacements to gap notes.

**Report** — per-query:
- PASS — results returned with snippets
- WARN — sparse results, refinement prompt fired
- FAIL — search error or empty after refinement
- SKIP — user cancelled refinement

**Summary** — total results, top URLs, refinement rounds.
