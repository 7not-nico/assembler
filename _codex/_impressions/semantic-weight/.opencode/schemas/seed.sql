-- Semantic Weight — Seed Data
-- INSERT statements (run after schema DDL)

-- Regions
INSERT OR REPLACE INTO regions (id, name, notes) VALUES
  ('EN', 'Anglophone', 'USA/UK — semantic information theory, s-vector semantics, ICDS, Centering Theory, thematic hierarchy'),
  ('DE', 'Germanic', 'Germany/Switzerland/Austria — Markiertheitstheorie, Informationsstruktur, semantische Granulation, Prominence'),
  ('FR', 'Romance French', 'France/Belgium/Switzerland — Mandelbrot cost-minimization, FSP, structural semantics, TOE'),
  ('ES', 'Romance Spanish', 'Spain/Latin America — ICDS, funciones informativas, informative efficiency indices, colocaciones'),
  ('CN', 'Sinosphere', 'China — synonymity mapping, semantic density, semantic communication, 语义韵, topic-prominence'),
  ('RU', 'Slavic', 'Russia — thesaurus measure, SemETAP, Meaning-Text theory, aktualnoe chlenenie, text complexity');

-- Fundamentals
INSERT OR REPLACE INTO fundamentals (id, title, summary, source, key_idea) VALUES
  ('FUND.IRP', 'Inverse Relationship Principle', 'Semantic information inversely proportional to logical probability', 'Carnap/Bar-Hillel (1952)', 'The more improbable a proposition, the more semantic information it carries. cont(s) = 1 - q(s)'),
  ('FUND.VERIDICAL', 'Veridicality thesis', 'Semantic information must be true', 'Floridi (2004-2005)', 'Strongly semantic information requires truth — false content is not information but disinformation'),
  ('FUND.SVECTOR', 's-vector semantics', 'Log-probability ratios as semantic content', 'Isaac (2019)', 'Shannon information intrinsically contains semantics via log-probability ratio vectors derived from Turing/Bletchley'),
  ('FUND.GTHEORY', 'G theory', 'Semantic generalization of Shannon information theory', 'Chen (2025)', 'Replace distortion constraint with semantic constraint via truth function semantic channels'),
  ('FUND.ICDS', 'Information Theory-based Compositional Distributional Semantics', 'Unified framework for embeddings, composition, similarity', 'Amigó et al. (2022)', 'Embedding norm ~ information content; formal properties for semantic representation spaces'),
  ('FUND.MARKEDNESS', 'Semantic markedness', 'Natürlichkeitstheorie / konstruktioneller Ikonismus', 'Mayerthaler (1981)', 'sem< values for grammatical categories — simpler categories are unmarked, complex ones are marked'),
  ('FUND.CD', 'Communicative dynamism', 'Degrees of contribution to communication progress', 'Firbas / Prague School', 'Each element carries a degree of CD; hierarchy of thematicity based on context-dependence'),
  ('FUND.THESAURUS', 'Thesaurus measure', 'Semantic information depends on users prior knowledge', 'Shreider (1960s)', 'Semantic information = function relating message to user thesaurus; maximum when understood + novel'),
  ('FUND.SYNONYMITY', 'Synonymity mapping', 'Semantic entropy via one-to-many synonymity relations', 'Niu/Zhang (2024)', 'Semantic entropy H_s(U~) = functional of source distribution and synonymity mapping f; 1-to-many'),
  ('FUND.SEMDENSITY', 'Semantic density', 'Knowledge condensation degree in academic writing', 'Gao/Zhou (2022)', 'Semantic density (SD) reveals knowledge coding; correlates with expertise across academic levels'),
  ('FUND.COSTMIN', 'Cost-minimization', 'Word frequency decays exponentially with cost', 'Mandelbrot/Zipf', 'Optimal code assigns frequency inversely to cost; rank-frequency relation follows power law'),
  ('FUND.INEFFICIENCY', 'Informative efficiency indices', 'Lexical and phonic efficiency across languages', 'Vercher/Bullejos (2022)', '459 languages analyzed for relativity, density, and efficiency indices correlating with morphological type'),
  ('FUND.FOCALISATION', 'Focalisation as dissociated assertion', 'Assertion on identification, not predication', 'Culioli / Robert (1998)', 'Focus = assertion dissociated from predication; predication presented as preconstructed'),
  ('FUND.TOPIC_PROM', 'Topic-prominence parameter', 'Topic as defining syntactic feature of Chinese', 'Li & Thompson (1976)', 'Chinese topics need no grammatical relation to comment — topic-prominence as parametric typology'),
  ('FUND.IDIOM_PRINC', 'Idiom principle', 'Extended units of meaning beyond word boundaries', 'Sinclair (1991)', 'Language operates via prefabricated word sequences, not open-choice slot-filling'),
  ('FUND.LEXICAL_PRIM', 'Lexical priming theory', 'Words carry priming from repeated collocational environments', 'Hoey (2005)', 'Every word is primed for use through accumulated exposure to its typical collocational contexts'),
  ('FUND.LEXICAL_FUNC', 'Lexical Functions (Meaning-Text)', 'Formal description of collocational relations', 'Melchuk (1974)', 'FLs map lexemes to their collocates via standard semantic relations (MAGN, OPER, FUNC, etc.)'),
  ('FUND.EQUICOMPLEX', 'Equi-complexity hypothesis', 'The idea that all languages are equally complex', 'Miestamo / Koplenig (2023)', 'Empirically disproven by IDS Mannheim 2000+ language entropy rate study — languages differ systematically'),
  ('FUND.KOLMOGOROV', 'Kolmogorov complexity', 'Shortest possible description length as complexity measure', 'Juola (1998) / Ehret & Szmrecsanyi', 'gzip compression ratio approximates Kolmogorov complexity; theory-neutral cross-linguistic metric'),
  ('FUND.TRADEOFF', 'Complexity-efficiency tradeoff', 'Languages trade structural complexity against communicative efficiency', 'Koplenig et al. (2025)', 'Higher entropy languages use fewer symbols for same content; larger speech communities → more complex + efficient');

-- Sources (consolidated from 5 research rounds)
INSERT OR REPLACE INTO sources (id, title, author, region_id, country, institution, key_content, methodology, language, doi_url, year) VALUES
  -- R1: Semantic Weight
  ('SRC.EN.CARNAP', 'An Outline of a Theory of Semantic Information', 'Carnap, R. & Bar-Hillel, Y.', 'EN', 'USA', 'UCLA / Hebrew U', 'Classical semantic information; cont() and inf() measures based on logical probability', 'logical formalism', 'EN', null, 1952),
  ('SRC.EN.FLORIDI', 'Outline of a Theory of Strongly Semantic Information', 'Floridi, L.', 'EN', 'UK', 'Oxford', 'Strongly semantic information; veridicality thesis; truthlikeness quantification', 'philosophical analysis', 'EN', 'https://philarchive.org/archive/FLOOOA', 2004),
  ('SRC.EN.RESNIK', 'Semantic Similarity in a Taxonomy: An Information-Based Measure', 'Resnik, P.', 'EN', 'USA', 'U Maryland', 'Information-based semantic similarity in WordNet; most informative subsumer', 'probabilistic taxonomy', 'EN', 'https://www.cs.cmu.edu/afs/cs/project/jair/pub/volume11/resnik99a.pdf', 1999),
  ('SRC.EN.MONTEMURRO', 'Towards the Quantification of Semantic Information in Written Language', 'Montemurro, M. & Zanette, D.', 'EN', 'UK', 'U Manchester', 'Word-level information contribution via mutual information; characteristic ~5000 word scale', 'information theory + corpus', 'EN', 'https://doi.org/10.1142/s0219525910002530', 2010),
  ('SRC.EN.ISAAC', 'The Semantics Latent in Shannon Information', 'Isaac, A.', 'EN', 'UK', 'U Edinburgh', 's-vector semantics; log-probability ratio as content; Turing parallel development', 'formal semantics + info theory', 'EN', 'https://doi.org/10.1093/bjps/axx029', 2019),
  ('SRC.EN.FUTRELL', 'Information Theory as a Bridge Between Language Function and Form', 'Futrell, R. & Hahn, M.', 'EN', 'USA', 'UC Irvine / Stanford', 'IT as bridge between functional and formal theories; constrained optimization', 'computational linguistics', 'EN', 'https://doi.org/10.3389/fcomm.2022.657725', 2022),
  ('SRC.EN.AMIGO', 'Information Theory-based Compositional Distributional Semantics', 'Amigó, E. et al.', 'EN', 'Spain', 'UNED / U Barcelona', 'ICDS: formal properties for embedding, composition, similarity', 'computational linguistics', 'EN', 'https://doi.org/10.1162/coli_a_00454', 2022),
  ('SRC.EN.CHEN', 'A Semantic Generalization of Shannons Information Theory', 'Chen (G theory)', 'EN', 'China/USA', 'Multiple', 'G theory; semantic channel of truth functions; replaces distortion with semantic constraint', 'information theory', 'EN', 'https://www.mdpi.com/1099-4300/27/5/461', 2025),
  -- R2: Semantic Salience
  ('SRC.EN.FILLMORE', 'The case for case / Thematic hierarchy', 'Fillmore, C.', 'EN', 'USA', 'UC Berkeley', 'Semantic roles as deep cases; thematic hierarchy governing subject/object selection', 'formal linguistics', 'EN', null, 1968),
  ('SRC.EN.DOWTY', 'Thematic proto-roles and argument selection', 'Dowty, D.', 'EN', 'USA', 'Ohio State', 'Proto-Agent/Patient entailments; salience hierarchy from event properties', 'formal semantics', 'EN', null, 1991),
  ('SRC.EN.TALMY', 'The Attention System of Language', 'Talmy. L.', 'EN', 'USA', 'SUNY Buffalo', 'Attention as schematic system; 10 categories of attentional factors; Figure/Ground', 'cognitive semantics', 'EN', null, 2007),
  ('SRC.DE.SFB1252', 'SFB 1252 Prominence in Language', 'von Heusinger, K. et al.', 'DE', 'Germany', 'U Cologne', 'Largest prominence research program: 3 fields, 40+ projects', 'interdisciplinary', 'DE/EN', 'https://sfb1252.uni-koeln.de/projekte', 2016),
  ('SRC.DE.KONUK', 'Grammatische Funktion, semantische Rolle und Diskursprominenz', 'Konuk', 'DE', 'Germany', 'U Cologne', 'Subjecthood + semantic role both influence discourse prominence; Turkish psych-verbs', 'experimental', 'DE', null, 2021),
  ('SRC.FR.LANDRAGIN', 'Saillance (Sémanticlopédie)', 'Landragin, F.', 'FR', 'France', 'CNRS / LLF Paris', '6 types of saillance: intrinsic, explicit, syntactic, grammatical, prosodic, indirect', 'encyclopedic synthesis', 'FR', 'https://dicosem.llf-paris.fr/wiki/Saillance', 2004),
  -- R3: Topic / Focus
  ('SRC.EN.LAMBRECHT', 'Information structure and sentence form', 'Lambrecht, K.', 'EN', 'USA', 'U Texas / UCSC', '3-way focus typology (predicate/argument/sentence); topic as aboutness', 'formal pragmatics', 'EN', null, 1994),
  ('SRC.EN.ROOTH', 'A theory of focus interpretation', 'Rooth, M.', 'EN', 'USA', 'UCSC', 'Focus as alternatives; alternative semantics for focus interpretation', 'formal semantics', 'EN', null, 1992),
  ('SRC.DE.KRIFKA', 'Basic notions of information structure', 'Krifka, M.', 'DE', 'Germany', 'HU Berlin / ZAS', '3-dimensional IS model: topic-comment, focus-background, given-new', 'formal pragmatics', 'EN', null, 2007),
  ('SRC.DE.SFB632', 'SFB 632 Informationsstruktur', 'Fanselow, G. et al.', 'DE', 'Germany', 'HU Berlin / ZAS / FU Berlin', '16+ project collaborative on IS; QUIS questionnaire for 60+ languages', 'interdisciplinary', 'DE/EN', 'https://edoc.hu-berlin.de/bitstreams/288a6290-43ca-4dbb-ad9d-78b82a9b2092/download', 2003),
  ('SRC.FR.CULIOLI', 'Théorie des Opérations Enonciatives (TOE)', 'Culioli, A.', 'FR', 'France', 'U Paris Diderot', 'Focus as assertion dissociated from predication; topicalisation as anchoring', 'enunciative linguistics', 'FR', null, 1990),
  ('SRC.FR.ROBERT', 'La focalisation / Wolof emphatic conjugations', 'Robert, S.', 'FR', 'France', 'CNRS / LLACAN', '4 values of subject focus in Wolof: identification, definition, explanation, exclamation', 'formal + fieldwork', 'FR', 'https://www.persee.fr/doc/flang_1244-5460_1998_num_6_11_1210', 1998),
  ('SRC.CN.LI_THOMPSON', 'Subject and topic: a new typology of language', 'Li, C. & Thompson, S.', 'CN', 'China/USA', 'UCSB / UCLA', 'Topic-prominence as parametric typological feature; Chinese topics need no grammatical link', 'typology', 'EN', null, 1976),
  ('SRC.CN.SUN', '汉语话题结构的类型新议', 'Sun, C.', 'CN', 'China', 'Shanghai Jiao Tong / BISU', '8+ topic subtypes: left/right peripheral, centrally-positioned, Chinese-style, argument-splitting', 'typological syntax', 'ZH', 'https://jfl.shisu.edu.cn/article/id/590', 2022),
  ('SRC.RU.PADUCHEVA', 'Коммуникативная структура предложения', 'Paducheva, E.', 'RU', 'Russia', 'IPPI RAS', 'Topic/focus as shifter categories; linear-accent structure as unified system', 'formal linguistics', 'RU', 'http://a0410571.xsph.ru/new/chapter/clauseintro/information_structure/', 1985),
  -- R4: Semantic Prosody
  ('SRC.EN.SINCLAIR', 'Corpus, Concordance, Collocation / Idiom principle', 'Sinclair, J.', 'EN', 'UK', 'Birmingham / COBUILD', 'Idiom principle; extended units of meaning: collocation, colligation, semantic preference, prosody', 'corpus linguistics', 'EN', null, 1991),
  ('SRC.EN.LOUW', 'Semantic prosody: a consistent aura of meaning', 'Louw, B.', 'EN', 'UK', 'U Zimbabwe / Birmingham', 'Semantic prosody as consistent evaluative aura from collocates', 'corpus linguistics', 'EN', null, 1993),
  ('SRC.EN.HOEY', 'Lexical Priming: A New Theory of Words and Language', 'Hoey, M.', 'EN', 'UK', 'U Liverpool', 'Lexical priming theory — words carry priming from repeated collocational environments', 'corpus linguistics / psycholinguistics', 'EN', 'https://doi.org/10.4324/9780203327630', 2005),
  ('SRC.EN.HAUSER', 'Semantic prosody and judgment', 'Hauser, D. & Schwarz, N.', 'EN', 'USA', 'USC / Michigan', 'Experimental validation: caused vs produced affect evaluative judgments of ambiguous outcomes', 'experimental', 'EN', null, 2016),
  ('SRC.EN.XIAO', 'Collocation, semantic prosody, and near synonymy', 'Xiao, R. & McEnery, T.', 'EN', 'UK', 'Lancaster', 'Cross-linguistic EN/ZH comparison of semantic prosody for near-synonyms', 'corpus linguistics', 'EN', 'https://doi.org/10.1093/applin/ami045', 2006),
  ('SRC.CN.SP', '新颖词语义韵的发生机制：“双枣树”效应的证据', 'Multiple authors', 'CN', 'China', 'CAS Psychology', 'Double-Jujube Tree effect: repeated context transfers affect to novel words; varied context aids word learning', 'experimental', 'ZH', 'https://journal.psych.ac.cn/xlxb/CN/10.3724/SP.J.1041.2024.00531', 2024),
  ('SRC.ES.ALONSO', 'Hacia una definición del concepto de colocación', 'Alonso Ramos, M.', 'ES', 'Spain', 'U Pompeu Fabra', 'Lexical Functions for Spanish collocations; DiCE dictionary project', 'lexicographic', 'ES', null, 1995),
  ('SRC.FR.POLGUERE', 'Dérivations sémantiques et collocations dans le DiCo/LAF', 'Polguère, A.', 'FR', 'France', 'ATILF / U Lorraine', 'DiCo/LAF lexical database; Lexical Functions for French collocations', 'lexicographic', 'FR', null, 2006),
  -- R5: Linguistic Complexity
  ('SRC.EN.MIESTAMO', 'Grammatical complexity in a cross-linguistic perspective', 'Miestamo, M.', 'EN', 'Finland', 'U Helsinki', 'Absolute vs relative complexity; functional domain approach; Fewer Distinctions principle', 'typological theory', 'EN', null, 2008),
  ('SRC.EN.EHRET', 'Kolmogorov complexity of English morphology and structure', 'Ehret, K.', 'EN', 'Germany', 'U Freiburg', 'gzip compression for morphological/syntactic complexity; -ing, -ed, tense structures', 'information-theoretic', 'EN', 'https://aclanthology.cn/2014.lilt-11.3/', 2014),
  ('SRC.EN.MOLUCA', 'The forms and meanings of grammatical markers support efficient communication', 'Mollica, F. et al.', 'EN', 'Multiple', 'Multiple', 'Information Bottleneck for grammatical marking; optimal complexity-informativeness tradeoff', 'information-theoretic', 'EN', null, 2021),
  ('SRC.DE.KOPLENIG2023', 'All languages are not equally complex (Nature Sci Reports)', 'Koplenig, A. et al.', 'DE', 'Germany', 'IDS Mannheim', '2000+ languages; entropy rate disproves equi-complexity; population size predicts complexity', 'information-theoretic + NLP', 'EN', 'https://doi.org/10.1038/s41598-023-42327-3', 2023),
  ('SRC.DE.KOPLENIG2025', 'Human languages trade off complexity against efficiency', 'Koplenig, A. et al.', 'DE', 'Germany', 'IDS Mannheim', 'Complexity-efficiency tradeoff across 7 LM architectures; 41 text collections; 2000+ languages', 'ML + information theory', 'EN', 'https://doi.org/10.1371/journal.pcsy.0000032', 2025),
  ('SRC.FR.OH', 'Quantitative and typological approach to correlating linguistic complexity', 'Oh, Y.M. et al.', 'FR', 'France', 'DDL Lyon / CNRS', 'Syllabic rate vs information density tradeoff across 14 languages; morphological classification', 'corpus + information theory', 'EN', 'http://www.ddl.cnrs.fr/fulltext/yoonmi/Oh_2013_qitl1.pdf', 2013),
  ('SRC.ES.VERCHER', 'Los índices de relatividad, densidad y eficiencia informativa', 'Vercher & Bullejos', 'ES', 'Spain', 'U Alicante', '459 languages; informative relativity/density/efficiency indices; morphological typology correlations', 'quantitative typology', 'ES/EN', 'https://doi.org/10.14198/ELUA.18583', 2022),
  ('SRC.RU.SOLNYSHKINA', 'Лингвистическая сложность учебных текстов', 'Solnyshkina, M. et al.', 'RU', 'Russia', 'Kazan Federal U', 'Readability, narrative, abstractness, lexical diversity for Russian textbooks', 'text complexity', 'RU', 'https://jpl-journal.ru/index.php/journal/article/view/78', 2021);

-- Researchers
INSERT OR REPLACE INTO researchers (id, name, institution, region_id, specialisation) VALUES
  ('RES.CARNAP', 'Rudolf Carnap', 'UCLA', 'EN', 'Logical semantics, probability, semantic information'),
  ('RES.FLORIDI', 'Luciano Floridi', 'Oxford', 'EN', 'Philosophy of information, veridicality thesis'),
  ('RES.ISAAC', 'Alistair Isaac', 'U Edinburgh', 'EN', 's-vector semantics, natural meaning'),
  ('RES.FUTRELL', 'Richard Futrell', 'UC Irvine', 'EN', 'Information-theoretic linguistics, language complexity'),
  ('RES.SINCLAIR', 'John Sinclair', 'U Birmingham', 'EN', 'Corpus linguistics, idiom principle, lexical grammar'),
  ('RES.HOEY', 'Michael Hoey', 'U Liverpool', 'EN', 'Lexical priming theory'),
  ('RES.MIESTAMO', 'Matti Miestamo', 'U Helsinki', 'EN', 'Grammatical complexity, typology'),
  ('RES.MAYERTHALER', 'Willi Mayerthaler', 'U Passau', 'DE', 'Naturalness theory, semantic markedness'),
  ('RES.KRIFKA', 'Manfred Krifka', 'HU Berlin / ZAS', 'DE', 'Information structure, focus, topic'),
  ('RES.VONHEUSINGER', 'Klaus von Heusinger', 'U Cologne', 'DE', 'Prominence, discourse structure, anaphora'),
  ('RES.KOPLENIG', 'Alexander Koplenig', 'IDS Mannheim', 'DE', 'Language complexity, information theory, NLP'),
  ('RES.CULIOLI', 'Antoine Culioli', 'U Paris Diderot', 'FR', 'Theory of Enunciative Operations'),
  ('RES.LANDRAGIN', 'Frédéric Landragin', 'CNRS / LLF Paris', 'FR', 'Saillance, anaphora, discourse structure'),
  ('RES.PELLEGRINO', 'François Pellegrino', 'DDL Lyon / CNRS', 'FR', 'Phonological complexity, information density'),
  ('RES.AMIGO', 'Enrique Amigó', 'UNED', 'ES', 'ICDS, information-theoretic semantics'),
  ('RES.VERCHER', 'E.J. Vercher García', 'U Alicante', 'ES', 'Informative efficiency indices'),
  ('RES.ALONSO_RAMOS', 'Margarita Alonso Ramos', 'U Pompeu Fabra', 'ES', 'Lexical Functions, Spanish collocations'),
  ('RES.GAO', 'Gao Yanmei', 'PKU', 'CN', 'Semantic density, disciplinary knowledge coding'),
  ('RES.NIU', 'Niu Kai', 'BUPT', 'CN', 'Semantic communication, synonymity mapping'),
  ('RES.SHREIDER', 'Yuliy Shreider', 'IPPI RAS', 'RU', 'Thesaurus measure, semantic information'),
  ('RES.PADUCHEVA', 'Elena Paducheva', 'IPPI RAS', 'RU', 'Communicative structure, aktualnoe chlenenie'),
  ('RES.SOLNYSHKINA', 'Marina Solnyshkina', 'Kazan Federal U', 'RU', 'Text complexity, readability assessment');

-- Gaps (cross-cutting)
INSERT OR REPLACE INTO gaps (id, description, regions) VALUES
  ('GAP.NOUNIFY', 'No unified formalization of semantic weight across any region', 'ALL'),
  ('GAP.NOMETA', 'No meta-analysis of semantic weight as distinct measurable concept in any region', 'ALL'),
  ('GAP.NOVALIDATION', 'None of the proposed measures validated against human judgments of semantic weight', 'ALL'),
  ('GAP.LOGDIST', 'No bridge between logical probability (Carnap) and distributional (Harris) approaches', 'EN↔FR'),
  ('GAP.ENGGAP', 'Chinese 6G/engineering semantic weight (UEP) not cited by non-Chinese frameworks', 'CN↔OTHER'),
  ('GAP.THESAURUS', 'Shreider thesaurus measure abandoned outside Russian-language literature since 1990s', 'RU↔OTHER'),
  ('GAP.WEIGHTSAL', 'No integration of quantitative semantic weight (R1) with discourse salience (R2)', 'R1↔R2'),
  ('GAP.ISWEIGHT', 'No formal weight measure for topic/focus distinctions — IS remains categorical', 'R3'),
  ('GAP.POLARITY', 'Semantic prosody binary polarity too coarse — ignores gradient evaluative meaning', 'R4'),
  ('GAP.KOLMONO', 'Kolmogorov complexity applied only to European languages in most studies', 'R5');
