**Optimization** — the mathematical procedure of minimizing a loss function over a parameter space. In machine learning, optimization is the engine of learning: given a model with parameters θ and a loss function L(θ), find θ* = argmin L(θ).

Gradient descent iteratively steps in the direction of steepest descent: θ_{t+1} = θ_t − η∇L(θ_t). Stochastic gradient descent approximates the gradient using a random subset of data — introducing noise that aids escape from saddle points and sharp minima. The non-convexity of neural network loss landscapes means convergence to a global optimum is not guaranteed, yet in practice gradient methods find solutions that generalize well. Understanding why is an active area (Berner et al. 2021, §4).

Optimization is not a physical process — it is a mathematical flow on a loss surface. It exists as calculus and linear algebra before any chip executes it.

---
id: CON.OPTIMIZATION
mode: practical
title: Optimization
source: COG.COMPUTER.SCIENCE
tags: machine-learning,optimization,gradient-descent,calculus

---
