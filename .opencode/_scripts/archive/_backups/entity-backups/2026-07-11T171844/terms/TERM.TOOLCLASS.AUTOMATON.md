**Tool Classification by Automata Theory I/O Model** — classifying tools by their automata-theoretic I/O model into four archetypes: acceptor/recognizer (RECG, read-only decision), transducer (TRNS, separate input/output tapes), generator (GENR, write-only from internal state), and synchronizer (SGNL, read-write coordination). Maps each tool's memory model, tape directionality, and read/write behavior to a formal automaton class. Classification is declared inline via `// @toolclass <CODE>` at line 1 of each tool file — no external DB, no second registry.

**Acceptor/Recognizer (RECG)** — decides language membership; reads input and halts in accepting or rejecting state. Stateless or stateful memory. Read-only.

**Transducer (TRNS)** — maps input to output; separate input and output tapes with register or tape memory. Separate-tapes I/O.

**Generator (GENR)** — produces output from internal state only; no input tape. Write-only tape memory.

**Synchronizer (SGNL)** — reads and writes shared state for coordination; requires read-write tape memory for consensus.

---
id: TERM.TOOLCLASS.AUTOMATON
title: Tool Classification by Automata Theory I/O Model
source: assembler
tags: automata,tooling,classification,architecture
terms: []
patterns: [PAT.TOOLCLASS]
related: []
reference:
  - title: PAT.TOOLCLASS — Tool Classification by Automata Theory I/O Model
    url: https://opencode.ai/docs
  - title: automata theory — Chomsky hierarchy
    url: https://en.wikipedia.org/wiki/Automata_theory
  - title: Mealy and Moore machines
    url: https://en.wikipedia.org/wiki/Mealy_machine
---