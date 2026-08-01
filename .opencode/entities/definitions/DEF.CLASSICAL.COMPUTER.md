**Classical Computer** — A stored-program digital computing machine built from binary switching elements (transistors) organized into logic gates. The classical computer implements the von Neumann (or IAS) architecture: a single processing unit (CPU) with an arithmetic-logic unit (ALU), control unit, and registers; a linear memory address space holding both instructions and data; and a sequential fetch-decode-execute cycle that reads machine code from memory.

The classical computer is one substrate for computation among many. It is distinguished by:
- **Stored-program architecture** — instructions and data share the same memory, enabling self-modifying code and programmability
- **Binary encoding** — the transistor substrate is inherently two-state (on/off), mapping to binary 0 and 1
- **Sequential execution** — instructions are fetched and executed one at a time (though pipelining and superscalar designs overlap these phases)
- **Determinism** — the same program and inputs always produce the same outputs

Not all computers are classical. The abacus and Antikythera mechanism are computers (they compute) but are mechanical, not stored-program, not binary. Quantum computers use superposition and entanglement rather than deterministic binary logic.

---
id: DEF.CLASSICAL.COMPUTER
title: Classical Computer
source: COG.COMPUTER.SCIENCE
precedes: []
tags: computer-architecture, von-neumann, stored-program, cpu, classical-computing
related: [CON.MACHINE.CODE, CON.MACHINA, CON.COMPUTARE, CON.CODEX, CON.BINARY]
reference:
  - title: von Neumann — First Draft of a Report on the EDVAC (1945)
    url: https://archive.org/details/FirstDraftOfAReportOnTheEdvac
  - title: Computer Architecture — Patterson & Hennessy
    url: https://www.elsevier.com/books/computer-organization-and-design/patterson/978-0-12-820109-3
  - title: "CS160 — The Stored-Program Computer (Chemeketa CC)"
    url: https://computerscience.chemeketa.edu/cs160Reader/ComputerArchitecture/StoredProgramConcept.html
---
