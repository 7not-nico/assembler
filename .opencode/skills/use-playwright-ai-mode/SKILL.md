---
name: use-playwright-ai-mode
description: Use this skill when using Playwright to interact with Google AI Mode (udm=50) — it covers navigation, chatting, and extracting structured responses
state-profile: stateless
type: reference
---

Google AI Mode (`udm=50`) renders an interactive LLM chat embedded in the search page. Use Playwright to navigate, ask, and extract the structured AI response from the DOM.

**Technique**

| Step | Action | Playwright tool |
|------|--------|-----------------|
| 1 | Navigate to `https://www.google.com/search?q=<query>&udm=50` — the `udm=50` param forces AI Mode | `browser_navigate` |
| 2 | Read the AI response from the page snapshot — tables, lists, and summaries render as DOM elements | `browser_snapshot` |
| 3 | For follow-up questions, type into the chat textbox and submit via Enter | `browser_run_code_unsafe` with `page.locator('textarea').fill(text)` then `page.keyboard.press('Enter')` |
| 4 | Wait for response to render, then re-snapshot | `browser_wait_for` + `browser_snapshot` |

**Gotchas**

- AI Mode appends `mstk=` session param on subsequent calls — always pass `udm=50` fresh
- Console errors (JS tracking/analytics) are normal — ignore
- AI follow-up suggestion buttons are often `[disabled]` — use the textbox instead
- Source citations appear below the AI response in a collapsible section
- `browser_find` may miss AI-generated content — use full `browser_snapshot`
