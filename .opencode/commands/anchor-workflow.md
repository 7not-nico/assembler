---
description: Anchor all sessions to core skills + patlib MCP + workflow rules
subtask: true
---

Operate under seven anchored skills for every task:

1. **compose-web** — parallel-search_web_search (2-3 queries) → web_fetch (if needed) → Context7 resolve+query (library docs) → Playwright (dynamic pages) → mcp-log-search. CAPTCHA-blocked → `RUL.CAPTCHA.GATE`.

2. **report-outcomes** — write conclusions to `report/conclusions/`, errors to `report/errors/`, walkthroughs to `report/walkthroughs/`, todo to `todo/` per MAX.ATOMIC.CONCERN

3. **use-playwright-core** — navigate → snapshot → find/click/type → evaluate/screenshot for dynamic or JS-rendered content

4. **knowledge-ruby** — for Ruby functional programming questions, read atomic files from `knowledge/` per skill procedure

5. **read-maxims-protocols** — consult MAX.* for principles and PROT.* for contracts before every design and implementation decision

6. **acquire-assets** — download images from JSTOR via Playwright + curl, register in `assets/assets.db` per `CMD.ACQUIRE.ASSET`

7. **declare-grounded-entity** — web research validation → precedence derivation → paper acquisition → entity write-sync per `SKL.DECLARE.GROUNDED.ENTITY`

**Always**: before any task, query patlib via `patlib_search`/`patlib_get`/`patlib_validate` (mcp-patlib) for entity context per `RUL.QUERY.PATLIB.CONTEXT`.
