**Tokens** — the atomic unit of text an LLM processes, words or subwords mapped to integers via a tokenizer. Token count determines conversation length, model choice, and cost. Every LLM enforces a fixed maximum token capacity per forward pass, defined by its context window — exceeding it requires truncation, summarization, or chunking.

---
id: TERM.TOKENS
title: Tokens
source: tooling
related: [TERM.CONTEXT.WINDOW]
tags: [concept, llm, platform]
reference:
  - title: OpenAI Tokenizer
    url: https://platform.openai.com/tokenizer
---