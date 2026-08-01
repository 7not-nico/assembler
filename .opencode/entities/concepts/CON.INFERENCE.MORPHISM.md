**Inference Morphism** — a transformer layer (or equivalent operation) treated as a morphism in the categorical sense: a structure-preserving map between KV-cache or hidden states. Composition of layers is composition of morphisms. The identity morphism is a no-op passthrough.

**Domain** — the input KV-cache or hidden state at a given layer.

**Codomain** — the output KV-cache or hidden state after the layer.

**Composition** — sequential application: layer_n ∘ ... ∘ layer_2 ∘ layer_1.

**Morphism classes** — distinct attention variants (CSA, HCA, SWA) are different morphism classes distinguished by compression rate and selection strategy.

**Examples** — DeepSeek-V4 interleaves CSA, HCA, and SWA morphisms across layers. DSpark composes a draft morphism with a verify morphism for speculative decoding.

---
id: CON.INFERENCE.MORPHISM
mode: theoretical
title: Inference Morphism
source: COG.MATH
tags: category-theory,inference,composition,transformer,llm,deepseek

---
