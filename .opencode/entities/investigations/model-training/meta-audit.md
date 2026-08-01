**Model Training — Global Research Index**

English-language surveys dominate, with Chinese institutions close behind (Peking U, BNU, ECNU). Japanese, Korean, German, French regions produce individual papers but no comprehensive surveys in native languages — English is the lingua franca. JP/KR focus on efficient pretraining (STEP, VTrain, Peri-LN). DE emphasizes infrastructure energy efficiency (OpenGPT-X, MPG neuromorphic, DFKI, LRZ). FR targets low-resource adaptation, frugal learning, and national sovereignty (ANR projects, CamemBERT, Jean Zay supercomputer).

Core tension: training efficiency methods (quantization, pruning, distillation, data selection) studied in isolation, rarely as coupled bottlenecks. Unified frameworks emerging in 2025 (Unifying Data/Memory/Compute survey, Data-centric flywheel, Mid-training paradigm).

Data: schemas/seed.sql — 36 sources, 10 meta-analyses, 24 researchers, 8 gaps.

---
id: MANIFEST.MODEL-TRAINING-AUDIT
title: Model Training — Global Research Index
summary: 36 sources, 6 regions, 10 meta-analyses, 24 researchers across EN/CN/JP/KR/DE/FR
tags: [model-training, LLM, efficient-training, distributed-training, research-index, cross-country]
tables: [fundamentals, regions, sources, meta-analyses, researchers, gaps]
---

## Fundamentals

| ID | Concept | Source | Key idea |
|----|---------|--------|----------|
| F.DATA | Data-centric efficiency | Luo et al. (2025) | Five-component data value flywheel: selection, quality, synthetic, distillation, self-evolving |
| F.MEM | Memory bottlenecks | GPU memory dominant in fine-tuning | Jointly reducing weight storage, optimizer states, activation memory needed |
| F.MID | Mid-training | Mo et al. (2025) | Targeted specialization phase between pre-training and fine-tuning |
| F.SCALE | Chinchilla scaling laws | Hoffmann et al. (2022), DeepMind | 20 tokens per parameter for compute-optimal training |
| F.LOWP | Low-precision training | arXiv 2505.01043 | Fixed-point, floating-point, and custom formats for LLM training |
| F.POST | Post-training pipeline | Tie et al. (2025) | Five paradigms: fine-tuning, alignment, reasoning, efficiency, integration |
| F.HPC | HPC training | OpenGPT-X (2025), Jülich | Megatron-LM, FSDP, FlashAttention, sequence parallelism on JUWELS Booster |
| F.MOE | Mixture of Experts | Sparse activation reduces compute per token | MoE + MoD (Mixture of Depths) emerging as dominant efficient architecture |
| F.PEFT | Parameter-efficient fine-tuning | LoRA, QLoRA | <0.1% of weights updated; LoRA typically 99.9% parameter reduction |

## Meta-analyses

| ID | Title | Scope | Key finding | Effect/size |
|----|-------|-------|-------------|-------------|
| MA.DATA | Efficient LLM Training: Data-centric | 200+ papers | Five-component data flywheel taxonomy; synthetic generation and self-evolving ecosystems emerging | taxonomy |
| MA.LOWP | Low-Precision Training Methods | comprehensive | Three format categories: fixed-point, floating-point, customized; quantization-aware training overlap | taxonomy |
| MA.MID | Mid-Training of LLMs | first unified paradigm | Three domains: data distribution, LR scheduling, long-context extension | first taxonomy |
| MA.EFF | Efficient Large Language Models | 200+ papers | Model-centric (quantization, pruning, distillation), data-centric, framework-centric | taxonomy |
| MA.DIST | Efficient Training on Distributed Infrastructures | comprehensive | Parallelism strategies: data, tensor, pipeline, sequence; FSDP, ZeRO, Megatron | taxonomy |
| MA.UNIFY | Unifying Data, Memory, Compute | constraint-centric | Resource-conditioned decision-making; dynamic data selection identified as critical gap | framework |
| MA.POST | Post-training of LLMs | first comprehensive | Five paradigms; LRMs (o1/o3, DeepSeek-R1) represent shift to reasoning-centric training | taxonomy |
| MA.ARCH | Efficient Architectures | 2023-2025 | Linear attention, sparse attention, MoE, hybrid designs, diffusion LLMs | taxonomy |
| MA.ATTN | Efficient Attention Mechanisms | comprehensive | Linear (kernelized, recurrent, fast-weight) and sparse (fixed, block, clustering) attention | taxonomy |
| MA.SYS | Peak Performance SLR (PRISMA) | 65/983 papers | Training optimization, hardware optimization, scalability, reliability | SLR |

## By Region

### EN (English) — PASS

| Source | Institution | Key content | Language |
|--------|-------------|-------------|----------|
| arxiv 2504.10013 | Jülich/OpenGPT-X | Training LLMs on HPC; Teuken-7B on JUWELS Booster | EN |
| arxiv 2510.25817 | Multiple | Data-centric survey; data value flywheel | EN |
| arxiv 2501.11847 | Multiple | Memory-efficient large-scale model training | EN |
| arxiv 2510.06826 | Multiple | Mid-training survey; first unified paradigm | EN |
| arxiv 2505.01043 | Multiple | Low-precision training: fixed/float/custom formats | EN |
| arxiv 2304.03589 | Multiple | Efficient training: data/model/optimization/system-centric | EN |
| arxiv 2401.02038 | Multiple | LLMs from training to inference: comprehensive overview | EN |
| arxiv 2312.03863 | Multiple | Efficient LLMs: model/data/framework-centric | EN |
| arxiv 2407.20018 | Multiple | Distributed infrastructure training survey | EN |
| arxiv 2606.10706 | Multiple | Unifying data/memory/compute efficiency | EN |
| arxiv 2503.06072 | Multiple | Post-training survey: fine-tuning, alignment, reasoning, efficiency | EN |
| arxiv 2508.09834 | Multiple | Efficient architectures: linear/sparse attention, MoE, diffusion | EN |
| arxiv 2307.06435 | Multiple | Comprehensive LLM overview (Minaee et al.) | EN |
| arxiv 2411.10478 | Multiple | LLMs for ML workflow construction and optimization | EN |
| arxiv 2409.04833 | Multiple | Peak performance SLR for LLMs (PRISMA) | EN |
| openreview | Multiple | Automated data preparation, data selection (GREATS) | EN |

### CN (Chinese) — PASS

| Source | Institution | Key content | Language |
|--------|-------------|-------------|----------|
| jcst.ict.ac.cn (2025) | ICT CAS | AI computing systems for LLM training | ZH/EN |
| aas.net.cn (2025) | Peking University | PEFT survey: additive, selective, reparameterized, hybrid | ZH/EN |
| aas.net.cn (2025) | Xi'an Jiaotong | Continual learning evolution in LLM era | ZH/EN |
| aclanthology.cn (2025) | Multiple | Active learning with LLMs: selection to generation | ZH/EN |
| cdut.edu.cn (2025) | Beihang Univ | Industrial LLM white paper; training pipeline, MoE | ZH |
| jcad.cn (2026) | Multiple | LLM explainability survey | ZH |
| jeit.ac.cn (2024) | Multiple | Continual learning: theory, methods, applications | ZH |

### JP (Japanese) — PASS

| Source | Institution | Key content | Language |
|--------|-------------|-------------|----------|
| ci.nii.ac.jp (2025) | CiNii | Comprehensive LLM overview (ACM TIST) | EN/JP |
| anlp.jp (2025) | Multiple | STEP: staged parameter-efficient pretraining | JP/EN |
| anlp.jp (2025) | NII/Tokyo | LLM-jp-3 training process analysis; 8 model sizes | JP/EN |
| anlp.jp (2025) | Multiple | Synthetic data + active learning for knowledge retention | JP/EN |
| arxiv 2606.10706 (trans.) | Fugu-MT | Memory-efficient training translation | JP |
| hatelabo.jp (2025) | Individual | Time-series analysis of speed/accuracy innovation methods | JP |

### KR (Korean) — PASS

| Source | Institution | Key content | Language |
|--------|-------------|-------------|----------|
| pure.kaist.ac.kr (MICRO 2024) | KAIST | VTrain: simulation framework for cost-effective LLM training | EN |
| pure.kaist.ac.kr (ICML 2025) | KAIST | Peri-LN: normalization layer placement in Transformers | EN |
| pure.kaist.ac.kr (NeurIPS 2025) | KAIST | Schedule-Free methods for LM training | EN |
| koreascience.kr (2024) | Multiple | LoRA + Curriculum Learning for Korean | KO/EN |
| i-na.kaist.ac.kr (SIGCOMM 2024) | KAIST | StellaTrain: multi-cluster training with consumer GPUs | EN |
| dis-cos.sogang.ac.kr (2024) | Sogang | ACUTE: multi-level checkpointing for DDL on spot VMs | EN |
| cvlab.yonsei.ac.kr (CVPR 2025) | Yonsei | DYNAS: dynamic supernet training for NAS | EN |
| nairl.kr (2025) | NAIRL | Neural scaling: efficiency and accessibility | KO |
| newswire.co.kr (2025) | SNU | PPL: policy-labeled preference learning for RLHF (ICML Spotlight) | KO/EN |
| discuss.pytorch.kr (2025) | Community | LLM foundations book review (Xiao & Zhu) | KO |
| arxiv multiple | Multiple | General LLM training surveys in Korean search | EN |

### DE (German) — PASS

| Source | Institution | Key content | Language |
|--------|-------------|-------------|----------|
| fz-juelich.de (ISC 2023) | Jülich | OpenGPT-X: LLM training on JUWELS Booster HPC | EN/DE |
| mpg.de (2023) | MPI for Light | Self-learning physical machines for neuromorphic training | DE |
| dfki.de (2025) | DFKI Saarbrücken | ESCADE: energy-efficient AI; 90% compression via distillation | DE |
| lrz.de (2025) | LRZ Munich | GPT-style model training on SuperMUC-NG (Intel GPU) | DE |
| dena.de (2024) | dena | Energy-efficient AI study; NNC standards | DE |
| publications.rwth-aachen.de (2025) | RWTH Aachen | Dataset storage optimization for ML on HPC | DE/EN |
| mind-verse.de (2025) | Community | ECO: error-compensating optimizer for quantized training | DE |
| th-brandenburg.de (2025) | TH Brandenburg | ML course materials; CRISP-DM workflow | DE |
| michaelkipp.de | Individual | Training pipeline: pre-training, mid-training, SFT, alignment | DE |
| mpgl.mpg.de (2025) | MPG | HORNs: oscillating recurrent networks; beyond scaling | DE |

### FR (French) — PASS

| Source | Institution | Key content | Language |
|--------|-------------|-------------|----------|
| cnrsformation.cnrs.fr (2025) | CNRS/IDRIS | Deep learning on Jean Zay supercomputer training | FR |
| coria-taln-2025.lis-lab.fr | Multiple | Data augmentation strategies for low-resource LLM domains | FR/EN |
| coria-taln-2025.lis-lab.fr | Multiple | SCOPE: self-supervised faithfulness for conditional text gen | FR/EN |
| coria-taln-2025.lis-lab.fr | Multiple | Contamination detection in LLMs practical survey | FR/EN |
| coria-taln-2025.lis-lab.fr | Multiple | Active learning with LLMs for NER (Mixtral-8x7B) | FR/EN |
| l2s.centralesupelec.fr (2025) | CentraleSupélec | DL optimization: Lyapunov analysis, adaptive LR | FR/EN |
| gretsi.fr (2025) | Multiple | Multilevel approach to accelerate Transformer training | FR/EN |
| lri.fr | Inria/LRI | Neural architecture growth for frugal learning | FR/EN |
| labo-llm.fr | Individual | LLM training pipeline: scaling laws, SFT, RLHF, DPO | FR |
| sorbonne-universite.fr (2026) | Sorbonne | LLM adaptation for low-resource languages (Kabyle) | FR |
| camembert-model.fr (2020) | Multiple | CamemBERT training: data size vs. variability impact | FR/EN |
| ins2i.cnrs.fr (2023) | CNRS | ANR projects: MALADES, Pantagruel - sovereign French LLMs | FR |

## Gaps

| ID | Region | Status | Notes |
|----|--------|--------|-------|
| GAP.JP.SURVEY | Japan | no native surveys | JP publishes LLM training results in English; no comprehensive JP-language survey identified |
| GAP.KR.SURVEY | Korea | no native surveys | KR institutions publish in English; VTrain, Peri-LN, StellaTrain are individual papers |
| GAP.DE.SURVEY | Germany | no native survey | DE focus on HPC infrastructure and energy efficiency; no systematic survey of training methods |
| GAP.FR.SURVEY | France | no native survey | FR targets low-resource, frugal learning, sovereignty; no comprehensive training survey |
| GAP.ES | Spain | not searched | Could produce LLM training research in Spanish/Catalan |
| GAP.RU | Russia | not searched | May have training research especially for non-Latin scripts |
| GAP.IT | Italy | not searched | Italian NLP community active but model training coverage unknown |
| GAP.BR | Brazil | not searched | Portuguese-language ML community could have relevant surveys |

## Key Researchers by Region

| Name | Region | Institution | Specialisation |
|------|--------|-------------|----------------|
| Junyu Luo | EN | PKU | Data-centric LLM training |
| Kaixiang Mo | EN | — | Mid-training paradigm |
| Guiyao Tie | EN | — | Post-training surveys |
| Zhongwei Wan | EN | — | Efficient LLMs survey |
| Weigao Sun | EN | — | Efficient architectures |
| Chelsea John | DE | Jülich/JSC | OpenGPT-X HPC training |
| Florian Marquardt | DE | MPI for Light | Neuromorphic training, self-learning machines |
| Wolfgang Maaß | DE | DFKI/Uni Saarland | Energy-efficient AI, ESCADE |
| Sabine Janzen | DE | DFKI | Knowledge distillation, model compression |
| Ajay Navilarekal Rajgopal | DE | LRZ | GPT training on SuperMUC-NG |
| Richard Dufour | FR | LS2N/Nantes | MALADES project, sovereign French LLMs |
| Didier Schwab | FR | LIG/Grenoble | Pantagruel multimodal French models |
| Guillaume Charpiat | FR | Inria/LRI | Frugal learning, neural architecture growth |
| Manon Verbockhaven | FR | Inria/LRI | Growing tiny networks |
| Arthur Amalvy | FR | LS2N/LIA | Long document LLM adaptation |
| Samia Bouzefrane | FR | Sorbonne | LLM adaptation for low-resource languages (Kabyle) |
| Benjamin Bensaid | FR | CentraleSupélec | DL optimization, Lyapunov analysis |
| Hwijoon Lim | KR | KAIST | StellaTrain, multi-cluster training |
| Jeongwoo Lee | KR | SNU | PPL: RLHF, ICML 2025 Spotlight |
| Kwanghoon Kim | KR | NAIRL | Neural scaling |
| J. Jeon | KR | Yonsei | DYNAS: supernet training for NAS |
| Kazuki Yano | JP | — | STEP: staged parameter-efficient pretraining |
| Yuto Nishida | JP | NII/Tokyo | LLM-jp-3 training analysis |
| Naoya Takeishi | JP | UTokyo | ML for scientific models |
