**Decoupling** — the process of identifying what aspects of a project can separate as work evolves and complexity grows. Not a one-time refactor, but a continuous necessity of great software engineering: as a system accumulates logic, the developer recognizes boundaries, extracts coherent domains, and lets each part evolve independently.

Coupling = dependence degree between system parts (MIT 6.005). Decoupling reduces it via interface/implementation split — interface stable, implementation free (Stanford CS190). Information hiding: encapsulate decisions so no other module depends on them. Dedicated SE curriculum topic (MIT 6.170 lec 2-3). In-assembler: `REF.META.DOMAIN.DIRECTORY` extraction morphism. Goal = intentional coupling (explicit, minimal, interface-bound).

---
id: CON.DECOUPLING
mode: practical
title: Decoupling
source: COG.COMPUTER.SCIENCE
tags: software-engineering,architecture,modularity,dependency-management,design-principle

---
