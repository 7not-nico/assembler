---
id: PRE.CODE.LAYER.TOOL.CLASS
title: Code Layer — Tool Behavior Classification
source: assembler
summary: Five tool behavior classes from automata theory. Tools are classified by workflow role. Orthogonal to dependency rings.
precept: Tools are classified by their workflow behavior as acceptor, classifier, transducer, sequencer, or signaler. The two groupings are orthogonal.
enforcement: Tool
tags: [tooling, architecture, automata, classification]
status: active
priority: 1
---

**Code Layer** — tool behavior classification. Five classes from automata theory.

## Corollaries

- Every tool declares its class via `// @toolclass {CLASS}` at line one
- Acceptor — binary accept/reject (recognizer)
- Classifier — n-ary category output
- Transducer — input→output transformation
- Sequencer — fixed ordered output
- Signaler — control signal emission
- The two groupings are orthogonal — a tool of any class may call lib files at any inward ring

## Applicability

All tool files across all projects — `tools/` and MCP server directories.
