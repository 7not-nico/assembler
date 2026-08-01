# Region: JP (Japanese language, Japan academic)

## Query Set

| Anchor | Query | Status | Results |
|--------|-------|--------|---------|
| Concurrency Models | `並行処理 モデル コンピュータサイエンス スレッド プロセス コルーチン site:ac.jp` | PASS | 10 |
| Memory Models | `メモリモデル 並行処理 逐次一貫性 happens-before site:ac.jp` | PASS | 10 |
| Classic Problems | `古典的同期問題 生産者消費者 readers writers 食事する哲学者 site:ac.jp` | PASS | 10 |
| Synchronization Primitives | `同期プリミティブ ミューテックス セマフォ 条件変数 並行処理 site:ac.jp` | PASS | 10 |

## Sources

### Anchor 1: Concurrency Models

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| Tsukuba Concurrent/Distributed (Yas) | U Tsukuba | .ac.jp | Concurrency vs parallelism vs distributed; processes, threads, coroutines; CSP, Go goroutines; SMP |
| Tsuthuba Coroutines (Yas) | U Tsukuba | .ac.jp | Coroutines vs threads; preemptive vs cooperative; fiber; GNU Pth; Go goroutines; Kotlin async |
| Tsukuba Concurrent PL (Yas) | U Tsukuba | .ac.jp | CSP as model language; guarded commands; concurrent programming languages history |
| Keio Concurrent Programming | Keio University | .ac.jp | Concurrent programming theory; coroutines, threads, semaphores, monitors, CSP, Go |
| Tokyo U Java Threads | U Tokyo | .ac.jp | Java threads; explicit vs implicit parallelism; thread creation; time-sharing; green vs native threads |
| Kagoshima Parallel Programming | Kagoshima U | .ac.jp | Shared memory vs distributed memory; OpenMP; MPI; hybrid MPI+OpenMP |
| Nagano Concurrent Programming | Nagano U | .ac.jp | Thread basics; race conditions; critical sections; Ruby Thread/Fiber |

### Anchor 2: Memory Models

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| Kochi Tech MMLib | Kochi U Tech | .ac.jp | SPIN model checking library for SC/TSO/PSO; store buffers; visualization of counterexamples |
| Tsukuba Consistency Models (Yas) | U Tsukuba | .ac.jp | Strict consistency; sequential consistency; release consistency; entry consistency; DSM |
| Tsukuba Pthread Memory Visibility | U Tsukuba | .ac.jp | Memory visibility in Pthread; ad hoc synchronization; synchronization variables |
| Waseda SW Cache Coherency | Waseda U | .ac.jp | Software cache coherency; True/False sharing; writeback; self-invalidate; compiler control |
| Ritsumeikan Cache Architecture | Ritsumeikan U | .ac.jp | Memory hierarchy; cache mapping (direct/associative); write policy; locality |
| Tokyo U SMP Cache | U Tokyo | .ac.jp | Cache coherence; locality; L1/L2/L3 cache; on-chip caching |
| Kyushu U OpenMP+MPI | Kyushu U | .ac.jp | OpenMP shared memory; MPI distributed memory; hybrid parallel computing |

### Anchor 3: Classic Problems

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| Nagoya Tech OS #5 | Nagoya U Tech | .ac.jp | Producer-consumer; readers-writers; dining philosophers; semaphore solutions; deadlock |
| Ryukyu Producer-Consumer | U Ryukyu | .ac.jp | Producer-consumer with counting semaphores implemented from pthread CVs; multiple producers/consumers |
| Keio Dining Philosophers | Keio University | .ac.jp | Dining philosophers; semaphore solutions; deadlock; starvation; fork ordering patterns |
| Kyoto Sangyo Rust Mutual Exclusion | Kyoto Sangyo U | .ac.jp | Dining philosophers and sleeping barber in Rust; Mutex; CVs; ownership-based safety |
| Kyushu Debugging Dining Philosophers | Kyushu U | .ac.jp | Distributed debugging of dining philosophers; deadlock detection; causal message analysis |
| Tokyo U Starvation/Deadlock | U Tokyo | .ac.jp | Starvation; deadlock; dining philosophers; resource ordering; lock ordering |
| Nagoya Tech OS #6 | Nagoya U Tech | .ac.jp | Monitor-based solutions for producer-consumer; readers-writers; dining philosophers; CVs |
| IPSJ LOTOS Dining Philosophers | IPSJ (Japan) | .ac.jp | Formal specification of dining philosophers in LOTOS (ISO 8807); protocol specification |

### Anchor 4: Synchronization Primitives

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| Tsukuba Pthread CVs | U Tsukuba | .ac.jp | Condition variables vs queues; Pthread bounded buffer with CVs; signal vs broadcast; Java Lock/Condition |
| Tsukuba Concurrent PL | U Tsukuba | .ac.jp | Semaphore P/V; monitor; rendezvous; SMP threads; language support for synchronization |
| Tsukuba Sync Primitives | U Tsukuba | .ac.jp | Mutex lock/unlock; condition variable wait/signal; ad hoc vs normal synchronization |
| Nagoya Tech Monitors | Nagoya U Tech | .ac.jp | Monitor vs semaphore; condition variables; signal/wait; encapsulation of resources |
| Ryukyu OS Lecture | U Ryukyu | .ac.jp | CAS; binary semaphore (P/V); counting semaphore from CVs; pthread synchronization |
| Ryukyu Process Sync | U Ryukyu | .ac.jp | Mutual exclusion; semaphore; counting semaphore; producer-consumer; barrier sync; context switch |
| UEC Mutex/CV in Scheme | U Electro-Communications | .ac.jp | Mutex lock/unlock; condition-wait/signal; producer-consumer in Scheme; process closure |
| Okinawa OS Lecture | U Ryukyu (TC) | .ac.jp | Binary semaphore; counting semaphore from CVs; pthread_mutex; counting semaphore implementation |

## Key Findings

- **Concurrency models**: Tsukuba (Yas) provides the most comprehensive Japanese-language treatment — full taxonomy of sequential/concurrent/parallel/distributed, detailed coroutine-vs-thread analysis, and coverage of CSP/Go. Keio covers concurrent programming language theory. Tokyo covers Java's threading model.
- **Memory models**: Strong emphasis on hardware-level consistency models (SC, TSO, release, entry). Kochi Tech's MMLib is unique — SPIN model checking across SC/TSO/PSO with visualization. Waseda covers software cache coherency for parallelizing compilers.
- **Classic problems**: Standard OS curriculum across all JP institutions. Nagoya Tech provides the clearest Japanese coverage of all three problems with semaphore and monitor solutions. Ryukyu provides hands-on counting semaphore implementations. Kyoto Sangyo offers modern Rust-based solutions.
- **Synchronization primitives**: Tsukuba and Nagoya Tech provide complementary coverage. Tsukuba covers the full spectrum from hardware interrupts through mutex/CVs/semaphores to monitors/rendezvous. Nagoya Tech emphasizes monitor encapsulation vs semaphore risks. Ryukyu provides counting semaphore implementations. UEC covers Scheme-based sync.

## Gaps

- Limited coverage of π-calculus or Actor model in JP-language sources
- Limited coverage of transactional memory
- Limited coverage of formal verification (IPsig LOTOS DP noted as exception)
- Limited coverage of async/await patterns
- Memory model coverage more hardware-oriented than language-level (JMM, C++11)
