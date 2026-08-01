-- organelle: doc-sections
-- membrane: shared-substrate
-- channel: ← meta-manifest
-- purpose: agentskills website sections mapped as investigation regions

INSERT OR IGNORE INTO regions (id, investigation_id, name, description) VALUES
  ('R.SPEC', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Specification', 'Core SKILL.md format — frontmatter fields, body conventions, directory structure, progressive disclosure, validation'),
  ('R.BEST.PRACTICES', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Best Practices', 'Skill creation guidance — scope calibration, context budgeting, control calibration, gotchas, templates, checklists'),
  ('R.EVALS', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Evaluating Skills', 'Test case design, evals execution, assertions, grading, benchmark aggregation, iteration loop'),
  ('R.DESCRIPTIONS', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Optimizing Descriptions', 'Trigger eval methodology, training/validation split, description revision loop'),
  ('R.SCRIPTS', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Using Scripts', 'One-off commands, self-contained scripts with inline deps, agentic script design');
