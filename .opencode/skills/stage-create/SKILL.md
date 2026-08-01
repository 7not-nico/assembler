---
name: stage-create
description: Use this skill when creating multiple related entities — it creates them one at a time, auditing each step before proceeding
state-profile: stateful-writer
related: ["SKL.VET.PROPOSAL", "SKL.PRUNE.STALE"]
---
**Procedure**

1. Plan — list all entities, identify cross-dependencies, determine creation order
2. Gate — run SKL.VET.PROPOSAL on each proposal. Proceed only after all proposals pass
3. For each entity in order:
   a. Create the file
   b. Run `write-sync` for its type
   c. Run `read-projection` to verify sync
   d. Run the type-specific audit (audit-pattern, audit-term, audit-skill, audit-rule)
   e. Fix any audit violations, resync, re-audit until clean. Then proceed
4. Cross-ref pass — update entities that reference later-created entities, sync, re-audit
5. Final `write-sync all`
6. Final audit — verify all cross-references resolve, zero violations across all entities
7. Prune stale — run SKL.PRUNE.STALE to remove stale DB entries

**Gotchas**

- Creating multiple files in sequence ensures each entity passes gate-by-gate validation before the next begins. Step 3 enforces this
- A step N audit violation halts progression. Fix the violation, resync, re-audit, then advance to step N+1
- Cross-references to entities absent from creation queue — recorded as pending in step 1, resolved in dedicated cross-ref pass (step 4)
- The skill itself must pass its own procedure — create it, sync, audit

**Rules**

- Each entity passes its type audit before the next entity starts
- Sync each entity in the same step as its creation
- Resolve cross-references in a dedicated pass after all initial creations. During-creation resolution excluded
- Run final audit on all entities at completion stage; require zero violations to declare complete
- Vet every proposal through SKL.VET.PROPOSAL before any file is written
