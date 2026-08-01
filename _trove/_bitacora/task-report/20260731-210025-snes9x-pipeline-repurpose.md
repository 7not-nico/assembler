# 20260731-210025-snes9x-pipeline-repurpose.md

**Date:** 2026-07-31
**Project:** `_trove/` — paper acquisition pipeline repurposed from `_codex/snes9x-repo/scripts/`

## What was done

```
Pipeline:  5 atomic units repurposed from the snes9x ROM pipeline:
           browse-arxiv.sh  (discovery: arxiv search → PAPER lines)
           fetch-paper.sh   (browser-context PDF download → SAVEDPATH=)
           verify-paper.sh  (PDF magic + page count → OK <file> (N pages))
           prepare-paper.sh (slugify + move → PAPER=)
           acquire-paper.sh (conductor: fetch → verify → prepare)
Smoke:     verify-paper ✓ (16 pages); prepare-paper ✓ (scratch dir); fetch-paper
           ✓ (math/0506456v1, 568 KB, 70 pages — artifact cleaned);
           bash -n on browse/acquire
AGENTS.md: tooling table 7 → 12 scripts; snes9x provenance + download lesson noted
Todo:      invariant-papers.md +4 items, all [x]
Logs:      task-stdout/ smoke-verify-paper, smoke-prepare-paper, smoke-fetch-paper,
           smoke-fetch-paper (second), registry-push, fixture-f3, fixture-f5
```

## Decisions

```
- context.request over the download event: arxiv serves PDFs inline, the
  download event never fires — browser-context HTTP carries session cookies and
  has no event dependency (snes9x stalled-engine lesson applied)
- pipeline naming mirrors the ROM pipeline (browse/fetch/verify/prepare/acquire)
  for recognizability; outputs use the same machine-line protocol (KEY=value)
- curl stays the primary download path (batch, no browser needed); fetch-paper
  is the fallback for cookie/CAPTCHA-gated sources (ACM, ScienceDirect)
- artifacts land in _trove/.opencode/.playwright-mcp/ — mirrors the root
  convention, keeps downloads out of the catalog until verified + prepared
```

## Errors found

```
1. fetch-paper v1 stalled: page.goto(pdf) + waitForEvent('download') — arxiv
   renders PDFs inline, event never fires, 60s wait. Fix: context.request.get,
   direct HTTP through the browser context, progress lines FETCH → SAVE
2. push-registry.rb globbed 'reports/' — trove dir is 'report/' singular;
   repurposed the copy; also restored the icount initializer dropped mid-edit
```

## Findings

```
1. Browser-mediated HTTP (context.request) is the reliable download fallback:
   session cookies, no event timing, works where curl 403s
2. The snes9x atomic-unit protocol (KEY=value machine lines, shared-browser
   guard, PW_CORE resolution, run-logged adoption) transfers cleanly to a
   paper pipeline — the patterns are source-agnostic
3. machine-line conductors compose units without parsing prose — acquire-paper
   reads SAVEDPATH= / PAPER= only
```

## Open edges

```
- acquire-paper.sh end-to-end run (browse → pick → acquire) on a real id
- figure-8 quantum invariants (math/0506456) fetched but not acquired — candidate
  for the next catalog addition (meta.json + register via register-invariants.rb)
- bitacora-report registration decision (push-registry scoped to _templates/report/)
- first real backup + change inventory at the first schema migration
```

## Todo state

```
Completed: 5-unit pipeline repurpose, stalled-engine fix, smoke tests, AGENTS.md
           update, todo close, task-stdout logs
Pending:   acquire end-to-end, figure-8 acquisition, bitacora-report registration,
           first backup at migration
```
