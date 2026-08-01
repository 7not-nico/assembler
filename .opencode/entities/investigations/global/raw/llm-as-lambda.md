# LLMs as Differentiable Lambda Calculus — Core Synthesis

---

## The Equivalence Chain

```
λ-calculus (Church 1932) — pure syntax, substitution, reduction
    ↓  Church-Turing thesis (1936): λ ≡ TM ≡ recursive functions
Turing Machine / General Recursive Functions
    ↓  Formal equivalence proof (Tang & Xie 2026)
Transformer ≡ Stateless Differentiable Neural Computer
    ↓  Empirical demonstration (Flach et al. JBCS 2026)
Transformer learns β-reduction at 99.73% accuracy
    ↓
LLMs are differentiable, probabilistic λ-calculus machines
```

---

## The sDNC Theorem (Tang & Xie 2026, arXiv:2603.19272)

**Formal statement**: A causal Transformer layer with parameters (W^Q, W^K, W^V, W^O) acting on a sequence X = (x₁, ..., x_T) is exactly a Stateless Differentiable Neural Computer (sDNC) where:

| sDNC component | Transformer equivalent |
|----------------|----------------------|
| Controller (emits K, V) | MLP projections |
| Write-once memory (value matrix) | V matrix in attention |
| Content-based read | softmax(QKᵀ)V |
| Multiple read heads | Multi-head attention |
| No recurrent state | Feedforward architecture |
| No memory modification | Write-once (no erasure) |

**Corollary**: Cross-attention = sDNC with two memories (encoder read-from + decoder write-to).

---

## Transformer Learned β-Reduction (Flach et al. 2026)

| Task | Accuracy | String Similarity |
|------|----------|-------------------|
| One-step β-reduction | **99.73%** | >99.99% |
| Multi-step β-reduction | **97.70%** | >99.90% |

**Implications**:
- Self-attention captures variable binding across arbitrary distances
- Model generalizes to unseen λ-terms — true compositional generalization
- H1 confirmed: Transformer can learn one-step computation (substitution)
- H2 confirmed: Transformer can learn full computation (reduction sequences)

**Neurosymbolic AI form**: Neuro:Symbolic→Neuro — symbolic domain (λ-calculus reductions) applied to neural architecture (Transformer).

---

## λ-RLM: Y-Combinator for LLMs (Roy et al. 2026)

```
λ-RLM ≡ fix(λf. λP. if |P| ≤ τ* then M(P)
                     else REDUCE(⊕, MAP(λpᵢ. f pᵢ, SPLIT(P, k*))))
```

**Architecture**:
| Layer | Type | Role |
|-------|------|------|
| Layer 1 | Symbolic (combinators) | SPLIT, MAP, FILTER, REDUCE — deterministic, pre-verified |
| Layer 2 | Planning (optimization) | k* = 2, τ* = min(K, n/k*), depth = ⌈logₖ(n/τ)⌉ |
| Layer 3 | Neural (β-reductions at leaves) | LLM as bounded oracle on leaf subproblems |

**Key insight**: Recursion as explicit semantic object (Y-combinator), not emergent model behavior. Formal guarantees on termination, cost, accuracy.

---

## Differentiable λ-Calculus (NeuralLambda)

| Component | Implementation |
|-----------|---------------|
| Substitution (β-reduction) | Tensor operations on AST-representation tensors |
| Variable tracking | Is-reduced flags (IR1, IR2) as scalars in [0.0, 1.0] |
| Memory (stack/queue) | NeuralStack, NeuralQueue — push/pop/null_op in superposition |
| Training | Gradient descent through λ-calculus interpreter |

**Claim**: "Existence proof that reasoning is possible inside a fully differentiable setting."

**Turing completeness via queue**: FSM + Queue = Turing Complete. If neural nets ≈ FSM, adding a NeuralQueue yields a full reasoning computer.

---

## What This Explains

### Why LLMs can code
Code is pure λ-calculus: variable binding (λx), application (function calls), substitution (argument passing). The same circuits that track subject-verb agreement (40-69% overlap across models) handle variable-function bindings. Filler-gap dependency heads (7.5, 7.6, 9.2) manage long-distance dataflow.

### Why LLMs fail at semantics
ICML 2026 asymmetry: syntax removal harms semantics, but semantics removal preserves syntax. This corresponds to the gap between *untyped* λ-calculus (syntax-only, Turing-complete) and *typed* λ-calculus (semantically constrained, strongly normalizing). LLMs produce syntactically valid programs that may not type-check — they approximate the typed λ-calculus without guaranteeing it.

### Why attention mechanisms work
The Query-Key-Value separation maps to the three parts of a λ-term:
- **Query** = the functional context hole [·] — what needs to be computed
- **Key** = the binder λx — what variable is being looked up
- **Value** = the term to substitute — what fills the hole

Soft β-reduction: instead of substituting *one* term for a variable, LLMs substitute a *weighted mixture* of all possible values.

---

## Summary

| Concept | λ-calculus | LLM equivalent |
|---------|------------|----------------|
| β-reduction | (λx.M)N → M[N/x] | Attention-weighted value retrieval |
| Variable binding | λx | Determiner-noun heads (68.91% overlap) |
| Application | M N | Subject-verb agreement circuits |
| α-conversion (rename) | λx.M = λz.M[x:=z] | Entity tracking (layer 1+) |
| Church-Rosser | Confluence | ICML 2026 asymmetry: syntax converges |
| Y combinator | fix f = f(fix f) | λ-RLM recursion |
| Curry-Howard | types=propositions | DSRA (31% differentia_quality) |
| Strong normalization | STLC terminates | ≠ LLM (unguaranteed) |
| Girard's paradox | No Type:Type | = LLM semantic failure mode |
