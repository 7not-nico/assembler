**Semantic weight** lacks a unified cross-regional theory. Six language regions produce related but non-converging frameworks: Anglophone (semantic information theory, s-vector semantics, ICDS), Germanic (Markiertheitstheorie, Informationsstruktur, semantische Granulation), Romance-FR (Mandelbrot cost-minimization, FSP communicative dynamism, pertinence theory), Romance-ES (ICDS, índices informativos, Matrix Syntax), Sinosphere (同义映射/synonymity mapping, semantic density, semantic communication), Slavic (тезаурусная мера/thesaurus measure, SemETAP inference-based semantics). The closest to a direct operationalization of "semantic weight" as a measurable quantity comes from Shreider's thesaurus measure, Montemurro & Zanette's word-level information contribution, and the Chinese semantic importance UEP framework — but none cross-reference each other.

Pattern: each region derives semantic weight from its own tradition — Anglophone/logical-probability, German/Natürlichkeit, Romance/structural-distributional, Chinese/engineering-optimization, Russian/cybernetics. No bridge between them.

Implication: semantic weight as a concept is implicitly present across all six but explicitly formalized with incompatible toolkits. A unified measure would need to reconcile logical probability (Carnap), thesaurus overlap (Shreider), communicative dynamism (Prague), and synonymity entropy (Niu/Zhang).

Data: schemas/seed.sql — 30 sources, 0 meta-analyses, 20+ researchers, 0 gaps.

---
id: MANIFEST.SEMANTIC-WEIGHT-META-AUDIT
title: Semantic Weight — Global Research Index
summary: 30+ sources, 6 language regions, 0 meta-analyses, 20+ researchers; semantic weight is implicitly present across all six regions but formalized with incompatible toolkits
tags: [semantic-weight, semantic-information, cross-region, research-index, linguistics]
tables: [per-region-summary, fundamentals, regions, meta-analyses, gaps, key-researchers]
---

## Per-Region Summary

| Region | Status | Sources | Key Finding |
|--------|--------|---------|-------------|
| Anglophone | PASS | 7 | Carnap/Bar-Hillel logical probability, Floridi veridicality, G theory, s-vector semantics, ICDS, Resnik information-based similarity |
| Germanic | PASS | 5 | Markiertheitstheorie (Mayerthaler), Informationsstruktur (Krifka), semantische Granulation (Rieger), literarische Information, WordNet |
| Romance-FR | PASS | 6 | Mandelbrot cost-minimization/Zipf, Harris regularization, FSP communicative dynamism, sémantique structurale, pertinence theory |
| Romance-ES | PASS | 5 | ICDS Spanish adaptation, funciones informativas, índices relatividad/densidad/eficiencia, Matrix Syntax, semántica formal |
| Sinosphere | PASS | 4 | Synonymity mapping/semantic entropy (Niu/Zhang), semantic density (Gao/Zhou), semantic importance UEP, LLM compression |
| Slavic | PASS | 3 | Thesaurus measure (Shreider), SemETAP (Boguslavsky), semantic information modeling (BSTU) |

## Fundamentals

| Concept | Source | Key Idea |
|---------|--------|----------|
| Inverse Relationship Principle | Carnap/Bar-Hillel (1952) | Semantic information of a proposition inversely proportional to its logical probability |
| Veridicality thesis | Floridi (2004-2005) | Semantic information must be true; truthlikeness determines information yield |
| s-vector semantics | Isaac (2019) | Shannon information intrinsically contains semantics via log-probability ratio vectors |
| G theory | Chen (2025) | Replace distortion constraint with semantic constraint; semantic channel of truth functions |
| ICDS | Amigó et al. (2022) | Information-theoretic composition + distributional semantics; embedding norm ~ information content |
| Semantic markedness | Mayerthaler (1981) | sem< (sprecher, nicht-sprecher); sem< (nicht-komplex, komplex); iconicity principle |
| Communicative dynamism | Firbas / Prague School | Degrees of CD determined by context-dependence; hierarchy of thematicity |
| Thesaurus measure | Shreider (1960s) | Semantic information = function of user thesaurus; maximum when understood + novel |
| Synonymity mapping | Niu/Zhang (2024) | Semantic entropy H_s = functional of source distribution and synonymity mapping; one-to-many |
| Semantic density | Gao/Zhou (2022) | Knowledge condensation degree; correlates with syntactic complexity in academic writing |
| Cost-minimization | Mandelbrot/Zipf | Word frequency decays exponentially with cost; optimization of information per unit cost |
| Informative efficiency | Vercher/Bullejos (2022) | Índices of relativity, density, efficiency across 459 languages; correlates with morphological type |

## Regions

### Anglophone

| Source | Country | Institution | Key Content | Methodology | Language |
|--------|---------|-------------|-------------|-------------|----------|
| Carnap/Bar-Hillel (1952) | USA | U Chicago / Hebrew U | Classical semantic information; cont() and inf() measures based on logical probability | Logical formalism | EN |
| Floridi (2004-2005) | UK | Oxford | Strongly semantic information; veridicality thesis; truthlikeness quantification | Philosophical analysis | EN |
| Resnik (1999) | USA | U Maryland | Information-based semantic similarity in WordNet taxonomy; most informative subsumer | Probabilistic taxonomy | EN |
| Montemurro & Zanette (2010) | UK/ARG | U Manchester | Word-level information contribution via mutual information; characteristic scale ~5000 words | Information theory + corpus | EN |
| Isaac (2019) | UK | U Edinburgh | s-vector semantics; log-probability ratio as content; Turing's parallel development of information theory | Formal semantics + info theory | EN |
| Futrell & Hahn (2022) | USA | UC Irvine / Stanford | Information theory as bridge between language function and form; constrained optimization | Computational linguistics | EN |
| Chen (2025) | USA/CN | Multiple | G theory; semantic channel of truth functions; replaces distortion with semantic constraint | Information theory | EN |
| Amigó et al. (2022) | Spain/Italy | UNED / U Barcelona | ICDS: formal properties for embedding, composition, similarity based on Shannon | Computational linguistics | EN |

### Germanic

| Source | Country | Institution | Key Content | Methodology | Language |
|--------|---------|-------------|-------------|-------------|----------|
| Mayerthaler (1981) | Germany | U Passau | Natürlichkeitstheorie: sem< values for grammatical categories; konstruktioneller Ikonismus | Typological linguistics | DE |
| Krifka (2004) | Germany | HU Berlin | Informationsstruktur: topic/comment, given/new, focus; universal force field | Pragmatics + syntax | DE |
| Rieger (2002) | Germany | U Trier | Semantische Granulation; fuzzy semantic space; vector-based meaning representation | Computational semantics | DE |
| Roth / CIS | Switzerland | U Zurich | Lexikalisch-semantische Netze; WordNet; semantic relations | Lexical semantics | DE |
| Literarische Information | Germany | LMU Munich | Shannon entropy applied to literary text features; Literarizität quantification | Computational literary studies | DE |

### Romance — French

| Source | Country | Institution | Key Content | Methodology | Language |
|--------|---------|-------------|-------------|-------------|----------|
| Mandelbrot (1956) | France | CNRS | Théorie de l'information et statistique linguistique; Zipf-derived cost minimization | Mathematical linguistics | FR |
| Ryckman/Harris (1990) | France/USA | Northwestern | Regularization of linguistic description; information structure in sublanguages | Formal linguistics | FR |
| Firbas / Prague School | Czech/France | Charles U / CNRS | Functional Sentence Perspective; degrees of communicative dynamism | Functional linguistics | FR |
| Pottier / Structural semantics | France | CNRS | Champs sémantiques; sème/sémème analysis; archisémème | Structural semantics | FR |
| Sperber & Wilson (1986) | France/UK | CNRS / UCL | Pertinence theory; contextual implications; cognitive efficiency | Pragmatics | FR/EN |
| Rastier / Sémantique interprétative | France | CNRS | Interpretative semantics; semantic isotopies; difference between denotation/connotation | Interpretative semantics | FR |

### Romance — Spanish

| Source | Country | Institution | Key Content | Methodology | Language |
|--------|---------|-------------|-------------|-------------|----------|
| Amigó et al. (2022) ICDS | Spain | UNED / U Barcelona | ICDS formalizado; embedding, composición, similitud basados en teoría de la información | Computational linguistics | ES/EN |
| Gutiérrez Ordóñez / Funciones informativas | Spain | U León | Tema/rema, foco, presuposición; jerarquía funcional; información como actividad semiológica | Functional syntax | ES |
| Vercher & Bullejos (2022) | Spain | U Alicante | Índices de relatividad/densidad/eficiencia informativa en 459 lenguas; correlación con tipología morfológica | Quantitative linguistics | ES/EN |
| Matrix Syntax (2024) | Spain | U Complutense / U Sevilla | Quantum-inspired syntactic model; Chomsky matrices; linguistic chains as superpositions | Mathematical linguistics | ES |
| Formal semantics tradition | Spain | UDC / multiple | Montague-style compositional semantics; función interpretativa; saturación de tipos semánticos | Formal semantics | ES |

### Sinosphere

| Source | Country | Institution | Key Content | Methodology | Language |
|--------|---------|-------------|-------------|-------------|----------|
| Niu & Zhang (2024) | China | BUPT | Synonymity mapping; semantic entropy; semantic channel capacity; semantic rate-distortion | Information theory | ZH |
| Gao & Zhou (2022) | China | PKU | Semantic density vs syntactic complexity; knowledge coding across academic levels | Corpus linguistics | ZH |
| Semantic importance UEP (2023) | China | ZTE / multiple | Semantic importance classification for unequal error protection in wireless communication | Engineering | ZH |
| LLM semantic compression (2024) | China/Canada | Multiple | Pythia models as semantic compressors; WordNet-based compression advantage metric | NLP | EN/ZH |
| Semantic knowledge base (2023) | China | PCL | 面向语义通信的语义知识库; structured semantic knowledge representation for 6G | Engineering | ZH |

### Slavic

| Source | Country | Institution | Key Content | Methodology | Language |
|--------|---------|-------------|-------------|-------------|----------|
| Shreider (1960s) | Russia | IPPI RAS | Тезаурусная мера семантической информации; semantic information = function of user's thesaurus | Information theory | RU |
| BSTU model (2020) | Russia | Bryansk State Tech U | Quantitative model of semantic information; semantic information environment; accumulation rate | Computational modeling | RU |
| Boguslavsky (2021) | Russia/Spain | IPPI RAS / UPM | SemETAP: inference-based semantic analysis; ontology-based semantic representation | Computational linguistics | RU |
| Melchuk / Meaning-Text | Russia/Canada | IPPI RAS / U Montreal | Integral linguistic model; semantic representation via lexical functions | Formal linguistics | RU/FR |
| Demyankov / Prototype theory | Russia | IPPI RAS | Prototype theory in semantics and pragmatics; semantic weights as gradient membership | Cognitive semantics | RU |

## Meta-Analyses

No dedicated meta-analyses found across any region — semantic weight is addressed implicity within larger frameworks, never as a standalone object of systematic review.

## Gaps

| Gap | Region(s) | Description |
|-----|-----------|-------------|
| No unified formalization | ALL | Each region defines semantic weight from its own tradition; no cross-regional synthesis exists |
| No meta-analysis | ALL | No systematic review of semantic weight as a distinct measurable concept |
| No bridge between logical and distributional | Anglophone ↔ Romance | Carnap logical probability and Harris distributional approach never reconciled |
| Engineering-semantics gap | Sinosphere ↔ Others | Chinese 6G/engineering semantic weight (UEP) never cited by non-Chinese linguistic frameworks |
| Thesaurus measure abandoned | Slavic | Shreider's thesaurus measure not referenced outside Russian-language literature since 1990s |
| Markedness not quantified | Germanic | Mayerthaler's sem< values remain qualitative; no link to Shannon information |
| ICDS isolated | Romance | ICDS published in English but not integrated with regional semantic traditions |
| No experimental validation | ALL | None of the proposed measures has been validated against human judgments of semantic weight |

## Key Researchers by Region

| Region | Researcher | Institution | Specialisation |
|--------|------------|-------------|----------------|
| Anglophone | Rudolf Carnap | UCLA | Logical semantics, probability |
| Anglophone | Luciano Floridi | Oxford | Philosophy of information |
| Anglophone | Alistair Isaac | U Edinburgh | s-vector semantics |
| Anglophone | Richard Futrell | UC Irvine | Information-theoretic linguistics |
| Anglophone | Philip Resnik | U Maryland | Information-based similarity |
| Anglophone | Marcelo Montemurro | U Manchester | Word-level semantic information |
| Germanic | Willi Mayerthaler | U Passau | Naturalness theory, markedness |
| Germanic | Manfred Krifka | HU Berlin | Information structure |
| Germanic | Burghard Rieger | U Trier | Fuzzy semantics, granulation |
| Romance-FR | Benoît Mandelbrot | CNRS / IBM | Zipf/Mandelbrot cost optimization |
| Romance-FR | Zellig Harris | U Pennsylvania | Information in grammar |
| Romance-FR | Jan Firbas | Charles U / Prague | Communicative dynamism |
| Romance-ES | Enrique Amigó | UNED | ICDS framework |
| Romance-ES | Salvador Gutiérrez Ordóñez | U León | Funciones informativas |
| Romance-ES | E.J. Vercher García | U Alicante | Informative efficiency indices |
| Sinosphere | Niu Kai / Zhang Ping | BUPT | Semantic communication math theory |
| Sinosphere | Gao Yanmei | PKU | Semantic density |
| Slavic | Yuliy Shreider | IPPI RAS | Thesaurus measure |
| Slavic | Igor Boguslavsky | IPPI RAS / UPM | SemETAP |
| Slavic | Igor Melchuk | U Montreal | Meaning-Text theory |

---

## Round 2 Comparison — Semantic Salience/Prominence (vs Weight)

The first round ("semantic weight") targeted *quantitative* frameworks for measuring meaning content. The second round ("semantic salience/prominence") targets *attentional/discourse* frameworks. The two rounds reveal a consistent cross-regional divergence:

### Cross-Region Comparison: Weight vs Salience

| Region | Round 1 — Semantic Weight | Round 2 — Semantic Salience |
|--------|--------------------------|------------------------------|
| **Anglophone** | Carnap/Bar-Hillel logical probability, s-vector semantics, G theory, ICDS | Fillmore thematic hierarchy, Dowty proto-roles, Talmy attention system, Centering Theory, choice functions |
| **Germanic** | Mayerthaler Markiertheit (sem<), semantische Granulation | SFB 1252 Prominence in Language (entire CRC), Krifka Centering, Diskursprominenz, At-issueness as propositional prominence |
| **Romance-FR** | Mandelbrot cost-minimization, FSP | Saillance (Sémanticlopédie), focalisation informationnelle, pertinence (Sperber/Wilson), structure informationnelle |
| **Romance-ES** | ICDS, índices informativos (relatividad/densidad/eficiencia) | Foco informativo/contrastivo (RAE), prominencia prosódica, focalización, Zubizarreta prominence preservation |
| **Sinosphere** | Synonymity mapping (同义映射), semantic entropy, UEP | Default Semantics (凸显义 vs 缺省义), figure/ground cognitive semantics, significance (显著性) as universal cognitive principle |
| **Slavic** | Shreider thesaurus measure, SemETAP | выделенность (Galperin), интонационная выделенность, функционально-семантическое поле (Bondarko), информативность |

### Key Differences

| Dimension | Semantic Weight | Semantic Salience/Prominence |
|-----------|-----------------|------------------------------|
| Core question | How much meaning? | What is attended to? |
| Intellectual ancestor | Shannon/Carnap | Prague School/Gestalt psychology |
| Unit of analysis | Propositions, words, signals | Discourse referents, arguments |
| Metric | Bits, logical probability, entropy | Ranking, hierarchy, activation level |
| Relation to grammar | Independent measure | Mapped to syntax (subject > object) |
| Institutional density | Distributed individuals | SFB 1252 (Cologne, 40+ projects) |
| Chinese framing | Engineering/communication | Cognitive/default semantics |
| Russian framing | Cybernetics/measurement | Intonation/text-structure |
| Shared gap | Neither validated against human judgments | Neither validated against human judgments |

### What Each Region's Salience Tradition Does That Weight Doesn't

| Region | Distinctive contribution to salience |
|--------|--------------------------------------|
| **Anglophone** | Thematic Hierarchy as prominence preservation mapping; formal link between semantics and syntax |
| **Germanic** | CRC-scale institutionalized research: 3 fields (prosody, morphosyntax/semantics, discourse); prominence as dynamic, relational, attractor-based |
| **Romance-FR** | Saillance as integrated physical+cognitive; focalisation/predication dissociation; 6 types of saillance (Landragin) |
| **Romance-ES** | RAE codification of foco; prosodic prominence as primary focus marker; politeness-attention interaction |
| **Sinosphere** | Significance/凸显 as universal cognitive principle governing grammar; 局部性与显著性 interaction as cross-linguistic typology |
| **Slavic** | Выделенность as intonational category + text-structure principle; информативность as gradient (absolute vs relative); functional-semantic field theory (Bondarko) |

---

## Round 3 — Topic vs Focus (Information Structure)

Third round targets the core IS dichotomy topic/focus — the most institutionalized of the three angles so far.

### Cross-Region Comparison: Topic vs Focus

| Region | Core Framework | Distinctive Contribution | Institutional Density |
|--------|---------------|--------------------------|-----------------------|
| **Anglophone** | Lambrecht (3-way focus: predicate/argument/sentence), Rooth alternatives, Krifka structured meanings, Jackendoff F-marking, Gundel givenness hierarchy, contrastive topic | Question Under Discussion (QUD) model; F-marking projection rules; alternative semantics | Distributed — no dedicated CRC but extensive monograph tradition (Lambrecht 1994, Rooth 1992, Krifka 2007) |
| **Germanic** | Krifka IS (topic-comment + focus-background + given-new as 3 separate dimensions), Jacobs FHG, topological field model (Vorfeld=topic), Dimroth focus particles | SFB 632 "Informationsstruktur" (Berlin, 2003-2015) — cross-linguistic IS with standardized QUIS questionnaire; VERUM-focus (Höhle); FHG relational vs categorical | **Highest in Round 3** — SFB 632 (16+ projects across HU Berlin, ZAS, FU Berlin); IDS Mannheim topological grammar; Krifka's 3-dimensional IS model |
| **Romance-FR** | Culioli TOE (Théorie des Opérations Enonciatives); focalisation = assertion dissociée de la prédication; topicalisation = ancrage énonciatif; pertinence = choix de l'énonciateur | African language data essential (Wolof emphatic conjugations, Hausa/Peul focus paradigms); exclusivity > contrast; 4 values of subject focus (identification, definition, explanation, exclamation) | The Sémanticlopédie wiki system; Persée archive of French linguistics; Langages journal tradition |
| **Romance-ES** | RAE canonical definitions (foco informativo vs contrastivo); Zubizarreta prominence preservation mapping; Gutierrez Ordóñez funciones informativas; cartographic left periphery (Top > Foc > T) | Prosodic focus marking as primary; foco as exclusive selection from paradigm; anteposición focalizadora | RAE/ASALE as normative center; Zubizarreta (USC) bridges Spanish/English; ELUA journal |
| **Sinosphere** | Li & Thompson topic-prominent typology; cartographic left periphery (TopP > FocP > TP); 8+ topic subtypes (left dislocation, Chinese-style, argument-splitting); Xu & Liu topic structure | **Topic-prominence as parametric**: Chinese topics need NO grammatical link to comment; richest topic typology of any region; 话题结构 (topic construction) as defining syntactic feature of Chinese | CASS linguistics; BISU cartographic research; Xuzhou Normal topic structure work; cross-fertilization with generative grammar |
| **Slavic** | Paducheva коммуникативная структура (aktualnoe chlenenie); linear-accent structure (ЛА-структура); topic > focus progressive; Zimmer formal IS; Bondarko functional-semantic field | Topic and focus as *shifter categories* (шифтерные категории); inversion of topic-focus order as expressive device; functional-semantic field periphery for IS marking | IPPI RAS (Paducheva); КемГУ Teleut fieldwork; Вопросы языкознания; strong integration with typology of Turkic/Uralic minority languages |

### Key Findings for Round 3

1. **The most institutionalized angle**: Topic/focus IS has the largest dedicated research programs (SFB 632 in DE, QUIS questionnaire across 60+ languages), unlike weight or salience.
2. **Chinese is unique**: Only region where topic-*prominence* is a parametric typological feature (Li & Thompson 1976). Topics can have no grammatical relation to the comment — impossible in all other regions' languages.
3. **French theory is distinctive**: Only region that defines focus as *dissociated assertion* (not new information vs given), grounded in Culioli's TOE and African language data.
4. **German theory is 3-dimensional**: Krifka's separation of topic-comment, focus-background, and given-new into independent dimensions is the most articulated IS model.
5. **Russian bridges syntax and prosody**: Paducheva's linear-accent structure as the *explanans* for communicative structure — word order + prosody as a unified system.
6. **Standardized methodology exists**: QUIS (Questionnaire on Information Structure) developed by SFB 632 enables cross-linguistically comparable IS research — the only angle of the three with this resource.
7. **Shared gap**: No region has fully formalized the relationship between topic and focus as quantifiable *weights* — IS remains categorical (topic vs focus) rather than scalar.

### What Each Region's Topic/Focus Tradition Adds

| Region | To the comparison |
|--------|------------------|
| **Anglophone** | QUD model connects IS to discourse coherence; alternative semantics formalizes focus as set of alternatives |
| **Germanic** | 3-dimensional IS model; topological field model linking syntax directly to IS; SFB 632 = largest collaborative IS research program |
| **Romance-FR** | TOE dissociates assertion from predication; African data enriches typology; pertinence as enunciative choice |
| **Romance-ES** | RAE codification; foco as exclusive selection; anteposición as syntactic focus strategy |
| **Sinosphere** | Topic-prominence as parametric; richest topic typology; topic as left-peripheral syntactic position, not pragmatic overlay |
| **Slavic** | Актуальное членение tradition from Prague via Russia; topic/focus as shifter categories; fieldwork on minority languages (Teleut, Mari) |

---

## Round 4 — Semantic Prosody & Lexical Priming

Fourth round targets evaluative meaning absorbed from collocational environments — the most applied/corpus-driven of the four angles.

### Cross-Region Comparison: Semantic Prosody & Lexical Priming

| Region | Core Framework | Key Figures | Methodology | Institutional Base |
|--------|---------------|-------------|-------------|-------------------|
| **Anglophone** | Sinclair idiom principle (4 extended units: collocation, colligation, semantic preference, semantic prosody); Louw "consistent aura of meaning"; Hoey lexical priming theory; Hauser & Schwarz experimental SP | Sinclair, Louw, Stubbs, Hoey, Partington, Xiao/McEnery, Hunston | Corpus-driven (KWIC concordance, log-likelihood, MI scores); experimental (valence rating, lexical decision) | Lancaster (UCREL), Birmingham, COBUILD dictionary project |
| **Germanic** | Firth contextual theory → Halliday collocation; Mel'čuk Lexical Functions (Meaning-Text Theory); semantisches Priming (Collins & Loftus spreading activation); IDS Mannheim Kollokationsforschung | Firth, Mel'čuk, Hausmann (collocation directionality), Heid, Krenn | Lexicographic (Lexical Functions formalism); psycholinguistic (lexical decision, priming paradigms); corpus-based | IDS Mannheim, U Cologne, U Potsdam (phraseology) |
| **Romance-FR** | Culioli TOE on prosody-semantic interaction; DiCo/LAF (Polguère) lexical database with Lexical Functions; phonosyntax (prosody-grammar interface); emotional prosody priming | Culioli, Polguère, Mel'čuk, Robert (Wolof), Martin | Lexicographic (Lexical Functions in DiCo); experimental (auditory priming, N400); acoustic analysis | LLF Paris, U Paris Diderot, ATILF Nancy |
| **Romance-ES** | Hausmann directed collocations (base + collocativo); Mel'čuk Lexical Functions via Alonso Ramos (DiCE); semantic prosody in journalistic discourse; bilingual semantic priming | Alonso Ramos, Corpas Pastor, Koike, Bosque, Sánchez Mayor | Lexicographic (DiCE dictionary); corpus-based (journalistic SP); experimental (bilingual priming, lexical availability) | U Pompeu Fabra, U Jaén, U Alicante, U Cádiz |
| **Sinosphere** | **Most active SP research community globally**; 语义韵 as major corpus-linguistics topic; "Double-Jujube Tree" effect (novel word SP acquisition); CLEC/COCA near-synonym comparisons; bilingual cross-language priming | Wei Naixing (卫乃兴), Wang Haihua, Huang Jian, Pu Jianzhong, Li Jingying | Corpus-based (AntConc, BCC, CCL, COCA, CLEC); experimental (valence rating, lexical decision, priming); L2 acquisition focus | Shanghai Jiao Tong, PKU, BISU, Xiamen U, ECNU |
| **Slavic** | Semantic prosody entry on Alphapedia (ru); Pickering & Garrod lexical priming adaptation; combinatorial lexicology (Vlavatskaya); functional-semantic field → collocations; prosodema theory | Shilikha, Vlavatskaya, Tabánakova, Allahverdov | Corpus-based (CyberLeninka); experimental (semantic priming, valence); classification of collocation types | VSU (Voronezh), Novosibirsk, Tumen, RANEPA |

### Key Findings for Round 4

1. **Most applied/corpus-driven angle**: Unlike weight (theoretical), salience (cognitive), or topic/focus (grammatical), semantic prosody is the most empirical — driven by corpus data and L2 pedagogy.
2. **Sinosphere is the most active region**: Chinese researchers dominate SP research globally, with extensive CLEC/COCA comparison studies, the "Double-Jujube Tree" effect (novel word SP acquisition from repeated contexts), and large-scale bilingual priming experiments.
3. **Lexical Functions (Mel'čuk) as cross-regional bridge**: The Meaning-Text Theory's Lexical Functions formalism appears across Germanic (source), Romance-FR (DiCo/LAF), and Romance-ES (DiCE) — the only framework that spans multiple regions in this round.
4. **Anglophone vs Germanic divide**: Both share Firth as ancestor, but Anglophone went corpus-driven (Sinclair, Louw) while Germanic went lexicographic-formal (Mel'čuk lexical functions) + psycholinguistic (spreading activation).
5. **Experimental validation exists**: Unlike all previous rounds, SP has experimental studies (Hauser & Schwarz, "Double-Jujube Tree", bilingual priming) that validate SP effects on human judgment — the only angle with behavioral evidence.
6. **L2 pedagogy connection**: SP research is uniquely tied to applied linguistics — distinguishing near-synonyms via their prosody is a major driver of Chinese and Spanish SP research.
7. **Definitional instability shared across all regions**: Every region debates whether SP is binary (±), functional, or register-specific — no consensus anywhere.

### Comparison Across All 4 Rounds

| Dimension | R1: Semantic Weight | R2: Salience/Prominence | R3: Topic/Focus | R4: Semantic Prosody |
|-----------|-------------------|------------------------|-----------------|---------------------|
| **Core question** | How much meaning? | What's attended to? | How is info packaged? | What attitude is absorbed? |
| **Ancestor** | Shannon/Carnap | Gestalt/Prague | Prague/Gabelentz | Firth/Sinclair |
| **Methodology** | Formal/logical | Theoretical+experimental | Typological/grammatical | Corpus-driven/empirical |
| **Unit** | Propositions, bits | Discourse referents | Clause constituents | Collocations, lexical items |
| **Metrics** | Entropy, probability | Ranking, activation | Categorical (topic/focus) | Polarity (±), frequency |
| **Experimental validation** | None | None | Some (QUIS + experiments) | **Exists** (Hauser, Double-Jujube) |
| **Dominant region** | Anglophone (Carnap tradition) | Germanic (SFB 1252) | Germanic (SFB 632) | Sinosphere (语义韵) |
| **Shared gap** | No human validation | No human validation | Formal weight missing | Binary polarity too coarse |

---

## Round 5 — Linguistic Complexity & Information Density

Fifth round targets the most typologically-grounded angle: how complexity and density trade off across linguistic levels and languages.

### Cross-Region Comparison: Linguistic Complexity & Information Density

| Region | Core Framework | Key Figures | Methodology | Scale |
|--------|---------------|-------------|-------------|-------|
| **Anglophone** | Miestamo absolute vs relative complexity; McWhorter equi-complexity hypothesis; Szmrecsanyi/Ehret Kolmogorov compression; Hawkins efficiency/dependency minimization; Jaeger uniform information density; Frazier syntactic complexity; Mollica et al. Information Bottleneck for grammatical marking | Miestamo, McWhorter, Szmrecsanyi, Ehret, Hawkins, Jaeger, Frazier, Mollica, Gibson, Futrell | Kolmogorov compression (gzip); dependency length; node counts; entropy rate; IB principle; psycholinguistic complexity metrics | Typological (100s of languages); corpus-based |
| **Germanic** | **Largest empirical study** — IDS Mannheim (Koplenig/Wolfer/Meyer) 2000+ languages; complexity ↔ speaker population; complexity-efficiency tradeoff (PLOS Complex Systems 2025); CTAP multi-dimensional complexity system (U Tübingen); Grambank (MPI Leipzig) grammatical complexity database; equi-complexity hypothesis disproven | Koplenig, Wolfer, Meyer (IDS); Ehret (Freiburg); Szmrecsanyi (KU Leuven); Skirgård (MPI); Shcherbakova (MPI) | Entropy rate from LM prediction; Kolmogorov via compression; CTAP 543 features; Grambank 130+ grammatical features | **2000+ languages** (largest of all rounds); 3.5B word corpus |
| **Romance-FR** | DDL Lyon (Oh, Pellegrino, Marsico, Coupé) — syllabic rate ↔ information density tradeoff across 14 languages; Complex Adaptive Systems theory (Léonard, Picard); VERBUM thematic volume; PFM (Paradigm Function Morphology) for systemic complexity | Pellegrino, Oh, Marsico, Coupé (DDL Lyon); Léonard (Paris-Sorbonne); Picard | Syllabic rate; syllabic/word information density; morphological complexity scoring; conditional entropy; diasystem analysis | 14 languages (oral corpus); Uralic diasystem (Sami) |
| **Romance-ES** | Vercher & Bullejos — informative relativity/density/efficiency indices across 459 languages; morphological typology correlations; textual complexity/readability analysis; automatic syntactic complexity (dependency length); Housen/Bulté integration | Vercher García, Bullejos Lorenzo (U Alicante); Rojas, Ibáñez (Chile); Solnyshkina-inspired readability | Informative indices (tokens/UFCT); MDD (mean dependency distance); TTR; readability formulas (Flesch-Szigriszt) | **459 languages**; school text corpora (Chile, Colombia) |
| **Sinosphere** | Gao/Zhou semantic density (Hallidayan); Kolmogorov complexity introductions (SISU); **largest L2 syntactic complexity research community**; BISU, ECNU, AHUT phraseological/syntactic complexity; TAASSC fine-grained NP complexity; Gao Kao writing assessment; CLEC-based measurement | Gao Yanmei (PKU); Lu Xiaofei (Penn State/Chinese); Xu QI, Wan Lifang; BISU L2 writing group | L2SCA (Lu); TAASSC; Kolmogorov compression; semantic density measure; T-unit analysis; noun phrase complexity fine-grained | L2 learner corpora (CLEC, COCA, CCL); school writing corpora |
| **Slavic** | Solnyshkina et al. (Kazan) — readability, narrative, abstractness, lexical diversity for Russian; Vinogradova (RSUH) syntactic complexity of academic texts; propositional modeling for information density; Burkova syntactic typology; discourse complexology (Kazan); cross-linguistic text complexity models (English + Russian ML comparison) | Solnyshkina, Kazachkova (Kazan); Vinogradova (RSUH); Burkova; Shpakovsky | Readability indices (Flesch-Kincaid Russian); TTR; narrative index (noun/verb ratio); abstractness index; propositional density; syntactic tree depth; ML classifiers | 6 corpora English + Russian; school textbooks (biology); academic writing |

### Key Findings for Round 5

1. **Largest empirical scale**: Only round including studies of 2000+ languages (IDS Mannheim) and 459 languages (Vercher/Bullejos). The equi-complexity hypothesis is empirically disproven.
2. **Germanic dominates with largest study**: IDS Mannheim's entropy rate study (Nature Sci Reports 2023, PLOS Complex Systems 2025) is the single largest cross-linguistic complexity study ever conducted.
3. **Trade-off is the unifying theme**: Morphological ↔ syntactic complexity tradeoff; syllabic rate ↔ information density tradeoff; complexity ↔ efficiency tradeoff — a cross-regional consensus.
4. **Spanish contribution is uniquely quantitative**: Vercher & Bullejos's informative indices (relativity, density, efficiency) applied to 459 languages with morphological typology correlations — direct quantification of "semantic weight" as information efficiency.
5. **Sinosphere focuses on L2 assessment**: Unlike all other regions, Chinese complexity research is overwhelmingly L2 pedagogy-driven — measuring syntactic complexity to assess English writing proficiency.
6. **French contribution: Complex Adaptive Systems**: Only region applying Complexity Theory (not just complexity *measurement*) as a paradigm, with Léonard's work on diasystem self-organization.
7. **Kolmogorov complexity as universal metric**: Appears across EN (Ehret, Juola), DE (Szmrecsanyi), ES (via Vercher), CN (introductions), RU (mentioned) — the least theory-dependent, most data-driven approach.

### All 5 Rounds — Synthesis

| Dimension | R1: Weight | R2: Salience | R3: Topic/Focus | R4: Prosody | R5: Complexity |
|-----------|-----------|-------------|----------------|-------------|---------------|
| **Core question** | How much meaning? | What's attended to? | How is info packaged? | What attitude? | How complex? |
| **Methodology** | Formal/logical | Cognitive/exp | Typological | Corpus-driven | Information-theoretic |
| **Scale** | Theoretical | Experimental | 60+ languages | Corpus studies | **2000+ languages** |
| **Empirical validation** | None | None | Some | Yes | **Strong** |
| **Dominant region** | Anglophone | Germanic | Germanic | Sinosphere | Germanic (IDS) |
| **L2 pedagogy** | None | None | None | Major | Major (CN) |
| **Unifying metric** | N/A | N/A | N/A | N/A | Kolmogorov complexity |
