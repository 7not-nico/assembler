# EXTRACT.EVALUATE.ARGUE — extract page content via evaluate, then argue grounding

When a user presents a URL or documentation page, extract the full text content using Playwright's `browser_evaluate` tool before reasoning about it. This ensures the analysis grounds in the page's actual text, not in snapshot summaries or partial reads.

Procedure:
1. Navigate to the URL via Playwright `browser_navigate`
2. Extract the main content area using `browser_evaluate` with `document.querySelector('[role="main"]').innerText`
3. If no `role="main"` element exists, fall back to `document.body.innerText`
4. Present the extracted text in the conversation
5. Argue the semantic analysis based on the extracted text, not on memory or inference

The extracted text must appear in the conversation before the semantic analysis is written. This replaces inference with grounded extraction.

Composes with: SHOW.SPEC.EXTRACT.FIRST, WRITE.BROWSER.FIRST, CITE.SOURCE.CROSSCHECK
