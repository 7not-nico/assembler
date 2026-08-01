---
description: Validate factual claims in notes via Exa web search
subtask: true
---

Run `validate-notes $ARGUMENTS`

1. Read all `.md` files from the given directory (recursive)
2. Extract factual claims — tool behaviors, versions, library names, syntax, config options, external references
3. For each claim — `exa_web_search_exa` for authoritative source

**Report** — per-file:
- PASS — matches source
- WARN — diverges from source
- FAIL — contradicts source — cite correction
- SKIP — unverifiable

**Summary** — total files, claims checked, count per verdict
