INSERT INTO anchors (id, name, description) VALUES
    ('ANCHOR.MEMORY', 'Memory Models', 'Sequential consistency, happens-before, DRF-SC, memory barriers');

INSERT INTO researchers (name, institution, region_id) VALUES
    ('Sarita Adve', 'UIUC / DEC WRL', 'en-US'),
    ('Bill Pugh', 'U Maryland', 'en-US'),
    ('Jeremy Manson', 'U Maryland', 'en-US'),
    ('Peter Sewell', 'Cambridge University', 'EU'),
    ('Mark Batty', 'Cambridge University', 'EU'),
    ('Kyndylan Nienhuis', 'Cambridge University', 'EU'),
    ('Kourosh Gharachorloo', 'DEC WRL', 'en-US');

INSERT INTO memory_models_sources (title, url, institution, region_id, domain_type, key_focus, model_type) VALUES
    ('JSR-133 (Pugh, Manson)', 'https://www.cs.umd.edu/~pugh/java/memoryModel/jsr133.pdf', 'U Maryland', 'en-US', 'edu', 'Java Memory Model; sequential consistency; happens-before; causality requirements', 'causality'),
    ('Adve & Gharachorloo Tutorial', 'http://www.cs.unc.edu/~prins/Classes/790-033/Readings/MemoryConsistencyModelsTutorial.pdf', 'UNC / DEC WRL', 'en-US', 'edu', 'Taxonomy: SC -> TSO -> release -> weak; programmer vs system perspective', 'SC'),
    ('JMM POPL05 (Manson, Pugh, Adve)', 'https://rsim.cs.illinois.edu/Pubs/popl05.pdf', 'U Maryland / UIUC', 'en-US', 'edu', 'Formal JMM definition; data-race-free guarantee; causality requirements', 'causality'),
    ('UIUC Memory Models CACM', 'http://rsim.cs.illinois.edu/denovo/Pubs/10-cacm-memory-models.pdf', 'U Illinois', 'en-US', 'edu', 'Case for rethinking parallel languages; SC vs relaxed models', 'relaxed'),
    ('Cambridge PL Semantics Problem', 'https://www.cl.cam.ac.uk/~jp622/the_problem.pdf', 'U Cambridge', 'EU', 'ac', 'Major open problem: JMM unsound, C/C++11 too weak, thin-air; DRF-SC proof in HOL4', 'axiomatic'),
    ('Mathematizing C++ Concurrency (Batty)', 'https://www.cl.cam.ac.uk/~pes20/cpp/popl085ap-sewell.pdf', 'U Cambridge', 'EU', 'ac', 'Formal Isabelle/HOL model of C++11; DRF-SC theorem; issues found in draft standard', 'axiomatic'),
    ('C/C++11 Operational Semantics', 'https://www.repository.cam.ac.uk/bitstreams/2e371053-9986-4854-b851-ab4171519696/download', 'U Cambridge', 'EU', 'ac', 'Operational vs axiomatic models; SC atomics; DRF-SC guarantee', 'operational'),
    ('Clarifying C/C++ Concurrency', 'https://www.cl.cam.ac.uk/~pes20/cppppc/popl079-batty.pdf', 'U Cambridge', 'EU', 'ac', 'Clarifying C++11 model; compilation to Power/ARM', 'axiomatic'),
    ('Nitpicking C++ Concurrency', 'https://www.cl.cam.ac.uk/~pes20/weakmemory/ppdp11.pdf', 'U Cambridge', 'EU', 'ac', 'Nitpicking the C++ memory model with Isabelle', 'axiomatic'),
    ('Thin-Air Semantics', 'https://www.cl.cam.ac.uk/~jp622/thin-air.pdf', 'U Cambridge', 'EU', 'ac', 'Novel event-structure approach; relaxed atomics; avoids thin-air', 'operational'),
    ('Relaxed Models Must Be Rigorous', 'https://www.cl.cam.ac.uk/~pes20/weakmemory/ec2.pdf', 'U Cambridge', 'EU', 'ac', 'Problems with x86, Power, ARM, Java, C++ models; need for mathematical precision', 'relaxed'),
    ('Go Memory Model (DRF-SC)', 'https://golang.ac.cn/ref/mem', 'Go CN', 'zh-CN', 'ac', 'DRF-SC guarantee; happens-before; channel/Mutex/atomic; Boehm-Adve approach', 'DRF-SC'),
    ('USTC Architecture SC', 'http://staff.ustc.edu.cn/~comparch/25spring_slides/chapter07-1-Consistency.pdf', 'USTC', 'zh-CN', 'edu', 'Hardware sequential consistency; cache coherence; read-modify-write', 'SC'),
    ('JCST TSO Semantics', 'https://jcst.ict.ac.cn/cn/article/doi/10.1007/s11390-021-1616-1', 'ICT CAS', 'zh-CN', 'ac', 'TSO trace semantics in UTP; algebraic laws; linearizability', 'TSO'),
    ('LLVM Atomics Guide', 'https://llvm.gnu.ac.cn/docs/Atomics.html', 'LLVM CN', 'zh-CN', 'ac', 'Atomic ordering: unordered, monotonic, acquire, release, seq_cst; per-arch codegen', 'relaxed');
