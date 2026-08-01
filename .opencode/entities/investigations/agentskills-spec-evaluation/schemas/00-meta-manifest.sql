-- organelle: meta-manifest
-- membrane: shared-substrate
-- channel: none
-- purpose: Investigation manifest — the agentskills spec evaluation itself

INSERT OR IGNORE INTO investigations (id, title, summary, tags) VALUES
  ('MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Agentskills.io Skill Format Evaluation',
   'Compare agentskills.io specification against the assembler project''s skill format across structural completeness, discoverability, maintainability, and real-world usefulness. Single-source evaluation of five agentskills pages (specification, best practices, evaluating skills, optimizing descriptions, using scripts).',
   'skill,format,specification,audit,evaluation,compartment');
