-- Seed: Critical Thinking Development

INSERT OR IGNORE INTO pedagogies (id, name, region, core_activity, evidence_rating) VALUES
('interactional-diversity', 'Interactional diversity', 'US', 'Cross-group interaction across race, politics, religion', 'strong'),
('classroom-deliberation', 'Classroom deliberation & discussion', 'US', 'Structured discussion of controversial issues', 'strong'),
('debate-instruction', 'Debate-based instruction', 'Japan + US', 'Structured advocacy, rebuttal, evidence evaluation', 'moderate'),
('rhetoric-argumentation', 'Rhetoric & argumentation', 'France', 'Text analysis, dissertation, essai across disciplines', 'moderate'),
('interdisciplinary-discourse', 'Interdisciplinary discourse', 'Germany', 'Multi-method exposure across fields', 'emerging');

INSERT OR IGNORE INTO mechanisms (id, name, description) VALUES
(1, 'Cognitive conflict', 'Exposure to perspectives that challenge existing mental models'),
(2, 'Perspective-taking', 'Practice in understanding and articulating viewpoints different from one''s own'),
(3, 'Evidence-based reasoning', 'Demand to construct, evaluate, and defend claims with evidence'),
(4, 'Metacognitive reflection', 'Conscious examination of one''s own thinking processes'),
(5, 'Social accountability', 'Need to justify reasoning to peers with differing views');

INSERT OR IGNORE INTO pedagogy_mechanisms (pedagogy_id, mechanism_id) VALUES
('interactional-diversity', 1),
('interactional-diversity', 2),
('interactional-diversity', 5),
('classroom-deliberation', 1),
('classroom-deliberation', 2),
('classroom-deliberation', 3),
('classroom-deliberation', 4),
('classroom-deliberation', 5),
('debate-instruction', 1),
('debate-instruction', 2),
('debate-instruction', 3),
('debate-instruction', 5),
('rhetoric-argumentation', 1),
('rhetoric-argumentation', 3),
('rhetoric-argumentation', 4),
('interdisciplinary-discourse', 1),
('interdisciplinary-discourse', 4);

INSERT OR IGNORE INTO gaps (description, severity) VALUES
('Standardized CT measurement across pedagogies', 'critical'),
('Long-term retention beyond college', 'critical'),
('Cross-cultural transferability of pedagogy models', 'moderate'),
('Scalability from elite to mass higher education', 'moderate'),
('Online vs. in-person modality effects on CT', 'moderate'),
('Causal isolation from self-selection effects', 'critical');

INSERT OR IGNORE INTO researchers (id, name, institution, focus_area) VALUES
('blaich', 'Blaich, Charles', 'Wabash College', 'Interactional diversity and CT outcomes'),
('pascarella', 'Pascarella, Ernest', 'Wabash College', 'Liberal arts cognitive impact'),
('campbell', 'Campbell, David', 'UWisc', 'Classroom deliberation and democratic engagement'),
('hess', 'Hess, Diana', 'UWisc', 'Controversial issues discussion'),
('mcavoy', 'McAvoy, Paula', 'UWisc', 'Deliberation and political polarization'),
('kusumi', 'Kusumi, Takashi', 'Kyoto University', 'Critical thinking foundations and measurement'),
('gurin', 'Gurin, Patricia', 'University of Michigan', 'Interactional diversity theory'),
('shaffer', 'Shaffer, Timothy', 'NDSU', 'Deliberative pedagogy framework'),
('johnson', 'Johnson, Matthew', 'Central Michigan University', 'Public deliberation andragogy'),
('longo', 'Longo, Nicholas', 'Campus Compact', 'Deliberative pedagogy and civic learning');
