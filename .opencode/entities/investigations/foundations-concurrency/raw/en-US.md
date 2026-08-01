# Region: en-US (English, US/UK academic)

## Query Set

| Anchor | Query | Status | Results |
|--------|-------|--------|---------|
| Concurrency Models | `concurrency models computer science threads processes fibers coroutines site:edu OR site:ac.uk` | PASS | 10 |
| Memory Models | `memory models concurrency sequential consistency happens-before shared memory site:edu OR site:ac.uk` | PASS | 10 |
| Classic Problems | `classic concurrency problems dining philosophers readers writers producer consumer site:edu OR site:ac.uk` | PASS | 10 |
| Synchronization Primitives | `synchronization primitives concurrency mutex semaphore barrier condition variable site:edu OR site:ac.uk` | PASS | 10 |

## Sources

### Anchor 1: Concurrency Models

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| MIT 6.031 Reading 21 | MIT | .edu | Shared memory vs message passing, processes/threads, race conditions |
| OSTEP Ch.26 (Wisconsin) | U Wisconsin-Madison | .edu | Thread abstraction, context switching, stack layout in multi-threaded address space |
| CSP (Hoare, Oxford) | Oxford University | .ac.uk | Formal model of processes, traces, nondeterminism, communication |
| UIUC CS340 | U Illinois | .edu | Concurrency vs parallelism, processes, threads, fibers, generators, async/await |
| CMU CSAPP Ch.12 | Carnegie Mellon | .edu | Three approaches: processes, I/O multiplexing, threads |
| Tufts (Ierusalimschy) | Tufts University | .edu | Coroutines classification, asymmetric vs symmetric, cooperative multitasking |
| GWU Kilim (Srinivasan) | George Washington U | .edu | Fibers, lightweight threads, continuation-passing on JVM, Erlang-style actors |

### Anchor 2: Memory Models

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| JSR-133 (UMD) | U Maryland | .edu | Java Memory Model, sequential consistency, happens-before, causality |
| Adve & Gharachorloo Tutorial | UNC Chapel Hill / DEC WRL | .edu | Taxonomy of consistency models, SC → relaxed models, programmer-vs-system centric |
| JMM POPL'05 (Manson, Pugh, Adve) | U Maryland / UIUC | .edu | Formal JMM definition, data-race-free guarantee, causality requirements |
| UIUC Memory Models CACM | U Illinois | .edu | Case for rethinking parallel languages, SC vs relaxed models |
| Denovo (UIUC) | U Illinois | .edu | Memory model as interface between program and system |

### Anchor 3: Classic Problems

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| UC Davis Handout | UC Davis | .edu | Producer-consumer, readers-writers (two priority variants), dining philosophers |
| UIUC CS241 | U Illinois | .edu | Semaphore solutions, reader/writer preference, deadlock conditions |
| Cornell CS414 | Cornell | .edu | Bounded buffer, readers-writers, dining philosophers, monitor solutions, deadlock prevention |
| Calvin College (Adams et al.) | Calvin University | .edu | Visualization tools for classic problems as pedagogical aids |
| UMD CMSC412 | U Maryland | .edu | Classical problems with semaphore and monitor solutions |
| CSU CS370 | Colorado State | .edu | Producer-consumer, readers-writers, dining philosophers with semaphore/monitor |
| UIC CS Bell | U Illinois Chicago | .edu | Classic problems, deadlock, starvation |
| CMU 14-712 | Carnegie Mellon | .edu | Bounded buffer, readers-writers, dining philosophers |

### Anchor 4: Synchronization Primitives

| Source | Institution | Type | Key Focus |
|--------|-----------|------|-----------|
| UIUC CS340 (Tychonievich) | U Illinois | .edu | Atomic ops (test-and-set, CAS), locks, condition variables, semaphores, barriers |
| Princeton COS 318 | Princeton | .edu | Semaphores, monitors, condition variables, barriers, producer-consumer |
| Stanford CS110 | Stanford | .edu | Mutexes, condition variables, semaphores — permits, binary/general coordination, layered construction |
| Yale CS422 | Yale | .edu | Spinlocks, semaphores, condition variables, lock implementation, CSP/Go model |
| UVa CS3130 | U Virginia | .edu | Mutex, semaphore, condition variable, monitor, reader-writer lock, barrier, transaction |
| Buffalo CSE 220 | SUNY Buffalo | .edu | Pthreads mutexes, condition variables, semaphores |
| Wisconsin OSTEP Ch.31 | U Wisconsin-Madison | .edu | Semaphore patterns, reader-writer locks, deadlock, building semaphores from CVs |
| JMU CS470 | James Madison U | .edu | Barriers with semaphores and condition variables |

## Key Findings

- **Concurrency models**: US universities teach the process/thread/fiber hierarchy consistently. CSP (Hoare, Oxford) provides the formal underpinning. MIT and CMU emphasize the shared-memory vs message-passing dichotomy.
- **Memory models**: US research dominates this field. JSR-133 (Pugh, Manson) and Adve's tutorial are canonical. Sequential consistency → happens-before → causality is the standard progression.
- **Classic problems**: Standard OS curriculum across all US institutions. UC Davis, Illinois, Cornell, and CMU provide comprehensive treatment.
- **Synchronization primitives**: Deep coverage from hardware atomics through spinlocks, semaphores, monitors, to high-level barriers. OSTEP and Stanford's CS110 provide practical implementation patterns.

## Gaps

- Limited formal methods (e.g., TLA+, Alloy) applied to concurrency in US sources
- Limited coverage of modern lock-free data structures beyond CAS
- Limited coverage of software transactional memory (STM)
