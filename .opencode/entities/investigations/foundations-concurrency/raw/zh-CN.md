# Region: zh-CN (Chinese language, China academic)

## Query Set

| Anchor | Query | Status | Results |
|--------|-------|--------|---------|
| Concurrency Models | `并发模型 计算机科学 线程 进程 协程 site:edu.cn OR site:ac.cn` | PASS | 10 |
| Memory Models | `内存模型 并发 顺序一致性 happens-before site:edu.cn OR site:ac.cn` | PASS | 10 |
| Classic Problems | `经典同步问题 生产者消费者 读者写者 哲学家就餐 site:edu.cn OR site:ac.cn` | PASS | 10 |
| Synchronization Primitives | `同步原语 互斥锁 信号量 条件变量 并发 site:edu.cn OR site:ac.cn` | PASS | 10 |

## Sources

### Anchor 1: Concurrency Models

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| Tsinghua Rust Concurrency | Tsinghua University | .edu.cn | Threads, concurrency vs parallelism, Send/Sync traits, channels, Rust ownership model |
| WHUT OS Course | Wuhan University of Technology | .edu.cn | Process concept, states, PCB, concurrency, synchronization, semaphores, classic problems, deadlock |
| SDUT Java Threads | Shandong University of Technology | .edu.cn | Java thread lifecycle, creation (Thread/Runnable/Callable), synchronization, thread pools |
| Xiamen DB (Lin Ziyu) | Xiamen University | .edu.cn | DBMS process models: per-worker process, per-worker thread, process pool, lightweight threads |
| BAAI (Armstrong/Go) | Beijing Academy of AI | .ac.cn | Concurrency vs parallelism debate, Erlang/Go perspectives |

### Anchor 2: Memory Models

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| Go Memory Model | Go language CN mirror | .ac.cn | DRF-SC, happens-before, channel synchronization, mutex ordering, atomic operations |
| JMM Book (OUC) | Ocean University of China | .edu.cn | Java Memory Model, happens-before, reordering, sequential consistency |
| NUDT JMM Model Checking | National University of Defense Tech | .edu.cn | Model checking Java concurrent programs under JMM, out-of-order execution |
| USTC Architecture | USTC (Hefei) | .edu.cn | Sequential consistency, cache coherence, read-modify-write, semaphore implementation |
| JCST TSO Semantics | Institute of Computing Technology, CAS | .ac.cn | TSO memory model trace semantics, algebraic laws, UTP, linearizability |
| NJU Data Race Detection | Nanjing University | .edu.cn | Happens-before based data race detection, region-based analysis |
| LLVM Atomics Guide | LLVM CN mirror | .ac.cn | Atomic ordering (unordered, monotonic, acquire, release, seq_cst), fence, code generation per arch |

### Anchor 3: Classic Problems

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| SDU OS (Shunxu Xin) | Shandong University | .edu.cn | Bounded buffer (producer-consumer), readers-writers, dining philosophers, semaphore solutions |
| SJTU OS (Wu Chengtian) | Shanghai Jiao Tong University | .edu.cn | Classical problems with semaphores, monitor solutions |
| WHUT Classic Problems | Wuhan University of Technology | .edu.cn | Producer-consumer (bounded buffer), readers-writers, dining philosophers, P/V operations |
| ECUST OS MOOC | East China University of Science and Technology | .edu.cn | Process synchronization, semaphores, classic problems |
| UCAS OS Course | University of Chinese Academy of Sciences | .edu.cn | Classic IPC problems: producer-consumer, readers-writers, dining philosophers |
| ZCST OS Course | Zhuhai College of Science and Technology | .edu.cn | Producer-consumer, readers-writers, dining philosophers, deadlock prevention |
| BJTU OS | Beijing Jiaotong University | .edu.cn | Classic problems, monitor solutions |
| JCST TM Verification | ICT CAS | .ac.cn | Transactional memory verification, Coq, dining philosophers proof |

### Anchor 4: Synchronization Primitives

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| Boost.Interprocess CN | Boost CN mirror | .ac.cn | Interprocess sync: mutexes, semaphores, condition variables, shared memory, message queues |
| BJTU OS Sync | Beijing Jiaotong University | .edu.cn | Mutex, condition variables, wait/signal primitives |
| XMU Dining Philosophers | Xiamen University | .edu.cn | Pthread semaphore vs condition variable + mutex solutions for dining philosophers |
| LLVM Atomics CN | LLVM CN mirror | .ac.cn | Atomic operations, cmpxchg, fence, acquire/release/seq_cst, per-arch codegen |
| Python asyncio Sync CN | Python CN mirror | .ac.cn | asyncio Lock, Condition, Semaphore, BoundedSemaphore |
| Qt Mutex CN | Qt CN mirror | .ac.cn | QMutex, lock/unlock, tryLock, QMutexLocker |
| Qt Semaphore CN | Qt CN mirror | .ac.cn | QSemaphore, acquire/release, producer-consumer example |
| PHP Sync CN | PHP CN mirror | .ac.cn | SyncMutex, SyncSemaphore |

## Key Findings

- **Concurrency models**: Chinese CS education follows the standard process/thread model. Tsinghua's Rust course uniquely covers Send/Sync traits for compile-time thread safety. Xiamen's DB process model provides applied perspective.
- **Memory models**: Strong coverage from Go JMM (DRF-SC) through LLVM atomics. USTC architecture course covers hardware SC. JCST provides deep TSO formal semantics. NJU covers happens-before based data race detection.
- **Classic problems**: Standard OS curriculum across ALL Chinese institutions. WHUT, SDU, SJTU, and BJTU provide comprehensive semaphore and monitor treatments.
- **Synchronization primitives**: Coverage from low-level LLVM atomics through middleware (Boost, Qt) to high-level language runtimes (Python asyncio, PHP). LLVM atomic ordering taxonomy is well-documented.

## Gaps

- Limited coverage of CSP, π-calculus, or Actor model in Chinese-language sources
- Limited coverage of lock-free data structures beyond basic CAS
- Limited formal methods applied to concurrency (JCST exceptions noted)
- Go's goroutine model and channel-based concurrency is well-documented but other language models less so
