**GPT** — Generative Pre-trained Transformer. A language model architecture introduced by Radford et al. at OpenAI (2018) that uses a stack of transformer decoder blocks with masked (causal) self-attention, meaning each token can only attend to tokens in its left context. GPT is pretrained on autoregressive language modeling: predict the next token given all previous tokens.

GPT demonstrated that autoregressive decoder pretraining produces a model that generates coherent text and can be adapted to downstream tasks through fine-tuning. GPT's architecture: 12 transformer decoder layers (GPT-1, 117M parameters). Each layer contains masked multi-head self-attention (tokens attend only to preceding positions) and a feed-forward sublayer. GPT established the autoregressive decoder paradigm and led to the scaled GPT-2 (2019), GPT-3 (2020), and GPT-4 (2023) series.

---
id: TERM.GPT
title: GPT
type: external
source: CON.TRANSFORMER
precedes: []
tags: gpt, decoder, autoregressive, language-model, nlp, transformer, external
related: []
reference:
  - title: "Improving Language Understanding by Generative Pre-Training (Radford et al., 2018)"
    url: https://openai.com/research/language-unsupervised/
  - title: "Language Models are Unsupervised Multitask Learners (GPT-2, Radford et al., 2019)"
    url: https://d4mucfpksywv.cloudfront.net/better-language-models/language_models_are_unsupervised_multitask_learners.pdf
  - title: "Language Models are Few-Shot Learners (GPT-3, Brown et al., 2020)"
    url: https://arxiv.org/abs/2005.14165
---
