---
description: Search arxiv.org for academic papers by topic and optionally download PDFs
subtask: true
---

1. Call `arxiv-search` tool with:
   - `query` — arxiv search syntax (use `+AND+` for boolean, e.g. `fts5+AND+vector`)
   - `maxResults` — max papers to return (default 10)
   - `category` — optional filter (e.g. `cs.IR`, `cs.DB`, `cs.LG`)
   - `download` — set `true` to save PDFs to `findings/`
   - `outDir` — subdirectory under `findings/` (default `arxiv-search`)
2. Present results to user in structured format
