**Cortical Hierarchy Category Coding** — categorical representations shift from rare single-neuron tuning in sensory areas to robust population-level category signals in parietal and frontal cortex, with strongest category signals in LIP. Population-level category information is ubiquitous even where single neurons show no tuning. Across the hierarchy, dimensionality increases while clustering decreases from sensory to frontal.

Pattern: sensory-rare-single → parietal-robust-population → frontal-abstract-category

Implication: categorical coding is not a single mechanism but a hierarchy of coding regimes — low-dimensional categorical in sensory areas, high-dimensional mixed-selectivity in cognitive areas.

Data: schemas/seed.sql — 35+ sources, 5 meta-analyses, 20+ researchers, 7 gaps.

---

id: MANIFEST.CORTICAL-HIERARCHY-AUDIT
title: Cortical Hierarchy Category Coding — Meta-Audit
summary: 35+ sources, 7 regions, 5 meta-analyses, 20+ researchers, 7 gaps across V1 → PFC/OFC
tags: [neuroscience, cortical-hierarchy, category-coding, visual-system, research-index]
tables: [per-region-summary, fundamentals, regions, meta-analyses, gaps, key-researchers]

---

## Per-Region Summary

| Region | Status | Sources | Key Finding |
|--------|--------|---------|-------------|
| V1-V3 | PASS | 5 | Animacy/size decodable from V1 populations. Color categorization emerges. Categorical representations rare — high-dimensional code dominates |
| V4 | PASS | 5 | Mid-level hub: shape-texture continuum, color categories, category × attention interaction. 35% foveal units category-selective |
| LOC/ITC | PASS | 4 | Shape-dominant: weak single-neuron category tuning, strong at population level. Category trumps shape as organizing principle |
| MTL | PASS | 5 | Concept cells with semantic tuning curves. Region-based feature coding bridges vision to categories. Abstract semantic hierarchy |
| LIP/Parietal | PASS | 5 | Strongest category signals in the hierarchy. Causal role in perceptual decisions. Curved task-dependent manifolds |
| MFC/dACC | PASS | 5 | Separate decision axes for memory vs categorization. Task-set representations. Theta-phase locking to MTL for memory retrieval |
| PFC/OFC | PASS | 5 | OFC neurons categorically encode single decision variables (confidence, value). dlPFC for rule-based, vmPFC for prototype learning. Abstract category representations |

## Fundamentals

| ID | Concept | Source | Key idea |
|----|---------|--------|----------|
| F.SINGLE | Single-neuron category tuning | Posani et al. 2024 | Rare outside primary sensory areas; only categorical at V1-V3 level |
| F.POP | Population-level category info | Multiple studies | Ubiquitous even where single neurons show no category tuning |
| F.GRADIENT | Hierarchy gradient | Fusi, Miller & Rigotti 2016 | Dimensionality increases, clustering decreases from sensory → frontal |
| F.REGIMES | Two coding regimes | Multiple studies | Low-dimensional categorical in sensory areas, high-dimensional mixed-selectivity in cognitive areas |

## By Region

### V1-V3 — PASS

| ID | Source | Institution | Key finding | Methodology |
|----|--------|-------------|-------------|-------------|
| V1-V3.ANIMACY | PMC10312552 | MIT | Animacy/real-world size decodable from V1 populations | single-unit |
| V1-V3.COLOR | Sah 1996 | — | Color categorization boundaries present in V1/V2/V4 | electrophysiology |
| V1-V3.SPATIAL | PMC6057270 | — | Spatial frequency → categorical representations in ~180ms | MEG |
| V1-V3.CLUSTER | JNeurosci 33:15454 | — | Categorical clustering of color space emerges in V4v/VO1 | fMRI |
| V1-V3.HIGHDIM | bioRxiv 2024 | — | Categorical structure rare, high-dimensional separability maximal | single-unit |

### V4 — PASS

| ID | Source | Institution | Key finding | Methodology |
|----|--------|-------------|-------------|-------------|
| V4.FOVEAL | SciAdv | — | 35% foveal units show category selectivity (faces vs houses) | single-unit |
| V4.SHAPETEXT | JNeurosci 2019 | — | Shape-texture coding continuum | single-unit |
| V4.WMCOLOR | bioRxiv 2021 | — | Categorical working memory codes for color | electrophysiology |
| V4.CONTEXT | JNeurosci 42:6408 | — | Task context modulates feature selectivity | single-unit |
| V4.DOMAINS | PMC4912377 | — | Functional domains for color, luminance, orientation | fMRI |

### LOC/ITC — PASS

| ID | Source | Institution | Key finding | Methodology |
|----|--------|-------------|-------------|-------------|
| LOC.SHAPE | NatureComms 2024 | — | Human LOC: shape-dominant, ~3% single-channel category-only, 48% shape×category interaction | single-unit |
| LOC.ANIMATE | PMC10124953 | — | Animate-inanimate primary organizing dimension, not aspect ratio | fMRI |
| LOC.SHAPESIM | PLOS CompBio 2013 | — | Shape similarity > semantic membership for IT representations | single-unit |
| LOC.GRADIENT | SciRep 2020 | — | Orthogonal shape/category gradients: shape in V1, category in anterior VTC | fMRI |

### MTL — PASS

| ID | Source | Institution | Key finding | Methodology |
|----|--------|-------------|-------------|-------------|
| MTL.CONCEPT | NatureComms 2025 | — | Concept cells: sparse, invariant semantic representations | single-unit |
| MTL.REGION | PMC11811184 | — | Region-based feature coding: neurons respond to feature-space regions | single-unit |
| MTL.TUNING | bioRxiv 2025 | — | Semantic tuning curves: graded, sigmoidal responses along semantic dimensions | single-unit |
| MTL.HIERARCHY | PLOS Bio 2019 | — | Abstract hierarchy: fruit → food → natural things at population level | single-unit |
| MTL.RELATION | PMC8545952 | — | Concept cells flexibly encode abstract relations between concepts | single-unit |

### LIP / Parietal — PASS

| ID | Source | Institution | Key finding | Methodology |
|----|--------|-------------|-------------|-------------|
| LIP.STRONGEST | NatureNeuro 2012 | — | LIP shows strongest, earliest category signals — stronger than PFC | single-unit |
| LIP.CAUSAL | Science 2019; PMC10255012 | — | Causal role: inactivation impairs categorical decisions | inactivation |
| LIP.MANIFOLD | PMC8273140 | — | Curved decision manifolds: task-dependent rotation in state space | single-unit |
| LIP.VSMIP | JNeurosci 2013 | — | LIP more involved in categorization, MIP in motor response | single-unit |
| LIP.MST | JNeurosci 2022 | — | MST also shows robust category encoding | single-unit |

### MFC / dACC — PASS

| ID | Source | Institution | Key finding | Methodology |
|----|--------|-------------|-------------|-------------|
| MFC.SUBSPACE | Science 2020 | — | Separate population subspaces for memory-based vs categorization-based decisions | single-unit |
| MFC.PRESMA | NatureComms 2018 | — | Pre-SMA encodes categorical boundaries for time intervals | single-unit |
| MFC.DACC | PMC3416924 | — | dACC neurons encode cognitive load, conflict adaptation | single-unit |
| MFC.THETA | Science 2020 | — | MFC-HA theta-phase locking selectively engaged during memory retrieval | LFP |
| MFC.UTILITY | NatureHumBehav 2023 | — | Pre-SMA encodes integrated utility signal for value-based choice | single-unit |

### PFC / OFC — PASS

| ID | Source | Institution | Key finding | Methodology |
|----|--------|-------------|-------------|-------------|
| PFC.CLUSTERS | Nature 2019 | — | OFC neurons form ~9 categorical clusters, each encoding a single decision variable | single-unit |
| PFC.VARIABLES | PLOS CompBio 2019 | — | Decision variables: confidence, integrated value, reward size — categorically encoded | single-unit |
| PFC.RULEPROTO | JNeurosci 44:34 | — | dlPFC: rule-based; vmPFC: prototype learning, attention to diagnostic features | single-unit |
| PFC.ABSTRACT | Science 291:312 | — | Lateral PFC: abstract category representations for visual stimuli | single-unit |
| PFC.VALUE | NatureComms 2020 | — | Value and choice are separable, stable population representations in OFC | single-unit |

## Meta-analyses

| ID | Citation | Scope | Key finding |
|----|----------|-------|-------------|
| MA.POSANI | Posani et al. 2024 (bioRxiv) | 43 cortical regions in mice | Categorical only in primary sensory; high-dimensional code elsewhere; max separability everywhere |
| MA.FUSI | Fusi, Miller & Rigotti 2016 (Curr Opin Neurobiol) | Review: mixed selectivity | High-dimensional representations enable flexible linear readout |
| MA.KOURTZI | Kourtzi & Connor 2011 (Annu Rev Neurosci) | Object representations | Shape, category, and adaptive coding across ventral stream |
| MA.FREEDMAN | Freedman & Assad 2011 (Nat Neurosci) | Common mechanism review | Category and perceptual decisions share neural substrate in parietal |
| MA.MONETA | Moneta, Grossman & Schuck 2024 (TINS) | OFC/vmPFC | Task states and values integrated; mixed selectivity common |

## Gaps

| ID | Area | Description | Severity |
|----|------|-------------|----------|
| GAP.MICRO | Within-area microarchitecture | How do categorical clusters form at columnar scale in humans? (only inferred from fMRI) | high |
| GAP.HOMOLOGY | Cross-species homology | Human LOC ↔ macaque ITC/TE/TEO mapping still debated | high |
| GAP.DEVELOPMENT | Development | How do categorical representations emerge during learning? (adult studies only) | medium |
| GAP.CAUSAL | Causal interactions | Most evidence correlational; inactivation/perturbation only in monkey LIP and PFC | high |
| GAP.NATURAL | Naturalistic stimuli | Most studies use controlled lab stimuli — how do categories work in natural vision? | medium |
| GAP.HUMAN | Single-neuron human data | Only available from epilepsy patients (MTL, MFC, LOC) — surgical constraints | high |
| GAP.EXEMPLAR | Within-category structure | How are exemplars organized within a category representation? | medium |

## Key Researchers by Region

| Region | Key Labs |
|--------|----------|
| V1-V4 | DiCarlo (MIT), Connor (JHU), Pasupathy (U Washington), Livingstone (Harvard) |
| LOC/ITC | Op de Beeck (KU Leuven), Janssen (KU Leuven), Grill-Spector (Stanford), Kanwisher (MIT) |
| MTL | Rutishauser (Cedars-Sinai), Quian Quiroga (Leicester), Kreiman (Harvard), Mormann (Bonn) |
| LIP/Parietal | Freedman (U Chicago), Shadlen (Columbia), Huk (UT Austin), Gold (UPenn) |
| MFC | Rushworth (Oxford), Kolling (Oxford), Procyk (Lyon), Holroyd (UC Santa Cruz) |
| PFC/OFC | Padoa-Schioppa (WashU), Wallis (UC Berkeley), Miller (MIT), Kepecs (WashU), Schoenbaum (NIDA) |
