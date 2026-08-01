-- Cortical Hierarchy Category Coding — Seed Data
-- Populates all tables from cortical-hierarchy meta-audit

-- Regions
INSERT INTO regions (id, name, hierarchy_level, status) VALUES
  ('V1-V3', 'V1-V3 (Early Visual)', 1, 'PASS'),
  ('V4', 'V4 (Mid-level Visual)', 2, 'PASS'),
  ('LOC-ITC', 'LOC / ITC (Ventral Stream)', 3, 'PASS'),
  ('MTL', 'MTL (Medial Temporal Lobe)', 4, 'PASS'),
  ('LIP-PARIETAL', 'LIP / Parietal', 5, 'PASS'),
  ('MFC-DACC', 'MFC / dACC', 6, 'PASS'),
  ('PFC-OFC', 'PFC / OFC', 7, 'PASS'),
  ('FUND', 'Fundamentals', 0, 'PASS'),
  ('MA', 'Meta-Analyses', 0, 'PASS'),
  ('GAP', 'Gaps', 0, 'PASS');

-- Fundamentals
INSERT INTO fundamentals (id, concept, source, key_idea) VALUES
  ('F.SINGLE', 'Single-neuron category tuning', 'Posani et al. 2024', 'Rare outside primary sensory areas; only categorical at V1-V3 level'),
  ('F.POP', 'Population-level category info', 'Multiple studies', 'Ubiquitous even where single neurons show no category tuning'),
  ('F.GRADIENT', 'Hierarchy gradient', 'Fusi, Miller & Rigotti 2016', 'Dimensionality increases, clustering decreases from sensory to frontal'),
  ('F.REGIMES', 'Two coding regimes', 'Multiple studies', 'Low-dimensional categorical in sensory areas, high-dimensional mixed-selectivity in cognitive areas');

-- Sources
INSERT INTO sources (id, region_id, title, url, year, species, methodology, key_finding, category_tuning_strength, population_level, single_neuron_level) VALUES
  -- V1-V3
  ('V1-V3.ANIMACY', 'V1-V3', 'Animacy and size decoding from V1 populations', 'https://pmc.ncbi.nlm.nih.gov/articles/PMC10312552', null, 'human', 'single-unit', 'Animacy/real-world size decodable from V1 populations', 'weak', 1, 0),
  ('V1-V3.COLOR', 'V1-V3', 'Color categorization boundaries in V1/V2/V4', null, 1996, 'macaque', 'electrophysiology', 'Color categorization boundaries present in V1/V2/V4', 'weak', 1, 0),
  ('V1-V3.SPATIAL', 'V1-V3', 'Spatial frequency and categorical representations', 'https://pmc.ncbi.nlm.nih.gov/articles/PMC6057270', null, 'human', 'MEG', 'Spatial frequency to categorical representations in ~180ms', 'weak', 1, 0),
  ('V1-V3.CLUSTER', 'V1-V3', 'Categorical clustering of color space', null, null, 'human', 'fMRI', 'Categorical clustering of color space emerges in V4v/VO1', 'moderate', 1, 0),
  ('V1-V3.HIGHDIM', 'V1-V3', 'High-dimensional separability in V1', null, 2024, 'mouse', 'single-unit', 'Categorical structure rare, high-dimensional separability maximal', 'none', 1, 0),

  -- V4
  ('V4.FOVEAL', 'V4', 'Foveal category selectivity in V4', null, null, 'human', 'single-unit', '35% foveal units show category selectivity', 'moderate', 0, 1),
  ('V4.SHAPETEXT', 'V4', 'Shape-texture coding continuum in V4', null, 2019, 'macaque', 'single-unit', 'Shape-texture coding continuum', 'weak', 1, 0),
  ('V4.WMCOLOR', 'V4', 'Categorical working memory for color', null, 2021, 'macaque', 'electrophysiology', 'Categorical working memory codes for color', 'moderate', 1, 0),
  ('V4.CONTEXT', 'V4', 'Task context modulation of feature selectivity', null, null, 'macaque', 'single-unit', 'Task context modulates feature selectivity', 'moderate', 1, 0),
  ('V4.DOMAINS', 'V4', 'Functional domains in V4', 'https://pmc.ncbi.nlm.nih.gov/articles/PMC4912377', null, 'macaque', 'fMRI', 'Functional domains for color, luminance, orientation', 'none', 1, 0),

  -- LOC/ITC
  ('LOC.SHAPE', 'LOC-ITC', 'Shape-dominant coding in human LOC', null, 2024, 'human', 'single-unit', 'Shape-dominant: ~3% single-channel category-only, 48% shape×category interaction', 'weak', 1, 0),
  ('LOC.ANIMATE', 'LOC-ITC', 'Animate-inanimate organization in IT', 'https://pmc.ncbi.nlm.nih.gov/articles/PMC10124953', null, 'human', 'fMRI', 'Animate-inanimate primary organizing dimension, not aspect ratio', 'moderate', 1, 0),
  ('LOC.SHAPESIM', 'LOC-ITC', 'Shape similarity vs semantic membership in IT', null, 2013, 'macaque', 'single-unit', 'Shape similarity > semantic membership for IT representations', 'weak', 1, 0),
  ('LOC.GRADIENT', 'LOC-ITC', 'Orthogonal shape/category gradients', null, 2020, 'human', 'fMRI', 'Orthogonal gradients: shape in V1, category in anterior VTC', 'moderate', 1, 0),

  -- MTL
  ('MTL.CONCEPT', 'MTL', 'Concept cells in MTL', null, 2025, 'human', 'single-unit', 'Concept cells: sparse, invariant semantic representations', 'strong', 0, 1),
  ('MTL.REGION', 'MTL', 'Region-based feature coding', 'https://pmc.ncbi.nlm.nih.gov/articles/PMC11811184', null, 'human', 'single-unit', 'Neurons respond to feature-space regions, not categories per se', 'moderate', 0, 1),
  ('MTL.TUNING', 'MTL', 'Semantic tuning curves', null, 2025, 'human', 'single-unit', 'Graded, sigmoidal responses along semantic dimensions', 'moderate', 0, 1),
  ('MTL.HIERARCHY', 'MTL', 'Abstract semantic hierarchy in MTL', null, 2019, 'human', 'single-unit', 'Fruit to food to natural things encoded at population level', 'moderate', 1, 0),
  ('MTL.RELATION', 'MTL', 'Flexible abstract relations in concept cells', 'https://pmc.ncbi.nlm.nih.gov/articles/PMC8545952', null, 'human', 'single-unit', 'Concept cells flexibly encode abstract relations between concepts', 'strong', 0, 1),

  -- LIP/Parietal
  ('LIP.STRONGEST', 'LIP-PARIETAL', 'LIP category signals', null, 2012, 'macaque', 'single-unit', 'LIP shows strongest, earliest category signals, stronger than PFC', 'strong', 0, 1),
  ('LIP.CAUSAL', 'LIP-PARIETAL', 'Causal role of LIP in categorization', null, 2019, 'macaque', 'inactivation', 'Inactivation of LIP impairs categorical decisions', 'strong', 0, 1),
  ('LIP.MANIFOLD', 'LIP-PARIETAL', 'Decision manifolds in LIP', 'https://pmc.ncbi.nlm.nih.gov/articles/PMC8273140', null, 'macaque', 'single-unit', 'Curved decision manifolds: task-dependent rotation in state space', 'strong', 0, 1),
  ('LIP.VSMIP', 'LIP-PARIETAL', 'LIP vs MIP in categorization', null, 2013, 'macaque', 'single-unit', 'LIP more involved in categorization, MIP in motor response', 'strong', 0, 1),
  ('LIP.MST', 'LIP-PARIETAL', 'MST category encoding', null, 2022, 'macaque', 'single-unit', 'MST also shows robust category encoding', 'moderate', 0, 1),

  -- MFC/dACC
  ('MFC.SUBSPACE', 'MFC-DACC', 'Population subspaces in MFC', null, 2020, 'macaque', 'single-unit', 'Separate population subspaces for memory vs categorization decisions', 'strong', 0, 1),
  ('MFC.PRESMA', 'MFC-DACC', 'Pre-SMA categorical boundaries', null, 2018, 'human', 'single-unit', 'Pre-SMA encodes categorical boundaries for time intervals', 'moderate', 0, 1),
  ('MFC.DACC', 'MFC-DACC', 'dACC cognitive load encoding', 'https://pmc.ncbi.nlm.nih.gov/articles/PMC3416924', null, 'human', 'fMRI', 'dACC neurons encode cognitive load, conflict adaptation', 'moderate', 1, 0),
  ('MFC.THETA', 'MFC-DACC', 'MFC-HA theta-phase locking', null, 2020, 'macaque', 'LFP', 'MFC-HA theta-phase locking selectively engaged during memory retrieval', 'moderate', 0, 1),
  ('MFC.UTILITY', 'MFC-DACC', 'Pre-SMA utility signal', null, 2023, 'human', 'single-unit', 'Pre-SMA encodes integrated utility signal for value-based choice', 'moderate', 0, 1),

  -- PFC/OFC
  ('PFC.CLUSTERS', 'PFC-OFC', 'OFC categorical clusters', null, 2019, 'macaque', 'single-unit', 'OFC neurons form ~9 categorical clusters, each encoding a single decision variable', 'strong', 0, 1),
  ('PFC.VARIABLES', 'PFC-OFC', 'Decision variables in OFC', null, 2019, 'macaque', 'single-unit', 'Decision variables: confidence, integrated value, reward size categorically encoded', 'strong', 0, 1),
  ('PFC.RULEPROTO', 'PFC-OFC', 'dlPFC and vmPFC categorization', null, null, 'human', 'fMRI', 'dlPFC: rule-based; vmPFC: prototype learning, attention to diagnostic features', 'moderate', 1, 0),
  ('PFC.ABSTRACT', 'PFC-OFC', 'Abstract category in lateral PFC', null, null, 'macaque', 'single-unit', 'Lateral PFC: abstract category representations for visual stimuli', 'strong', 0, 1),
  ('PFC.VALUE', 'PFC-OFC', 'Value and choice in OFC', null, 2020, 'macaque', 'single-unit', 'Value and choice are separable, stable population representations in OFC', 'strong', 0, 1);

-- Meta-analyses
INSERT INTO meta_analyses (id, citation, scope, key_finding, url) VALUES
  ('MA.POSANI', 'Posani et al. 2024 (bioRxiv)', '43 cortical regions in mice', 'Categorical only in primary sensory; high-dimensional code elsewhere; max separability everywhere', null),
  ('MA.FUSI', 'Fusi, Miller & Rigotti 2016 (Curr Opin Neurobiol)', 'Review: mixed selectivity', 'High-dimensional representations enable flexible linear readout', null),
  ('MA.KOURTZI', 'Kourtzi & Connor 2011 (Annu Rev Neurosci)', 'Object representations', 'Shape, category, and adaptive coding across ventral stream', null),
  ('MA.FREEDMAN', 'Freedman & Assad 2011 (Nat Neurosci)', 'Common mechanism review', 'Category and perceptual decisions share neural substrate in parietal', null),
  ('MA.MONETA', 'Moneta, Grossman & Schuck 2024 (TINS)', 'OFC/vmPFC', 'Task states and values integrated; mixed selectivity common', null);

-- Researchers
INSERT INTO researchers (id, name, region_id, institution, focus_area) VALUES
  ('R.DICARLO', 'James DiCarlo', 'V1-V3', 'MIT', 'V1 population coding, object recognition'),
  ('R.CONNOR', 'Charles Connor', 'V1-V3', 'Johns Hopkins', 'V1 shape coding'),
  ('R.PASUPATHY', 'Anitha Pasupathy', 'V1-V3', 'U Washington', 'V4 shape and category selectivity'),
  ('R.LIVINGSTONE', 'Margaret Livingstone', 'V1-V3', 'Harvard', 'Color vision, V1 organization'),
  ('R.OPDEBEECK', 'Hans Op de Beeck', 'LOC-ITC', 'KU Leuven', 'LOC shape processing'),
  ('R.JANSSEN', 'Peter Janssen', 'LOC-ITC', 'KU Leuven', 'ITC 3D shape coding'),
  ('R.GRILLSPECTOR', 'Kalanit Grill-Spector', 'LOC-ITC', 'Stanford', 'LOC functional organization'),
  ('R.KANWISHER', 'Nancy Kanwisher', 'LOC-ITC', 'MIT', 'Face processing, category specificity'),
  ('R.RUTISHAUSER', 'Ueli Rutishauser', 'MTL', 'Cedars-Sinai', 'Human MTL single-unit, concept cells'),
  ('R.QUIANQUIROGA', 'Rodrigo Quian Quiroga', 'MTL', 'University of Leicester', 'Concept cells, hippocampal coding'),
  ('R.KREIMAN', 'Gabriel Kreiman', 'MTL', 'Harvard', 'Visual memory, MTL recordings'),
  ('R.MORMANN', 'Florian Mormann', 'MTL', 'University of Bonn', 'Human MTL, category selectivity'),
  ('R.FREEDMAN', 'David Freedman', 'LIP-PARIETAL', 'University of Chicago', 'LIP category coding, decision making'),
  ('R.SHADLEN', 'Michael Shadlen', 'LIP-PARIETAL', 'Columbia', 'LIP decision signals, integration-to-bound'),
  ('R.HUK', 'Alexander Huk', 'LIP-PARIETAL', 'UT Austin', 'LIP motion processing, decision'),
  ('R.GOLD', 'Joshua Gold', 'LIP-PARIETAL', 'UPenn', 'LIP perceptual decision making'),
  ('R.RUSHWORTH', 'Matthew Rushworth', 'MFC-DACC', 'Oxford', 'MFC, social decision making'),
  ('R.KOLLING', 'Nicolas Kolling', 'MFC-DACC', 'Oxford', 'MFC, value-based choice'),
  ('R.PROCYK', 'Emmanuel Procyk', 'MFC-DACC', 'Lyon', 'dACC, behavioral adaptation'),
  ('R.HOLROYD', 'Clay Holroyd', 'MFC-DACC', 'UC Santa Cruz', 'dACC, reinforcement learning'),
  ('R.PADOASCHIOPPA', 'Camillo Padoa-Schioppa', 'PFC-OFC', 'Washington U', 'OFC, economic decision making'),
  ('R.WALLIS', 'Jonathan Wallis', 'PFC-OFC', 'UC Berkeley', 'OFC, value encoding'),
  ('R.MILLER', 'Earl Miller', 'PFC-OFC', 'MIT', 'PFC, cognitive control, category'),
  ('R.KEPECS', 'Adam Kepecs', 'PFC-OFC', 'Washington U', 'OFC, confidence, decision variables'),
  ('R.SCHOENBAUM', 'Geoffrey Schoenbaum', 'PFC-OFC', 'NIDA', 'OFC, learning, value');

-- Gaps
INSERT INTO gaps (id, area, description, severity) VALUES
  ('GAP.MICRO', 'Within-area microarchitecture', 'How do categorical clusters form at columnar scale in humans?', 'high'),
  ('GAP.HOMOLOGY', 'Cross-species homology', 'Human LOC to macaque ITC/TE/TEO mapping still debated', 'high'),
  ('GAP.DEVELOPMENT', 'Development', 'How do categorical representations emerge during learning?', 'medium'),
  ('GAP.CAUSAL', 'Causal interactions', 'Most evidence correlational; inactivation only in monkey LIP and PFC', 'high'),
  ('GAP.NATURAL', 'Naturalistic stimuli', 'Most studies use controlled lab stimuli', 'medium'),
  ('GAP.HUMAN', 'Single-neuron human data', 'Only available from epilepsy patients', 'high'),
  ('GAP.EXEMPLAR', 'Within-category structure', 'How are exemplars organized within a category representation?', 'medium');
