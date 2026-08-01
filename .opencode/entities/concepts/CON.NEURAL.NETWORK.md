**Neural Network** — The discovered form of distributed parallel computation through interconnected processing units. From Greek *neuron* "nerve" — a network of simple computational nodes (neurons) connected by weighted edges (synapses), where each node computes a weighted sum of its inputs followed by a nonlinear activation function.

Neural networks were discovered through the observation that biological neural systems (the brain) perform computation through densely interconnected, individually simple units. The McCulloch-Pitts neuron (1943) formalized this as a mathematical abstraction; Rosenblatt's Perceptron (1958) demonstrated that such networks could learn. A neural network is a discovered form because distributed parallel computation through weighted connections is a natural computational paradigm — it exists in nature (brains, slime molds, ant colonies) before humans name it.

Neural networks are the substrate from which attention and transformers emerge. The classic architecture is a stack of layers: input → hidden layers (each with weights, bias, activation) → output. Training adjusts weights via backpropagation (gradient descent applied through the chain rule of calculus).

---
id: CON.NEURAL.NETWORK
mode: theoretical
title: Neural Network
source: COG.MACHINE.LEARNING
precedes: [CON.ATTENTION]
tags: neural-network, deep-learning, perceptron, backpropagation, activation-function, discovered-form
related: [CON.LEARNING, CON.REPRESENTATION, COG.LINEAR.ALGEBRA, COG.CALCULUS]
---
