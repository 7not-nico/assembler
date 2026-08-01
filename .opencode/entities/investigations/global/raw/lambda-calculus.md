# Lambda Calculus — Foundations and Typed Systems

---

## Core Concepts

### β-reduction (the heart of computation)
```
(λx.M)N → M[x := N]
```
Substitution of argument N for parameter x in body M. This is the only computational primitive.

### Church-Rosser Theorem (confluence)
If `P → Q` and `P → R`, then there exists `S` such that `Q → S` and `R → S`.
**Implication**: order of reduction doesn't matter — syntax converges regardless of path.

### Three rules
| Rule | Operation | Meaning |
|------|-----------|---------|
| α-conversion | λx.M = λz.M[x:=z] | Rename bound variables |
| β-reduction | (λx.M)N → M[x:=N] | Function application |
| η-conversion | λx.Mx = M (x not free) | Extensionality |

---

## Barendregt's Lambda Cube

Three axes of expressiveness:
1. **Polymorphism** (terms depending on types) — axis from λ→ to λ2
2. **Type constructors** (types depending on types) — axis from λ→ to λω
3. **Dependent types** (types depending on terms) — axis from λ→ to λP

| System | Name | Creator | Properties |
|--------|------|---------|------------|
| λ→ | Simply-typed λ-calculus | Church 1940 | Strong normalization; no polymorphism |
| λ2 | System F (polymorphic) | Girard 1972, Reynolds 1974 | Parametric polymorphism; type inference undecidable |
| λω | Higher-order λ-calculus | Girard 1972 | Type constructors; kinds |
| λP | Dependent types (LF) | de Bruijn AUTOMATH 1970; Harper et al. 1987 | Types depend on terms |
| λP2 | Dependent + polymorphic | Longo & Moggi 1988 | Both P and 2 axes |
| λω | Fω | Girard 1972 | Type constructors + polymorphism |
| λPω | Weak calculus | — | Dependent + constructors (rare) |
| **λC** | **Calculus of Constructions** | Coquand & Huet 1988 | **All three axes** |

---

## Pure Type Systems (PTS)

Generalized framework via:
- **Sorts** S = {∗, □} — ∗ = universe of types, □ = universe of sorts
- **Axioms** A ⊆ S × S — e.g., ∗ : □
- **Rules** R ⊆ S × S × S — controlling allowed function spaces

**Sources**: Berardi (1988), Terlouw (1989), Barendregt (1992).

---

## Girard-Reynolds Isomorphism (System F)

Discovered independently by Jean-Yves Girard (logician) and John C. Reynolds (computer scientist).

| Component | Discovery |
|-----------|-----------|
| **Girard's Representation Theorem** | Every function on ℕ provably total in second-order predicate logic P2 can be represented in F2 |
| **Reynolds's Abstraction Theorem** | Every term in F2 satisfies a logical relation embeddable into P2 |
| **Composition** | Girard projection → Reynolds embedding = identity |

**Curry-Howard corollary**: Types = propositions, programs = proofs, reduction = cut elimination.

---

## Calculus of Constructions (CoC)

Coquand (1985), Coquand & Huet (1988). Basis for the Coq proof assistant.

| Feature | Syntax | Purpose |
|---------|--------|---------|
| Terms from terms | λx:A.M | Ordinary function abstraction |
| Types from terms | Πx:A.B | Dependent function types |
| Types from types | λX:K.C | Type constructors |
| Terms from types | ΛX.M | Polymorphism |

**Key theorem**: Strong normalization — all computations in CoC terminate.

**Restriction**: No Type:Type — Girard's paradox avoided by universe stratification.

---

## λ-Cube → LLM Mapping

| λ-cube axis | LLM capability | Evidence |
|-------------|---------------|----------|
| λ→ (simple types) | Function application | Subject-verb agreement circuits (40-69% overlap) |
| λ2 (System F) | Parametric reasoning | NLI compositional generalization (ICLR 2026) |
| λω (type constructors) | Type-level computation | Differentia_quality = 31% (CoNLL 2026) |
| λP (dependent types) | Value-dependent types | Entity tracking (Korean LM study 2026) |
| λC (CoC) | Full higher-order logic | β-reduction at 99.73% (JBCS 2026) |
