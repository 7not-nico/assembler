---
name: vet-proposal
description: Use this skill when vetting proposals — it critically evaluates proposals for new patterns, terms, skills, or rules before creation
state-profile: hybrid
related: ["SKL.JUDGE.SEMANTIC"]
---
**Procedure**

When evaluating a proposal:

1. Essential — state the problem in your own words. What concrete gap does this fill? Explain why it matters; ambiguous value excluded
2. Entity type — confirm pattern vs term vs rule. Type mismatch → flag for reassignment
3. Existence — run the type-specific propose-* skill (propose-pattern, propose-term, propose-rule) to confirm no exact match. For semantic overlap, delegate to SKL.JUDGE.SEMANTIC.
4. Type-specific — for terms: 3+ quality references with title+url. For patterns: actionable principle.
5. Orthogonality — would this ripple across existing files? If yes, flag coupling.
6. Quality — is this the thinnest viable version? Any defects in the proposal itself (vague title, weak tags)?
7. Verdict — pass/fail with reasons per check. If fail, suggest alternative.

**Gotchas**

- Essential test requires a concrete gap — "it would be useful to document X" is insufficient. What breaks without it?
- This skill delegates existence checking to propose-* skills — evaluates only. Duplication excluded
- If all checks pass and the proposal still feels wrong, trust your judgement. The skill is a tool, thinking excluded from replacement
- Proposing a pattern when a rule already covers the same ground is a common mistake — flag it

**Rules**

- Entity type must match SPEC.ENTITY.DISTINCTION.BOUNDARY
- Terms require 3+ references with title and URL
- Patterns require actionable principle
- Verdict must cite specific reason per failed check
- Delegates to propose-* skills for exact-match checking; semantic overlap is the skill's domain
