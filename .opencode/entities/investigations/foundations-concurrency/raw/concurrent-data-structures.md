# Anchor: Concurrent Data Structures

**Queries**: 4 regions (en-US, zh-CN, EU/UK, JP) — 4 queries, all PASS

## Sources

### Region: en-US

| Source | Institution | Focus |
|--------|-------------|-------|
| MIT Scalable Lock-Free Stack (Hendler et al.) | MIT CSAIL | Elimination-backoff stack; Treiber stack; elimination array; linearizable, lock-free |
| MIT Concurrent Skip List (Herlihy et al.) | MIT CSAIL | Optimistic skip list; lazy validation; logical deletion via marking; wait-free contains |
| MIT Split-Ordered Lists (Shalev/Shavit) | MIT CSAIL | Lock-free extensible hash table; split-ordering; bit-reversal; CAS-based resize |
| MIT Optimistic FIFO Queue (Edya Ladan-Mozes) | MIT CSAIL | Optimistic doubly-linked queue; single-CAS enqueue/dequeue; fixList recovery |
| UCF Wait-Free Hash Map | U Central Florida | Wait-free hash map, stack, ring buffer, vector; MCAS; bit-marking for contention |
| City University Skip Hash | City London | STM-based ordered map combining skip list + hash; range queries; O(1) overhead |
| UMD Skip Lists (Pugh) | U Maryland | Original skip list; probabilistic balancing; concurrent access with write locks only |
| Cambridge Concurrent Programming Without Locks (Fraser/Harris) | Cambridge | MCAS; WSTM; OSTM; non-blocking skip lists and red-black trees |
| Cambridge Practical Lock-Freedom (Fraser) | Cambridge | Lock-free skip lists, BSTs, red-black trees; FSTM; practical CAS-based designs |
| Cambridge Non-blocking Linked-Lists (Harris) | Cambridge | CAS-based linked list; pointer marking for logical deletion; lock-free linearizable |
| Cambridge Tim Harris (Multicore course) | Cambridge | Linearizability; lock-free/wait-free/obstruction-free; hashtables, skip lists, work-stealing queues |
| Oxford CSP Lock-Free Queue Analysis (Lowe) | Oxford | CSP model checking of MS-queue linearizability; FDR; hazard pointer verification |

### Region: zh-CN

| Source | Institution | Focus |
|--------|-------------|-------|
| Tianjin U Wait-Free List | Tianjin/TJU | Wait-free unordered linked list; fast-path-slow-path; wait-free enlist via helping |
| BAAI DLHT Hash Table | BAAI | Non-blocking resizable hashtable; bounded-cache-line chaining; 1.6B req/s |
| CUIT Java ConcurrentHashMap | Chengdu U IT | Java ConcurrentHashMap API; concurrencyLevel; segment-based locking; weak consistency |
| Boost lockfree spsc_queue (CN) | Boost CN | Single-producer/single-consumer wait-free FIFO; ring buffer; C++ lockfree library |
| Nankai NDP Data Structures | Nankai U | Near-data-processing for concurrent data structures; DRAM-aware design |
| UCAS Concurrent Programming | UCAS | Course on concurrent data structures: coarse/fine-grained locks, lock-free |
| WebKit Locking (CN) | Apple CN | Concurrent hash table; per-bucket locking vs lock-free tradeoffs |
| USTC B-Queue | USTC | Batching lock-free SPSC queue; backtracking deadlock prevention; cache-aware |
| Go Swiss Tables (CN) | Go CN | Swiss Table open-addressing hash map; incremental growth; SIMD probing |

### Region: EU/UK

| Source | Institution | Focus |
|--------|-------------|-------|
| Cambridge Lock-Free Linked-List (Harris) | Cambridge | Practical CAS-based linked list; pointer marking; linearizable insert/delete |
| Cambridge Concurrent Programming Without Locks | Cambridge | MCAS, WSTM, OSTM; skip lists; red-black trees; non-blocking composability |
| Cambridge Practical Lock-Freedom (Fraser) | Cambridge | Lock-free skip lists, BSTs, red-black trees; evaluation vs lock-based |
| Oxford CSP Lock-Free Queue Analysis (Lowe) | Oxford | CSP model checking MS-queue; FDR; hazard pointers; divergence freedom |
| City University Skip Hash | City London | STM skip list + hash map; range queries; O(1) average |

### Region: JP

| Source | Institution | Focus |
|--------|-------------|-------|
| IPSJ Lock-Free Hash Table (JP) | IPSJ (Japan) | Practical lock-free open-addressing hash table; CAS-based; reference counting |
| Nagoya Tech Transactional KVS | Nagoya U Tech | Distributed transaction on KVS; STM-based; obstruction-free; non-blocking |
| Tsukuba Tuple Space/Stack | U Tsukuba | Distributed data structures; Linda tuple space; JavaSpaces; message-passing |
| Aoyama Gakuin Hash | Aoyama Gakuin U | Hash functions; chaining vs open addressing; universal hashing; Ruby Hash internals |
| Tokyo U Sets/Hash | U Tokyo | Open and closed hashing; priority queues; data structure efficiency analysis |
| TWCU Stack/Queue | Tokyo Woman's Christian U | Linked list stack and queue; binary trees; data structure fundamentals |
| Kochi U Stack/Queue | Kochi U | Linear data structures; stack (LIFO); queue (FIFO); Python implementation |
| Fukui NCT Stack/Queue | Fukui NCT | Ring buffer queue; linked list stack/queue; C implementations |

## Key Findings

- **en-US/UK**: Dominates concurrent data structure research — MIT CSAIL (Herlihy, Shavit, Shalev) and Cambridge (Harris, Fraser) produced most foundational algorithms. Treiber stack, MS-queue, split-ordered lists, elimination-backoff stack, optimistic skip lists all from this region.
- **zh-CN**: Strong applied focus — DLHT high-performance hashtable (1.6B req/s), B-Queue cache-aware SPSC queue, wait-free lists via fast-path-slow-path (Tianjin). Boost.lockfree and Java ConcurrentHashMap documented in Chinese.
- **JP**: Covers fundamentals (stack/queue/hash table implementations) plus some practical lock-free hash table research (IPSJ, Nagoya Tech).
- **Progress guarantees**: Lock-free (most common), wait-free (elimination-backoff, UCF hash map, fast-path-slow-path), obstruction-free (STM-based).
- **Core techniques**: CAS, pointer marking, elimination, split-ordering, optimistic synchronization, lazy validation, batching, backoff.
