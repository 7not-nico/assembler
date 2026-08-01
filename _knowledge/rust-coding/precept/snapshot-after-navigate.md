After every `playwright_browser_navigate` call, capture the page snapshot with `playwright_browser_snapshot`. Snapshot provides the structured accessibility tree for content extraction — screenshot alone is insufficient for text and link processing.

Scope: session-level. Applies to every browser navigation.
Fallback: when snapshot returns empty, use `browser_find` or `browser_evaluate` for targeted extraction.
Composes with: `source-playwright`
