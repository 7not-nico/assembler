**Learning** — a system improving its performance on a task through experience (data). A mathematical process of adjusting parameters to minimize error on observed examples, with the expectation of performing well on unseen examples.

Formally: given a task T, a performance measure P, and experience E, a system is said to learn from E if its performance at T (measured by P) improves with E (Mitchell 1997). In modern ML, this reduces to an optimization problem: minimize empirical risk over a training set while maintaining low risk over the true data distribution.

Learning is not a physical process — it is an abstract mathematical procedure. It exists as optimization theory before any computer executes it. The distinction between learning (the concept) and training (the physical act of running an optimizer on hardware) is the clearing between concept and definition.

---
id: CON.LEARNING
mode: theoretical
title: Learning
source: COG.COMPUTER.SCIENCE
precedes: [CON.NEURAL.NETWORK]
tags: machine-learning,learning-theory,optimization,generalization
---
