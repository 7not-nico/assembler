**Mixture of Experts (MoE)** — a machine learning architecture that divides computation across multiple specialized sub-networks (experts) with a learned gating mechanism that routes each input to a subset of experts. The gating network produces a probability distribution over experts; only the top-k experts activate per forward pass, enabling model capacity to scale without proportional compute cost.

---
id: ML.MIXTUREOFEXPERTS
title: Mixture of Experts
type: architecture
paradigm: supervised
subfield: deep-learning, ensemble-methods
category: sparse-computation, gating
source: CON.MACHINE.LEARNING
precedes: []
tags: mixture-of-experts, moe, sparse-activation, gating-network, conditional-computation, neural-network, llm
related: []
reference:
  - title: "Adaptive Mixtures of Local Experts — Jacobs, Jordan, Nowlan, Hinton (1991)"
    url: https://doi.org/10.1162/neco.1991.3.1.79
  - title: "Outrageously Large Neural Networks — Shazeer et al. (2017)"
    url: https://arxiv.org/abs/1701.06538
  - title: "Switch Transformers — Fedus, Zoph, Shazeer (2022)"
    url: https://arxiv.org/abs/2101.03961
  - title: "Mixture-of-Experts — Wikipedia"
    url: https://en.wikipedia.org/wiki/Mixture_of_experts
---
