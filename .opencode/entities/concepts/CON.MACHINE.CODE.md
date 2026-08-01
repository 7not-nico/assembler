**Machine Code** — The discovered form of instructions encoded in a substrate for direct execution by a machine. Machine code exists wherever a machine reads instructions from a medium without translation: sequences in a substrate (voltage patterns, magnetic domains, punched holes) that a decoder interprets as commands — load, store, add, compare, jump.

Machine code is a discovered form, not an invention. Any machine that executes instructions from a stored medium discovers machine code as the relationship between the inscription (codex) and the decoder (machina). The specific encoding depends on the substrate: classical computers encode machine code as binary (voltage high/low = 1/0). Punch cards encode machine code as hole/no hole. The *form* — instructions inscribed for direct machine reading — is substrate-independent.

Machine code is *iners* — it has no power to act on its own. A binary pattern is just voltage without a decoder. The CPU's fetch-decode-execute cycle gives machine code meaning by reading the inert substrate. Each instruction set architecture (ISA) defines its own encoding; machine code for one ISA cannot run on another.

---
id: CON.MACHINE.CODE
mode: synthetic
title: Machine Code
source: COG.COMPUTER.SCIENCE
precedes: [DEF.CLASSICAL.COMPUTER]
tags: machine-code, instruction-set-architecture, cpu, binary, assembly, discovered-form
related: [CON.CODEX, CON.INERS, CON.BINARY, CON.MACHINA]
reference:
  - title: "ICS 312 — Machine Code and CPU Architecture (U. Hawaii)"
    url: http://courses.ics.hawaii.edu/ReviewICS312/morea/ComputerArchitecture/ics312_arch.pdf
  - title: "CP1300 — Fetch-Decode-Execute Cycle (U. Miami)"
    url: https://www.cs.miami.edu/home/geoff/Courses/JCUSubjects/CP1300/Content/Architecture/FetchDecodeExecute.shtml
  - title: "CS160 — The Machine Cycle (Chemeketa CC)"
    url: https://computerscience.chemeketa.edu/cs160Reader/ComputerArchitecture/MachineCycle.html
---
