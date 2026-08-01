-- Seed data for research-methodology investigation

INSERT OR IGNORE INTO regions (id, name, status, source_count, surveyed_at) VALUES
    ('anglosphere', 'Anglosphere (US/UK/AUS/CA)', 'PASS', 30, '2026-07-13T22:37:13.492Z'),
    ('continental-europe', 'Continental Europe (FR/DE/ES/NL)', 'PASS', 32, '2026-07-13T22:37:13.492Z'),
    ('nordic', 'Nordic (SE/DK/NO/FI)', 'PASS', 16, '2026-07-13T22:37:13.492Z'),
    ('east-asia', 'East Asia (CN/TW/JP/KR)', 'PASS', 32, '2026-07-13T22:37:13.492Z');

INSERT OR IGNORE INTO researchers (id, name, institution, focus, region) VALUES
    ('r-mckenzie', 'Joanne E. McKenzie', 'Monash / Cochrane', 'SWiM guideline, evidence synthesis', 'Anglosphere'),
    ('r-campbell', 'Mhairi Campbell', 'Glasgow', 'Narrative synthesis transparency', 'Anglosphere'),
    ('r-sowden', 'Amanda Sowden', 'York', 'ESRC narrative synthesis guidance', 'Anglosphere'),
    ('r-thomas', 'James Thomas', 'LSHTM', 'Qualitative synthesis, thematic synthesis', 'Anglosphere'),
    ('r-petticrew', 'Mark Petticrew', 'LSHTM', 'Narrative vs systematic review', 'Anglosphere'),
    ('r-higgins', 'Julian Higgins', 'Bristol', 'Meta-analysis, heterogeneity I²', 'Anglosphere'),
    ('r-ioannidis', 'John P.A. Ioannidis', 'Stanford', 'Meta-research, publication bias', 'Anglosphere'),
    ('r-nosek', 'Brian Nosek', 'UVA / OSF', 'Reproducibility', 'Anglosphere'),
    ('r-rieh', 'Soo Young Rieh', 'Michigan / UT Austin', 'Credibility assessment', 'Anglosphere'),
    ('r-simmons', 'Joseph P. Simmons', 'Wharton', 'p-Curve, p-hacking', 'Anglosphere'),
    ('r-melendez', 'G.J. Melendez-Torres', 'Exeter', 'NS vs MA reasoning', 'Anglosphere'),
    ('r-gedda', 'Michel Gedda', 'Berck-sur-Mer', 'PRISMA French translation', 'Continental Europe'),
    ('r-muka', 'Taulant Muka', 'Rotterdam', '24-step SR guide', 'Continental Europe'),
    ('r-sanchez', 'Josué Sánchez-Meca', 'Murcia', 'SR/MA tutorial', 'Continental Europe'),
    ('r-weitmann', 'Astrid Weitmann', 'Charité Berlin', 'SR Leitfaden doctoral', 'Continental Europe'),
    ('r-gronde', 'Toon van der Gronde', 'Utrecht', 'SR methodology', 'Continental Europe');

INSERT OR IGNORE INTO meta_analyses (id, title, focus, key_finding, source_url) VALUES
    ('ma-bartos-2024', 'Footprint of publication selection bias', 'Publication bias across 68K meta-analyses', 'Economics most contaminated; medicine least', 'https://researchonline.lse.ac.uk/id/eprint/122107/'),
    ('ma-simonsohn-2014', 'p-Curve and Effect Size', 'Publication bias correction using p-curve', 'p-Curve outperforms Trim and Fill', 'https://faculty.ucmerced.edu/'),
    ('ma-brodeur-2023', 'Unpacking p-hacking and publication bias', '20K test statistics across peer review', 'Authors p-hack pre-submission; peer review neutral', 'https://faculty.econ.ucdavis.edu/'),
    ('ma-campbell-2019', 'Lack of transparency in narrative synthesis', '75 reviews using NS', '95% no NS methods described', 'https://eprints.whiterose.ac.uk/'),
    ('ma-melendez-2016', 'Interpretive analysis of 85 systematic reviews', 'NS vs MA reasoning', 'Different modes of reasoning (configurational vs predictive)', 'https://researchonline.lshtm.ac.uk/');

INSERT OR IGNORE INTO gaps (id, region_id, gap_type, description, severity) VALUES
    ('g-personal-practice', NULL, 'cross-cutting', 'No academic literature on personal research skill development — theory-to-practice gap', 'high'),
    ('g-ai-tooling', NULL, 'cross-cutting', 'AI-assisted research tools (MCPs, LLM search) not covered in academic literature', 'high'),
    ('g-discipline-silos', NULL, 'cross-cutting', 'Health dominates; social sciences/humanities/engineering underdeveloped', 'medium'),
    ('g-bias-workflow', NULL, 'cross-cutting', 'Bias detection well-documented statistically but poorly integrated into individual workflows', 'medium'),
    ('g-weird', NULL, 'cross-cutting', 'WEIRD population bias acknowledged but no practical solutions', 'medium'),
    ('g-cognitive-bias-europe', 'continental-europe', 'regional', 'Less cognitive bias primary research in Continental Europe', 'low'),
    ('g-source-frameworks-europe', 'continental-europe', 'regional', 'Source credibility frameworks (CRAAP/SIFT) absent — rely on GRADE instead', 'low'),
    ('g-nordic-finnish', 'nordic', 'regional', 'Limited Finnish-specific sources in methodology literature', 'low');

INSERT OR IGNORE INTO frameworks (id, name, domain, description, origin_region) VALUES
    ('fw-prisma', 'PRISMA 2020', 'Reporting', 'Preferred Reporting Items for Systematic Reviews and Meta-Analyses', 'Anglosphere'),
    ('fw-grade', 'GRADE', 'Evidence certainty', 'Grading of Recommendations Assessment, Development and Evaluation', 'Anglosphere'),
    ('fw-swim', 'SWiM', 'Synthesis', 'Synthesis Without Meta-Analysis reporting guideline', 'Anglosphere'),
    ('fw-esrc-ns', 'ESRC Narrative Synthesis', 'Synthesis', '4-element framework: theory, preliminary, explore, assess robustness', 'Anglosphere'),
    ('fw-pico', 'PICO', 'Question framing', 'Population, Intervention, Comparison, Outcome', 'Anglosphere'),
    ('fw-spice', 'SPICE', 'Question framing', 'Setting, Perspective, Intervention, Comparison, Evaluation', 'Nordic'),
    ('fw-craap', 'CRAAP', 'Source evaluation', 'Currency, Relevance, Authority, Accuracy, Purpose', 'Anglosphere'),
    ('fw-sift', 'SIFT', 'Source evaluation', 'Stop, Investigate, Find, Trace — digital content evaluation', 'Anglosphere'),
    ('fw-robis', 'ROBIS', 'Bias assessment', 'Risk of Bias in Systematic Reviews — domain-based tool', 'Anglosphere'),
    ('fw-amstar', 'AMSTAR 2', 'Quality assessment', 'MeaSurement Tool to Assess systematic Reviews', 'Anglosphere'),
    ('fw-quickstar', 'Quickstar', 'Rapid assessment', '6-step synoptic bias assessment for SRs', 'Nordic'),
    ('fw-salsa', 'SALSA', 'Review classification', 'Search, Appraisal, Synthesis, Analysis framework', 'Continental Europe'),
    ('fw-entreq', 'ENTREQ', 'Reporting', 'Enhancing transparency in reporting qualitative synthesis', 'Anglosphere'),
    ('fw-icerqual', 'GRADE-CERQual', 'Evidence certainty', 'Confidence in Evidence from Reviews of Qualitative research', 'Nordic'),
    ('fw-rob2', 'RoB 2', 'Bias assessment', 'Cochrane Risk of Bias tool for randomized trials', 'Anglosphere'),
    ('fw-robins-i', 'ROBINS-I', 'Bias assessment', 'Risk Of Bias In Non-randomized Studies of Interventions', 'Anglosphere'),
    ('fw-cat', 'CAT', 'Rapid review', 'Critically Appraised Topic — concise evidence summary', 'Continental Europe');
