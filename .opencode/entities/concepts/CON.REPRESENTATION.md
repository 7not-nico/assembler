**Representation** — the encoding of information in a form a model can process. A representation maps raw data (pixels, text, audio) into a structured space where semantically similar inputs are near each other.

Representation learning seeks to discover the underlying explanatory factors of variation in data — features that disentangle the causes of observed variation (Bengio, Courville, Vincent 2013). Deep learning succeeds because hierarchical representations compose: edges from pixels, shapes from edges, objects from shapes. Embeddings are a special case: discrete entities (words, nodes, items) mapped into continuous vector space where arithmetic captures semantics — `king − man + woman ≈ queen`. Representation is a concept because it exists as a mathematical map before any physical storage.

---
id: CON.REPRESENTATION
mode: theoretical
title: Representation
source: COG.COMPUTER.SCIENCE
precedes: [CON.NEURAL.NETWORK]
tags: machine-learning,representation-learning,embeddings,features
---
