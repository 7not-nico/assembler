**Generalization** — performing well on data never seen during training. The central puzzle of machine learning: why do overparameterized models that could memorize any training set instead learn patterns that transfer to new examples?

Generalization is the gap between empirical risk (error on training data) and true risk (error on the data distribution). The classical PAC-learning bound depends on model complexity, but modern deep networks defy this — they have far more parameters than training examples yet generalize well. Understanding why is an open mathematical question (Berner et al. 2021). Neural tangent kernel theory, implicit regularization via gradient descent, and the lottery ticket hypothesis each offer partial answers.

Generalization is not a property of hardware — it is a statistical property of the learned function. It exists in the space between the model, the data distribution, and the optimization trajectory.

---
id: CON.GENERALIZATION
mode: theoretical
title: Generalization
source: COG.COMPUTER.SCIENCE
tags: machine-learning,generalization,learning-theory,statistical-learning

---
