---
description: Check patlib for patterns and terms on a topic and report gaps
subtask: true
---

Check foundations for `$ARGUMENTS`

1. Infer core noun from `$ARGUMENTS` — scope to the domain; action verb excluded. If ambiguous, use question tool to narrow.
2. Query patlib — `read-selection --type patterns --query <noun>` and `read-selection --type terms --query <noun>`. Try 2-3 synonyms on first empty return.
3. Evaluate:
   - Both present → PASS
   - One missing → WARN. Flag: "No <missing-type> for <noun>. Use `skill propose-<type>` to seed."
   - Both missing → FAIL. Flag: "No patterns or terms for <noun>. Use `skill propose-pattern` or `skill propose-term` to seed."
4. Return verdict: PASS, WARN, or FAIL.

**Report:**
- PASS — both present
- WARN — one missing
- FAIL — both missing
