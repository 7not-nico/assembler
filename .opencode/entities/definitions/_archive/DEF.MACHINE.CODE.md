**Machine Code** — binary instructions executed directly by a CPU without translation. The lowest-level representation of a program: sequences of bits (opcodes and operands) that a processor's hardwired decoder circuitry interprets as commands — load, store, add, compare, jump. Each instruction set architecture (ISA) defines its own binary encoding; machine code for one ISA (x86, ARM, RISC-V) cannot run on another.

Machine code is stored as voltage patterns in memory cells (transistors holding charge), transmitted as electrical signals across buses, and decoded by logic gates etched into silicon. It has physical properties: bit states correspond to voltage thresholds (e.g., 0V for 0, +5V for 1), signals propagate at finite speeds through copper traces, and switching dissipates heat. The fetch-decode-execute cycle is a physical process — electrons moving through semiconductor material.

---
id: DEF.MACHINE.CODE
title: Machine Code
origin: artificial
nature: mechanical
source: COG.COMPUTER.SCIENCE
tags: machine-code,instruction-set-architecture,cpu,binary,assembly,computer-architecture
related: []
reference:
  - title: "ICS 312 — Machine Code and CPU Architecture (U. Hawaii)"
    url: http://courses.ics.hawaii.edu/ReviewICS312/morea/ComputerArchitecture/ics312_arch.pdf
  - title: "CP1300 — Fetch-Decode-Execute Cycle (U. Miami)"
    url: https://www.cs.miami.edu/home/geoff/Courses/JCUSubjects/CP1300/Content/Architecture/FetchDecodeExecute.shtml
  - title: "ECE 2620 — Microprocessor Systems Machine Code (Wayne State)"
    url: https://neuron.eng.wayne.edu/auth/ece2620_new/lectures/ece2620_unit_1.htm
  - title: "CS160 — The Machine Cycle (Chemeketa CC)"
    url: https://computerscience.chemeketa.edu/cs160Reader/ComputerArchitecture/MachineCycle.html
  - title: "COMP 162 — Machine Language (Middle Georgia State)"
    url: https://comp.mga.edu/learning/python/module/1/topic/162
---
