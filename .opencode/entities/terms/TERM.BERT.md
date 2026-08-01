**BERT** — Bidirectional Encoder Representations from Transformers. A language model architecture introduced by Devlin et al. at Google (2018) that uses a stack of transformer encoder blocks with bidirectional self-attention, meaning each token can attend to all tokens in both left and right context. BERT is pretrained on two objectives: masked language modeling (predict randomly masked tokens from their context) and next sentence prediction (predict whether two sentences are consecutive).

BERT demonstrated that bidirectional encoder pretraining learns rich contextual representations that transfer to downstream tasks through fine-tuning. BERT's architecture: 12 transformer encoder layers (BERT-BASE, 110M parameters) or 24 layers (BERT-LARGE, 340M parameters), each with multi-head self-attention and feed-forward sublayers. It established the pretrain-then-finetune paradigm for NLP.

---
id: TERM.BERT
title: BERT
type: external
source: CON.TRANSFORMER
precedes: []
tags: bert, encoder, bidirectional, language-model, nlp, transformer, external
related: []
reference:
  - title: "BERT: Pre-training of Deep Bidirectional Transformers (Devlin et al., 2018)"
    url: https://arxiv.org/abs/1810.04805
  - title: BERT — Google Research
    url: https://github.com/google-research/bert
---
