**Alpha conversion (α-conversion)** — renaming of bound variables in a lambda term without changing its meaning. The operation `λx.M →α λy.M[x:=y]` where `y ∉ FV(M)` (y not free in M). Enables capture-avoiding substitution during β-reduction.

**Formal rule** — If `y ∉ FV(M)`, then `λx.M` may be α-converted to `λy.M[x:=y]`. Renaming a bound variable must preserve all free variables.

**Purpose** — prevents variable capture when substituting into an abstraction. If `y ∈ FV(N)` during `(λy.M)[x:=N]`, α-rename `λy.M → λy'.M[y:=y']` with `y'` fresh, then substitute.

**Examples:**
- `λx.x →α λy.y` (valid — identity)
- `λx.y →α λz.y` (valid — y free, unchanged)
- `λx.xy →α λz.zy` (valid)
- `λx.xy →α λy.yy` (invalid — y would be captured)

**De Bruijn indices** — alternative encoding that eliminates named variables, making α-conversion unnecessary.

Exception to PROT.LLM.SPECIFICATION — this abstraction defines formal lambda calculus concepts (α-conversion rules, capture avoidance); as a definition it is exempt from the contract/gotcha framing rules that govern behavioral instructions.

---

id: ABS.ALPHA.CONVERSION
title: Alpha Conversion
source: SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY
tags: lambda-calculus, formal-methods, logic, computation, substitution, type-theory
related: [ABS.ALPHA.EQUIVALENCE]
reference:
  - url: https://en.wikipedia.org/wiki/Lambda_calculus#Alpha_conversion
    title: Wikipedia — Lambda calculus (α-conversion)
  - url: https://web.stanford.edu/class/cs242/materials/lectures/lecture04.pdf
    title: Stanford CS242 — Lambda Calculus (Aiken)
  - url: https://personal.utdallas.edu/~gupta/courses/apl/lambda.pdf
    title: A Tutorial Introduction to the Lambda Calculus
  - url: https://opendsa-server.cs.vt.edu/ODSA/StandaloneModules/20250903221625/html/AlphaConversion.html
    title: OpenDSA — Alpha-Conversion
---
