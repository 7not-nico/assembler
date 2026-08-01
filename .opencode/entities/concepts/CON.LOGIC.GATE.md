**Logic Gate** — The discovered form of Boolean function implementation in hardware. From Greek *logikē* "of reasoning" + Old Norse *gata* "way, path" — a physical circuit that implements a Boolean function: given binary inputs (0 or 1, represented as voltage levels), it produces a binary output according to a truth table. The seven standard gates are AND, OR, NOT, NAND, NOR, XOR, XNOR.

Logic gates are discovered, not invented. The AND function (output 1 only when both inputs are 1) is a logical necessity that exists whether or not any circuit implements it. Transistors naturally realize Boolean functions: a MOSFET in series implements AND; in parallel, OR. The NAND gate (two transistors in series) is functionally complete — any Boolean function, and therefore any digital circuit, can be built from NAND gates alone. This is a theorem about Boolean algebra, not an engineering decision.

---
id: CON.LOGIC.GATE
mode: theoretical
title: Logic Gate
source: COG.DIGITAL.ELECTRONICS
precedes: [DEF.CLASSICAL.COMPUTER]
tags: logic-gate, boolean-function, and, or, not, nand, nor, xor, xnor, discovered-form
related: [CON.TRANSISTOR, COG.BOOLEAN.ALGEBRA]
---
