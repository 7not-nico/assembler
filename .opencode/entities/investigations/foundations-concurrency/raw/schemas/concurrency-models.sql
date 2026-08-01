INSERT INTO regions (id, name, languages, status, source_count) VALUES
    ('en-US', 'United States / English Academic', 'English', 'PASS', 30),
    ('zh-CN', 'China / Chinese Academic', 'Chinese', 'PASS', 30),
    ('EU', 'Europe / UK Academic', 'English', 'PASS', 30);

INSERT INTO anchors (id, name, description) VALUES
    ('ANCHOR.MODELS', 'Concurrency Models', 'Threads, processes, fibers, coroutines; shared-memory vs message-passing; formal models');

INSERT INTO researchers (name, institution, region_id) VALUES
    ('C.A.R. Hoare', 'Oxford University', 'EU'),
    ('Robin Milner', 'Cambridge University', 'EU'),
    ('Roberto Ierusalimschy', 'Tufts University', 'en-US'),
    ('Han Wentao', 'Tsinghua University', 'zh-CN'),
    ('Lin Ziyu', 'Xiamen University', 'zh-CN');

INSERT INTO concurrency_models_sources (title, url, institution, region_id, domain_type, key_focus, model_categories) VALUES
    ('MIT 6.031 Reading 21', 'https://web.mit.edu/6.031/www/sp22/classes/21-concurrency/', 'MIT', 'en-US', 'edu', 'Shared memory vs message passing; processes, threads, time-slicing; race conditions', 'shared-memory,message-passing'),
    ('OSTEP Ch.26', 'https://pages.cs.wisc.edu/~remzi/OSTEP/threads-intro.pdf', 'U Wisconsin', 'en-US', 'edu', 'Thread abstraction; context switching; multi-threaded address space', 'threads'),
    ('CSP (Hoare)', 'https://www.cs.ox.ac.uk/ucs/hoarebook.pdf', 'Oxford University', 'EU', 'ac', 'Process algebra; traces; nondeterminism; communication; dining philosophers as CSP', 'process-algebra'),
    ('UIUC CS340', 'https://courses.grainger.illinois.edu/CS340/sp2025/text/concurrency.html', 'U Illinois', 'en-US', 'edu', 'Concurrency vs parallelism; processes, threads, fibers, generators, async/await', 'processes,threads,fibers'),
    ('CMU CSAPP Ch.12', 'https://csapp.cs.cmu.edu/2e/ch12-preview.pdf', 'Carnegie Mellon', 'en-US', 'edu', 'Three approaches: processes, I/O multiplexing, threads', 'processes,threads,io-multiplexing'),
    ('Tufts (Ierusalimschy)', 'https://www.cs.tufts.edu/~nr/cs257/archive/roberto-ierusalimschy/revisiting-coroutines.pdf', 'Tufts University', 'en-US', 'edu', 'Coroutines classification; asymmetric vs symmetric; cooperative multitasking', 'coroutines'),
    ('GWU Kilim (Srinivasan)', 'https://www2.seas.gwu.edu/~simha/NHCworkshop/final/NHC06-Srinivasan.pdf', 'George Washington U', 'en-US', 'edu', 'Fibers; lightweight threads; continuation-passing on JVM; Erlang-style actors', 'fibers,actors'),
    ('Cambridge Concepts of PL', 'https://www.cl.cam.ac.uk/teaching/1314/ConceptsPL/Concurrency-Parallelism-4up.pdf', 'U Cambridge', 'EU', 'ac', 'PRAM, BSP, CSP, CCS, pi-calculus, Actors taxonomy; MPI vs OpenMP vs CUDA', 'formal-models,process-algebra'),
    ('Winskel & Nielsen Models', 'https://www.cl.cam.ac.uk/~gw104/winskel-nielsen-models-for-concurrency.pdf', 'U Cambridge', 'EU', 'ac', 'Category-theoretic survey; interleaving vs non-interleaving; Petri nets; event structures', 'formal-models,petri-nets,event-structures'),
    ('Applied pi Tutorial', 'https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-498.pdf', 'U Cambridge', 'EU', 'ac', 'pi-calculus; operational semantics; Pict; typing; distributed pi calculi; scope extrusion', 'process-algebra'),
    ('occam-pi (Kent)', 'https://www.cs.kent.ac.uk/projects/ofa/kroc/occam-pi.pdf', 'U Kent', 'EU', 'ac', 'CSP + pi-calculus binding; mobile processes/channels; millions of concurrent processes', 'process-algebra'),
    ('Mixing Metaphors (Edinburgh)', 'https://homepages.inf.ed.ac.uk/wadler/papers/mixing-metaphors/mixing-metaphors.pdf', 'U Edinburgh', 'EU', 'ac', 'Lambda-calculus comparison of channels vs actors; Go vs Erlang; typed translations', 'channels,actors'),
    ('Tsinghua Rust Concurrency', 'https://lab.cs.tsinghua.edu.cn/rust/slides/06-concurrency.pdf', 'Tsinghua University', 'zh-CN', 'edu', 'Threads; concurrency vs parallelism; Send/Sync traits; channels; Rust ownership', 'threads,channels'),
    ('Xiamen DB Processes', 'https://dblab.xmu.edu.cn/wp-content/uploads/old/files/linziyu-Architecture%20of%20a%20Database%20System(Chinese%20Version)-Chapter2-Process%20Model.pdf', 'Xiamen University', 'zh-CN', 'edu', 'DBMS process models: per-worker process, thread, process pool; lightweight threads', 'processes,threads'),
    ('BAAI Concurrency vs Parallelism', 'https://hub.baai.ac.cn/view/18005', 'Beijing Academy of AI', 'zh-CN', 'ac', 'Concurrency vs parallelism debate; Erlang/Go perspectives (Armstrong)', 'concurrency-vs-parallelism');
