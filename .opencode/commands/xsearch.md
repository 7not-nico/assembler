---
description: Perform a single-query web search for a specific topic and log results to patlib
subtask: true
---

1. Execute `parallel-search_web_search` with `$ARGUMENTS` as the objective.
2. Extract top findings, including academic and commercial sources.
3. Log the search operation via `mcp-log-search` with a concise summary.
4. Report results to the user in a structured format including:
   - Search status (PASS/WARN/FAIL)
   - Core findings summary
   - List of key URLs and their source type (Academic vs Commercial)
   - Recommendation for `/xresearch-geo` upgrade if gaps are identified
