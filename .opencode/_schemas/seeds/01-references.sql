-- PROT.REFERENCE.AUTHORITY — Seed: roles + deduplicated sources + entity links

INSERT OR REPLACE INTO reference_roles VALUES
  ('primary',       'Primary source — authoritative for entity type'),
  ('supplementary', 'Supplementary source — supporting authority');

-- Each source stored once regardless of how many entities cite it
INSERT OR IGNORE INTO ref_sources (title, url) VALUES
  ('Tanenbaum — Modern Operating Systems (4th ed.)',
   'https://www.pearson.com/en-us/subject-catalog/p/modern-operating-systems'),
  ('Silberschatz, Galvin, Gagne — Operating System Concepts (10th ed.)',
   'https://www.os-book.com/OSC10/'),
  ('Stallings — Operating Systems: Internals and Design Principles (9th ed.)',
   'https://www.pearson.com/en-us/subject-catalog/p/operating-systems'),
  ('Bryant and O''Hallaron — Computer Systems: A Programmer''s Perspective (3rd ed.)',
   'http://csapp.cs.cmu.edu/'),
  ('Arpaci-Dusseau — Operating Systems: Three Easy Pieces',
   'https://ostep.org/'),
  ('Goetz et al. — Java Concurrency in Practice',
   'http://jcip.net/'),
  ('Dijkstra — Cooperating Sequential Processes (1965)',
   'https://www.cs.utexas.edu/~EWD/transcriptions/EWD01xx/EWD123.html'),
  ('Lamport — Time, Clocks, and the Ordering of Events (1978)',
   'https://doi.org/10.1145/359545.359563'),
  ('Hennessy and Patterson — Computer Architecture: A Quantitative Approach (6th ed.)',
   'https://www.elsevier.com/books/computer-architecture/hennessy/978-0-12-811905-1'),
  ('Flynn — Some Computer Organizations and Their Effectiveness (1972)',
   'https://doi.org/10.1109/TC.1972.5009071'),
  ('Amdahl — Validity of the Single Processor Approach (1967)',
   'https://doi.org/10.1145/1465482.1465560');

-- PROT.DOCUMENT.COMPOSITION — seminal papers (primary per PROT.REFERENCE.AUTHORITY)
INSERT OR IGNORE INTO ref_sources (title, url) VALUES
  ('Böhm and Jacopini — Flow Diagrams, Turing Machines and Languages with Only Two Formation Rules (1966)',
   'https://doi.org/10.1145/355592.365646'),
  ('Dijkstra — The Structure of the THE-Multiprogramming System (1968)',
   'https://doi.org/10.1145/363095.363143'),
  ('Wirth — Program Development by Stepwise Refinement (1971)',
   'https://doi.org/10.1145/362575.362577'),
  ('Dahl, Dijkstra, and Hoare — Structured Programming (1972)',
   'https://dl.acm.org/doi/book/10.5555/1243380'),
  ('Parnas — On the Criteria To Be Used in Decomposing Systems into Modules (1972)',
   'https://doi.org/10.1145/361598.361623'),
  ('Alexander, Ishikawa, and Silverstein — A Pattern Language (1977)',
   'https://global.oup.com/academic/product/a-pattern-language-9780195019193'),
  ('Hoare — Communicating Sequential Processes (1978)',
   'https://doi.org/10.1145/359576.359585'),
  ('Osterweil — Software Processes Are Software Too (1987)',
   'https://dl.acm.org/doi/10.5555/41765.41766'),
  ('Gamma, Helm, Johnson, and Vlissides — Design Patterns (1994)',
   'https://dl.acm.org/doi/book/10.5555/186897');

INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'pattern', 'PROT.DOCUMENT.COMPOSITION', id, 0, 'primary' FROM ref_sources WHERE url = 'https://doi.org/10.1145/355592.365646';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'pattern', 'PROT.DOCUMENT.COMPOSITION', id, 1, 'primary' FROM ref_sources WHERE url = 'https://doi.org/10.1145/363095.363143';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'pattern', 'PROT.DOCUMENT.COMPOSITION', id, 2, 'primary' FROM ref_sources WHERE url = 'https://doi.org/10.1145/362575.362577';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'pattern', 'PROT.DOCUMENT.COMPOSITION', id, 3, 'primary' FROM ref_sources WHERE url = 'https://dl.acm.org/doi/book/10.5555/1243380';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'pattern', 'PROT.DOCUMENT.COMPOSITION', id, 4, 'primary' FROM ref_sources WHERE url = 'https://doi.org/10.1145/361598.361623';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'pattern', 'PROT.DOCUMENT.COMPOSITION', id, 5, 'primary' FROM ref_sources WHERE url = 'https://global.oup.com/academic/product/a-pattern-language-9780195019193';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'pattern', 'PROT.DOCUMENT.COMPOSITION', id, 6, 'primary' FROM ref_sources WHERE url = 'https://doi.org/10.1145/359576.359585';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'pattern', 'PROT.DOCUMENT.COMPOSITION', id, 7, 'primary' FROM ref_sources WHERE url = 'https://dl.acm.org/doi/10.5555/41765.41766';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'pattern', 'PROT.DOCUMENT.COMPOSITION', id, 8, 'primary' FROM ref_sources WHERE url = 'https://dl.acm.org/doi/book/10.5555/186897';

-- Junction rows: TERM.CONCURRENCY
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.CONCURRENCY', id, 0, 'primary' FROM ref_sources WHERE url = 'https://www.pearson.com/en-us/subject-catalog/p/modern-operating-systems';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.CONCURRENCY', id, 1, 'primary' FROM ref_sources WHERE url = 'https://www.os-book.com/OSC10/';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.CONCURRENCY', id, 2, 'primary' FROM ref_sources WHERE url = 'https://www.pearson.com/en-us/subject-catalog/p/operating-systems';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.CONCURRENCY', id, 3, 'primary' FROM ref_sources WHERE url = 'http://csapp.cs.cmu.edu/';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.CONCURRENCY', id, 4, 'primary' FROM ref_sources WHERE url = 'https://ostep.org/';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.CONCURRENCY', id, 5, 'primary' FROM ref_sources WHERE url = 'http://jcip.net/';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.CONCURRENCY', id, 6, 'supplementary' FROM ref_sources WHERE url = 'https://www.cs.utexas.edu/~EWD/transcriptions/EWD01xx/EWD123.html';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.CONCURRENCY', id, 7, 'supplementary' FROM ref_sources WHERE url = 'https://doi.org/10.1145/359545.359563';

-- Junction rows: TERM.PARALLELISM
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.PARALLELISM', id, 0, 'primary' FROM ref_sources WHERE url = 'https://www.elsevier.com/books/computer-architecture/hennessy/978-0-12-811905-1';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.PARALLELISM', id, 1, 'primary' FROM ref_sources WHERE url = 'https://www.pearson.com/en-us/subject-catalog/p/modern-operating-systems';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.PARALLELISM', id, 2, 'primary' FROM ref_sources WHERE url = 'https://www.os-book.com/OSC10/';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.PARALLELISM', id, 3, 'primary' FROM ref_sources WHERE url = 'https://www.pearson.com/en-us/subject-catalog/p/operating-systems';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.PARALLELISM', id, 4, 'primary' FROM ref_sources WHERE url = 'http://csapp.cs.cmu.edu/';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.PARALLELISM', id, 5, 'supplementary' FROM ref_sources WHERE url = 'https://doi.org/10.1109/TC.1972.5009071';
INSERT OR IGNORE INTO entity_references (entity_type, entity_id, source_id, position, role)
SELECT 'term', 'TERM.PARALLELISM', id, 6, 'supplementary' FROM ref_sources WHERE url = 'https://doi.org/10.1145/1465482.1465560';
