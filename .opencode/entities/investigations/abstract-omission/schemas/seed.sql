-- Abstract Omission Global Research Index — Seed Data
-- Populates all tables from abstract-omission geo-audit

-- Regions
INSERT INTO regions (id, name, notes) VALUES
  ('FUND', 'Fundamentals', 'Core principles: self-contained, concise, accurate, structured, informative, objective, autonomous, keyword-rich'),
  ('NA', 'North America', 'English-language academic writing tradition; APA manual dominant'),
  ('EU', 'Western Europe', 'French and German academic writing traditions; national university guidelines'),
  ('LATAM', 'Latin America', 'Spanish and Portuguese academic writing; ABNT NBR 6028 national standard (Brazil)'),
  ('EA', 'East Asia', 'Chinese and Japanese academic writing; GB/T 6447-2025 national standard (China)'),
  ('MA', 'Meta-Analyses', 'Cross-journal systematic reviews of abstract writing guidelines'),
  ('GAP', 'Gaps', 'Regions with no indexed sources or native-language surveys found');

-- Fundamentals
INSERT INTO fundamentals (id, concept, source, key_idea) VALUES
  ('F.SELFCONTAINED', 'Self-contained', 'Universal (all regions)', 'Abstract must be intelligible without reading the full paper'),
  ('F.CONCISE', 'Concise', 'Universal (all regions)', 'Minimum words for maximum signal; typical 150-300 word limit'),
  ('F.ACCURATE', 'Accurate', 'Universal (all regions)', 'Every claim in abstract must appear in the full paper — no absent content'),
  ('F.STRUCTURED', 'Structured', 'Universal (all regions)', 'Background → Methods → Results → Conclusions (IMRaD)'),
  ('F.INFORMATIVE', 'Informative', 'Universal (all regions)', 'Delivers findings, not a table of contents'),
  ('F.OBJECTIVE', 'Objective', 'LatAm, CN, JP', 'No evaluation, no commentary, no self-appraisal'),
  ('F.AUTONOMOUS', 'Autonomous', 'Universal (all regions)', 'No forward references to figures, tables, or bibliography'),
  ('F.KEYWORD', 'Keyword-rich', 'Universal (all regions)', 'Optimized for database indexing and discoverability');

-- Sources
INSERT INTO sources (id, region_id, title, country, institution, key_content, methodology, language, doi_url, year, tags) VALUES
  -- North America
  ('NA.USC', 'NA', 'Organizing Your Social Sciences Research Paper — The Abstract', 'US', 'USC LibGuides', '10 explicit "should not" items: no hooks, no quotes, no lengthy background, no acronyms, no citations, no jargon, no figures', 'guidelines', 'EN', 'https://libguides.usc.edu/writingguide/abstract', 2026, 'na,usc,should-not'),
  ('NA.UNC', 'NA', 'Abstracts — UNC Writing Center', 'US', 'UNC Chapel Hill', 'Descriptive vs informative abstracts; how not to write: no extensive references, no absent info, no term definitions', 'handout', 'EN', 'https://writingcenter.unc.edu/tips-and-tools/abstracts/', 2011, 'na,unc,handout'),
  ('NA.UWISC', 'NA', 'Writing an Abstract for Your Research Paper', 'US', 'UW-Madison Writing Center', 'Typical abstract components; no citations, no references in abstract', 'handout', 'EN', 'https://writing.wisc.edu/handbook/assignments/writing-an-abstract-for-your-research-paper/', 2026, 'na,uwisc,handout'),
  ('NA.CALVIN', 'NA', 'WHAT NOT TO DO: ABSTRACTS', 'US', 'Calvin College', 'No withholding conclusions, no hooks, no persuasive rhetoric, no definitions, no citations, no unnecessary content', 'handout', 'EN', 'https://calvin.edu/sites/default/files/migrated/offices-services-rhetoric-center-images-WHAT-NOT-TO-DO--ABSTRACTS.pdf', 2026, 'na,calvin,should-not'),
  ('NA.CW', 'NA', 'What to Include and Exclude in an Abstract', 'Global', 'CW Authors', 'No absent content, no confirmatory/negative results, no references, no figures/tables, no abbreviations', 'guidelines', 'EN', 'https://www.cwauthors.com/article/what-to-include-and-exclude-in-an-abstract', 2022, 'na,cwauthors,include-exclude'),
  ('NA.AWIS', 'NA', 'Mistakes to Avoid When Writing a Scientific Abstract', 'US', 'AWIS', 'No too much background, no vague language, no dense terminology, no overstating conclusions, no missing implications', 'article', 'EN', 'https://awis.org/resource/mistakes-to-avoid-when-writing-a-scientific-abstract/', 2026, 'na,awis,mistakes'),
  ('NA.WORDVICE', 'NA', 'How to Write an Abstract for a Research Paper', 'Global', 'Wordvice', 'No acronyms/abbreviations unless defined, no references to people, no tables/figures/sources/long quotations', 'guide', 'EN', 'https://blog.wordvice.com/how-to-write-a-research-paper-abstract/', 2024, 'na,wordvice,guide'),
  ('NA.OUP', 'NA', 'How Research Abstracts Succeed and Fail', 'UK', 'OUP Blog', 'Abstracts that meta-report ("this paper discusses") fail; no new info, no exaggeration, no puffery', 'article', 'EN', 'https://blog.oup.com/2021/11/how-research-abstracts-succeed-and-fail/', 2021, 'na,oup,success-fail'),
  ('NA.WKU', 'NA', 'How to Write an Abstract — UCSB/WKU', 'US', 'WKU/UCSB', 'No casual/colloquial phrasing, no contractions, no personal narrative, no opinion, no commentary', 'slides', 'EN', 'https://www.wku.edu/studentresearch/documents/student_resources/how_to_write_an_abstract_ucsb.pdf', 2026, 'na,wku,slides'),

  -- Western Europe
  ('EU.CIRAD', 'EU', 'Ce que vous devez éviter dans un résumé', 'France', 'Cirad', 'No references, no tables/figures, no brand names, no abbreviations, no section references, no absent elements', 'guidelines', 'FR', 'https://coop-ist.cirad.fr/rediger/article-scientifique/le-resume/4-ce-que-vous-devez-eviter-dans-un-resume', 2026, 'eu,cirad,eviter'),
  ('EU.SCRIBBR', 'EU', 'Le résumé d''un article scientifique', 'France', 'Scribbr', 'No new elements, no undefined abbreviations, no images/figures/tables, no section references, no citations, no long sentences', 'guide', 'FR', 'https://www.scribbr.fr/article-scientifique/resume-article-scientifique/', 2020, 'eu,scribbr,resume'),
  ('EU.PHARM', 'EU', 'Rédaction d''un résumé scientifique', 'Canada (FR)', 'Pharmactuel', 'No abbreviations unless official, no references, no passive voice preference, no superficial content', 'article', 'FR', 'https://pharmactuel.com/index.php/pharmactuel/article/download/1275/1108?inline=1', 2026, 'eu,pharmactuel,redaction'),
  ('EU.GRAZ', 'EU', 'Informationsblatt: Abstracts', 'Austria', 'Uni Graz', 'No detailed content, no literature references, no source citations in abstract', 'guidelines', 'DE', 'https://static.uni-graz.at/fileadmin/gewi-institute/Translationswissenschaft/Formulare/info_abstract.pdf', 2026, 'eu,graz,abstract'),
  ('EU.TUD', 'EU', 'Leitlinien wissenschaftliche Arbeit (Abstract section)', 'Germany', 'TU Dresden', 'No new formulations; abstract derived from intro and conclusion', 'guidelines', 'DE', 'https://tu-dresden.de/bu/wirtschaft/bwl/bu/ressourcen/dateien/lehre/2025-01-16_Leitlinien_deu-von-CSc-LJ-RP-bearbeitet.pdf?lang=de', 2025, 'eu,tudresden,leitlinien'),
  ('EU.MANNHEIM', 'EU', 'Richtlinien zur Gestaltung von wissenschaftlichen Arbeiten (Abstract)', 'Germany', 'Uni Mannheim', 'No repetition of introduction; max 200 words (BA) / 300 (MA)', 'guidelines', 'DE', 'https://www.bwl.uni-mannheim.de/media/Lehrstuehle/bwl/Kuester/Lehre/Wissenschaftliche_Arbeiten/Richtlinien_Oct2023_de.pdf', 2023, 'eu,mannheim,richtlinien'),
  ('EU.GOETTINGEN', 'EU', 'Richtlinien zur formalen Gestaltung (Abstract)', 'Germany', 'Uni Göttingen', 'Only content of the present work; no external references', 'guidelines', 'DE', 'https://uni-goettingen.de/de/document/download/ab71bf61fc438ea262e9a9516091f3d2.pdf/Richtlinien-zur-Gestaltung-wissenschaftlicher-Arbeiten_PMI_September-2024.pdf', 2024, 'eu,goettingen,formal'),
  ('EU.STUTTGART', 'EU', 'Abstracts schreiben', 'Germany', 'Uni Stuttgart', 'Abstract includes key results and conclusions (unlike introduction); no evaluation', 'handout', 'DE', 'https://www.sz.uni-stuttgart.de/dokumente/schreibwerkstatt-materialien/textsortenwissen/Abstracts-schreiben.pdf', 2026, 'eu,stuttgart,schreiben'),
  ('EU.KIEL', 'EU', 'Leitfaden für die Anfertigung von wissenschaftlichen Arbeiten', 'Germany', 'Uni Kiel', 'Abstract must give precise overview; no evaluation, no interpretation', 'guidelines', 'DE', 'https://www.techman.uni-kiel.de/de/downloads/files/leitfaden-walter-und-schultz-version-juli23.pdf/at_download/file', 2023, 'eu,kiel,leitfaden'),
  ('EU.DORTMUND', 'EU', 'Formale Anforderungen Seminar- und Abschlussarbeiten', 'Germany', 'TU Dortmund', 'Abstract covers topic, research question, method, results, conclusion; no evaluation', 'guidelines', 'DE', 'https://uc.wiwi.tu-dortmund.de/storages/uc-wiwi/r/Abschlussarbeiten/Richtlinien_UC_LS_Version4.1_07-2023_.pdf', 2023, 'eu,dortmund,formal'),
  ('EU.MUENSTER', 'EU', 'Wie formatiere ich meine Abschlussarbeit?', 'Germany', 'Uni Münster', 'No info absent from original; no value judgments; understandable without expertise', 'guidelines', 'DE', 'https://www.uni-muenster.de/imperia/md/content/psyipbe/ae_jucks/anleitung_formatierung_abschlussarbeit_2023.pdf', 2023, 'eu,muenster,formatierung'),
  ('EU.LEIPZIG', 'EU', 'Richtlinien wiss. Arbeiten (Abstract)', 'Germany', 'Uni Leipzig', 'Abstract covers problem, method, results; max half page; bibliography in separate section', 'guidelines', 'DE', 'https://www.wifa.uni-leipzig.de/fileadmin/Fakultaet_Wifa/Institut_fuer_Wirtschaftsinformatik/IWI-SE/Richtlinien_wiss__Arbeiten_28_jsc.pdf', 2026, 'eu,leipzig,richtlinien'),

  -- Latin America
  ('LATAM.REDALYC', 'LATAM', 'El resumen de un artículo científico. Qué es y qué no es', 'Colombia', 'Redalyc / U. de Antioquia', '16 "no" statements: no citations, no tables/figures, no percentages, no bibliography, no acronyms, no first person, no personal criticism, no examples', 'article', 'ES', 'https://www.redalyc.org/pdf/1052/105215404001.pdf', 2007, 'latam,redalyc,que-no-es'),
  ('LATAM.SCIELO.ES', 'LATAM', 'Diez claves para la elaboración del resumen en un artículo científico', 'Spain', 'Scielo ISCIII', 'No vague expressions, no acronyms (except common), no bibliographic citations, no tables/graphs, no formulas, no equations', 'article', 'ES', 'https://scielo.isciii.es/scielo.php?script=sci_arttext&pid=S1132-12962020000100025', 2020, 'latam,scielo,claves'),
  ('LATAM.HOSPITAL', 'LATAM', 'Cómo presentar un resumen (abstract): recomendaciones', 'Argentina', 'Hospital Italiano de Buenos Aires', 'No bibliography, no references to tables/images, no abbreviations, no info absent from paper', 'article', 'ES', 'https://ojs.hospitalitaliano.org.ar/index.php/revistahi/article/download/324/308/1645', 2026, 'latam,argentina,recomendaciones'),
  ('LATAM.UMA', 'LATAM', 'Elaborar Resúmenes (UNE 50-103-90 / ISO 214:1976)', 'Spain', 'UMA Biblioteca', 'No "este artículo...", no textual extracts, no acronyms (except well-known), no tables/equations/formulas/diagrams unless essential', 'guidelines', 'ES', 'https://www.uma.es/publicadores/biblioteca/wwwuma/ElaborarResumenes.pdf', 2026, 'latam,uma,elaborar'),
  ('LATAM.REDALAC', 'LATAM', '¿Cuál es la mejor manera de escribir un resumen efectivo?', 'LatAm', 'Red ALAC', 'No jargon, no unknown acronyms, no bibliographic citations, no tables/graphs', 'article', 'ES', 'https://redalac.org/cual-es-la-mejor-manera-de-escribir-un-resumen-efectivo/', 2026, 'latam,redalac,efectivo'),
  ('LATAM.UCHILE', 'LATAM', 'Resumen de artículo de investigación', 'Chile', 'U. de Chile', 'No omission of key results; no meta-description; structure: intro, purpose, methods, results, conclusions', 'guide', 'ES', 'https://aprendizaje.uchile.cl/recursos-para-leer-escribir-y-hablar-en-la-universidad/escribir-resumenes-academicos/el-resumen-de-articulo-de-investigacion/', 2026, 'latam,uchile,resumen'),
  ('LATAM.PRS.ES', 'LATAM', 'Resúmenes en la Investigación: Errores Comunes', 'LatAm', 'Proof-Reading-Service.com', 'No vague language, no too much background, no omitted results, no jargon overload, no ignoring word limits', 'guide', 'ES', 'https://www.proof-reading-service.com/es/blogs/academic-publishing/abstracts-in-research-structure-best-practices-and-common-mistakes', 2025, 'latam,prs,errores'),
  ('LATAM.ABNT', 'LATAM', 'ABNT NBR 6028 — Resumos (National Standard)', 'Brazil', 'ABNT', 'No citations, no figures/diagrams/tables/graphs/formulas, no descriptions/explanations; single paragraph, third person', 'national standard', 'PT', 'https://www.abnt.org.br/', 2021, 'latam,abnt,nbr6028'),
  ('LATAM.UFRJ', 'LATAM', 'Como elaborar um bom resumo', 'Brazil', 'UFRJ Biblioteca', 'No symbols, no contractions, no formulas, no equations, no diagrams unless essential; 150-500 words', 'guide', 'PT', 'https://biblioteca.letras.ufrj.br/resumos-para-trabalho-academico/', 2026, 'latam,ufrj,resumo'),
  ('LATAM.SCIELO.BR', 'LATAM', 'Escrevendo para publicação: Resumos', 'Brazil', 'Scielo BR', 'No bibliographic citations, no first person, no generalized/implications beyond data', 'article', 'PT', 'https://www.scielo.br/j/pee/a/458SMFV6Kz3txfKByGDFSNz/?lang=pt', 2026, 'latam,scielo,escrevendo'),
  ('LATAM.USP', 'LATAM', 'O resumo não deve conter citações bibliográficas, tabelas, quadros, esquemas', 'Brazil', 'USP FSP', 'No bibliographic citations, no tables, no frames, no schemas; third person singular', 'guide', 'PT', 'https://biblioteca.fsp.usp.br/guia/a_cap_05.htm', 2026, 'latam,usp,conter'),
  ('LATAM.UEMG', 'LATAM', 'Normalização de publicações técnico-científicas (Resumo)', 'Brazil', 'UEMG', 'No evaluation, no judgment; concise single paragraph; third person; 150-500 words', 'guidelines', 'PT', 'https://www.editora.uemg.br/images/livros-pdf/catalogo-2024/Normalizacao/4-PUBLICACOES_CIENTIFICAS.pdf', 2024, 'latam,uemg,normalizacao'),
  ('LATAM.UERJ', 'LATAM', 'Resumo Roteiro BDTD (NBR 6028:2021)', 'Brazil', 'UERJ', 'No symbols, no contractions, no formulas, no equations, no diagrams unless essential', 'guidelines', 'PT', 'https://www.rsirius.uerj.br/extras/downloads/Resumo_Roteiro_BDTD_UERJ.pdf', 2026, 'latam,uerj,roteiro'),

  -- East Asia
  ('EA.GBT6447', 'EA', 'GB/T 6447-2025 — Compilation Rules of Document Abstracts', 'China', 'SAC/TC4', 'National standard: no commentary, no common knowledge, no repetition of title, no undefined symbols/terms, no figure/table numbering; 12 detailed clauses', 'national standard', 'ZH/EN', 'https://std.samr.gov.cn/gb/search/gbDetailed?id=3B46A026CC89469CE06397BE0A0AEEB8', 2025, 'ea,gbt,standard'),
  ('EA.TSINGHUA', 'EA', 'Writing Requirements for English Abstracts (Tsinghua Journal)', 'China', 'Tsinghua University', 'No background info, no future plans, no self-praise ("first reported"), no repeated title, no unnecessary phrases ("this paper...")', 'guidelines', 'EN', 'https://jst.tsinghuajournals.com/EN/column/column9.shtml', 2026, 'ea,tsinghua,abstract'),
  ('EA.CAS', 'EA', 'UCAS Dissertation Writing Guidelines (Abstract)', 'China', 'Chinese Academy of Sciences', 'No equations/figures/tables/illustrations, no citations, no "this paper"', 'guidelines', 'ZH/EN', 'http://scsio.cas.cn/yjsjy/is/dl/201904/W020191011657673357940.pdf', 2019, 'ea,cas,guidelines'),
  ('EA.UESTC', 'EA', 'Graduate Dissertation Writing Standards (Abstract)', 'China', 'UESTC', 'No outline-style ("Chapter 1..."), no figures/tables/formulas, no "this paper"', 'guidelines', 'ZH/EN', 'https://gr.uestc.edu.cn/attached/papers/101/202303/Graduate%20Dissertation(Thesis)%20Writing%20Standards_20230301_011659218393.pdf', 2023, 'ea,uestc,standards'),
  ('EA.SIE', 'EA', '论文摘要撰写格式', 'China', 'Shenyang Institute of Engineering', 'No common knowledge, no intro content, no self-evaluation, no repeated title, no formulas/figures/tables, no citations', 'guidelines', 'ZH', 'https://xuebao2.sie.edu.cn/info/1030/1030.htm', 2026, 'ea,sie,format'),
  ('EA.SCITRANS', 'EA', '论文中英摘要的写作', 'China', 'SciTrans', 'No common knowledge, no intro content, no self-evaluation, no repeated title, no formulas/figures/tables, no citations unless essential', 'guide', 'ZH', 'https://fanyixueyuan.scientrans.com/zhaiyaofanyi/fanyixueyuan_36.html', 2026, 'ea,scitrans,writing'),
  ('EA.JSME', 'EA', '要旨作成の注意点', 'Japan', 'JSME', 'No vague expressions, no repeated subjects ("we"), no undefined abbreviations, no references to past work unknown to reader; one-idea-per-sentence', 'guidelines', 'JP', 'https://2023.jsme-conference.net/wp-content/uploads/2023/09/7a5e3c8ebd1da0ee967f7096f015747c.pdf', 2023, 'ea,jsme,youshi'),
  ('EA.PAPERSFLOW.JP', 'EA', '要旨（Abstract）の書き方：ステップバイステップガイド', 'Japan', 'PapersFlow', 'No citations in abstract, no teaser (must state conclusions), no table of contents style', 'guide', 'JP', 'https://papersflow.ai/ja/blog/how-to-write-an-abstract-ja', 2026, 'ea,papersflow,guide'),
  ('EA.EDITAGE', 'EA', '優れたアブストラクトを書くためのヒント6選', 'Japan', 'Editage JP', 'No info absent from paper, no undefined abbreviations, no figures/tables/references, no verbose expressions', 'guide', 'JP', 'https://www.editage.jp/blog/6-tips-for-writing-a-research-paper-abstract/', 2024, 'ea,editage,tips'),
  ('EA.ENAGO', 'EA', '論文の要旨（Abstract/アブストラクト）の種類と書き方', 'Japan', 'Enago JP', 'No citations, no subjective evaluation, no exaggerated claims; abstract is not an introduction, not a teaser, not a table of contents', 'guide', 'JP', 'https://www.enago.jp/knowledge-base/importance-of-abstracts-in-research-papers', 2024, 'ea,enago,abstract'),
  ('EA.MTS', 'EA', 'Abstractの書き方 (ICMJE guidelines)', 'Japan', 'Medical Translation Service', 'No overinterpretation of findings, no citations in abstract, consistent with ICMJE recommendations', 'guide', 'JP', 'https://medicaltrans.info/abstract/', 2018, 'ea,mts,icmje'),
  ('EA.READABLE', 'EA', 'アブストラクトとは？論文の顔として読者を惹きつける書き方', 'Japan', 'Readable JP', 'No excessive jargon, no undefined abbreviations, no reference to figures/paper body, no citations, no overstated claims', 'guide', 'JP', 'https://compass.readable.jp/2025/05/23/post-660/', 2025, 'ea,readable,guide'),

  -- Meta-analyses
  ('MA.CW', 'MA', 'What to Include and Exclude in an Abstract', 'comprehensive', 'CW Authors', 'Exclusions: absent content, confirmatory/negative results, references, figures/tables, abbreviations', 'cross-journal guidelines', 'EN', 'https://www.cwauthors.com/article/what-to-include-and-exclude-in-an-abstract', 2022, 'meta,include-exclude'),
  ('MA.AJET', 'MA', 'Don''t be Abstract: Crafting an Impactful Abstract (AJET)', 'comprehensive', 'Australasian Journal of Educational Technology', 'Exclusion table: excessive detail, too many words, extraneous content, citations, repeated text, absent info, overstated findings', 'content analysis of 100 abstracts', 'EN', 'https://ajet.org.au/index.php/AJET/article/download/9938/2100/32140', 2024, 'meta,ajet,exclusion'),
  ('MA.DRURY', 'MA', 'How to Write a Comprehensive Research Abstract', 'comprehensive', 'Seminars in Oncology Nursing', 'BMRaC structure; no citations, no figures, no absent content; write last', 'review', 'EN', 'https://doi.org/10.1016/j.soncn.2023.151395', 2023, 'meta,drury,comprehensive'),
  ('MA.ALSPACH', 'MA', 'Elements Not to Include in an Abstract', 'comprehensive', 'Alspach (adapted by AJET)', 'Excessive detail, too many words, extraneous content, citations, repeated text from intro, absent info, overstated findings, mismatched conclusions', 'review', 'EN', 'https://ajet.org.au/', 2017, 'meta,alspach,exclusion');

-- Meta-analyses
INSERT INTO meta_analyses (id, title, scope, key_finding, effect_size, sample_size, doi_url) VALUES
  ('MA.CW', 'What to Include and Exclude in an Abstract', 'cross-journal guidelines', 'Five exclusion categories: absent content, confirmatory results, references, figures/tables, abbreviations', 'taxonomy', 'cross-journal', 'https://www.cwauthors.com/article/what-to-include-and-exclude-in-an-abstract'),
  ('MA.AJET', 'Don''t be Abstract: Crafting an Impactful Abstract for Educational Technology Research', '100 abstracts from top 10 journals', 'Table of exclusion elements: excessive detail, extraneous content, citations, overstated findings, mismatched results', 'taxonomy', '100 abstracts', 'https://ajet.org.au/index.php/AJET/article/download/9938/2100/32140'),
  ('MA.DRURY', 'How to Write a Comprehensive and Informative Research Abstract', 'nursing research', 'BMRaC structure guidance; no citations, no figures, no absent content; write abstract last', 'framework', 'comprehensive', 'https://doi.org/10.1016/j.soncn.2023.151395'),
  ('MA.ALSPACH', 'Elements That Should Not Be Included in an Abstract', 'comprehensive', 'Seven exclusion elements for abstract writing', 'taxonomy', 'comprehensive', 'https://ajet.org.au/');

-- Researchers
INSERT INTO researchers (id, name, region_id, institution, specialisation) VALUES
  ('R.DIEZ', 'Bertha Ligia Díez', 'LATAM', 'U. de Antioquia / Redalyc', '"Qué es y qué no es un resumen" — 16 exclusion statements'),
  ('R.DRURY', 'Amanda Drury', 'MA', 'Seminars in Oncology Nursing', 'Abstract writing guidance for nursing research'),
  ('R.RATHMAN', 'Eric Rathman', 'NA', 'UAMS', 'Scientific abstract writing guide (2026)'),
  ('R.REID', 'Tom Reid', 'NA', 'U. of Bath', 'Abstract writing 6-point checklist'),
  ('R.ZHANG', 'Zhang Pinchun (张品纯)', 'EA', 'SAC/TC4', 'Lead drafter of GB/T 6447-2025 national standard');

-- Gaps
INSERT INTO gaps (id, region_name, status, notes) VALUES
  ('GAP.ARABIC', 'Middle East / Arabic', 'not searched', 'Arabic-language abstract conventions and guidelines not surveyed'),
  ('GAP.SOUTHASIA', 'South Asia / India', 'not searched', 'Indian academic abstract conventions in English and regional languages'),
  ('GAP.SEA', 'Southeast Asia', 'not searched', 'Thai, Vietnamese, Indonesian academic writing conventions'),
  ('GAP.AFRICA', 'Africa', 'not searched', 'African academic writing traditions and abstract guidelines'),
  ('GAP.NORDIC', 'Nordic / Scandinavia', 'not searched', 'Swedish, Danish, Norwegian abstract conventions'),
  ('GAP.EMPIRICAL', 'Global', 'not surfaced', 'Empirical studies of abstract rejection rates by exclusion violation type'),
  ('GAP.STRUCTURED', 'Global', 'not surfaced', 'Comparison of structured vs unstructured abstract exclusion rules by region');
