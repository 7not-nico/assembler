# Region: European Typed Lambda Calculus Research

## Sources

| Source | Institution | Key Content |
|--------|-------------|-------------|
| Cambridge — Homotopy Type Theory (Sterling) | Cambridge | HoTT/Univalent Foundations course 2025-26. Dependent types, identity types, univalence axiom. Prerequisites: typed λ-calculus. |
| Cambridge — Mechanised MSP Semantics (Li, Kramarz, Xie, Yallop) | Cambridge 2026 | Multi-stage programming with quotations and splices. λ-calculus with run-time + compile-time code generation. Stage-indexed types. Phase distinction. |
| Cambridge — Category Theory (Fiore) | Cambridge 2025-26 | STLC semantics in cartesian closed categories. Curry-Howard-Lawvere correspondence. Monads for computation (Moggi). |
| Cambridge — Locally Nameless (Pitts) | Cambridge 2026 | Well-scoped locally nameless representation of syntax (arXiv:2605.08990). Nominal techniques for λ-calculus binding. |
| Edinburgh (Wadler) | Edinburgh | Gradual typing calculi (λB, λC, λS, λT). Propositions-as-Types. Polymorphic blame calculus. Programming Language Foundations in Agda. |
| Nottingham (Hutton) | Nottingham | Sound-by-construction type systems. Flow typing for linearity. Calculational compiler derivation. Concurrent λ-calculus with channels. |
| Nottingham (Hutton) | Nottingham | Past PhD topics: Worker/Wrapper, monads for effects, compiling concurrency, dependent types, quotient types. |
| Oxford — Distributed Processes | Oxford 2025-26 | π-calculus, mobile processes. Linear type theory for communication safety. Go language implementations. |
| LFCS Edinburgh (Milner, Plotkin, Burstall) | Edinburgh | LCF, CCS, ML. Monads in semantics. Structural Operational Semantics. λ-calculus + π-calculus foundations. |

## Key Findings

### Cambridge Tradition
- **Curry-Howard-Lawvere correspondence**: STLC types ↔ objects in cartesian closed categories
- **Multi-stage programming**: λ-calculus with quotes ⟨⟩ and splices $. Stage-indexed type systems. Phase distinction ensures compile-time vs run-time separation.
- **HoTT**: Identity types as paths. Univalence: equivalent types are equal. Builds on dependent type theory.

### Edinburgh Tradition
- **Propositions-as-Types**: λ-calculus terms correspond to natural deduction proofs
- **Gradual typing**: λB (blame), λC (coercions), λS (space-efficient). Full abstraction between calculi.
- **Monads in semantics**: Moggi's computational λ-calculus — modeling effects via monads
- **π-calculus**: Mobile processes, channel-based communication, type safety for concurrency

### Nottingham / Applied
- **Sound-by-construction type systems**: Deriving type systems from soundness proofs
- **Calculational compiler derivation**: From high-level semantics to correct compilers via equational reasoning
- **Flow typing**: Lightweight linearity without complex type features

### Connection to LLMs
- **Church-Turing thesis**: λ-calculus = Turing machine = equivalent computational power
- **Curry-Howard**: If LLMs learn λ-calculus reductions (proven: 99.73% accuracy), they are implicitly performing proof search
- **Phase distinction**: Compile-time vs run-time code generation in MSP mirrors LLM training vs inference separation
- **SOS**: Structured Operational Semantics provides the rule-based framework that resembles attention-based reduction
