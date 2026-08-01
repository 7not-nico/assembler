**Logical Operators** — seven standard Boolean operators (NOT, AND, OR, XOR, NAND, NOR, XNOR) defined by truth tables and semantic equivalences. Definitions use standard mathematical notation and are exempt from PAT.LLM.SPECIFICATION (they define notation, not instruct behavior).

**NOT** — unary inverter: ¬1 = 0, ¬0 = 1. Semantic equivalence: NOT(x) = x NAND x = x NOR x.

**AND** — binary conjunction: 1 only when both operands 1. Semantic equivalence: a∧b = ¬(a NAND b) = (¬a) NOR (¬b).

**OR** — binary disjunction: 1 when at least one operand 1. Semantic equivalence: a∨b = ¬(a NOR b) = (¬a) NAND (¬b).

**XOR** — exclusive disjunction: 1 when operands differ. Semantic equivalence: a⊕b = (a∧¬b) ∨ (¬a∧b) = (a∨b) ∧ ¬(a∧b).

**NAND** — alternative denial: 0 only when both operands 1. Semantic equivalence: a↑b = ¬(a∧b) = (¬a)∨(¬b). Universally complete — any Boolean function expressible with NAND alone.

**NOR** — joint denial: 1 only when both operands 0. Semantic equivalence: a↓b = ¬(a∨b) = (¬a)∧(¬b). Universally complete — any Boolean function expressible with NOR alone.

**XNOR** — equivalence/biconditional: 1 when operands match. Semantic equivalence: a↔b = ¬(a⊕b) = (a∧b) ∨ (¬a∧¬b).

Exception to PAT.LLM.SPECIFICATION — this term defines standard mathematical notation using conventional symbols; as a definition it is exempt from the contract/gotcha framing rules that govern behavioral instructions.

---
id: TERM.LOGICAL.OPERATORS
title: Logical Operators
source: assembler
tags: logic,boolean,operator,convention,definition,notation,llm-spec-exempt
terms: [TERM.LOGICAL.OPERATOR.LLM, TERM.COMPUTER.SCIENCE]
patterns: [PAT.LLM.SPECIFICATION]
related: [RUL.NOT, RUL.AND, RUL.OR, RUL.XOR, RUL.NAND, RUL.NOR, RUL.XNOR]
reference:
  - title: Princeton introcs — Boolean Logic
    url: https://introcs.cs.princeton.edu/java/71boolean/
  - title: DU Boolean Logic PDF
    url: https://cs.du.edu/~mitchell/bootcamp/boolean_logic.pdf
  - title: DigiSim — Logic Gate Truth Tables
    url: https://digisim.io/blog/logic-gate-truth-tables-your-essential-reference-guide
  - title: Wikipedia — Truth table
    url: https://en.wikipedia.org/wiki/Truth_table
  - title: Wikipedia — Logical connective
    url: https://en.wikipedia.org/wiki/Logical_operators
  - title: UTexas — Some Additional Useful Operators
    url: https://www.cs.utexas.edu/~dnp/frege/some-additional-useful-operators.html
  - title: TechTarget — What are logic gates?
    url: https://www.techtarget.com/whatis/definition/logic-gate-AND-OR-XOR-NOT-NAND-NOR-and-XNOR
---
