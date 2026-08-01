**Architecture** — the structural design of a neural network: the graph of computational layers, their connectivity, and the flow of information through them. An architecture is a blueprint before it is a program.

Architecture determines what functions a network can represent and what inductive biases it carries. Convolutional architectures encode translation equivariance; recurrent architectures encode sequential dependence; transformer architectures encode pairwise attention. The architecture is the hypothesis space — the set of functions learnable through optimization. Depth matters: deeper architectures can represent certain functions with exponentially fewer parameters than shallow ones (Berner et al. 2021, §3). Architecture search (NAS) treats the design itself as optimizable. Architecture is a concept because a design exists as a graph before any implementation in silicon or code.

---
id: CON.ARCHITECTURE
mode: practical
title: Architecture
source: COG.COMPUTER.SCIENCE
tags: machine-learning,neural-networks,architecture,deep-learning

---
