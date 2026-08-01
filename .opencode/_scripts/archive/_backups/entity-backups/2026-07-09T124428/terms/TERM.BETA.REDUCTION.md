**Beta reduction (β-reduction)** — the computation rule of lambda calculus: applying a function to its argument. `(λx.M) N →β M[x:=N]` (substitute N for every free x in M, avoiding capture). A term containing a β-redex (reducible expression) reduces until no redexes remain — the **β-normal form**.

**Capture-avoiding substitution** — β-reduction relies on α-conversion to rename bound variables when `FV(N)` would collide with bound variables in M.

**Church–Rosser theorem** — β-reduction is confluent up to α-equivalence: if a term reduces to two different forms, both eventually reduce to a common term (unique normal form). Ensures reduction order does not affect final result.

**Evaluation strategies:**
- **Normal order** (leftmost, outermost) — guarantees normalization
- **Applicative order** (rightmost, innermost) — evaluate arguments first
- **Call-by-name** — no reduction inside abstractions
- **Call-by-value** — evaluate argument to value before applying

**Normalization** — a term is strongly normalizing if every reduction sequence terminates; weakly normalizing if some sequence terminates. The untyped lambda calculus has terms with no normal form (e.g., Ω = (λx.xx)(λx.xx)).

---

id: TERM.BETA.REDUCTION
title: Beta Reduction
source: assembler
tags: lambda-calculus, formal-methods, logic, computation, substitution, type-theory
related: [TERM.ALPHA.CONVERSION, TERM.ALPHA.EQUIVALENCE]
reference:
  - url: https://en.wikipedia.org/wiki/Lambda_calculus#Beta_reduction
    title: Wikipedia — Lambda calculus (β-reduction)
  - url: https://web.stanford.edu/class/cs242/materials/lectures/lecture04.pdf
    title: Stanford CS242 — Lambda Calculus (Aiken)
  - url: https://personal.utdallas.edu/~gupta/courses/apl/lambda.pdf
    title: A Tutorial Introduction to the Lambda Calculus
---
