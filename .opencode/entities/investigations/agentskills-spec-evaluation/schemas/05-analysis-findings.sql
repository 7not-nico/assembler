-- organelle: analysis-findings
-- membrane: shared-substrate
-- channel: ← meta-manifest
-- purpose: Comparative analysis findings from the spec evaluation

INSERT OR IGNORE INTO meta_analyses (id, investigation_id, title, key_finding, our_status, priority) VALUES
  ('MA.BODY.FREEDOM', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Body Section Enforcement Trade-off',
   'agentskills body freedom allows reference-table and workflow skills to coexist without audit friction. Our rigid section enforcement adds overhead for pure-reference skills.',
   'audit-skills fails reference-only skills (4 violations)', 'high'),
  ('MA.DESC.PRINCIPLES', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Description Writing Principles',
   'agentskills prescribes 4 writing principles: imperative phrasing, focus on user intent, err on pushy side, keep concise under 1024 chars. Our descriptions are static, no principles applied, no trigger testing.',
   'No writing principles or iterative refinement', 'medium'),
  ('MA.DESC.OPT', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Description Trigger Eval Loop',
   '20 queries (8-10 should-trigger, 8-10 should-not), vary phrasing/explicitness/detail/complexity, near-misses, 3 runs each, threshold 0.5, train/val ~60/40 split, loop: evaluate→identify→revise→repeat ≤5 iterations, select best by validation pass rate. skill-creator Skill automates. We have none of this.',
   'No trigger testing or optimization loop', 'medium'),
  ('MA.EVAL.FRAMEWORK', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Eval Framework — Test + Grade',
   'agentskills provides full pipeline: test cases (evals.json), assertions (verifiable pass/fail with concrete evidence), grading (grading.json with evidence), blind LLM comparison, benchmark aggregation (with/without/delta from benchmark.json). We have nothing comparable.',
   'No test case framework, no assertions, no grading', 'low'),
  ('MA.EVAL.PATTERNS', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Eval — Pattern Analysis',
   '5 analysis patterns: remove always-pass assertions, investigate always-fail, study pass-with-skill, tighten inconsistent runs, check time/token outliers. We have none.',
   'No eval data to analyze', 'low'),
  ('MA.EVAL.HUMAN', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Eval — Human Review + Iteration',
   'feedback.json with actionable feedback. 5-step iteration: signal→LLM→revise→rerun→grade→review. Guidelines: generalize, keep lean, explain why, bundle. Stop when satisfied. We have none.',
   'No human review or iteration process', 'low'),
  ('MA.PROGRESSIVE', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Progressive Disclosure Advantage',
   'agentskills three-tier loading (metadata→body→refs) minimizes context footprint. Our audit loads full SKILL.md on activation with no references/ directory.',
   'Full file loaded at activation', 'medium'),
  ('MA.STATE.PROFILE', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'State Profile Advantage',
   'Our state-profile field (stateless, stateful-reader, stateful-writer, stateful-auditor, hybrid) tells agent whether skill maintains state. agentskills has no equivalent.',
   'Unique advantage — keep field', 'high'),
  ('MA.BP.PATTERNS', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Best Practices Patterns',
   'agentskills recommends 6 instruction patterns: gotchas (highest-value), templates (reliable via pattern-matching), checklists (progress tracking), validation loops (self-correct), plan-validate-execute (batch/destructive ops), bundling scripts (reusable logic). We use gotchas and bundling but not the other four.',
   'Partial adoption — gotchas + bundling only', 'medium'),
  ('MA.BP.SOURCES', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Source Material Synthesis',
   'agentskills lists 5 concrete artifact types for skill synthesis: runbooks/style guides, API specs/configs, code review/issue trackers, git history/patches, failure cases. We have no equivalent synthesis pipeline.',
   'Skills created from scratch or task extraction only', 'medium'),
  ('MA.BP.REFINEMENT', 'MANIFEST.AGENTSKILLS.SPEC.EVALUATION', 'Real-Execution Refinement',
   'agentskills prescribes execute→revise loop: run skill against real tasks, read execution traces, feed results back. Three root causes of wasted time: vague instructions (multiple approaches tried), inapplicable instructions (agent follows anyway), too many options w/out clear default. We create skills once, rarely revise.',
   'No systematic refinement or trace diagnosis', 'medium');
