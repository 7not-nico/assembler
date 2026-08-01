A zero-knowledge proof (ZKP) is a cryptographic protocol between two parties — a prover and a verifier. The prover convinces the verifier that a statement is true without revealing any information beyond the statement's validity.

Three required properties:
- **Completeness** — an honest prover always convinces an honest verifier
- **Soundness** — a dishonest prover cannot convince an honest verifier (except with negligible probability)
- **Zero-knowledge** — the verifier learns nothing beyond the fact that the statement is true

Two forms:
- **Interactive** — multiple challenge-response rounds between prover and verifier
- **Non-interactive (NIZK)** — a single proof string the prover produces; anyone can verify without interaction. Achieved via the Fiat–Shamir heuristic.

Major families:
- **zk-SNARKs** — succinct, constant-size proofs, fast verification, requires trusted setup
- **zk-STARKs** — transparent (no trusted setup), quantum-resistant, larger proof size
- **Bulletproofs** — short proofs without trusted setup, efficient for range proofs
- **PLONK** — universal trusted setup, reusable across circuits

First formalized by Goldwasser, Micali, and Rackoff in 1985.

---
id: TERM.CRYPTO.ZEROKNOWLEDGEPROOF
title: Zero-Knowledge Proof — Prove Without Revealing
source: Goldwasser–Micali–Rackoff 1985
tags: cryptography,zero-knowledge,proof,cryptographic-protocol
related: [TERM.CRYPTO.INTERACTIVEPROOF]
precedes: [TERM.CRYPTO.INTERACTIVEPROOF]
reference:
  - title: "Boaz Barak — Lecture 14: Zero Knowledge Proofs (Harvard CS 127)"
    url: https://www.boazbarak.org/cs127spring16/chap14_zero_knowledge.html
  - title: "RDI Berkeley — Zero Knowledge Proofs course"
    url: https://rdi.berkeley.edu/zk-learning
  - title: "Oded Goldreich — Zero-Knowledge (a tutorial, Weizmann Institute)"
    url: https://www.wisdom.weizmann.ac.il/~oded/zk-tut02.html
---