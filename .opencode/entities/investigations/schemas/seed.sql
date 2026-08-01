-- Semantic Weight — Cross-Region Research Index
-- Seed data from semantic-weight-meta-audit.md

-- Regions
INSERT INTO regions (id, name, notes) VALUES
  ('EN', 'Anglophone', 'USA/UK — semantic information theory, s-vector semantics, ICDS'),
  ('DE', 'Germanic', 'Germany/Switzerland — Markiertheitstheorie, Informationsstruktur, semantische Granulation'),
  ('FR', 'Romance French', 'France/Prague — Mandelbrot cost-minimization, FSP, structural semantics'),
  ('ES', 'Romance Spanish', 'Spain/Latin America — ICDS, funciones informativas, informative efficiency indices'),
  ('CN', 'Sinosphere', 'China — synonymity mapping, semantic density, semantic communication engineering'),
  ('RU', 'Slavic', 'Russia — thesaurus measure, SemETAP, Meaning-Text theory'),
  ('GAP', 'Gaps', 'Regions with no indexed sources or cross-regional bridges');

-- Fundamentals
INSERT INTO fundamentals (id, concept, source, key_idea) VALUES
  ('F.IRP', 'Inverse Relationship Principle', 'Carnap/Bar-Hillel (1952)', 'Semantic information of a proposition inversely proportional to its logical probability'),
  ('F.VERIDICAL', 'Veridicality thesis', 'Floridi (2004-2005)', 'Semantic information must be true; truthlikeness determines information yield'),
  ('F.SVECTOR', 's-vector semantics', 'Isaac (2019)', 'Shannon information intrinsically contains semantics via log-probability ratio vectors'),
  ('F.GTHEORY', 'G theory', 'Chen (2025)', 'Replace distortion constraint with semantic constraint; semantic channel of truth functions'),
  ('F.ICDS', 'ICDS', 'Amigó et al. (2022)', 'Information-theoretic composition + distributional semantics; embedding norm ~ information content'),
  ('F.MARKEDNESS', 'Semantic markedness', 'Mayerthaler (1981)', 'sem< values for grammatical categories; iconicity principle'),
  ('F.CD', 'Communicative dynamism', 'Firbas / Prague School', 'Degrees of CD determined by context-dependence; hierarchy of thematicity'),
  ('F.THESAURUS', 'Thesaurus measure', 'Shreider (1960s)', 'Semantic information = function of user thesaurus; maximum when understood + novel'),
  ('F.SYNONYMITY', 'Synonymity mapping', 'Niu/Zhang (2024)', 'Semantic entropy H_s = functional of source distribution and synonymity mapping'),
  ('F.SEMDENSITY', 'Semantic density', 'Gao/Zhou (2022)', 'Knowledge condensation degree; correlates with syntactic complexity in academic writing'),
  ('F.COSTMIN', 'Cost-minimization', 'Mandelbrot/Zipf', 'Word frequency decays exponentially with cost; optimization of information per unit cost'),
  ('F.INEFFICIENCY', 'Informative efficiency', 'Vercher/Bullejos (2022)', 'Indices of relativity, density, efficiency across 459 languages; correlates with morphological type');

-- Sources
INSERT INTO sources (id, region_id, title, country, institution, key_content, methodology, language, doi_url, year, tags) VALUES
  -- Anglophone
  ('EN.CARNAP', 'EN', 'An Outline of a Theory of Semantic Information', 'USA', 'UCLA / Hebrew U', 'Classical semantic information; cont() and inf() measures based on logical probability', 'logical formalism', 'EN', null, 1952, 'semantic-information,logical-probability,carnap'),
  ('EN.FLORIDI', 'EN', 'Outline of a Theory of Strongly Semantic Information', 'UK', 'Oxford', 'Strongly semantic information; veridicality thesis; truthlikeness quantification', 'philosophical analysis', 'EN', 'https://philarchive.org/archive/FLOOOA', 2004, 'semantic-information,veridicality,truthlikeness'),
  ('EN.RESNIK', 'EN', 'Semantic Similarity in a Taxonomy: An Information-Based Measure', 'USA', 'U Maryland', 'Information-based semantic similarity in WordNet taxonomy; most informative subsumer', 'probabilistic taxonomy', 'EN', 'https://www.cs.cmu.edu/afs/cs/project/jair/pub/volume11/resnik99a.pdf', 1999, 'semantic-similarity,wordnet,information-content'),
  ('EN.MONTEMURRO', 'EN', 'Towards the Quantification of Semantic Information in Written Language', 'UK', 'U Manchester', 'Word-level information contribution via mutual information; characteristic scale ~5000 words', 'information theory + corpus', 'EN', 'https://doi.org/10.1142/s0219525910002530', 2010, 'semantic-information,word-level,corpus'),
  ('EN.ISAAC', 'EN', 'The Semantics Latent in Shannon Information', 'UK', 'U Edinburgh', 's-vector semantics; log-probability ratio as content; Turlings parallel development', 'formal semantics + info theory', 'EN', 'https://doi.org/10.1093/bjps/axx029', 2019, 'shannon-information,semantics,s-vector'),
  ('EN.FUTRELL', 'EN', 'Information Theory as a Bridge Between Language Function and Form', 'USA', 'UC Irvine / Stanford', 'Information theory as bridge; constrained optimization formalism for language universals', 'computational linguistics', 'EN', 'https://doi.org/10.3389/fcomm.2022.657725', 2022, 'information-theory,language-universals,optimization'),
  ('EN.AMIGO', 'EN', 'Information Theory-based Compositional Distributional Semantics', 'Spain', 'UNED / U Barcelona', 'ICDS: formal properties for embedding, composition, similarity based on Shannon', 'computational linguistics', 'EN', 'https://doi.org/10.1162/coli_a_00454', 2022, 'icds,distributional-semantics,composition'),
  -- Germanic
  ('DE.MAYERTHALER', 'DE', 'Natürlichkeitstheorie / Markiertheitstheorie', 'Germany', 'U Passau', 'sem< values for grammatical categories; konstruktioneller Ikonismus; Natürlichkeit', 'typological linguistics', 'DE', null, 1981, 'markedness,naturalness,iconicity'),
  ('DE.KRIFKA', 'DE', 'Informationsstruktur: Prosodische, syntaktische, semantische Aspekte', 'Germany', 'HU Berlin', 'Topic/comment, given/new, focus; universal force field in information structure', 'pragmatics + syntax', 'DE', 'https://amor.cms.hu-berlin.de/~h2816i3x/Lehre/2004_VL_InfoStruktur/', 2004, 'information-structure,topic,focus'),
  ('DE.RIEGER', 'DE', 'Bedeutungskonstitution und semantische Granulation', 'Germany', 'U Trier', 'Fuzzy semantic space; vector-based meaning representation; granular organization', 'computational semantics', 'DE', 'https://www.uni-trier.de/fileadmin/fb2/LDV/Rieger/Publikationen/Aufsaetze/2002/landau00.pdf', 2002, 'semantic-granulation,fuzzy,vector-semantics'),
  ('DE.LITERARISCH', 'DE', 'Literarische Information und die Messbarkeit von Literarizität', 'Germany', 'LMU Munich', 'Shannon entropy applied to literary text features; Literarizität quantification', 'computational literary studies', 'DE', 'https://epub.ub.uni-muenchen.de/69738/', null, 'literariness,shannon,entropy'),
  -- Romance FR
  ('FR.MANDELBROT', 'FR', 'Théorie de l''information et statistique linguistique', 'France', 'CNRS', 'Zipf-derived cost minimization; rank-frequency relation; phoneme/letter distributions', 'mathematical linguistics', 'FR', 'https://www.persee.fr/doc/barb_0001-4141_1956_num_42_1_68367', 1956, 'zipf,mandelbrot,cost-minimization'),
  ('FR.RYCKMAN', 'FR', 'De la structure d''une langue aux structures de l''information', 'France/USA', 'Northwestern', 'Harris regularization; language as information system; sublanguages', 'formal linguistics', 'FR', 'https://www.persee.fr/doc/lgge_0458-726x_1990_num_25_99_1590', 1990, 'harris,regularization,information-structure'),
  ('FR.FSP', 'FR', 'Hiérarchie et dépendance au niveau informationnel: FSP', 'France', 'CNRS / Prague', 'Functional Sentence Perspective; degrees of communicative dynamism; theme/rheme hierarchy', 'functional linguistics', 'FR', 'https://www.persee.fr/doc/igram_0222-9838_1991_num_50_1_3254', 1991, 'fsp,communicative-dynamism,theme'),
  ('FR.STRUCTURAL', 'FR', 'Analyse distributionnelle des significations et champs sémantiques', 'France', 'CNRS', 'Champs sémantiques; sème/sémème analysis; structural semantics methodology', 'structural semantics', 'FR', 'https://www.persee.fr/doc/lgge_0458-726x_1966_num_1_1_2865', 1966, 'semantic-field,structural-semantics,seme'),
  -- Romance ES
  ('ES.VERCHER', 'ES', 'Los índices de relatividad, densidad y eficiencia informativa en las lenguas', 'Spain', 'U Alicante', 'Indices of relativity/density/efficiency in 459 languages; morphological typology correlation', 'quantitative linguistics', 'ES/EN', 'https://doi.org/10.14198/ELUA.18583', 2022, 'efficiency,indices,typology'),
  ('ES.FUNCIONES', 'ES', 'Información y funciones informativas', 'Spain', 'U León', 'Tema/rema, foco, presuposición; jerarquía funcional; información como actividad semiológica', 'functional syntax', 'ES', 'https://www.gruposincom.es/salvadorgutierrez/', null, 'functional-sentence,theme,focus'),
  ('ES.MATRIX', 'ES', 'Matrix Syntax', 'Spain', 'U Complutense / U Sevilla', 'Quantum-inspired syntactic model; Chomsky matrices; Pauli matrices; superpositions', 'mathematical linguistics', 'ES', 'http://revista.sel.edu.es/index.php/revista/article/download/2065/1282/802', 2024, 'matrix-syntax,quantum,chomsky'),
  -- Sinosphere
  ('CN.NIUZHANG', 'CN', 'A mathematical theory of semantic communication', 'China', 'BUPT', 'Synonymity mapping; semantic entropy; semantic channel capacity; semantic rate-distortion', 'information theory', 'ZH', 'https://doi.org/10.11959/j.issn.1000-436x.2024111', 2024, 'semantic-communication,synonymity,entropy'),
  ('CN.GAOZHOU', 'CN', 'Semantic density, syntactic complexity and disciplinary knowledge coding', 'China', 'PKU', 'Semantic density vs syntactic complexity; knowledge coding across academic levels', 'corpus linguistics', 'ZH/EN', 'https://www.qk.sjtu.edu.cn/cfls/EN/10.3969/j.issn.1674-8921.2022.06.008', 2022, 'semantic-density,syntactic-complexity,knowledge-coding'),
  ('CN.UEP', 'CN', 'Semantic importance UEP data transmission', 'China', 'ZTE', 'Semantic importance classification for unequal error protection in wireless communication', 'engineering', 'ZH', 'https://www.zte.com.cn/content/dam/zte-site/res-www-zte-com-cn/mediares/magazine/', 2023, 'uep,semantic-importance,6g'),
  ('CN.LLMCOMPRESS', 'CN', 'Semantic relations in LLMs: an information-theoretic compression approach', 'China/Canada', 'Multiple', 'Pythia models as semantic compressors; WordNet-based compression advantage metric', 'NLP', 'EN/ZH', 'https://aclanthology.cn/2024.neusymbridge-1.2/', 2024, 'llm,compression,semantic-relations'),
  -- Slavic
  ('RU.SHREIDER', 'RU', 'Thesaurus measure of semantic information', 'Russia', 'IPPI RAS', 'Тезаурусная мера; semantic information as function of users prior knowledge', 'information theory', 'RU', null, 1960, 'thesaurus,semantic-measure,cybernetics'),
  ('RU.BSTU', 'RU', 'Quantitative scale models of semantic information', 'Russia', 'Bryansk State Tech U', 'Semantic information environment; accumulation rate; semantic energy; capacity', 'computational modeling', 'RU', 'https://bstu.editorum.ru/ru/nauka/article/37788/view', 2020, 'semantic-information,modeling,quantitative'),
  ('RU.BOGUSLAVSKY', 'RU', 'Semantic analysis based on inference in a functional language model', 'Russia/Spain', 'IPPI RAS / UPM', 'SemETAP: inference-based semantic analysis; ontology; implication and implicature', 'computational linguistics', 'RU', 'https://vja.ruslang.ru/sites/default/files/articles/2021/1/2021-1_29-56.pdf', 2021, 'semantic-analysis,inference,ontological-semantics'),
  ('RU.MELCHUK', 'RU', 'Meaning-Text theory', 'Russia/Canada', 'IPPI RAS / U Montreal', 'Integral linguistic model; lexical functions; semantic representation via deep-syntactic structure', 'formal linguistics', 'RU/FR', null, 1974, 'meaning-text,lexical-function,deep-syntax');

-- Researchers
INSERT INTO researchers (id, name, region_id, institution, specialisation) VALUES
  ('R.CARNAP', 'Rudolf Carnap', 'EN', 'UCLA', 'Logical semantics, probability, semantic information'),
  ('R.FLORIDI', 'Luciano Floridi', 'EN', 'Oxford', 'Philosophy of information, veridicality thesis'),
  ('R.ISAAC', 'Alistair Isaac', 'EN', 'U Edinburgh', 's-vector semantics, natural meaning'),
  ('R.FUTRELL', 'Richard Futrell', 'EN', 'UC Irvine', 'Information-theoretic linguistics, language complexity'),
  ('R.RESNIK', 'Philip Resnik', 'EN', 'U Maryland', 'Information-based semantic similarity'),
  ('R.MONTEMURRO', 'Marcelo Montemurro', 'EN', 'U Manchester', 'Word-level semantic information'),
  ('R.MAYERTHALER', 'Willi Mayerthaler', 'DE', 'U Passau', 'Naturalness theory, semantic markedness'),
  ('R.KRIFKA', 'Manfred Krifka', 'DE', 'HU Berlin', 'Information structure, focus, topic'),
  ('R.RIEGER', 'Burghard Rieger', 'DE', 'U Trier', 'Fuzzy semantics, semantic granulation'),
  ('R.MANDELBROT', 'Benoît Mandelbrot', 'FR', 'CNRS / IBM', 'Zipf/Mandelbrot cost optimization, fractal geometry'),
  ('R.HARRIS', 'Zellig Harris', 'FR', 'U Pennsylvania', 'Information in grammar, transformations'),
  ('R.FIRBAS', 'Jan Firbas', 'FR', 'Charles U / Prague', 'Communicative dynamism, FSP'),
  ('R.AMIGO', 'Enrique Amigó', 'ES', 'UNED', 'ICDS, information-theoretic semantics'),
  ('R.GUTIERREZ', 'Salvador Gutiérrez Ordóñez', 'ES', 'U León', 'Funciones informativas, functional syntax'),
  ('R.VERCHER', 'E.J. Vercher García', 'ES', 'U Alicante', 'Informative efficiency indices'),
  ('R.NIU', 'Niu Kai', 'CN', 'BUPT', 'Semantic communication, synonymity mapping'),
  ('R.ZHANG', 'Zhang Ping', 'CN', 'BUPT', 'Semantic communication, 6G, semantic entropy'),
  ('R.GAO', 'Gao Yanmei', 'CN', 'PKU', 'Semantic density, disciplinary discourse'),
  ('R.SHREIDER', 'Yuliy Shreider', 'RU', 'IPPI RAS', 'Thesaurus measure, semantic information'),
  ('R.BOGUSLAVSKY', 'Igor Boguslavsky', 'RU', 'IPPI RAS / UPM', 'SemETAP, inference-based semantics'),
  ('R.MELCHUK', 'Igor Melchuk', 'RU', 'U Montreal', 'Meaning-Text theory, lexical functions');

-- Gaps
INSERT INTO gaps (id, description, regions) VALUES
  ('G.NOUNIFY', 'No unified formalization of semantic weight across regions', 'ALL'),
  ('G.NOMETA', 'No meta-analysis of semantic weight as a distinct measurable concept', 'ALL'),
  ('G.LOGDIST', 'No bridge between logical probability (Carnap) and distributional (Harris) approaches', 'EN↔FR'),
  ('G.ENGGAP', 'Chinese 6G/engineering semantic weight (UEP) not cited by non-Chinese linguistic frameworks', 'CN↔OTHER'),
  ('G.THESAURUS', 'Shreider thesaurus measure abandoned outside Russian-language literature since 1990s', 'RU↔OTHER'),
  ('G.MARKEDNESS', 'Mayerthaler sem< values remain qualitative; no link to Shannon information', 'DE'),
  ('G.ICDSISOLATED', 'ICDS published in English but not integrated with regional semantic traditions', 'ES'),
  ('G.NOVALIDATION', 'None of the proposed measures validated against human judgments of semantic weight', 'ALL');

-- Round 2 sources (semantic salience/prominence)
INSERT INTO sources (id, region_id, title, country, institution, key_content, methodology, language, year, tags) VALUES
  -- Anglophone
  ('EN.FILLMORE', 'EN', 'The case for case / Thematic hierarchy', 'USA', 'UC Berkeley', 'Semantic roles as deep cases; thematic hierarchy governing subject/object selection', 'formal linguistics', 'EN', 1968, 'thematic-hierarchy,semantic-roles,case-grammar'),
  ('EN.DOWTY', 'EN', 'Thematic proto-roles and argument selection', 'USA', 'Ohio State', 'Proto-Agent/Patient entailments; salience hierarchy derived from event properties', 'formal semantics', 'EN', 1991, 'proto-roles,salience,argument-realization'),
  ('EN.TALMY', 'EN', 'The Attention System of Language', 'USA', 'SUNY Buffalo', 'Attention as a schematic system; 10 categories of attentional factors; Figure/Ground', 'cognitive semantics', 'EN', 2007, 'attention,salience,figure-ground,foregrounding'),
  ('EN.ROSE', 'EN', 'Syntactic and semantic prominence in discourse referents', 'USA', 'Northwestern', 'Both syntactic and semantic prominence contribute to salience of discourse referents', 'experimental', 'EN', 2005, 'salience,prominence,discourse-referent'),
  -- Germanic
  ('DE.SFB1252', 'DE', 'SFB 1252 Prominence in Language', 'Germany', 'U Cologne', 'Largest prominence research program: 3 fields, 40+ projects; prominence as relational, attractor-based, dynamic', 'interdisciplinary', 'DE/EN', 2016, 'prominence,sfb,attractor,discourse'),
  ('DE.KONUK', 'DE', 'Grammatische Funktion, semantische Rolle und Diskursprominenz (Türkisch)', 'Germany', 'U Cologne', 'Subjecthood + semantic role both influence discourse prominence; experimental evidence from Turkish psych-verbs', 'experimental', 'DE', 2021, 'discourse-prominence,grammatical-function,semantic-role'),
  ('DE.GUTZMANN', 'DE', 'At-issueness as propositional prominence', 'Germany', 'RU Bochum', 'At-issueness derived from propositional prominence; multiple prominence-lending cues', 'theoretical+experimental', 'DE', 2020, 'at-issueness,propositional-prominence,cues'),
  ('DE.HEIDELBERG', 'DE', 'Salienz in der Satzproduktion (visuelle/semantische/kontextuelle)', 'Germany', 'U Heidelberg', 'Sentence production prioritization: contextual > semantic > visual salience in German', 'eye-tracking', 'DE', 2019, 'salience,sentence-production,pragmatic-processing'),
  -- Romance FR
  ('FR.LANDRAGIN', 'FR', 'Saillance (Sémanticlopédie)', 'France', 'CNRS / LLF Paris', '6 types of saillance: intrinsic, explicit, syntactic, grammatical, prosodic, indirect; physical vs cognitive', 'encyclopedic synthesis', 'FR', 2004, 'saillance,typology,physical,cognitive'),
  ('FR.FOCALISATION', 'FR', 'La focalisation', 'France', 'CNRS / LLF', 'Focalisation as rhématisation; assertion on identification, not predication; contrast vs topicalisation', 'formal linguistics', 'FR', 1998, 'focalisation,rhematisation,contrast'),
  ('FR.PERTINENCE', 'FR', 'Pertinence, focalisation, thématisation', 'France', 'CNRS / U Paris', 'Relevance as significance-for-utterer; focalization as making relevant for co-utterer', 'enunciative linguistics', 'FR', 2001, 'pertinence,focalisation,thematisation'),
  -- Romance ES
  ('ES.RAE_FOCO', 'ES', 'RAE Glosario: Foco informativo/contrastivo', 'Spain', 'RAE / ASALE', 'Foco as segment with special prominence; informativo vs contrastivo; prosodic marking; focus adverbs', 'standard reference', 'ES', 2010, 'foco,rae,informational-structure'),
  ('ES.ZUBIZARRETA', 'ES', 'Prominence preserving mapping', 'Spain/USA', 'USC', 'Thematic hierarchy as prominence-preserving mapping from semantics to syntax', 'formal syntax', 'ES/EN', 1999, 'prominence-preservation,thematic-hierarchy,syntax-semantics'),
  ('ES.PROSODIAFOCO', 'ES', 'Prosodia y foco en español de Buenos Aires', 'Argentina', 'U Buenos Aires', 'Perception of prosodic prominence for focus; 540 sentences analyzed; focus-prosody correlation', 'experimental', 'ES', 2016, 'prosodic-prominence,foco,perception'),
  -- Sinosphere
  ('CN.DEFAULT_SEM', 'CN', 'Default Semantics: 凸显义与缺省义', 'China', 'Multiple / cited by Xinyang Normal', 'Discourse coherence via default semantics; 凸显义 vs 缺省义; intention hierarchy + figure/ground', 'theoretical', 'ZH', 2019, 'default-semantics,prominence,salience,discourse'),
  ('CN.COGNITIVE_SEM', 'CN', 'Cognitive semantics: 凸显概念角色 (prominent conceptual roles)', 'China', 'Multiple (citing Langacker, Talmy)', 'Cognitive semantics figure/ground; 射体/陆标, 凸体/衬体; steal/rob asymmetry explained by prominence', 'cognitive semantics', 'ZH', 2010, 'cognitive-semantics,prominence,figure-ground'),
  ('CN.SIGNIFICANCE', 'CN', 'Significance and locality as universal linguistic principles', 'China', 'CASS', '显著性 (prominence) vs 局部性 (locality) as universal cognitive-grammatical principles; prominence central for Chinese grammar', 'theoretical+typological', 'ZH', 2025, 'significance,locality,universals,prominence'),
  -- Slavic
  ('RU.GALPERIN', 'RU', 'Information/informativity and information structure of text', 'Russia', 'MSU', 'Информативность as gradient: absolute vs relative; key units with концептуальность/предикативность', 'text linguistics', 'RU', 1980, 'informativity,text-structure,key-units'),
  ('RU.VYDELENNOST', 'RU', 'Интонационная категория выделенности', 'Russia', 'Russian universities', 'Выделенность (prominence) as intonational category; predicts hierarchy of predicates controls prosodic weight', 'experimental+theoretical', 'RU', 2017, 'vydelennost,prominence,intonation,predicate-hierarchy'),
  ('RU.BONDARKO', 'RU', 'Functional-semantic field theory (функционально-семантическое поле)', 'Russia', 'IPPI RAS / SPbU', 'Fields with center/periphery structure; polycentric vs monocentric; semantic invariant + formal means', 'functional grammar', 'RU', 1984, 'functional-semantic-field,center-periphery,semantic-category'),
  ('RU.MAXIMOV', 'RU', 'Defining semantic information through meaning and goal projection', 'Russia', 'ITMO', 'Semantic information = information in context of meaning/goal; projection of sign systems onto aspect ontology', 'computational', 'RU', 2022, 'semantic-information,goal,ontology');

-- Round 2 researchers
INSERT INTO researchers (id, name, region_id, institution, specialisation) VALUES
  ('R.FILLMORE', 'Charles Fillmore', 'EN', 'UC Berkeley', 'Case grammar, semantic roles, frame semantics'),
  ('R.DOWTY', 'David Dowty', 'EN', 'Ohio State', 'Proto-roles, argument selection, thematic hierarchy'),
  ('R.TALMY', 'Leonard Talmy', 'EN', 'SUNY Buffalo', 'Cognitive semantics, attention system, force dynamics'),
  ('R.LEVIN', 'Beth Levin', 'EN', 'Stanford', 'Argument realization, thematic hierarchy, verb classes'),
  ('R.VONHEUSINGER', 'Klaus von Heusinger', 'DE', 'U Cologne', 'Prominence, discourse structure, anaphora'),
  ('R.GUTZMANN_D', 'Daniel Gutzmann', 'DE', 'RU Bochum', 'At-issueness, propositional prominence, expressives'),
  ('R.LANDRAGIN', 'Frédéric Landragin', 'FR', 'CNRS / LLF Paris', 'Saillance, anaphora, discourse structure'),
  ('R.GUTIERREZ_R', 'Rodrigo Gutiérrez-Bravo', 'ES', 'U Mexico City', 'Prosody-focus interface, Mexican Spanish'),
  ('R.ZUBIZARRETA', 'Maria Luisa Zubizarreta', 'ES', 'USC', 'Focus, prosody, prominence preservation'),
  ('R.BONDARKO', 'Alexander Bondarko', 'RU', 'IPPI RAS / SPbU', 'Functional-semantic field theory, Russian grammar'),
  ('R.GALPERIN', 'Ilya Galperin', 'RU', 'MSU', 'Text linguistics, informativity, stylistics');
