---
id: PATTERN.KEYED.LINE.HANDOFF
title: Keyed-Line Handoff — Machine Lines Carry Stage Facts
layer: pattern/
purpose: "Pipeline stages hand off through keyed machine lines on stdout; each line carries one key=value fact for the next stage."
naming: keyed-line-handoff.md
tags: [pattern, morphism, keyed-line, pipeline]
status: active
---
# KEYED-LINE-HANDOFF.md

**Layer:** pattern/
**Naming:** `keyed-line-handoff.md` — code morphism, reusable structure.
**Composes with:** `pattern/atomic-tool-contract.md`; derived from `study/` + `fixture/` proof.

## Morphism

Pipeline stages hand off through keyed machine lines on stdout; each line carries one key=value fact that the next stage or the orchestrator consumes without shared state.

## Structure

```text
stage 1 → stdout machine lines:
    IMAGE=/abs/path.img        KEY=value — one fact per line
    SIZE=127205376
    STATUS=0
orchestrator/labels:
    SEARCH / GAME <url> | <title> / OPEN / DL / VARIANTS: N <url> | <name>
stage 2 reads the lines from its stdin/stdout contract and continues
```

Invariant: lines parse without surrounding context; keys stay stable per tool family; the keyed line always carries a value.

## Verification

Pipe two stages and assert the downstream stage consumes the lines; run the tool standalone and assert the same lines appear; change a key and watch the consumer fail loudly, never silently.

## Instance

`instantiator/verify-archive.sh` → `acquire-game.sh` chain (`IMAGE=`/`SIZE=`/`STATUS=`) and `browse-romsfun` (`SEARCH`/`GAME`/`VARIANTS:`) → `fetch-download` (`SAVEDPATH=`) → `acquire` (2026-08-04/05); the MCP tools return the lines verbatim to the agent.
