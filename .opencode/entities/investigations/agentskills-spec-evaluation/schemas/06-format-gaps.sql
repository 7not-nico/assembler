-- organelle: format-gaps
-- membrane: shared-substrate
-- channel: ← meta-manifest
-- purpose: Gaps in our skill format vs agentskills, severity-ordered

INSERT OR IGNORE INTO gaps (id, investigation_id, description, severity, status) VALUES
  ('GAP.DESC.OPT', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'No description trigger-eval loop — skills may not activate when needed or may trigger when irrelevant', 'high', 'searched_disabled'),
  ('GAP.EVAL.FRAMEWORK', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'No eval framework — cannot measure whether skill improves output quality or by how much', 'medium', 'searched_disabled'),
  ('GAP.PROGRESSIVE', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'No progressive disclosure — full SKILL.md loads on activation with no references/ directory', 'medium', 'searched_disabled'),
  ('GAP.SECTION.RIGIDITY', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'audit-skills enforces Trigger/Procedure/Rules/Gotchas for all skills including pure-reference', 'high', 'searched_disabled'),
  ('GAP.DESCRIPTION.LENGTH', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'No hard limit on description length — agentskills enforces 1024 chars', 'low', 'searched_disabled');
