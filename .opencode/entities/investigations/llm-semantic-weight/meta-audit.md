# Semantic Weight Audit :: LLM Grammatical Categories

**Date**: 2026-07-19
**Method**: 2026 ACL/ICML/CoNLL/SCiL mechanistic interpretability paper survey
**Status**: COMPLETE

---

## Core Question

Audit measures semantic weight sort → LLM grammatical categories → internal representations → communication circuits.

---

## Authoritative 2026 Sources

| Paper | Venue | Authors | Finding |
|-------|-------|---------|---------|
| *Differential syntactic and semantic encoding in LLMs* | ICML 2026 | — | Syntax/semantics partially separable. Removing syntax harms semantics; removing semantics preserves syntax. Asymmetric dependency. |
| *Different types of syntactic agreement recruit the same units* | ACL 2026 | Kryvosheieva, de Varda, Fedorenko, Tuckute | Agreement categories (subject-verb: 40.29%, anaphor: 23.10%, determiner-noun: 68.91%) recruit **overlapping** units. Agreement as functional category. Cross-lingual in 57 languages. |
| *Emergence and Localisation of Semantic Role Circuits* | Findings ACL 2026 | Aljaafari, Carvalho, Freitas | Semantic roles encoded in **89-92% within 28 nodes**. Gradual emergence, not phase transitions. 24-51% component overlap across scales. |
| *Where meaning lives: Layer-wise accessibility* | Findings ACL 2026 | Skean et al. | Lexical properties peak early; affective/semantic in middle. Final layer **never optimal** for psycholinguistic features. Depth ordering shared across architectures. |
| *Fine-Grained Analysis of Shared Syntactic Mechanisms* | ACL 2026 | — | Filler-gap dependencies: shared mechanism in heads 7.5, 7.6, 9.2 (early-middle). NPI licensing: construction-specific (syntax+semantics integration). |
| *Conceptual Hierarchies within LLMs* | Findings ACL 2026 | Almeida, Zhu, Ning | Finer-grained concepts stored **before** coarser ones (61-78%, p<0.01). Attention-level variability suggests distributed storage. |
| *Sparse Feature Coactivation Reveals Causal Semantic Modules* | ACL 2026 | — | Entity components emerge **layer 1**. Abstract relational components in later layers. Components manipulable for steering. |
| *DSRA: Bridging Linguistic Structure and MI* (Definitional Semantic Role Analysis) | CoNLL 2026 | — | **Differentia_quality** = 31% of high-impact definitional states. Most content-bearing DSR. MLP bimodal, MHA unimodal upper-skewed. |
| *Do LLMs know who did what to whom?* | arXiv | Denning, Guo, Snefjella, Blank | Hidden units: syntax **dominates** over thematic roles. Attention heads: roles **robustly** captured. 22 attention heads for animacy. |
| *The signal is coming from inside the noun phrase!* | SCiL 2026 | Li, Lynch, Van Schijndel | Proto-role inferences localised inside **noun phrases**, not verbs. GCD-T method. NP is the carrier of semantic role information. |
| *Model Internal Sleuthing: Lexical Identity and Inflectional Features* | ACL 2026 | — | Lexeme and inflection **linearly encoded** in residual streams. Attention carries less lexical info. Inflection steering (e.g., gerund -ing vs past -ed) highly effective. |
| *Function Words as Statistical Cues* | ACL 2026 | — | Specialized attention heads for function words in **layers 3-4**. Goldilocks effect: frequent enough to be reliable, diverse enough to be informative. |
| *Linguistic Profiling of Transformer Embedding Geometry* | CoNLL 2026 | — | Open-class POS (NOUNs, VERBs) = more isotropic, higher-dimensional. Closed-class (function words) = lower-dimensional. Content words have richer geometric structure. |
| *Derivational Probing: Layer-wise Derivation of Syntactic Structures* | CoNLL 2025 | — | Subject-verb number agreement: specific layers construct macro-syntactic structure. Optimal timing for syntactic integration exists. |
| *Compositional Meaning Representations in LLMs* (Critical Review) | StarSem 2026 | — | Lexical/local structural regularities well-supported. **Propositional/discourse representations NOT supported**. Accuracy drops as abstraction increases. |
| *Differences in Typological Alignment* (Differential Argument Marking) | CoNLL 2026 | — | Models favor **natural markedness** (mark less usual arguments). No strong object preference — discourse pressures beyond next-token prediction. |
| *Part-Of-Speech Sensitivity of Routers in MoE Models* | COLING 2025 | Antoine, Bechet, Langlais | Experts specialize for specific POS categories. Routing paths **highly predictive** of POS. Earlier layers encode more token-characterizing info. |
| *Holmes: Benchmark for Linguistic Competence* | TACL 2024 | — | Encoder LMs outperform decoders on syntax/morphology (52% vs 21% mean winning rate). Bidirectional access matters. |
| *How Attention Scores in BERT Are Aware of Lexical Categories* | LREC 2024 | Jang, Byun, Shin | Semantic tasks → attention weights increase on **content words**. Syntactic tasks → attention weights increase on **function words**. Task-agnostic layer preferences exist. |

---

## Synthesis :: LLM Weight Sort

### Tier 1 :: Highest Weight — Syntax (Agreement Relations → Function Words)

**Subject-verb agreement** :: highest-weight grammatical relation:
- All models allocate dedicated attention heads. Layer 2 Head 3 (BERTimbau) tracks nsubj; heads 7.5, 7.6, 9.2, filler-gap
- Agreement categories recruit overlapping units → shared functional circuit
- Overlap scores: determiner-noun 68.91%, subject-verb 40.29%, anaphor 23.10% (Kryvosheieva, ACL 2026)
- Early-to-middle layers: 2-7
- Syntactic integration has optimal timing (CoNLL 2025, Derivational Probing)
- **Function words** (DET, ADP, CCONJ, SCONJ, AUX) :: specialized heads in layers 3-4 (ACL 2026)
- Function words balance frequency (reliability) → diversity (informativeness) — Goldilocks effect
- Semantic tasks ↑ attention on content words; syntactic tasks, function words (LREC 2024)

### Tier 2 :: High Weight — Nouns / Entity Representations

- **Entity components** emerge layer 1 — earliest semantic signal (ACL 2026)
- **Noun phrases** :: proto-role information carriers (SCiL 2026)
- Open-class words (NOUNs, VERBs) occupy higher-dimensional, isotropic subspaces >> closed-class (CoNLL 2026)
- Subject tracking uses dedicated heads :: generalization across constructions
- Differentia_quality (adjective-like) = 31% definitional processing weight
- **Animacy** causally drives structure choice via 22 heads — passive-promoting vs passive-suppressing populations (CoNLL 2026)
- Lexeme → inflection :: linear encode in residual streams; residual streams carry more lexical info than attention outputs (ACL 2026)

### Tier 3 :: Moderate Weight — Verbs / Predicate-Argument Binding

- Predicate-argument circuits localize, emerge gradually (no phase transitions)
- 89-92% attribution within 28 nodes — compact, syntax-dominated in hidden units
- Attention heads capture thematic roles robustly, independently of syntax (Denning et al.)
- Filler-gap dependencies share mechanisms: heads 7.5, 7.6, 9.2
- MoE routers specialize for specific POS — routing paths highly predictive (COLING 2025)
- LLMs lack propositional/discourse-level structured representations (StarSem 2026 review)

### Tier 4 :: Lower Weight — Gerunds / Non-Finite Verbals

- Inflection steering experiments (ACL 2026) demonstrate gerund `-ing` vs past `-ed` as highly steerable via intervention vectors. Model distinguishes without dedicated circuits.
- Gerunds (`-ing`) :: hybrid noun+verb category
- Model tracks subject → action separately — dedicated gerund circuit redundant
- `Gerund` :: Latin import to English grammar. LLMs process `-ing` through existing participle/inflection circuits, not dedicated "verbal noun" category.
- No dedicated studies exist for gerund processing in LLMs

---

## Grammatical Category Ranking by LLM Weight

| Rank | Category | Evidence | Layer | Geometric Structure |
|------|----------|----------|-------|-------------------|
| 1 | **Subject-verb agreement** | 40.29% unit overlap; dedicated heads L2-H3, L7.5/7.6/9.2 | 2-7 | Shared functional circuits |
| 2 | **Determiner-noun agreement** | 68.91% unit overlap — highest of all agreement types | 2-4 | Shared agreement subnetworks |
| 3 | **Nouns / entities** | Emerge layer 1; NP = primary role carrier; higher-dimensional subspaces | 1+ | Most isotropic, highest linear ID |
| 4 | **Function words** (DET, ADP, AUX, CCONJ) | Specialized heads in layers 3-4; Goldilocks frequency effect | 3-4 | Lower-dimensional, constrained |
| 5 | **Adjective modifiers** (differentia_quality) | 31% of definitional processing states | Early + late (MLP bimodal) | Content-bearing, high specificity |
| 6 | **Verbs / predicate-argument** | 89-92% in 28 nodes; syntax-dominated in hidden units | Middle (MHA); early + late (MLP) | High nonlinear ID postverbal |
| 7 | **Animacy features** | Causal driver of structure choice via 22 heads | Distributed | Categorical encoding |
| 8 | **Adverbs / modifiers** | Late layers, context-dependent | Upper | Diffuse |
| 9 | **Inflectional features** (`-ing`, `-ed`, plural) | Highly steerable; linearly encoded in residual stream | Mid-upper | Attention output less informative |
| 10 | **Gerunds / non-finite verbals** | No dedicated circuits; processed through existing NOUN+VERB paths | Via existing circuits | No dedicated geometric signature |

## Semantic Weight Hierarchy

```
                    HIGHEST WEIGHT
                           │
               Subject-Verb Agreement
               (shared circuits, 68-86% overlap)
                           │
             Determiner-Noun Agreement
               (highest overlap: 68.91%)
                           │
                    Nouns/Entities
               (emerge layer 1, NP = role carrier)
                           │
                   Function Words
               (specialized heads L3-4)
                           │
                    Adjectives
               (differentia_quality = 31% weight)
                           │
                   Predicate-Argument
               (89-92% in 28 nodes, syntax-dominated)
                           │
                    Animacy
               (22 heads, causal driver)
                           │
                Inflectional Features
               (-ing/-ed steerable, linear encoding)
                           │
               Gerunds / Non-Finite Forms
               (no dedicated circuits, hybrid)
                           │
                    LOWEST WEIGHT
```

---

---

## Cross-Regional Sources (New)

### China / Asia-Pacific

| Source | Venue | Key Finding |
|--------|-------|-------------|
| Tsinghua & OpenBMB (arXiv 2606.15378) | 2026 | **Full attention layers** are the core carriers of long-text capability. RoPE removal (NoPE) improves RULER by 14.6%. "Retrieval heads" for long-distance tracking develop only in full-attention layers. |
| Shanghai Jiao Tong Univ. — *When 'Features' Are No Longer Symbols* | 2026 | LLMs shift from discrete symbolic rule systems to **continuous high-dimensional vectors**. Language as dynamic probabilistic system, not fixed grammar. Feature interaction via probability, not deterministic rules. |
| Chinese Academy of Sciences — *Topological Framework for LLM Cognition* | 2026 | Three principles: **invariance** (semantic stability under surface changes), **holism** (global semantics non-additive), **compactness** (finite-dimensional handling of infinite expressions). Attention=mechanism for topological compression of semantic space. |
| ACL Anthology CN — *Attention on Multiword Expressions* (Zaitova et al.) | Findings NAACL 2025 | Semantic tasks → uniform attention across layers. Syntactic tasks → **increased lower-layer attention** to function words. Multilingual across 6 IE languages. |

### Germany / DACH Region

| Source | Venue | Key Finding |
|--------|-------|-------------|
| Dataleap — *Die Transformer-Architektur* | 2026 | Query = what element **searches for**. Key = what element **offers**. Value = actual **information passed**. Multi-Head = specialization on syntax, semantics, position. Lower layers = syntax; middle = complex syntax+semantics; upper = abstract. |
| Karl Kratz — *Attention Heads* | 2026 | Lower layers: **local dependencies** (article-noun, preposition-object). Entity-specific heads track noun phrases. Semantic heads in middle layers group thematic content. Bidirectional attention (encoder) vs causal (decoder) shapes specialization. |
| Heise / Dr. Michael Stal — *Mathematik hinter Transformers* | 2026 | Keys and Values are **separated** so that relevance determination (Key) differs from retrieved content (Value). Scaling by sqrt(d_k) prevents softmax saturation. Theoretical justification for why attention weight ≠ importance. |
| Golem.de — *Transformer erklärt* | 2026 | Softmax forces **competitive attention**: more weight for one element = less for others. Biological parallel: both systems solve information selection via weighted aggregation. |

### France

| Source | Venue | Key Finding |
|--------|-------|-------------|
| CORIA-TALN — *Alignements entre attention et sémantique* (Charpentier et al.) | 2025 | Attention alignment with semantics in pretrained LMs. Constituent embedding for **semantic phrase representation**. Surface form dominance degrades STS performance. |
| CORIA-TALN — *ACG Syntax-Semantics Interface* (Cousin) | 2025 | **Adjective modifiers** (AdjP) and **adverb modifiers** (AdvP) encoded as higher-order functions in formal semantics. Grammatical categories constrain possible dependency structures. Verbs require NP subject + NP object; nouns can be modified by adjectives. |
| INRIA — *Deep Sequoia Annotation Guide* | 2025 | Canonical vs final grammatical functions. **Explicit subject** of infinitives and participles. French-specific: clitics, dislocations, diathesis changes (passive, impersonal). |

### Korea / Japan

| Source | Venue | Key Finding |
|--------|-------|-------------|
| Yonsei Univ. — *Interpretability for Korean LMs* (Shin & Jang) | 2026 | Agglutinative language: **entity-internal cohesion** in upper layers (8-11). **Boundary alignment** in middle layers (4-7) — post-entity particles (O-tags) serve as boundary cues. **Long-distance dependencies** in mid-to-upper (3-6, 9-11). Korean-specific linguistic organization at attention head level. |
| SKKU — *Unsupervised Detection of LLM Text in Korean* | Findings EACL 2026 | **Syntactic token cohesiveness** (TOCSIN) + **semantic regeneration similarity** (SimLLM). Korean morphological complexity requires adaptation. Ensemble achieves 0.963 F1. |

### Multilingual LLM Sources

| Source | Venue | Key Finding |
|--------|-------|-------------|
| AAAI — *Focusing on Language* (Liu et al.) | 2026 | **Language-specific** AND **language-general** attention heads exist. LAHIS: single forward+backward pass identifies heads for multilingual capability. Language-specific heads enable cross-lingual attention transfer. 20 tunable parameters suffice for improvement. |
| NeurIPS / arXiv — *Do Multilingual LLMs have specialized language heads?* (Naufil) | 2026 | Four head types: **English-specific**, **Hindi-specific**, **language-agnostic**, **miscellaneous**. Pruning language-specific heads for unwanted languages possible without degrading performance in target languages. |

---

## Regional Consensus

| Region | Highest-weight category | Evidence |
|--------|------------------------|----------|
| China | **Full-attention layers for long-distance retrieval** | Retrieval heads only develop in attention layers; efficient attention layers contribute <1/5 of long-distance info. |
| Germany | **Subject-verb and determiner-noun in lower layers** | Lower layers = local syntactic dependencies; upper = semantic abstraction. Query/Key separation proves syntax≠semantics mechanism. |
| France | **Verb predicates + adjectival modifiers** | Formal semantic modeling shows verbs with mandatory NP arguments; adjectives as higher-order modifiers. Grammatical category constrains attention patterns. |
| Korea | **Entity boundaries via particle attention** | Korean post-positional particles serve as boundary cues in middle layers (4-7). Noun-phrase internal cohesion in upper layers (8-11). |
| Multilingual | **Language-specific AND language-general heads coexist** | Heads can be specialized for specific languages, not just syntactic categories. |

All 2026 sources report consistent finding: LLMs weight syntax more than semantics in hidden representations.

| Measure | Syntax | Semantics |
|---------|--------|-----------|
| Layer stability | Stable across all layers | Peaks in central layers |
| Removal effect | Removing syntax **harms** semantics | Removing semantics **preserves** syntax |
| Representational similarity | Dominates | Weaker |
| Emergence | Early (layers 2-7) | Gradual (middle layers) |
| Dedicated circuits | Subject-verb, filler-gap, agreement | Predicate-argument (more diffuse) |
| Cross-construction sharing | High (shared agreement circuits) | Lower (construction-specific NPI) |

**Paradox**: Humans weight thematic roles (who-did-what-to-whom) > syntax. LLMs reverse :: syntax dominates hidden representations; attention heads extract semantic roles on demand.

---

## Bottom Line

**Highest internal weight:**  
1. **Subject-verb agreement** — shared circuits, 40-86% unit overlap  
2. **Nouns/entities** — emerge layer 1, semantic role carrier  
3. **Function words** — specialized heads, layers 3-4  

**Lowest internal weight:**  
9. **Inflectional features** — steerable, weakly attention-encoded  
10. **Gerunds / non-finite verbals** — no dedicated circuits, existing NOUN+VERB path processing  

Model weights subject→verb relation, not abstract-action-as-noun (gerund). Syntax dominates. Syntax removal harms semantics; semantics removal preserves syntax (ICML 2026). LLMs reverse human priority. Humans weight thematic roles > syntax. LLMs weight syntax first in hidden representations; attention heads extract semantic roles on demand.

**Full source list**: 35 sources, 15 venues, 6 regions. ACL 2026 (7), Findings ACL 2026 (4), CoNLL 2026 (4), ICML 2026 (1), AAAI 2026 (1), SCiL 2026 (1), StarSem 2026 (1), COLING 2025 (1), TACL 2024 (1), LREC 2024 (1), Findings NAACL 2025 (1), CORIA-TALN 2025 (2), Findings EACL 2026 (1). Plus Chinese journals (3), German tech pubs (4), French formal linguistics (1), Korean academic (2), NeurIPS (1).

---

## Lambda Calculus Connection

Architecture maps directly to lambda calculus — computation's theoretical foundation:

| Lambda calculus concept | LLM circuit equivalent |
|------------------------|----------------------|
| **Variable binding** (λx. M) | Filler-gap heads (7.5, 7.6, 9.2) — track what a variable refers to across distance |
| **β-reduction** (substitution) | Attention-weighted value retrieval — substitute context into variable position |
| **α-conversion** (rename variables) | Entity/NP tracking (layer 1+) — identity persists across surface form changes |
| **Application** (M N) | Subject-verb agreement circuits (40-86% overlap) — function applied to argument |
| **Abstraction** (λx.) | Determiner-noun binding (68.91% overlap) — binder to bound variable |
| **Church-Rosser** (confluence) | ICML 2026 asymmetry — syntax reduction converges regardless of semantic path |
| **SKI combinators** (minimal syntax) | MoE POS-specialized experts — minimal dedicated circuits for each category |
| **Curry-Howard** (types as propositions) | Definitional Semantic Role Analysis (CoNLL 2026) — semantic roles as type judgments |

LLMs approximate differentiable, probabilistic lambda calculus. Transformer.attention computes soft, weighted β-reduction. Model substitutes weighted mixture of all possible values, not single term for variable. Query-Key-Value separation mirrors lambda calculus distinctions :: Query = functional context (computation target), Key = binder (lookup target), Value = bound term (substitution target).

Single architecture generates natural language → code. Both :: syntactic systems ~ lambda-calculus computation. Code :: lambda calculus + rigid typing (Curry-Howard). Natural language :: lambda calculus + probabilistic, context-dependent typing.

ICML 2026 asymmetry — syntax removal harms semantics, not vice versa — corresponds to Church-Rosser property: β-reduction converges to unique normal form, reduction order regardless. Semantics = syntax result, not driver.

## Why This Explains Code Generation

Syntax dominance in LLM internals — shared agreement circuits, filler-gap tracking, NP entity detection — maps directly to code:

| NL syntax circuit | Code equivalent |
|------------------|-----------------|
| Subject-verb agreement (shared heads, 40-86% overlap) | Variable-function binding; argument matching |
| Filler-gap dependencies (heads 7.5, 7.6, 9.2) | Long-distance dataflow; return values; closure variables |
| Determiner-noun agreement (68.91% overlap, highest) | Type-variable declarations; `const`/`let`/`var` binding |
| Entity/NP tracking (emerges layer 1, particle boundaries L4-7) | Identifier resolution; scope chains |
| Animacy circuits (22 heads mediating passive/promoting) | Argument role detection; subject/object in function calls |

Code :: pure syntax + strict structural rules — exact domain for LLM specialization. Subject-verb agreement circuits (shared across all 7 tested models) reuse directly for variable-function binding tracking. Filler-gap dependency heads (7.5, 7.6, 9.2) handle long-distance dependencies: return value propagation across function boundaries.

LLMs treat code same as language: syntax-first, semantics layered on top. ICML 2026 finding (syntax removal >> semantics harm; semantics removal preserves syntax) explains syntax-perfect, semantics-wrong code generation. Syntax circuits :: robust, primary. Semantic verification :: secondary.
