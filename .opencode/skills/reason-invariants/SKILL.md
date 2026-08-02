---
name: reason-invariants
description: Use this skill before and during any work in an invariant-bearing layer — identify the governing state facts, check them against the invariant/ files, reason about their violation signatures, and confirm the enforcement chain holds. Reference NEX.TOOL.SEQUENCE for the validation workflow
state-profile: hybrid
nexus: NEX.TOOL.SEQUENCE
---

**Purpose**

Identify the always-true state predicates that govern the work. Verify the current state against them. Reason through violation signatures before acting. Consult the `invariant/` layer first — it precedes all work layers.

**Detection triggers**

Check invariants when any of these hold:

- Work touches a layer with an `invariant/` folder
- Work launches, mutates, or tears down a shared resource (browser, DB, daemon, profile)
- Work writes files, downloads assets, or fixes artifacts at a destination
- Work composes steps across phases and the intermediate state must survive
- A prior run failed and the failure signature matches an invariant violation

**Procedure**

1. **Locate the invariant layer** — find `invariant/` in the project root. List every `{domain}-{constraint}.md` file. Treat the layer as the outermost fact set.

2. **Read the governing invariants** — read the matching invariant files for the task domain. Extract from each:
   - The invariant — one declarative predicate sentence
   - The formal — the good state, the forbidden state, and what the forbidden state means
   - The violation signature — the observable symptom or check that detects the forbidden state
   - The enforced-by chain — precept, pattern, and procedure links

3. **Map the task to the facts** — name the invariants the task preserves and the invariants at risk. Name the forbidden state the task could enter.

4. **Check the current state** — run each violation-signature check before acting. Use the check command from the invariant file (`curl` probe, process count, file existence, DB query). Record PASS or FAIL per invariant.

5. **Trace the enforcement chain** — follow the enforced-by links. Confirm each precept, pattern, and procedure exists and routes the work through it. The invariant cites its enforcers; read the linked files for the mechanism.

6. **Guard the risk surface** — state the enforcement step that keeps each at-risk invariant inside its allowed state. Apply the enforcing procedure's steps, the enforcing pattern's structure, and the enforcing precept's rule.

7. **Re-check after the mutation** — re-run the violation-signature checks after the task's write phase. Confirm the forbidden state stayed unreachable; record the outcome.

8. **Record the instance** — note the date, incident, and outcome in the invariant's `## Instance` section on success. Record the failure signature, the enforcement gap, and the corrective step on violation.

**Reasoning prompts**

Ask these per invariant before acting:

- Which state fact must stay true for this task to be safe?
- What is the exact forbidden state, and which observable symptom reveals it?
- Does the enforcement chain cover this task's path, or does the task route around it?
- Which planned step enters the forbidden state, and which guard prevents it?
- Does the signature check still pass after the mutation?

**Verification checklist**

- [ ] `invariant/` layer located; governing files read
- [ ] Each invariant's formal and violation signature extracted
- [ ] Task mapped: preserved invariants vs at-risk invariants
- [ ] Signature checks run before the mutation; results recorded
- [ ] Enforcement chain traced; no routing around it
- [ ] Signature checks re-run after the mutation
- [ ] Instance section updated with date, incident, outcome

**Gotchas**

- Consult the `invariant/` layer before scripts, bitacora, precepts, or study — it precedes all work layers
- Read the linked enforcement files for the mechanism; the invariant file cites them and restates only the predicate
- A zero-instance state (browser down, DB absent) restores cleanly; the forbidden state appears at the violation count
- Reuse the invariant file's own check commands; ad-hoc checks drift from the signature
