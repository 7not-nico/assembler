-- organelle: doc-authors
-- membrane: shared-substrate
-- channel: ← meta-manifest, ← doc-sections
-- purpose: agentskills.io documentation authors by section

INSERT OR IGNORE INTO researchers (id, investigation_id, region_id, name, role) VALUES
  ('R.ORIGIN', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'R.SPEC', 'Anthropic', 'Original format authors — released as open standard'),
  ('R.SPEC.TEAM', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'R.SPEC', 'agentskills team', 'Specification authors'),
  ('R.BP.TEAM', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'R.BEST.PRACTICES', 'agentskills team', 'Best practices authors'),
  ('R.EVALS.TEAM', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'R.EVALS', 'agentskills team', 'Evaluating skills authors'),
  ('R.DESC.TEAM', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'R.DESCRIPTIONS', 'agentskills team', 'Description optimization authors'),
  ('R.SCRIPTS.TEAM', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'R.SCRIPTS', 'agentskills team', 'Script usage authors');
