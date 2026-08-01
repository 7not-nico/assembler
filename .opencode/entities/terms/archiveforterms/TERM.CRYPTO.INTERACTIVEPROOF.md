**Interactive Proof System** — a protocol between two algorithms: a computationally unbounded prover P and a probabilistic polynomial-time verifier V. P and V exchange messages; V tosses private random coins and decides acceptance based on the transcript. A language L has an interactive proof if:

- **Completeness** — for x ∈ L, an honest prover convinces V with probability ≥ 2/3
- **Soundness** — for x ∉ L, any dishonest prover convinces V with probability ≤ 1/3

Interactive proofs generalize classical NP proofs by adding interaction (multiple message rounds) and randomization (verifier's private coins). The class IP equals PSPACE (Shamir 1990), demonstrating that interaction and randomization dramatically increase the power of proof systems beyond NP.

Interactive proofs are the direct predecessor of zero-knowledge proofs: ZKP = interactive proof + zero-knowledge property.

---
id: TERM.CRYPTO.INTERACTIVEPROOF
title: Interactive Proof System — Prover–Verifier Protocol
source: Goldwasser–Micali–Rackoff 1985, Babai 1985
tags: cryptography,complexity,proof,interactive-protocol,ip
related: [TERM.CRYPTO.ZEROKNOWLEDGEPROOF, CON.MATH.FORMALPROOF]
reference:
  - title: Goldwasser–Micali–Rackoff — The Knowledge Complexity of Interactive Proof-Systems (1985)
    url: https://people.csail.mit.edu/silvio/Selected%20Scientific%20Papers/Proof%20Systems/The_Knowledge_Complexity_Of_Interactive_Proof_Systems.pdf
  - title: Princeton COS 522 — Interactive Proofs lecture notes
    url: https://www.cs.princeton.edu/courses/archive/spr06/cos522/ip.pdf
  - title: Cornell CS 6820 — Interactive Proofs and the Sum-Check Protocol
    url: https://www.cs.cornell.edu/courses/cs6820/2022fa/notes/ip.pdf
---