---
description: Audit _lib/ and tools/ method implementations against library best practices and anti-patterns
subtask: true
---

Audit `.opencode/_lib/` and `.opencode/tools/` for `$ARGUMENTS`

1. Read every `.ts` file — identify each function and its external library calls
2. For each library — `context7_resolve-library-id` then `context7_query-docs` for idiomatic usage + anti-patterns
3. `read-selection` all active patterns, `read-projection` each — enforce every rule against code
4. Audit each method against Context7 docs + patlib patterns

Write full report to `docs/method-flow.md`.

**Report** — per-file, per-method:
- PASS — follows best practices and patterns
- WARN — deviation from documented pattern — cite source
- FAIL — anti-pattern detected — cite source

**Summary** — total files, methods audited, count per rating. Code refs as `file:line`.
