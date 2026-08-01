# Region: FR (French language, France academic — INRIA, ENS, CNRS)

## Query Set

| Anchor | Query | Status | Results |
|--------|-------|--------|---------|
| Concurrency Models | `modèles de concurrence informatique threads processus fibres acteurs site:.fr` | PASS | 10 |
| Memory Models | `modèle mémoire concurrence cohérence séquentielle happens-before site:.fr` | PASS | 10 |
| Classic Problems | `problèmes classiques synchronisation producteurs consommateurs philosophes site:.fr` | PASS | 10 |
| Synchronization Primitives | `primitives synchronisation mutex sémaphore moniteur site:.fr` | PASS | 10 |

## Sources

### Anchor 1: Concurrency Models

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| INRIA CADP (Garavel) | INRIA Grenoble | .fr | Process calculi survey: CSP, CCS, π-calculus, LOTOS, LNT; formal modeling; CADP toolset |
| INRIA Jourdan Concurrency | INRIA Paris | .fr | Concurrency vs parallelism; threads; Lwt monads; weak memory models; C20 model; DRF theorem |
| Telecom Paris Threads | Telecom Paris | .fr | POSIX threads; mutex; CV; semaphore; Java threads; ThreadPool; ExecutorService; BlockingQueue |
| Paris-Saclay Threads | U Paris-Saclay | .fr | Process vs thread models (M:1, 1:1, M:N); Python threading; locks; conditions; semaphores |
| Polytechnique Parallel/Distributed | Polytechnique | .fr | PRAM model; Flynn taxonomy; shared vs distributed memory; Java RMI; threads |
| INRIA Akka Actors | INRIA Grenoble (AIR) | .fr | Actor model (Akka); Erlang inspiration; STM transactors; self-healing supervision hierarchies |
| INRIA Process Algebra (Garavel) | INRIA Grenoble | .fr | Defense of process algebras over other formalisms; rendezvous vs shared variables; data modeling |
| CNAM Synchronization | CNAM Paris | .fr | Locks; semaphores; producer-consumer; readers-writers; pipes; mailboxes |

### Anchor 2: Memory Models

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| INRIA Alglave/Maranget | INRIA Saclay | .fr | Axiomatic memory models; SC criterion; TSO; herd7; cat language; barrier placement |
| INRIA Ladeveze RC11 | INRIA | .fr | RC11 model; DRF-SC mechanization in Coq (40K lines); happens-before; prefix executions |
| INRIA Petri JMM | INRIA Sophia | .fr | JMM formalization in Coq; DRF guarantee proof; committing semantics; out-of-thin-air |
| INRIA Chappe Thesis | INRIA / ENS Lyon | .fr | Choice Trees (concurrent Interaction Trees); monadic semantics for LLVM IR; Promising/TSO/SC models |
| MSR-INRIA Alglave/Mahboubi | MSR-INRIA | .fr | Coq framework for weak memory models; event structures; SC, TSO, PSO, RMO, Alpha; barrier placement |
| INRIA Declerck Thesis | INRIA Saclay | .fr | Model checking parameterized concurrent programs on weak memory (TSO-like); Cubicle-W model checker |
| INRIA herd7/DIY | INRIA Saclay | .fr | herd7 simulator for weak memory models; cat language; SC, TSO models; coherence relations |
| IMT Shared Memory | IMT (ex-Telecom) | .fr | Coherence, consistency, memory models; cache coherence protocols; C11 SC for race-free programs |
| CNAM Memory Coherence | CNAM | .fr | Lamport SC definition; cache coherence; bus snooping; directory protocols; MESI; weak ordering |

### Anchor 3: Classic Problems

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| Lyon 1 Caniou | U Lyon 1 | .fr | Semaphore solutions for classic problems |
| CNRS Champin | CNRS Lyon | .fr | Producer-consumer; readers-writers; dining philosophers; mutex; semaphore; event synchronization |
| Grenoble Sync | U Grenoble | .fr | Monitor solutions; semaphore P/V; rendezvous; producer-consumer; mutex |
| Labri Bordeaux | U Bordeaux (Labri) | .fr | Classic synchronization problems: producer-consumer, readers-writers, dining philosophers |
| Lip6 (Queinnec) | Sorbonne/Lip6 | .fr | Dining philosophers; deadlock; mutual exclusion; semaphore solutions in OCaml |
| Lyon 1 Semaphore Solutions | U Lyon 1 | .fr | Producer-consumer; dining philosophers with semaphores; P/V operations |
| Grenoble Du-ISN | U Grenoble | .fr | Producer-consumer with conditions (Python); readers-writers problem |
| INSA Lyon Sync | INSA Lyon | .fr | Producer-consumer; semaphore solutions; mutex; condition variables |

### Anchor 4: Synchronization Primitives

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| INRIA Jourdan Semaphores | INRIA Paris | .fr | Mutex; semaphore; condition variables; C20 weak memory model; DRF theorem |
| INSA Lyon Synchronization | INSA Lyon | .fr | Mutex; semaphore (P/V); producer-consumer; POSIX semaphores |
| ENS Lyon Rao | ENS Lyon | .fr | Semaphores vs mutex; condition variables; C++11 std::mutex, std::condition_variable; dining philosophers |
| ENS Lyon Semaphore TP | ENS Lyon | .fr | POSIX semaphores; mutex; sleeping barber; dining philosophers; semaphore implementation with CVs |
| CNAM Delacroix | CNAM | .fr | Verrous (locks); semaphores (P/V/INIT); reader-writer; kernel synchronization; interrupt masking |
| Lip6 Chamoux | Sorbonne/Lip6 | .fr | Mutex; condition variables; OCaml Condition module; producer-consumer; readers-writers |
| Grenoble Synchronization | U Grenoble | .fr | Mutex; semaphore; monitor; rendezvous; producer-consumer |
| INRIA herd7 | INRIA Saclay | .fr | herd7 simulator; cat model definitions for SC/TSO; memory model test generation |

## Key Findings

- **Concurrency models**: INRIA (Grenoble/Saclay) is a world leader in process calculi — Garavel's CADP team developed LOTOS, LNT, and the CADP verification toolset. The INRIA process algebra survey is definitive. INRIA Paris (Jourdan) provides modern concurrency theory with monadic Lwt and weak memory model connections. Polytechnique covers PRAM theory.
- **Memory models**: INRIA dominates globally in weak memory model formalization. Alglave & Maranget created the axiomatic framework used by herd7 and the .cat model language. Two theses (Ladeveze, Chappe) mechanize DRF-SC for RC11 in Coq. MSR-INRIA (Alglave, Mahboubi) provides formalized framework for SC/TSO/PSO/RMO/Alpha. herd7 is the standard tool for litmus-testing weak memory models.
- **Classic problems**: Standard OS curriculum across all FR institutions. Lyon 1, CNRS, Grenoble, Labri, and Lip6 all provide classic treatments using semaphores and monitors.
- **Synchronization primitives**: ENS Lyon and INSA Lyon provide the most thorough French-language treatment. ENS Lyon's Rao covers C++11 concurrency primitives in depth. The Lip6 (OCaml) coverage is notable for functional-language concurrency.

## Gaps

- Limited coverage of GPU concurrency (CUDA/OpenCL)
- Limited coverage of lock-free/wait-free data structures beyond CAS
- Limited coverage of async/await patterns (Lwt monads partially cover this)
- Limited coverage of transactional memory (Akka transactors noted as exception)
