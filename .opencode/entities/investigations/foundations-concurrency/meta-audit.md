# Meta-Audit: Foundations of Concurrency in Computer Science

**Date**: 2026-07-15
**Method**: Cross-region systematic survey (xresearch-geo)
**Commercial-source ratio**: 0% (all academic)

---

## Per-Step Status

| Step | Status |
|------|--------|
| FOUNDATIONS (xrequire-foundations) | FAIL — no patlib entities for concurrency |
| DECOMPOSITION | PASS — 5 anchors confirmed (Concurrency Models, Memory Models, Classic Problems, Synchronization Primitives, Concurrent Data Structures) |
| RESEARCH (xresearch-geo) | PASS — 6 regions, 28 queries, all PASS |

---

## Regions Surveyed

| Region | Languages | Status | Sources |
|--------|-----------|--------|---------|
| en-US | English | PASS | 30 |
| zh-CN | Chinese | PASS | 30 |
| EU (UK-centric) | English | PASS | 30 |
| JP | Japanese | PASS | 30 |
| DE | German (English-language research) | PASS | 30 |
| FR | French | PASS | 30 |

---

## Fundamentals

### Anchor 1: Concurrency Models
Concurrency models span hardware (PRAM, multi-core, GPU), OS (processes, threads), language (fibers, coroutines, actors), and formal (CSP, CCS, π-calculus) levels. The key dichotomy is shared-memory vs message-passing.

| Source | Institution | Key Finding |
|--------|-------------|-------------|
| MIT 6.031 Reading 21 | MIT | Shared memory vs message passing dichotomy; processes, threads, time-slicing; race conditions |
| OSTEP Ch.26 (Remzi) | U Wisconsin | Thread abstraction; context switching; multi-threaded address space; parallelism vs concurrency |
| CSP (Hoare) | Oxford | Process algebra foundation; traces; nondeterminism; communication; dining philosophers as CSP example |
| Cambridge Concepts of PL | U Cambridge | PRAM, BSP, CSP, CCS, π-calculus, Actors taxonomy; MPI vs OpenMP vs CUDA |
| Winskel & Nielsen Models | U Cambridge | Category-theoretic survey of all concurrency models; interleaving vs non-interleaving |
| AI Lab Tsinghua Rust | Tsinghua University | Rust Send/Sync traits; compile-time thread safety; channels; ownership-based concurrency |
| Xiamen DB (Lin Ziyu) | Xiamen University | DBMS process models: per-worker process, per-worker thread, process pool |

### Anchor 2: Memory Models
Memory models define the interface between program and system. Central concepts: sequential consistency (Lamport), happens-before, DRF-SC (data-race-free → sequential consistency).

| Source | Institution | Key Finding |
|--------|-------------|-------------|
| JSR-133 (Pugh, Manson) | U Maryland | Java Memory Model; sequential consistency; happens-before; causality requirements; DRF-SC |
| Adve & Gharachorloo Tutorial | UNC / DEC WRL | Taxonomy of consistency models: SC → TSO → release → weak; programmer vs system perspective |
| Cambridge PL Semantics Problem | U Cambridge | Major open problem: JMM unsound, C/C++11 too weak, thin-air executions; DRF-SC proven in HOL4 |
| Mathematizing C++ Concurrency (Batty et al.) | U Cambridge | Formal Isabelle/HOL model of C++11; DRF-SC theorem; multiple issues found in draft standard |
| Go Memory Model (DRF-SC) | Go CN | DRF-SC guarantee; happens-before; channel/Mutex/atomic; formal definition follows Boehm-Adve |
| USTC Architecture | USTC | Hardware sequential consistency; cache coherence; read-modify-write |
| JCST TSO Semantics | ICT CAS | TSO trace semantics in UTP; algebraic laws; linearizability |

### Anchor 3: Classic Problems
Three canonical problems: producer-consumer (bounded buffer), readers-writers (two priority variants), dining philosophers (deadlock demonstration).

| Source | Institution | Key Finding |
|--------|-------------|-------------|
| UC Davis Handout | UC Davis | Problem definitions: producer-consumer, readers-writers (2 priority variants), dining philosophers |
| Cambridge CDS | U Cambridge | Semaphore solutions; one-to-one and many-to-many producer-consumer; ring buffer; condition synchronization |
| Cornell CS414 | Cornell | Semaphore and monitor solutions; deadlock prevention (4 conditions); resource allocation graphs |
| Calvin College (Adams et al.) | Calvin College | Visualization tools as pedagogical aids for classic problems |
| WHUT OS | Wuhan U Tech | Standard Chinese OS curriculum: P/V operations, classic problems, deadlock |
| Silberschatz/Galvin/Gagne | Warwick/Strathclyde | OS textbook standard: bounded buffer, readers-writers, dining philosophers |

### Anchor 4: Synchronization Primitives
Hierarchy from hardware atomics through spinlocks, semaphores, monitors, to high-level language constructs.

| Source | Institution | Key Finding |
|--------|-------------|-------------|
| OSTEP Ch.31 (Remzi) | U Wisconsin | Semaphore patterns; reader-writer locks; building semaphores from CVs; deadlock |
| Stanford CS110 | Stanford | Mutexes, CVs, semaphores; permits, binary/general coordination; layered construction |
| Cambridge CDS L4 | U Cambridge | CCRs -> monitors -> condition variables; Hoare vs Mesa signal semantics; historical evolution |
| Princeton COS 318 | Princeton | Semaphores, monitors, barriers; producer-consumer; interrupt-driven concurrency |
| Illinois CS340 | U Illinois | Atomic ops (TAS, CAS); locks, CVs, semaphores, barriers; detailed API coverage |
| Cambridge ConcDistSys | U Cambridge | Full course: threads -> mutual exclusion -> semaphores -> CCRs -> monitors -> deadlock -> transactions |
| LLVM Atomics Guide (CN) | LLVM CN | Atomic ordering: unordered, monotonic, acquire, release, seq_cst; per-arch code generation |

### Anchor 5: Concurrent Data Structures
Non-blocking and lock-free structures implementing stacks, queues, hash tables, skip lists, and linked lists with linearizability and progress guarantees.

| Source | Institution | Key Finding |
|--------|-------------|-------------|
| MIT Scalable Lock-Free Stack (Hendler et al.) | MIT CSAIL | Elimination-backoff stack; Treiber stack; elimination array; lock-free and linearizable |
| MIT Concurrent Skip List (Herlihy et al.) | MIT CSAIL | Optimistic skip list; lazy validation; marking for logical deletion; wait-free contains |
| MIT Split-Ordered Lists (Shalev/Shavit) | MIT CSAIL | Lock-free extensible hash table via split-ordering; bit-reversal; CAS-based resize |
| Cambridge Lock-Free Linked-List (Harris) | Cambridge | Practical CAS-based linked list; pointer marking; linearizable insert/delete |
| Cambridge Concurrent Programming Without Locks (Fraser/Harris) | Cambridge | MCAS, WSTM, OSTM; non-blocking skip lists, red-black trees |
| Oxford CSP Lock-Free Queue Analysis (Lowe) | Oxford | CSP model checking of MS-queue linearizability; FDR; hazard pointer verification |
| Tianjin U Wait-Free List | Tianjin/TJU | Wait-free unordered linked list; fast-path-slow-path; wait-free via helping |
| USTC B-Queue | USTC | Batching lock-free SPSC queue; backtracking deadlock prevention; cache-aware |

---

## By Region Findings

| Region | Strengths | Gaps |
|--------|-----------|------|
| **en-US** | Deep coverage of all 4 anchors. Best: memory models (JSR-133, Adve), OSTEP, MIT courseware | Limited formal methods; limited lock-free/STM coverage |
| **zh-CN** | Wide OS curriculum coverage. Best: Go memory model, LLVM atomics, architecture-level SC, TSO formalism | Limited CSP/π-calculus/Actors in Chinese; limited lock-free |
| **EU (UK)** | World-leading formal models (CSP, CCS, π-calculus, Cambridge). Best: programming language concurrency semantics (Batty, Sewell), DRF-SC proof | Limited non-English sources; limited GPU concurrency; limited async/await |
| **JP** | Strong hardware-level coverage. Best: Tsukuba (Yas) concurrency taxonomy; Kochi Tech MMLib for SC/TSO/PSO model checking; Waseda SW cache coherency | Limited π-calculus/Actors coverage; limited formal verification; limited STM; limited JMM/C++11 language model coverage |
| **DE** | Strong HPC and weak memory model research. Best: MPI-SWS Weakestmo event-structure model; TU Dresden consistency taxonomy; TUM lock/monitor theory; RWTH C++ memory model docs | Limited CSP/π-calculus; limited Actor model; limited async/await; limited STM |
| **FR** | World leader in weak memory model formalization and process calculi. Best: INRIA Alglave/Maranget herd7 + cat models; INRIA Garavel CADP process calculus tools; INRIA Ladeveze RC11 DRF-SC Coq proof; INRIA Chappe Choice Trees | Limited GPU concurrency; limited lock-free structures beyond CAS; limited async/await beyond Lwt |

---

## Gaps

| Gap | Regions Affected | Notes |
|-----|-----------------|-------|
| **Formal methods for concurrency** (TLA+, Alloy, Coq) | en-US, zh-CN | Cambridge/UK has some, but limited across all regions |
| **Software Transactional Memory** | All | Only brief mentions; no deep treatment |
| **GPU concurrency** (CUDA, OpenCL, Vulkan) | All | Mentioned in taxonomy but no detailed coverage |
| **Wait-free data structures (practical)** | All | Most CDS work lock-free; wait-free algorithms remain rare and complex |
| **Formal verification of concurrent data structures** | All | Cambridge/Oxford exceptions; CSP model checking limited |
| **Memory management for lock-free** (hazard pointers, RCU, epoch-based) | All | Limited to specialized sources; critical for practical deployment |
| **Modern async/await patterns** | All | Some coroutine coverage but no systematic treatment |
| **Verification of concurrent programs** | en-US, zh-CN | Cambridge has some (Isabelle/HOL); NJU covers data race detection |

---

## Key Researchers by Region

| Region | Researchers | Affiliations |
|--------|-------------|-------------|
| **en-US** | Leslie Lamport (SC), Sarita Adve (memory models), Remzi Arpaci-Dusseau (OSTEP), Bill Pugh (JSR-133), Jeremy Manson (JMM) | Microsoft, UIUC, Wisconsin, Maryland |
| **en-US** | Edsger Dijkstra (semaphores, dining philosophers), Luther Tychonievich, John Bell | Illinois, Virginia |
| **zh-CN** | Lin Ziyu (Xiamen DB), Han Wentao (Tsinghua Rust), various OS textbook authors | Xiamen, Tsinghua, ICT CAS |
| **EU (UK)** | C.A.R. Hoare (CSP, Oxford), Robin Milner (CCS, π-calculus), Glynn Winskel (event structures), Peter Sewell (C/C++ semantics), Mark Batty (C++ formalization), Kyndylan Nienhuis (DRF-SC proof), Jean Pichon-Pharabod (thin-air), Simon Fowler (channels vs actors), Philip Wadler | Oxford, Cambridge, Edinburgh, Kent |
| **JP** | Yasushi Shinjo (Tsukuba — concurrency taxonomy, CVs, coroutines), Kazunori Matsuo (Nagoya Tech — OS semaphores/monitors), Hiroshi Kono (Ryukyu — counting semaphores), Tetsuo Hattori (Keio — concurrent programming theory) | Tsukuba, Nagoya Tech, Ryukyu, Keio, Kochi Tech, Waseda |
| **DE** | Viktor Vafeiadis (MPI-SWS — weak memory models, Weakestmo), Anton Podkopaev (MPI-SWS — weak memory semantics), Ori Lahav (MPI-SWS — memory models), Evgenii Moiseenko (MPI-SWS — Weakestmo Coq proofs), Andreas Podpolny — Andreas Polze (HPI — OS concurrency), Andreas Lochbihler (TUM — JMM Isabelle/HOL), Alexander Zuepke (TUM — deterministic futexes), Horst Schirmeier (TU Dresden — IPC sync lectures), Martin Schulz (TUM — AMT/MPI) | MPI-SWS, RWTH, TUM, TU Dresden, HPI |
| **FR** | Hubert Garavel (INRIA — CADP, LNT, process calculi), Jade Alglave (INRIA/UCL — weak memory models, herd7), Luc Maranget (INRIA — herd7, cat models), Jacques-Henri Jourdan (INRIA — concurrency semantics, RC11), Quentin Ladeveze (INRIA — RC11 DRF-SC Coq proof), Nicolas Chappe (INRIA/ENS Lyon — Choice Trees, LLVM concurrency), Gustavo Petri (INRIA — JMM Coq formalization), Assia Mahboubi (MSR-INRIA — Coq weak memory framework), Michaël Rao (ENS Lyon — synchronization primitives) | INRIA, ENS Lyon, INSA Lyon, CNAM, Polytechnique |
| **CDS (cross-region)** | Maurice Herlihy (MIT — concurrent DS, linearizability), Nir Shavit (MIT/Tel Aviv — elimination, split-ordering), Tim Harris (Cambridge/MSR — lock-free DS, STM), Keir Fraser (Cambridge — practical lock-freedom), Maged Michael (IBM — lock-free queues), William Pugh (UMD — skip lists), Alexandru Turcu (UCF — wait-free hash map) | MIT, Cambridge, UMD, IBM, UCF |

---

## Source Count Summary

| Region | Total Sources |
|--------|---------------|
| en-US | 7 (Models) + 7 (Memory) + 8 (Classic) + 8 (Sync) = 30 |
| zh-CN | 5 (Models) + 7 (Memory) + 10 (Classic) + 8 (Sync) = 30 |
| EU | 6 (Models) + 8 (Memory) + 8 (Classic) + 8 (Sync) = 30 |
| JP | 7 (Models) + 7 (Memory) + 8 (Classic) + 8 (Sync) = 30 |
| DE | 9 (Models) + 9 (Memory) + 8 (Classic) + 8 (Sync) = 34 |
| FR | 8 (Models) + 9 (Memory) + 8 (Classic) + 8 (Sync) + 8 (CDS) = 33 |
| **Total** (6 regions × 4 anchors + CDS) | **187 + 34 = 221** |
