-- Seed data: tools
INSERT INTO tools VALUES ('TOOL.PAPER.SCREENING.AGENT', 'Paper-Screening-Agent', 'us-uk', 'LLM scoring + tiered routing', '200+ concurrent', 'api-costs', 'screening', 'https://github.com/pursurer/Paper-Screening-Agent');
INSERT INTO tools VALUES ('TOOL.ARXIV.RADAR', 'arXiv Radar', 'us-uk', 'pgvector + BM25 hybrid (RRF)', 'Self-hosted', 'free', 'indexing', 'https://github.com/deepweather/arxiv-radar');
INSERT INTO tools VALUES ('TOOL.DAILY.PAPERS', 'Daily-Papers', 'us-uk', 'Gemini 4D scoring', 'Free API', 'free', 'screening', 'https://github.com/WingEdge777/daily-papers');
INSERT INTO tools VALUES ('TOOL.ARXIV.PAPER.QUALITY.FILTER', 'arXiv-Paper-Quality-Filter', 'china', 'CCF matching + keyword', 'RPA-crawled', 'free', 'screening', 'https://github.com/henrypan1993/arXiv-Paper-Quality-Filter');
INSERT INTO tools VALUES ('TOOL.PAPER.DAILY', 'paper_daily', 'china', '5D scoring + academic value', 'SQLite persistent', 'api-costs', 'screening', 'https://github.com/deadpoppy/paper_daily');
INSERT INTO tools VALUES ('TOOL.LLM.SURVER', 'LLMSurver', 'eu', 'Multi-LLM consensus', 'Recall >98.8%', 'free', 'screening', 'https://llmsurver.dbvis.de/');
INSERT INTO tools VALUES ('TOOL.META.SCREENER', 'MetaScreener', 'eu', '4-model ensemble + CCA', '95-97% sensitivity', 'api-costs', 'screening', 'https://metascreener.net/');
INSERT INTO tools VALUES ('TOOL.ASREVIEW', 'ASReview', 'eu', 'Active learning', '95% workload reduction', 'free', 'screening', 'https://asreview.nl/');
INSERT INTO tools VALUES ('TOOL.SCHOLAR.VAULT', 'ScholarVault', 'india', '18-point forensic audit', '12 sec audit', 'free', 'verification', 'https://scholarvault.in/');
INSERT INTO tools VALUES ('TOOL.ALETHEIA.PROBE', 'Aletheia-Probe', 'india', 'Multi-source predatory detection', 'Hybrid DB+pattern', 'free', 'detection', 'https://github.com/pastvir/aletheia-probe');
INSERT INTO tools VALUES ('TOOL.PATENT.NOISE.FILTER', 'PatentNoiseFilter', 'japan-korea', '3-module ML ensemble', 'User-precision optimized', 'commercial', 'screening', NULL);
INSERT INTO tools VALUES ('TOOL.AUTOEXP', 'AutoEXP', 'japan-korea', 'Multi-agent LLM search', 'NE coverage', 'research', 'screening', NULL);

-- Seed data: indexers
INSERT INTO indexers VALUES ('IDX.SEMANTIC.SCHOLAR', 'Semantic Scholar', 'us-uk', '205M papers, 121M authors', 'AI-generated TLDR; citation graph', 'global', 'https://semanticscholar.org/');
INSERT INTO indexers VALUES ('IDX.PAPERS.WITH.CODE', 'Papers With Code', 'us-uk', '400K ML papers', 'Code links; benchmarks; RDF KG', 'global', 'https://paperswithcode.com/');
INSERT INTO indexers VALUES ('IDX.RESEARCH.SCOPE', 'ResearchScope', 'us-uk', '100K+ CS papers', '6-signal scoring; venue recommender', 'global', 'https://kishormorol.github.io/ResearchScope/');
INSERT INTO indexers VALUES ('IDX.PAPER.ESPRESSO', 'Paper Espresso', 'us-uk', '13K trending papers', 'LLM topic labeling; trend lifecycle', 'global', 'https://huggingface.co/spaces/Elfsong/Paper_Espresso');
INSERT INTO indexers VALUES ('IDX.CINII', 'CiNii Research', 'japan-korea', '180M items', 'Japanese academic integration', 'national', 'https://cir.nii.ac.jp/');
INSERT INTO indexers VALUES ('IDX.KISTI', 'KISTI ScienceON', 'japan-korea', 'National Korean portal', 'Patents + journals + standards', 'national', 'https://scienceon.kisti.re.kr/');
INSERT INTO indexers VALUES ('IDX.CNKI', 'CNKI', 'china', 'National Chinese database', 'Primary academic DB + plagiarism detection', 'national', 'https://www.cnki.net/');
INSERT INTO indexers VALUES ('IDX.SCHOLAR.INBOX', 'Scholar Inbox', 'eu', '800K user ratings', 'Active learning recommendations', 'global', 'https://www.scholar-inbox.com/');
INSERT INTO indexers VALUES ('IDX.HF.DAILY', 'Hugging Face Daily Papers', 'us-uk', '~2-3% of arXiv', 'Community curation', 'global', 'https://huggingface.co/papers');

-- Seed data: regions
INSERT INTO regions VALUES ('us-uk', 'US/UK/English-Western', 'PASS', 'English', 15, 10, 'Multilingual filtering absent');
INSERT INTO regions VALUES ('china', 'China', 'PASS', 'Chinese, English', 14, 10, 'Fragmented individual GitHub projects');
INSERT INTO regions VALUES ('eu', 'EU (DE/FR/NL)', 'PASS', 'English, German', 15, 10, 'Systematic review focus; general filtering sparse');
INSERT INTO regions VALUES ('japan-korea', 'Japan/South Korea', 'PASS', 'Japanese, Korean, English', 14, 5, 'Patent filtering dominates; AI paper filtering nascent');
INSERT INTO regions VALUES ('india', 'India', 'PASS', 'English', 11, 4, 'No arxiv filtering tools; predatory journal focus');

-- Seed data: gaps
INSERT INTO gaps VALUES ('GAP.CROSS.PLATFORM', 'No single tool aggregates scores from all major indexers', NULL, 'high');
INSERT INTO gaps VALUES ('GAP.MULTILINGUAL', 'Most tools filter English only; CJK arxiv papers under-served', NULL, 'high');
INSERT INTO gaps VALUES ('GAP.METRIC.STANDARD', 'Each tool uses proprietary scoring; no benchmark dataset', NULL, 'high');
INSERT INTO gaps VALUES ('GAP.INDIA.ARXIV', 'No India-specific arxiv filtering tool', 'india', 'medium');
INSERT INTO gaps VALUES ('GAP.CHINA.FRAGMENT', 'Many individual GitHub tools but no dominant platform', 'china', 'medium');
INSERT INTO gaps VALUES ('GAP.JP.PATENT', 'Patent filtering dominates; AI paper filtering nascent', 'japan-korea', 'medium');
