INSERT INTO anchors (id, name, description) VALUES
    ('ANCHOR.SYNC', 'Synchronization Primitives', 'Mutexes, semaphores, condition variables, monitors, barriers');

INSERT INTO researchers (name, institution, region_id) VALUES
    ('Edsger Dijkstra', 'Eindhoven University', 'EU'),
    ('Luther Tychonievich', 'U Illinois', 'en-US'),
    ('Jaswinder Pal Singh', 'Princeton', 'en-US'),
    ('Steve Hand', 'Cambridge University', 'EU'),
    ('Robert Watson', 'Cambridge University', 'EU');

INSERT INTO sync_primitives_sources (title, url, institution, region_id, domain_type, key_focus, primitives_covered) VALUES
    ('UIUC CS340 (Tychonievich)', 'https://courses.grainger.illinois.edu/CS340/sp2025/text/sync.html', 'U Illinois', 'en-US', 'edu', 'Atomic ops (TAS, CAS); locks; CVs; semaphores; barriers; detailed API coverage', 'atomic,TAS,CAS,lock,cv,semaphore,barrier'),
    ('Princeton COS 318', 'https://www.cs.princeton.edu/courses/archive/fall18/cos318/lectures/7.SemaphoreMonitor.pdf', 'Princeton', 'en-US', 'edu', 'Semaphores; monitors; CVs; barriers; producer-consumer; interrupt-driven concurrency', 'semaphore,monitor,cv,barrier'),
    ('Stanford CS110', 'https://web.stanford.edu/class/cs110/lectures/cs110-win2122-lecture-17.pdf', 'Stanford', 'en-US', 'edu', 'Mutexes; CVs; semaphores; permits; binary/general coordination; layered construction', 'mutex,cv,semaphore'),
    ('Yale CS422', 'https://flint.cs.yale.edu/cs422/lectureNotes/L08.pdf', 'Yale', 'en-US', 'edu', 'Spinlocks; semaphores; CVs; lock implementation; CSP/Go model comparison', 'spinlock,semaphore,cv'),
    ('UVA CS3130', 'https://www.cs.virginia.edu/~cr4bd/3130/F2025/readings/sync.html', 'U Virginia', 'en-US', 'edu', 'Mutex; semaphore; CV; monitor; reader-writer lock; barrier; transaction', 'mutex,semaphore,cv,monitor,rwlock,barrier'),
    ('Buffalo CSE 220', 'https://cse.buffalo.edu/courses/cse220/2025-Spring/33-pthreads.pdf', 'SUNY Buffalo', 'en-US', 'edu', 'Pthreads: mutexes, CVs, semaphores', 'mutex,cv,semaphore'),
    ('OSTEP Ch.31', 'https://pages.cs.wisc.edu/~remzi/OSTEP/threads-sema.pdf', 'U Wisconsin', 'en-US', 'edu', 'Semaphore patterns; reader-writer locks; deadlock; building semaphores from CVs', 'semaphore,rwlock'),
    ('JMU CS470', 'https://w3.cs.jmu.edu/lam2mo/cs470_2018_01/files/04_conditions.pdf', 'James Madison U', 'en-US', 'edu', 'Barriers with semaphores and CVs; thread pool patterns', 'barrier,semaphore,cv'),
    ('Cambridge CDS L4 (Hand)', 'https://www.cl.cam.ac.uk/teaching/1920/ConcDisSys/djg-materials/CDS-djg-L04.pdf', 'U Cambridge', 'EU', 'ac', 'CCRs -> monitors -> CVs; Hoare vs Mesa signal semantics; historical evolution', 'ccr,monitor,cv'),
    ('Cambridge HLL Shared Mem', 'https://www.cl.cam.ac.uk/teaching/1415/ConcDisSys/03-HLLShMem-2up.pdf', 'U Cambridge', 'EU', 'ac', 'Historical: critical regions -> CCRs -> monitors -> guarded commands -> Ada rendezvous', 'critical-region,ccr,monitor,guarded-command'),
    ('City University London', 'https://www.staff.city.ac.uk/c.kloukinas/concurrency/concurrency-handouts.pdf', 'City London', 'EU', 'ac', 'FSP modeling of semaphores; monitors; condition synchronization in Java', 'semaphore,monitor'),
    ('Strathclyde Process Sync', 'https://personal.cis.strath.ac.uk/sotirios.terzis/classes/CS.304/Process%20Synchronisation.pdf', 'U Strathclyde', 'EU', 'ac', 'Semaphore implementation; hardware sync (TAS); monitors in Java; deadlock', 'semaphore,monitor'),
    ('Cambridge CDS Deadlock', 'https://www.cl.cam.ac.uk/teaching/1415/ConcDisSys/2013a-ConcurrentSystems-1B-L4.pdf', 'U Cambridge', 'EU', 'ac', 'Deadlock prevention (4 conditions); avoidance (Bankers); detection (graph algorithm); priority inversion', 'deadlock,priority-inversion'),
    ('LLVM Atomics (CN)', 'https://llvm.gnu.ac.cn/docs/Atomics.html', 'LLVM CN', 'zh-CN', 'ac', 'Atomic ordering: unordered, monotonic, acquire, release, seq_cst; per-arch codegen', 'atomic,cmpxchg,fence'),
    ('XMU Dining Philosophers', 'https://dblab.xmu.edu.cn/blog/92/', 'Xiamen University', 'zh-CN', 'edu', 'Pthread semaphore vs CV + mutex solutions for dining philosophers', 'semaphore,cv,mutex');
