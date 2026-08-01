**Transformer** — The discovered form of attention-only sequence processing. From Latin *trans-* "across" + *formare* "to shape" — a neural network architecture that processes sequences using only attention mechanisms, without recurrence (RNNs) or convolution (CNNs). The transformer arranges input elements into queries, keys, and values; computes pairwise attention scores; and produces weighted combinations through stacked self-attention and feed-forward layers.

The transformer was discovered by Vaswani et al. (2017) in "Attention Is All You Need." Its key innovations: multi-head attention (multiple parallel attention computations capture different relationships), positional encoding (since attention has no inherent notion of order, positions must be encoded as signals), and the encoder-decoder structure (encoder reads all inputs bidirectionally; decoder generates outputs autoregressively).

The transformer is a discovered form because attention-only processing is a natural evolutionary step in sequence modeling — once attention mechanisms existed, the transformer architecture emerged as the minimal and most effective way to organize them. It has two canonical variants: encoder-only (BERT — bidirectional pretraining) and decoder-only (GPT — autoregressive generation).

---
id: CON.TRANSFORMER
mode: theoretical
title: Transformer
source: COG.MACHINE.LEARNING
precedes: [TERM.BERT, TERM.GPT]
tags: transformer, attention, self-attention, multi-head-attention, encoder, decoder, discovered-form
related: [CON.ATTENTION, CON.NEURAL.NETWORK, COG.LINEAR.ALGEBRA]
---
