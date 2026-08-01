# use-shared-browser.md

**Layer:** precept/
**Naming:** `{action}-{domain}.md` — declarative, atomic.
**Composes with:** `_scripts/start-browser.sh`, `_scripts/start-browser-headless.sh`.

## Rule

All browser work runs on one shared Chromium — the instance on CDP 9222 (headed, MCP profile) or 9223 (headless). Scripts connect via `connectOverCDP`; they never launch a new Chrome instance; they never copy the profile.

## Scope

Script-level. Applies to every browser-touching unit: `browse-arxiv.sh`, `fetch-paper.sh`, crawls.

## Close discipline

A script closes its page, then exits — it never calls `browser.close()` on the shared connection. The connection drop stalls; the shared browser persists. `process.exit(0)` after `page.close().catch(() => {})` is the safe pattern.

## Why

Two stalled-engine incidents (browse-arxiv, fetch-paper v1) both came from shared-browser misuse: waiting on an event that never fires, or closing the connection. The shared browser carries the session cookies and extensions; a new instance loses them.

## Practice

```
- start:  bash _scripts/start-browser.sh          (idempotent, 9222)
- crawl:  connectOverCDP → work → page.close → exit
- never:  browser.close(), fresh launches, profile copies
```

## Instance

2026-07-31 — browse-arxiv stall fixed by dropping browser.close(); fetch-paper v1 fixed by context.request.
