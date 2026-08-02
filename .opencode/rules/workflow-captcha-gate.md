Script access to a content site (JSTOR, ACM, ScienceDirect, etc.) that hits a CAPTCHA or access check pauses the script flow; that URL goes to the user, who solves the challenge in the browser session. The flow resumes after the user confirms the solve or the page loads with HTTP 200.

Scope: session-level. Applies to any browser-automation workflow that hits a CAPTCHA, access check, or bot-check page.

Composes with `RUL.WORKFLOW.PRINCIPLE` — one of 11 workflow principles.
