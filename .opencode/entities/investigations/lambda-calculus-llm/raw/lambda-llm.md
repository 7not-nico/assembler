# Region: Lambda Calculus + LLM Connection

## Sources

| Paper | Venue | Key Finding |
|-------|-------|-------------|
| *Towards a Neural Lambda Calculus* (Flach, Moreira, Lamb) | JBCS 2026 | Transformer learns β-reduction with 99.73% accuracy. Self-attention captures variable dependencies. Seq2seq + λ-calculus models can learn full computation. |
| *The Y-Combinator for LLMs* (Roy et al.) | arXiv 2603.20105, 2026 | λ-RLM framework for long-context reasoning. Typed functional runtime: SPLIT, MAP, FILTER, REDUCE as combinators. Y-combinator for recursion. LLM as bounded oracle at leaves only. |
| *Transformers are Stateless Differentiable Neural Computers* (Tang & Xie) | arXiv 2603.19272, 2026 | Formal proof: transformer layer ≡ stateless DNC. Value matrix = write-once memory. Attention = content-based read. Multi-head = multiple read heads. |
| *λ-RLM* (lambda-calculus-llm) | GitHub 2026 | Open-source implementation of typed recursive reasoning. Three layers: symbolic (combinators), planning (deterministic), neural (β-reductions at leaves). |
| *Neural Lambda Calculus* (neurallambda) | GitHub | Fully differentiable λ-calculus. Substitution implemented via tensor operations. NeuralStack + NeuralQueue for memory. "Existence proof that reasoning is possible in a differentiable setting." |
| *Gradient-Based Program Synthesis* (Macfarlane et al.) | arXiv 2604.18907, 2026 | Neural Language Interpreter (NLI) learns discrete symbolic-like language end-to-end. Gumbel-Softmax for differentiable program synthesis. Outperforms ICL on compositional tasks. |

## Key Findings

### Transformer as λ-calculus executor
- Transformer learns β-reduction with **99.73% accuracy** (one-step), **97.70%** (multi-step)
- Self-attention captures variable binding dependencies across arbitrary distances
- The model generalizes to unseen λ-terms — true compositional generalization

### Transformer as differentiable DNC (sDNC)
- **Formal theorem**: causal transformer layer ≡ stateless Differentiable Neural Computer
- Key-value projections = controller emitting key-value pairs into memory
- Attention = content-based read from write-once memory
- Multi-head = parallel read heads
- Residual + MLP = independent post-processing

### λ-RLM: Control flow via combinators
- Replaces free-form LLM code generation with SPLIT/MAP/FILTER/REDUCE
- Y-combinator for recursion — recursion as explicit semantic object
- LLM used only as **bounded oracle** on leaf subproblems
- Formal guarantees: termination, cost bounds, depth = ⌈logₖ(n/τ)⌉

### Differentiable λ-calculus
- NeuralLambda: substitution as tensor operation in fully differentiable setting
- "Existence proof that reasoning is compatible with gradient descent"
- NeuralStack + NeuralQueue for memory — Turing-complete via queue addition to FSM
