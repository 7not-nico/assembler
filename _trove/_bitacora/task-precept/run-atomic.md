# run-atomic.md

**Layer:** precept/
**Naming:** `{action}-{domain}.md` — declarative, atomic.
**Composes with:** `_scripts/atomic-script-template.sh`, `task-fixture/fixtures.md`.

## Rule

Every script fulfills one task, prints machine lines (`KEY=value`), and exits non-zero on any failure. Bounded timeouts everywhere; visible progress per step; no wait on an event that may not fire.

## Scope

Script-level. Applies to every unit in `_scripts/` and any new acquisition tool.

## Stalled-engine recovery

A stalled engine shows no progress within its timeout. Recovery: abort the step, print the diagnostic, fix the wait — never let a script wait unbounded.

```
- progress lines per phase: FETCH → SAVE → SAVEDPATH= (fetch-paper)
- event-wait only when the event is guaranteed; else drive the request directly
- timeouts: open/read bounded; curl --max-time; Playwright { timeout }
```

## Why

The arxiv download-event never fires (inline PDF viewer); the browser.close() on a shared connection hangs. Both stalls cost sessions. Atomic units with bounded waits and line output compose without stalls.

## Practice

```
- one task per script, args in, KEY=value out
- non-zero exit on failure, stderr diagnostics
- run through run-logged.sh for the record
```

## Instance

2026-07-31 — fetch-paper v1 (download-event wait) and browse-arxiv (browser.close) both stalled; both fixed with bounded, direct patterns.
