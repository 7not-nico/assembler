# Region: Lambda Calculus Foundations

## Sources
- SEP (Stanford): Church-Turing Thesis — λ-definability ≡ Turing machine ≡ recursion. Church (1936); Church-Rosser (1936).
- CMU (Harper): λ-Calculus as "The Other Turing Machine". Church numerals, β-reduction, denotational semantics (Scott-Strachey). Propositions-as-Types principle.
- UIUC (Lecture Notes): Church-Rosser theorem, confluence, η-equivalence. Simply-typed λ-calculus, Curry-Howard isomorphism, strong normalization.
- MIT (Barenblat): λ-calculus is Turing-complete. Church numerals encode arithmetic. Y combinator for recursion.
- IEP (Internet Encyclopedia): λ-calculi as formal systems for functions and application. Curry-Howard: types as propositions, programs as proofs. Simply-typed λ-calculus is strongly normalizing.
- SEP (Church supplement): α-conversion, β-reduction. Currying (Schönfinkel). Church's simple theory of types (STT). Types: ι (individuals), ο (truth values), (αβ) (functions).
- Harvard (Curry-Howard): Universal quantification ↔ parametric polymorphism. Existential types ↔ ∃ quantification. CPS translation ↔ double negation.
- CMU (PFPL): Proofs as programs. The judgment M : A as both "M is a proof term for proposition A" and "M is a program of type A".

## Key Findings
- **β-reduction** = substitution = the core computational operation
- **Church-Rosser** = confluence = syntax converges regardless of reduction order
- **Curry-Howard** = types are propositions, programs are proofs
- **Simply-typed λ-calculus** = strongly normalizing (no non-termination)
- **Untyped λ-calculus** = Turing-complete (Y combinator for recursion)
- **Currying** = reducing n-ary functions to monadic functions
