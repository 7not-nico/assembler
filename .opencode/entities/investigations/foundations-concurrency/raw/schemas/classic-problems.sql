INSERT INTO anchors (id, name, description) VALUES
    ('ANCHOR.CLASSIC', 'Classic Problems', 'Producer-consumer, readers-writers, dining philosophers');

INSERT INTO researchers (name, institution, region_id) VALUES
    ('Edsger Dijkstra', 'Eindhoven University', 'EU'),
    ('Joel C. Adams', 'Calvin College', 'en-US'),
    ('Luther Tychonievich', 'U Illinois', 'en-US');

INSERT INTO classic_problems_sources (title, url, institution, region_id, domain_type, key_focus, problems_covered) VALUES
    ('UC Davis Handout', 'https://nob.cs.ucdavis.edu/classes/ecs150-2008-02/handouts/sync/sync-problems.html', 'UC Davis', 'en-US', 'edu', 'Problem definitions: producer-consumer, readers-writers (2 priority variants), dining philosophers', 'producer-consumer,readers-writers,dining-philosophers'),
    ('UIUC CS241', 'https://courses.grainger.illinois.edu/cs241/fa2012/lectures/22-ClassicSynch.pdf', 'U Illinois', 'en-US', 'edu', 'Semaphore solutions; reader/writer preference; deadlock conditions', 'producer-consumer,readers-writers,dining-philosophers'),
    ('Cornell CS414', 'https://www.cs.cornell.edu/courses/cs414/2004su/slides/08_classicsynchproblems.pdf', 'Cornell', 'en-US', 'edu', 'Semaphore and monitor solutions; deadlock prevention (4 conditions); resource allocation graphs', 'producer-consumer,readers-writers,dining-philosophers'),
    ('Calvin College (Adams)', 'https://digitalcommons.calvin.edu/cgi/viewcontent.cgi?article=1000&context=calvin_facultypubs', 'Calvin University', 'en-US', 'edu', 'Visualization tools as pedagogical aids for classic problems', 'dining-philosophers,producer-consumer,readers-writers'),
    ('UMD CMSC412', 'https://www.cs.umd.edu/class/fall2023/cmsc412/Slides/Set10-%20Chapter%207%20Synchronization%20Examples.pdf', 'U Maryland', 'en-US', 'edu', 'Classical problems with semaphore and monitor solutions', 'producer-consumer,readers-writers,dining-philosophers'),
    ('CSU CS370', 'https://www.cs.colostate.edu/~cs370/Spring24/lectures/CS370-L11-ProcessSynchronization-PartC-Spring24-Pouchet.pdf', 'Colorado State', 'en-US', 'edu', 'Producer-consumer, readers-writers, dining philosophers with semaphore/monitor', 'producer-consumer,readers-writers,dining-philosophers'),
    ('CMU 14-712', 'https://www.andrew.cmu.edu/course/14-712-s20/applications/ln/14712-l9.pdf', 'Carnegie Mellon', 'en-US', 'edu', 'Bounded buffer, readers-writers, dining philosophers', 'producer-consumer,readers-writers,dining-philosophers'),
    ('Cambridge CDS Classical CC', 'https://www.cl.cam.ac.uk/teaching/1011/CDSysI/02-classicalCC.pdf', 'U Cambridge', 'EU', 'ac', 'Producer-consumer (1-to-1, many-to-many), readers-writers, semaphore solutions', 'producer-consumer,readers-writers'),
    ('Cambridge L3 Transcript', 'https://www.cl.cam.ac.uk/teaching/2324/ConcDisSys/djg-materials/ccds-L3-transcript.txt', 'U Cambridge', 'EU', 'ac', 'Semaphores; mutual exclusion; condition synchronization; ring buffer producer-consumer', 'producer-consumer'),
    ('Cambridge CS2 Problems', 'https://www.cl.cam.ac.uk/teaching/2425/ConcDisSys/cs2.pdf', 'U Cambridge', 'EU', 'ac', 'Semaphore exercises; generalized producer-consumer; priorities; round-robin; priority inversion', 'producer-consumer'),
    ('Newcastle Concurrency Control', 'https://research.ncl.ac.uk/game/mastersdegree/workshops/concurrencycontrol/Concurrency%20Control.pdf', 'Newcastle University', 'EU', 'ac', 'Dining philosophers; deadlock; starvation; livelock; transactional memory; wait-free', 'dining-philosophers'),
    ('SDU OS (Xin)', 'http://mima.sdu.edu.cn/Members/xinshunxu/Courses/OS/chapter6.pdf', 'Shandong University', 'zh-CN', 'edu', 'Bounded buffer; readers-writers; dining philosophers; semaphore solutions', 'producer-consumer,readers-writers,dining-philosophers'),
    ('SJTU OS (Wu)', 'https://www.cs.sjtu.edu.cn/~wuct/os/slides/lec7-OS.pdf', 'Shanghai Jiao Tong', 'zh-CN', 'edu', 'Classical problems with semaphores; monitor solutions', 'producer-consumer,readers-writers,dining-philosophers'),
    ('WHUT Classic Problems', 'https://jxpt.whut.edu.cn/meol/analytics/resPdfShow.do;jsessionid=4F54AC5A1F1E621877E4ACE1D175E30C?lid=6517&resId=31868', 'Wuhan U Tech', 'zh-CN', 'edu', 'Producer-consumer; readers-writers; dining philosophers; P/V operations', 'producer-consumer,readers-writers,dining-philosophers');
