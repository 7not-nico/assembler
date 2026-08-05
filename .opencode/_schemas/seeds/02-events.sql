-- PROT.DATE.PRECISION — Seed: event definitions + person-event links
-- Shared events only: every event must link to ≥1 person

INSERT OR IGNORE INTO events (id, title) VALUES
  ('EVT.BORN', 'Born'),
  ('EVT.DIED', 'Died'),
  ('EVT.PHD.CONFERRED', 'PhD Conferred'),
  ('EVT.ACM.TURING.AWARD', 'ACM Turing Award'),
  ('EVT.CHURCH.TURING.THESIS', 'Church-Turing Thesis Formulated'),
  ('EVT.PAPER.PUBLISHED', 'Paper Published'),
  ('EVT.BOOK.PUBLISHED', 'Book Published'),
  ('EVT.THEOREM.PROVEN', 'Theorem Proven'),
  ('EVT.ACM.FOUNDED', 'ACM Founded'),
  ('EVT.ACM.RENAMED', 'ACM Renamed'),
  ('EVT.ACM.TURING.AWARD.ESTABLISHED', 'ACM Turing Award Established'),
  ('EVT.ACM.PORTAL.LAUNCHED', 'ACM Portal Launched');

INSERT OR IGNORE INTO person_events (person_id, event_id, year, month, day, location, description) VALUES
  ('PER.EDSGER.W.DIJKSTRA', 'EVT.BORN', 1930, 5, 11, 'Rotterdam, Netherlands', NULL),
  ('PER.EDSGER.W.DIJKSTRA', 'EVT.PAPER.PUBLISHED', 1956, NULL, NULL, 'Amsterdam, Netherlands', 'Published "A Note on Two Problems in Connexion with Graphs" — shortest path algorithm'),
  ('PER.EDSGER.W.DIJKSTRA', 'EVT.PHD.CONFERRED', 1959, NULL, NULL, 'Amsterdam, Netherlands', 'Received PhD from University of Amsterdam'),
  ('PER.EDSGER.W.DIJKSTRA', 'EVT.PAPER.PUBLISHED', 1962, NULL, NULL, 'Eindhoven, Netherlands', 'Published first known use of "vector" in computing context — ALGOL 60 translation memory description'),
  ('PER.EDSGER.W.DIJKSTRA', 'EVT.PAPER.PUBLISHED', 1968, 3, NULL, 'Eindhoven, Netherlands', 'Published "Go To Statement Considered Harmful" letter in Communications of the ACM'),
  ('PER.EDSGER.W.DIJKSTRA', 'EVT.ACM.TURING.AWARD', 1972, 8, 14, 'Montebello, Quebec, Canada', NULL),
  ('PER.EDSGER.W.DIJKSTRA', 'EVT.DIED', 2002, 8, 6, 'Nuenen, Netherlands', NULL),

  ('PER.ACM', 'EVT.ACM.FOUNDED', 1947, 9, 15, 'New York, New York, USA', 'Founded as the Eastern Association for Computing Machinery'),
  ('PER.ACM', 'EVT.ACM.RENAMED', 1948, NULL, NULL, 'New York, New York, USA', 'Renamed to Association for Computing Machinery'),
  ('PER.ACM', 'EVT.ACM.TURING.AWARD.ESTABLISHED', 1966, NULL, NULL, 'New York, New York, USA', 'Established the ACM Turing Award'),
  ('PER.ACM', 'EVT.ACM.PORTAL.LAUNCHED', 1998, NULL, NULL, NULL, 'Launched ACM Portal digital library'),

  ('PER.ALONZO.CHURCH', 'EVT.BORN', 1903, 6, 14, 'Washington, D.C., USA', NULL),
  ('PER.ALONZO.CHURCH', 'EVT.PAPER.PUBLISHED', 1932, NULL, NULL, 'Princeton, NJ, USA', 'Published "A Set of Postulates for the Foundation of Logic"'),
  ('PER.ALONZO.CHURCH', 'EVT.CHURCH.TURING.THESIS', 1936, NULL, NULL, 'Princeton, NJ, USA', 'Formulated the Church-Turing thesis'),
  ('PER.ALONZO.CHURCH', 'EVT.DIED', 1995, 8, 11, 'Hudson, Ohio, USA', NULL),

  ('PER.HASKELL.CURRY', 'EVT.BORN', 1900, 9, 12, 'Millis, MA, USA', NULL),
  ('PER.HASKELL.CURRY', 'EVT.PAPER.PUBLISHED', 1930, NULL, NULL, 'Göttingen, Germany', 'Published "Grundlagen der Kombinatorischen Logik"'),
  ('PER.HASKELL.CURRY', 'EVT.DIED', 1982, 9, 1, 'State College, PA, USA', NULL),

  ('PER.ALAN.TURING', 'EVT.BORN', 1912, 6, 23, 'London, UK', NULL),
  ('PER.ALAN.TURING', 'EVT.PAPER.PUBLISHED', 1936, NULL, NULL, 'Cambridge, UK', 'Published "On Computable Numbers, with an Application to the Entscheidungsproblem"'),
  ('PER.ALAN.TURING', 'EVT.PHD.CONFERRED', 1938, NULL, NULL, 'Princeton, NJ, USA', 'Received PhD under Alonzo Church'),
  ('PER.ALAN.TURING', 'EVT.DIED', 1954, 6, 7, 'Wilmslow, Cheshire, UK', NULL),

  ('PER.STEPHEN.KLEENE', 'EVT.BORN', 1909, 1, 5, 'Hartford, CT, USA', NULL),
  ('PER.STEPHEN.KLEENE', 'EVT.PHD.CONFERRED', 1934, NULL, NULL, 'Princeton, NJ, USA', 'Received PhD under Alonzo Church'),
  ('PER.STEPHEN.KLEENE', 'EVT.PAPER.PUBLISHED', 1936, NULL, NULL, 'Princeton, NJ, USA', 'Co-authored proofs of λ-definability equivalence'),
  ('PER.STEPHEN.KLEENE', 'EVT.DIED', 1994, 1, 25, 'Madison, WI, USA', NULL),

  ('PER.J.BARKLEY.ROSSER', 'EVT.BORN', 1907, 12, 6, 'Jacksonville, FL, USA', NULL),
  ('PER.J.BARKLEY.ROSSER', 'EVT.PHD.CONFERRED', 1934, NULL, NULL, 'Princeton, NJ, USA', 'Received PhD under Alonzo Church'),
  ('PER.J.BARKLEY.ROSSER', 'EVT.THEOREM.PROVEN', 1936, NULL, NULL, 'Princeton, NJ, USA', 'Co-authored "Some Properties of Conversion" (confluence theorem)'),
  ('PER.J.BARKLEY.ROSSER', 'EVT.DIED', 1989, 9, 5, 'Madison, WI, USA', NULL),

  ('PER.DAVID.GRIES', 'EVT.BORN', 1939, 4, 26, 'Flushing, Queens, New York, USA', NULL),
  ('PER.DAVID.GRIES', 'EVT.PHD.CONFERRED', 1966, NULL, NULL, 'Munich, Germany', 'Received Dr. rer. nat. from Munich Institute of Technology (Technical University Munich)'),
  ('PER.DAVID.GRIES', 'EVT.BOOK.PUBLISHED', 1981, NULL, NULL, 'New York, NY, USA', 'Published "The Science of Programming" (Springer-Verlag)'),
  ('PER.DAVID.GRIES', 'EVT.BOOK.PUBLISHED', 1993, 10, 22, 'New York, NY, USA', 'Published "A Logical Approach to Discrete Math" (Springer-Verlag, with Fred B. Schneider)'),

  ('PER.FRED.B.SCHNEIDER', 'EVT.BORN', 1953, 12, 7, 'USA', NULL),
  ('PER.FRED.B.SCHNEIDER', 'EVT.PHD.CONFERRED', 1978, NULL, NULL, 'Stony Brook, NY, USA', 'Received PhD from SUNY Stony Brook — "Structure of Concurrent Programs Exhibiting Reproducible Behavior"'),
  ('PER.FRED.B.SCHNEIDER', 'EVT.BOOK.PUBLISHED', 1993, 10, 22, 'New York, NY, USA', 'Published "A Logical Approach to Discrete Math" (Springer-Verlag, with David Gries)'),
  ('PER.FRED.B.SCHNEIDER', 'EVT.BOOK.PUBLISHED', 1997, NULL, NULL, 'New York, NY, USA', 'Published "On Concurrent Programming" (Springer-Verlag)'),

  ('PER.SPRINGER.NEW.YORK', 'EVT.BOOK.PUBLISHED', 1993, 10, 22, 'New York, NY, USA', 'Published "A Logical Approach to Discrete Math" by David Gries and Fred B. Schneider');
