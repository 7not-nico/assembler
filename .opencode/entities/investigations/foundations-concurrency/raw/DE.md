# Region: DE (German universities — RWTH Aachen, TUM, TU Dresden, MPI-SWS, HPI)

## Query Set

| Anchor | Query | Status | Results |
|--------|-------|--------|---------|
| Concurrency Models | `concurrency models computer science parallel programming MPI OpenMP site:.de` | PASS | 10 |
| Memory Models | `memory model concurrency sequential consistency weak memory site:.de` | PASS | 10 |
| Classic Problems | `classic synchronization problems producer consumer dining philosophers site:.de` | PASS | 10 |
| Synchronization Primitives | `synchronization primitives mutex semaphore monitor concurrency site:.de` | PASS | 10 |

## Sources

### Anchor 1: Concurrency Models

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| TUM Parallel Programming | TU Munich | .de | MPI, OpenMP, PGAS, TBB, CUDA, OpenCL, OpenACC; dependence analysis; program transformations |
| TUM Programming of Supercomputers | TU Munich | .de | Production-level MPI + OpenMP; supercomputer architecture; batch vs interactive |
| RWTH MPI+Threads | RWTH Aachen | .de | MPI hybrid with threads; EuroMPI 2025; MPI continuations |
| RWTH MPI Continuations | RWTH Aachen | .de | MPI Continuations proposal; hybrid MPI + async task-based programming |
| RWTH Parallel Programming Overview | RWTH Aachen | .de | MPI, OpenMP fork-join; CUDA, OpenCL, OpenACC for accelerators; weak memory model for GPUs |
| RWTH Introduction to Parallel Programming | RWTH Aachen | .de | MPI for distributed memory; OpenMP for shared memory; Java threads; architecture |
| TUM Parallel Systems (Weidendorfer) | TU Munich / LRZ | .de | HPC, heterogeneous computing, cache simulation, KCachegrind, Callgrind |
| TUM AMT Runtime (Schulz) | TU Munich | .de | Asynchronous Many-Task (AMT) runtime; GLB; dynamic resource management; MPI-DPP |
| RWTH Data Race Detection (Protze) | RWTH Aachen | .de | Hybrid MPI+OpenMP data race detection; vector clocks; concurrency within threads |

### Anchor 2: Memory Models

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| RWTH Adve Tutorial | RWTH Aachen | .de | Sequential consistency; weak ordering; release consistency; programmer vs system-centric |
| RWTH Saraswat Theory | RWTH Aachen | .de | RAO framework for relaxed memory; DRF-SC Fundamental Property; volatility; causality |
| MPI-SWS Weakestmo (Moiseenko) | MPI-SWS / Kaiserslautern | .de | Event-structure weak memory model; compilation to x86/POWER/ARM; Coq proof; thin-air avoidance |
| TU Dresden Memory Consistency | TU Dresden | .de | SC, TSO, PC, PSO, WO, RC taxonomy; hardware consistency models; SC-DRF for C++/Java |
| TU Kaiserslautern Weak Memory | TU Kaiserslautern | .de | SC vs weak consistency; hardware weak memory models |
| DISC 2024 Merge Theorem | TU Darmstadt / MPI-SWS | .de | Mergeability; SCM/TSO/RA models; impossibility results; optimal implementations |
| RWTH C++ Memory Model | RWTH Aachen | .de | C++ memory model; threads, data races; memory order; forward progress guarantees |
| RWTH Boehm-Adve Foundations | RWTH Aachen | .de | C++0x concurrency memory model; data-race-free; SC atomics; DRF guarantee |
| Lochbihler JMM | TUM / Andreas Lochbihler | .de | Java Memory Model formalization; Isabelle/HOL; machine-checked proofs |

### Anchor 3: Classic Problems

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| HPI ParProg (Köhler) | HPI Potsdam | .de | Dining philosophers; lefty-righty solution; Coffman deadlock conditions; lock-free |
| HPI Shared-Memory (Polze) | HPI Potsdam | .de | Dekker; Lamport bakery; dining philosophers; Coffman conditions; spinlocks; RW-locks; barriers |
| HPI ParProg Theory | HPI Potsdam | .de | Concurrency vs parallelism; dining philosophers; lefty-righty; Coffman conditions |
| Ben-Ari Principles | TU (Ben-Ari via Pearson) | .de | Producer-consumer; dining philosophers; semaphore and monitor solutions; channels |
| Paul McKenney PerfBook | MPI-INF (mirror) | .de | Dining philosophers; locking granularity; advanced synchronization; non-blocking sync |
| IPFS Dining Philosophers | SSI.EECC (DE) | .de | DP problem statement; Dijkstra; Chandy-Misra; waiter; resource hierarchy solutions |
| IPFS Producer-Consumer | SSI.EECC (DE) | .de | PC with semaphores; FIFO/channel alternative; lost wakeup; generalized PC |
| OSTEP Semaphores (DE mirror) | TUM (momdali) | .de | Producer-consumer; reader-writer locks; semaphore patterns; dining philosophers; throttling |

### Anchor 4: Synchronization Primitives

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| TUM Locks/Monitors | TU Munich | .de | Atomic ops; wait-free/lock-free; mutex; semaphore; monitor; deadlock prevention; condition variables |
| TU Dresden IPC Lecture | TU Dresden | .de | Semaphore; monitor; path expressions; readers-writers; producer-consumer; duality of IPC |
| TU Dresden Nonblocking Sync | TU Dresden | .de | Lock-free/wait-free; CAS; helping; wait-and-notify monitors; real-time microkernel (Fiasco) |
| TUM Futex Paper (Zuepke) | TU Munich | .de | Inside-out futexes; IPCP; user-space monitors; deterministic RT sync; mutex/CV |
| RWTH C++ Mutex | RWTH Aachen | .de | std::mutex, std::counting_semaphore, std::binary_semaphore; C++20 sync primitives |
| RWTH L3S Monitor | LUH Hannover (mirror) | .de | Monitor theory; Hoare vs Mesa signal; condition variables; Java synchronized; Brinch Hansen |
| TUM Deterministic Futexes | TU Munich | .de | Deterministic futex; WCET; bounded interference; RT synchronization |
| HPI Advanced Sync | HPI Potsdam | .de | Spinlocks; RW-locks; reentrant locks; barriers; lock-free; CAS; memory barriers |

## Key Findings

- **Concurrency models**: German research strongly emphasizes HPC — MPI, OpenMP, hybrid parallelism. RWTH Aachen and TUM lead in the EuroMPI community and MPI continuations research. TUM also covers AMT runtimes and dynamic resource management.
- **Memory models**: MPI-SWS (Kaiserslautern) leads weak memory model research — Weakestmo event-structure model with Coq compilation proofs to x86/POWER/ARM. Dresden provides the clearest taxonomy of hardware consistency models (SC→TSO→PC→PSO→WO→RC). RWTH Aachen hosts key tutorials (Adve, Saraswat, Boehm-Adve). Lochbihler (TUM) formalized JMM in Isabelle/HOL.
- **Classic problems**: HPI Potsdam provides thorough DP treatment with lefty-righty and Coffman conditions. Ben-Ari textbook covers all three problems. McKenney's perfbook (MPI-INF mirror) covers DP in context of parallel OS kernels.
- **Synchronization primitives**: TUM has the clearest lock/monitor theory lecture. TU Dresden covers the full IPC spectrum from semaphores through path expressions. Notable: Zuepke's inside-out futexes (TUM) for real-time systems.

## Gaps

- Limited coverage of CSP/π-calculus compared to UK
- Limited coverage of actor model or Go-style concurrency
- Limited coverage of async/await patterns
- Memory model focus on hardware/architecture level rather than language-level
