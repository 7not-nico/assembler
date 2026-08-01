**Attention** — The discovered form of weighted focus over elements. From Latin *attendere* "to stretch toward, direct the mind" — a mechanism that computes a weighted combination of input elements, where the weights (attention scores) are themselves computed from the inputs. Each element receives a relevance score determining how much it contributes to the output.

Attention was discovered in machine translation (Bahdanau et al., 2014) as a solution to the bottleneck problem: encoder-decoder architectures lost information about long input sequences because the encoder compressed everything into a single fixed-size vector. Attention solves this by letting the decoder look back at all encoder states, weighted by relevance. The key mathematical form: for each query, compute similarity (dot product) against all keys, normalize (softmax), then weight the corresponding values by the resulting distribution.

Attention is a discovered form because weighted focus is a natural cognitive operation — humans attend selectively to parts of their sensory input, and this mechanism arises naturally in any system that must process complex, structured information. The specific mathematical form (query × key → softmax → weight × value) was discovered through engineering, but the underlying principle is universal.

---
id: CON.ATTENTION
mode: theoretical
title: Attention
source: COG.MACHINE.LEARNING
precedes: [CON.TRANSFORMER]
tags: attention, self-attention, attention-mechanism, transformer, nlp, discovered-form
related: [CON.NEURAL.NETWORK, COG.LINEAR.ALGEBRA]
---
