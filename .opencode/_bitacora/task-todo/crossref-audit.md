# Cross-reference audit — update refs from TERM.* to COG.*/CON.*

**Maxim refs:** MAX.KNOWLEDGE.CLASSIFICATION (source vectors point to earlier layer)  
**Needed because:** 32 terms were reclassified; any entity referencing TERM.ABSTRACT, TERM.BOUNDED.CONTEXT, etc. now points to a non-existent ID

## Find stale refs
- [ ] grep all .md files for TERM.* IDs that were migrated to COG.* or CON.*
- [ ] grep all .md files for TERM.* IDs that are no longer in terms/ directory

## Update patterns
- TERM.ABSTRACT → CON.ABSTRACT
- TERM.ABSTRACTION → CON.ABSTRACTION
- TERM.BOUNDED.CONTEXT → CON.BOUNDED.CONTEXT
- TERM.COMPUTER.SCIENCE → COG.COMPUTER.SCIENCE
- TERM.MATH → COG.MATH
- TERM.CONCURRENCY → COG.CONCURRENCY
- ... (all 32 migrated items)

## Verify
- [ ] write-sync reports 0 broken references
- [ ] no entity has related: pointing to non-existent ID

---

## 2026-08-01 — protocol rename wave (waves 1-3 applied, illustrations 57→0)

Confirmed waves already applied system-wide (26 + 9 + 6 identity maps + 7 NEX maps in illustrations/skills):
`PROT.TOOL.CUSTOM.DEFINITION→PROT.TOOL.DEFINITION`, `PROT.LIB.MODULE.CONTRACT→PROT.LIB.CONTRACT`,
`PROT.{TYPE}.IDENTITY[.SCHEMA]→PROT.{TYPE}.SCHEMA`, `PROT.MCP.STDIO.TRANSPORT→PROT.MCP.TRANSPORT`,
`PROT.META.PROTOCOL.*→PROT.META.*`, `NEX.* 4-segment→3-segment`, `PROT.TOOL.CLASSIFICATION[.AUTOMATON]→PROT.TOOL.AUTOMATON`,
`PROT.TOOL.PLUGIN.VALIDATION→PROT.TOOL.COMPLIANCE`, `PROT.TOOL.LAYER.CHOICE→NEX.TOOL.CHOICE`.

**Remaining stale IDs (no confirmed target — decision or entity creation needed), counts from `rs check stale-refs`:**

| Stale ID | Count | Options |
|----------|-------|---------|
| PROT.LLM.SPECIFICATION | 22 | create protocol or map to PROT.META.IDENTITY |
| PROT.LIB.DIRECTORY.LAYER | 13 | create or map to PROT.LIB.CONTRACT |
| PROT.TOOL.COMPOSITE | 11 | create or map to PROT.TOOL.COMPOSITE |
| PROT.LIB.PURITY.BOUNDARY | 11 | create or map to PROT.LIB.ENFORCEMENT |
| PROT.LIB.BOUNDARY | 10 | create or map to PROT.LIB.CONTRACT |
| PROT.SEARCH.VECTOR.INDEX | 10 | create or map to PROT.SEARCH.QUERY |
| SPEC.ENTITY.ROUTING.TABLE | 7 | map to SPEC.ENTITY.ROUTING.TABLE |
| PROT.LIB.MUTATION.STRATEGY | 7 | create or defer |

Trailing-dot false positives in sweep (fix regex): `PROT.META.IDENTITY.` (11), `PROT.SEARCH.VECTOR.INDEX.` (7).
Sandbox fixtures (SANDBOX.*) and template boilerplate account for the residual ~2187 — verify scope before acting.

**Flag resolved 2026-08-01:** `PROT.META.IDENTITY.md:16` derived as **PROT.RULE.SCHEMA** (doc's own identity-protocol enumeration, lines 76-78: MAXIM + RULE pairing; same RULE-map iteration corrupted both sites).
