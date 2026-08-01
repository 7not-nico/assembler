**Lib Module** — a unit of shared logic inside `.opencode/lib/` with a single responsibility, explicit contract (exports + dependencies, see TERM.PURITY.PROTOCOL), and a strict import boundary. Lib modules restrict imports to builtins, npm packages, and sibling lib modules. Tool files stay outside the import boundary.

Each lib module follows the 7 universal principles validated across all major software engineering traditions (see reference section):

1. **High cohesion, low coupling** — 高内聚低耦合 (Aliyun Developer 2024); module internals are tightly related to a single purpose
2. **Clear interface contract** — contrat d'interface clair (AppMaster 2023); communication through well-defined APIs over internal details
3. **Information hiding** — encapsulation behind a facade (Parnas 1972); internal implementation is hidden behind the interface
4. **Single responsibility** — one actor, one reason to change (Martin 2002)
5. **Acyclic dependency** — dependency graph stays acyclic (Martin 1994)
6. **Separation of concerns** — divide by what changes together; gather what changes for the same reason
7. **Interface over implementation** — depend on abstractions over concretions (DIP, all regions)

## See also

- `PROT.LIB.CONTRACT` — contract block format examples
- `ILL.LIB.CONTRACT.BLOCK` — contract declaration walkthrough

---
id: TERM.LIB.MODULE
title: Lib Module
source: CON.DECOUPLING
tags: [lib, module, architecture, convention, cross-region]
related: [TERM.PURITY.PROTOCOL]
reference:
  - title: On the Criteria To Be Used in Decomposing Systems into Modules (Parnas 1972)
    url: https://www.win.tue.nl/~wstomv/edu/2ip30/references/criteria_for_modularization.pdf
  - title: Clean Architecture — The Dependency Rule (Martin 2012)
    url: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
  - title: 软件架构设计的原则与模式 (Aliyun 2024)
    url: https://developer.aliyun.com/article/1572074
  - title: Architecture modulaire — 5 principes clés (AppMaster 2023)
    url: https://appmaster.io/fr/blog/pourquoi-utiliser-une-architecture-modulaire-dans-la-conception-de-logiciels
  - title: モジュール設計の基本概念 (BREXA 2026)
    url: https://engineering-technology.brexa.com/blog/technavi/dr-modulardesign
  - title: Softwarearchitektur — IEEE Std 1471-2000 (Tecnovy 2026)
    url: https://tecnovy.com/de/software-architektur-ultimative-leitfaden
  - title: Package Principles — ADP, CCP, SDP (Martin 1994-2017)
    url: https://en.wikipedia.org/wiki/Package_Principles
---
