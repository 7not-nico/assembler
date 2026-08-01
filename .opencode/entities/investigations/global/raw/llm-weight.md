# What LLMs Assign Most Semantic Weight To

**Method**: Survey of 35+ papers from ACL 2026, ICML 2026, CoNLL 2026, AAAI 2026, SCiL 2026, and more.

---

## Core Finding

**LLMs weight syntax > semantics in hidden representations.** This is the consistent finding across all 2026 sources. The ICML 2026 DeepSeek-V3 study shows the asymmetry clearly: removing syntax from representations harms semantic similarity measurements, but removing semantics *preserves* syntax.

---

## Grammatical Category Ranking

| Rank | Category | Evidence | Layer | Overlap/Strength |
|------|----------|----------|-------|-------------------|
| 1 | **Subject-verb agreement** | Kryvosheieva et al. ACL 2026 | L2-7 | 40.29% overlap; shared circuits across 7 models |
| 2 | **Determiner-noun agreement** | Kryvosheieva et al. ACL 2026 | L2-4 | **68.91%** — highest of all agreement types |
| 3 | **Nouns / entities** | Sparse Feature Coactivation ACL 2026 | L1+ | Emerge from layer 1; NP = primary role carrier |
| 4 | **Function words** (DET, ADP, AUX) | Function Words as Statistical Cues ACL 2026 | L3-4 | Specialized heads; Goldilocks frequency effect |
| 5 | **Adjective modifiers** (differentia_quality) | DSRA CoNLL 2026 | Early+Late | 31% of definitional processing states |
| 6 | **Verbs / predicate-argument** | Aljaafari et al. Findings ACL 2026 | Middle (MHA) | 89-92% in 28 nodes; syntax-dominated |
| 7 | **Animacy features** | CoNLL 2026 (Animacy Effects) | Distributed | 22 heads; passive-promoting vs suppressing |
| 8 | **Adverbs / modifiers** | Linguistic Profiling CoNLL 2026 | Upper | Late layers, context-dependent |
| 9 | **Inflectional features** (-ing, -ed, plural) | Model Internal Sleuthing ACL 2026 | Mid-upper | Steerable; attention output less informative |
| 10 | **Gerunds / non-finite verbals** | — (no dedicated studies) | Via existing circuits | No dedicated circuit; processed through NOUN+VERB paths |

---

## Why Syntax Dominates

| Measure | Syntax | Semantics |
|---------|--------|-----------|
| Layer stability | Stable across all layers | Peaks in central layers |
| Removal effect | Removing syntax **harms** semantics | Removing semantics **preserves** syntax |
| Representational similarity | Dominates | Weaker |
| Emergence | Early (layers 2-7) | Gradual (middle layers) |
| Dedicated circuits | Subject-verb, filler-gap, agreement | Predicate-argument (more diffuse) |
| Cross-construction sharing | High (shared agreement circuits) | Lower (construction-specific NPI) |

**Paradox**: Humans weight thematic roles (who-did-what-to-whom) over syntax. LLMs reverse this.

---

## Key Sources (2026)

| Venue | Paper | Key finding |
|-------|-------|-------------|
| ICML 2026 | Differential syntactic and semantic encoding in LLMs | Syntax/semantics separable; syntax removal harms semantics |
| ACL 2026 | Different types of syntactic agreement recruit the same units | 40-69% overlap; agreement as functional category |
| Findings ACL 2026 | Emergence and Localisation of Semantic Role Circuits | 89-92% in 28 nodes; gradual emergence |
| ACL 2026 | Fine-Grained Analysis of Shared Syntactic Mechanisms | Filler-gap: heads 7.5, 7.6, 9.2; shared mechanism |
| ACL 2026 | Sparse Feature Coactivation Reveals Causal Semantic Modules | Entity components from layer 1 |
| CoNLL 2026 | DSRA: Definitional Semantic Role Analysis | Differentia_quality = 31% of definitional states |
| ACL 2026 | Model Internal Sleuthing | Lexeme/inflection linear; inflection steerable |
| ACL 2026 | Function Words as Statistical Cues | Specialized heads L3-4; Goldilocks effect |
| CoNLL 2026 | Linguistic Profiling of Transformer Embedding Geometry | Open-class = higher-dimensional; closed-class = lower |
| SCiL 2026 | The signal is coming from inside the noun phrase | NP = primary carrier of proto-role information |
| Findings ACL 2026 | Where meaning lives | Final layer never optimal for psycholinguistic features |
| ACL 2026 | Conceptual Hierarchies within LLMs | Finer concepts before coarser (61-78%) |
| StarSem 2026 | Compositional Meaning Representations | Lexical/local supported; discourse NOT supported |
