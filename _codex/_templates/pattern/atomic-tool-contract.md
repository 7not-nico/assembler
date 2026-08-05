---
id: PATTERN.ATOMIC.TOOL.CONTRACT
title: Atomic Tool Contract — One Responsibility, One Keyed Line
layer: pattern/
purpose: "An atomic tool fulfills one responsibility, prints one keyed result line, exits non-zero on failure, runs cwd-independent."
naming: atomic-tool-contract.md
tags: [pattern, morphism, atomic, tool, contract]
status: active
---
# ATOMIC-TOOL-CONTRACT.md

**Layer:** pattern/
**Naming:** `atomic-tool-contract.md` — code morphism, reusable structure.
**Composes with:** `pattern/keyed-line-handoff.md`; derived from `study/` + `fixture/` proof.

## Morphism

An atomic tool fulfills one responsibility, prints one keyed result line, exits non-zero on failure, and runs cwd-independent.

## Structure

```text
tool {args...}
  → stdout: KEY=value          — one machine-readable fact (or per-stage lines)
  → exit 0 on success, non-zero on failure
  → cwd-independent: resolves its own root, never assumes the caller's pwd
```

Invariant: one responsibility per tool; the result line parses without surrounding context; failure always carries a non-zero exit.

## Verification

Run the tool from a foreign cwd and assert the keyed line still resolves; force the failure path and assert the exit code and stderr hint; check the tool refuses missing required args with a usage error.

## Instance

The 8 instantiator tools (2026-08-04/05): `acquire-game` (`IMAGE=`/`SIZE=`/`STATUS=`), `stop-process` (`STOPPED=`), `fetch-download` (`SAVEDPATH=`), `browse-romsfun`, `build-cmake` (`BUILD=pass`), `launch-emulator` (`RUN=pid=`), `verify-archive` (`OK=`), `trace-evidence` (`LINES=`).
