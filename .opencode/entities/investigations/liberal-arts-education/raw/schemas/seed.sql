-- Seed: Liberal Arts Education Investigation

INSERT OR IGNORE INTO regions (id, name, rating, source_count, notes) VALUES
('us-uk', 'English (US/UK)', 'PASS', 8, 'Strongest empirical literature; employer surveys, longitudinal studies'),
('germany', 'Germany', 'PASS', 10, 'Bildung tradition; Studium Generale; key qualifications focus'),
('france', 'France', 'PASS', 9, 'Pluridisciplinarity; structured competency frameworks; elite programs'),
('japan', 'Japan', 'PASS', 10, 'リベラルアーツ + career education; critical thinking via debate');

INSERT OR IGNORE INTO outcomes (id, name, description) VALUES
('critical-thinking', 'Critical thinking', 'Evidence-based, logical, unbiased reasoning; analytical and reflective thinking'),
('broad-knowledge', 'Broad general knowledge', 'Interdisciplinary knowledge across humanities, sciences, social sciences'),
('communication', 'Communication skills', 'Written and oral expression; argumentation; rhetoric'),
('civic-ethical', 'Civic and ethical formation', 'Citizenship, moral reasoning, social responsibility, democratic participation'),
('employability', 'Employability and adaptability', 'Transferable skills; career readiness; lifelong learning'),
('lifelong-learning', 'Lifelong learning', 'Propensity and capacity for continued learning across lifespan'),
('intercultural', 'Intercultural competence', 'Understanding across cultures; foreign language proficiency; global perspective'),
('multi-perspective', 'Multi-perspective thinking', 'Ability to view problems from multiple angles; bird''s-eye synthesis');

INSERT OR IGNORE INTO region_outcomes (region_id, outcome_id, evidence_quality) VALUES
('us-uk', 'critical-thinking', 'strong'),
('us-uk', 'broad-knowledge', 'strong'),
('us-uk', 'communication', 'strong'),
('us-uk', 'civic-ethical', 'moderate'),
('us-uk', 'employability', 'strong'),
('us-uk', 'lifelong-learning', 'strong'),
('us-uk', 'intercultural', 'moderate'),
('us-uk', 'multi-perspective', 'strong'),
('germany', 'critical-thinking', 'strong'),
('germany', 'broad-knowledge', 'strong'),
('germany', 'communication', 'strong'),
('germany', 'civic-ethical', 'strong'),
('germany', 'employability', 'strong'),
('germany', 'lifelong-learning', 'strong'),
('germany', 'intercultural', 'moderate'),
('germany', 'multi-perspective', 'strong'),
('france', 'critical-thinking', 'strong'),
('france', 'broad-knowledge', 'strong'),
('france', 'communication', 'strong'),
('france', 'civic-ethical', 'moderate'),
('france', 'employability', 'strong'),
('france', 'lifelong-learning', 'strong'),
('france', 'intercultural', 'strong'),
('france', 'multi-perspective', 'strong'),
('japan', 'critical-thinking', 'strong'),
('japan', 'broad-knowledge', 'strong'),
('japan', 'communication', 'moderate'),
('japan', 'civic-ethical', 'strong'),
('japan', 'employability', 'strong'),
('japan', 'lifelong-learning', 'strong'),
('japan', 'intercultural', 'moderate'),
('japan', 'multi-perspective', 'strong');

INSERT OR IGNORE INTO sources (id, title, institution, region_id, source_type) VALUES
('aacu-2021', 'How College Contributes to Workforce Success', 'AAC&U / ETSU', 'us-uk', 'academic'),
('leap-report', 'Liberal Education: LEAP Report', 'AAC&U', 'us-uk', 'academic'),
('uchicago-noncog', 'Noncognitive Outcomes of Liberal Arts Education', 'UChicago Consortium', 'us-uk', 'academic'),
('wisc-democratic', 'Liberal Arts Education and Democratic Outcomes', 'UWisc', 'us-uk', 'academic'),
('wabash-wns', 'Lessons from the Wabash National Study', 'Wabash College', 'us-uk', 'academic'),
('uni-siegen-sg', 'Studium Generale Qualifikationsziele', 'Universität Siegen', 'germany', 'academic'),
('hcu-sg-netzwerk', 'SG Netzwerk Nord Leitbild', 'HCU Hamburg', 'germany', 'academic'),
('uni-mainz-sg', 'Studium Generale Mainz', 'Universität Mainz', 'germany', 'academic'),
('uni-strasbourg-hu', 'Licence Humanités Strasbourg', 'Université de Strasbourg', 'france', 'academic'),
('univ-lorraine-hu', 'Licence Humanités Metz', 'Université de Lorraine', 'france', 'academic'),
('paris-nanterre-ldd', 'LDD Humanités Nanterre', 'Université Paris Nanterre', 'france', 'academic'),
('twcu-survey', 'Graduate Survey', 'Tokyo Women''s Christian University', 'japan', 'academic'),
('teikyo-employer', 'Employer Survey', 'Teikyo University', 'japan', 'academic'),
('kyoto-ct', 'Critical Thinking Foundations', 'Kyoto University', 'japan', 'academic'),
('yamaguchi-ct', 'Critical Thinking in Career Education', 'Yamaguchi University', 'japan', 'academic');

INSERT OR IGNORE INTO researchers (id, name, institution, region_id, focus_area) VALUES
('blaich', 'Blaich, Charles', 'Wabash College', 'us-uk', 'Wabash National Study; cognitive outcomes'),
('pascarella', 'Pascarella, Ernest', 'Wabash College', 'us-uk', 'Liberal arts cognitive impact'),
('campbell', 'Campbell, David', 'UWisc', 'us-uk', 'Liberal arts and democratic engagement'),
('mcavoy', 'McAvoy, Paula', 'UWisc', 'us-uk', 'Democratic education'),
('hess', 'Hess, Diana', 'UWisc', 'us-uk', 'Classroom discussion and civic engagement'),
('kusumi', 'Kusumi, Takashi', 'Kyoto University', 'japan', 'Critical thinking foundations and measurement');

INSERT OR IGNORE INTO gaps (description, regions_affected, severity) VALUES
('Causal evidence isolating liberal arts from general higher education', 'all', 'critical'),
('Longitudinal tracking of liberal arts graduates vs. specialized', 'all', 'critical'),
('Standardized cross-national outcome comparisons', 'all', 'critical'),
('Equity of access to liberal arts education', 'france,japan', 'moderate'),
('Civic engagement outcome measurement gaps', 'all', 'moderate');

INSERT OR IGNORE INTO meta_analyses (id, title, region_id, key_conclusions) VALUES
('aacu-leap', 'AAC&U LEAP Campaign', 'us-uk', '15-year research: 90% employers value liberal education outcomes; cross-cutting skills > major'),
('wabash-synthesis', 'Wabash National Study Synthesis', 'us-uk', 'Liberal arts colleges produce cognitive gains indirectly via instructional clarity, deep learning, diversity experiences'),
('sg-netzwerk', 'SG Netzwerk Nord Charter', 'germany', 'Collective outcomes framework for German Studium Generale — interdisciplinarity, reflection, participation'),
('french-competency', 'French Humanities Competency Framework', 'france', 'National shift from knowledge-based to competency-based training with transversal skills');
