Automated access to a content site (JSTOR, ACM, ScienceDirect, etc.) that hits a CAPTCHA or access check pauses the automated flow; the blocked URL reports to the user, who solves the challenge in the browser session. The flow resumes after the user confirms completion or the page loads with HTTP 200.

Scope: session-level. Applies to any browser-automation workflow hitting a CAPTCHA, access check, or bot detection page.

Composes with `RUL.WORKFLOW.PRINCIPLE` — one of 11 workflow principles.
