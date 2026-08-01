---
id: PAT.TOOLCLASS
title: Tool Classification — Automata Theory I/O Model
source: assembler
summary: Every tool has an I/O automaton model that determines its memory, directionality, and read/write behavior. Classify by model, not by name.
principle: Every tool has an I/O automaton model that determines its memory, directionality, and read/write behavior.
enforcement: Convention
tags: [tooling, architecture, automata, classification, convention]
patterns: [PAT.SKILL.STATECLASS, PAT.DRY, PAT.ASSEMBLER.ARCHITECTURE]
terms: [TERM.TOOLCLASS.AUTOMATON]
status: active
priority: 2
---

Every tool has an I/O automaton model that determines its memory, directionality, and read/write behavior. Classification is declared inline via a `// @toolclass <CODE>` comment at the top of each tool file, parsed by `audit-tool` and optionally aggregated into a manifest.

## Context

Tools are often named by function, not by interface contract. Two tools that write to a DB may differ fundamentally in whether they also read or validate. Automata theory provides a precise vocabulary: acceptor, transducer, generator, synchronizer. Mapping each tool to one of these four models reveals which tools compose, which need isolation, and which can run in parallel.

The classification lives **in the source file** — each `.opencode/tools/*.ts` starts with `// @toolclass <CODE>`. This follows the metadata-first principle: every entity carries its own classification. No external DB, no second registry.

## Rules

- Every tool belongs to exactly one of: RECG (acceptor), TRNS (transducer), GENR (generator), SGNL (synchronizer)
- RECG tools are read-only; they decide language membership and halt
- TRNS tools have separate input and output tapes; they read and write different data
- GENR tools are write-only; they produce output from internal state alone
- SGNL tools are read-write; they coordinate by reading and writing shared state
- Classification is declared at line 1 of the tool file: `// @toolclass <CODE>`
- `audit-tool` skill enforces classification coverage (convention, not tool)
- A manifest file (`.opencode/manifests/tools.md`) may be generated from annotations for documentation

## Migration

Tools created before classification must have `// @toolclass <CODE>` added before the next `audit-tool` run. Undefined classes produce a warning. The former `toolclass.db` has been removed — classification is now file-local.

## Applicability

All tooling within the AMANDA ecosystem. Not intended for external tools — the classification is specific to OpenCode IPC and CLI patterns.

## See also

- TERM.TOOLCLASS.AUTOMATON
- PAT.SKILL.STATECLASS
- PAT.DRY
- PAT.ASSEMBLER.ARCHITECTURE — metadata-first principle
