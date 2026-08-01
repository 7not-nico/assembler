---
name: validate-spec
description: Use this skill when verifying LLM specification compliance — it checks instruction files against PROT.LLM.SPECIFICATION rules and reports compliance score and violations
state-profile: stateful-reader
related: ["RUL.USE.LOCAL.MCP", "RUL.DECLARATIVE.OVER.IMPERATIVE", "RUL.AVOID.NEGATION.PRIMING", "RUL.CONSTRAINT.SATURATION.LIMIT", "RUL.POSITIVE.NEGATIVE.RATIO", "RUL.BRIDGE.CONSTRAINT", "RUL.OUTPUT.SHAPE.SPECIFICATION"]
patterns: ["PROT.LLM.SPECIFICATION", "NEX.TOOL.SEQUENCE"]
terms: ["IDENTITY.MCP"]
---

**Validate LLM Specification** — verify every instruction file follows PROT.LLM.SPECIFICATION in its totality.

Apply PROT.LLM.SPECIFICATION in its totality. Selective application excluded.

**Procedure**

1. Run `spec_audit_file` (mcp-spec-audit) on the file — covers 12 mechanically-detectable rules: positive framing, 3:1 ratio, declarative register, concept-boundary priming, constraint budget, structural preference, hard stop redirect, operator hygiene (conjunction, negation, exclusive OR, implication, connectives)

2. For non-mechanical rules outside spec_audit scope — manually check:
   - `RUL.DECLARATIVE.OVER.IMPERATIVE` — declarative register ("X: required") over imperative ("NEVER do X"). Cross-lingual variance reduction 81%
   - `RUL.AVOID.NEGATION.PRIMING` — no forbidden concept named. Use "X: disabled" not "don't use X". Priming failure rate 87.5%
   - `RUL.CONSTRAINT.SATURATION.LIMIT` — ≤5-6 constraints per instruction block. Beyond threshold → ~16% floor
   - `RUL.POSITIVE.NEGATIVE.RATIO` — ≥3:1 positive-to-negative ratio. >40% negatives → instruction-breakdown
   - `RUL.BRIDGE.CONSTRAINT` — bridge constraints reconcile competing requirements. Reduces violations 39%
   - `RUL.OUTPUT.SHAPE.SPECIFICATION` — positive shape requirements ("Output JSON with keys X,Y"), not prohibitions ("Don't add extra fields")
   - Negative constraints limited to hard stops only — binary prohibitions with real consequences
   - Positive leads, negatives last — each section starts with positive instructions
   - Ablation — every added constraint measured before inclusion
   - Out-of-prompt enforcement — move deterministically-checkable constraints out of the prompt

3. Merge results: mechanical violations from `spec_audit_file` + manual findings

4. Summarize — pass/fail count and compliance score

**Gotchas**

- Data-only entity types (terms, abstractions, raw YAML) — behavioral instructions excluded. Skip during validation
- A hard stop and its redirect count as separate items toward the 3:1 ratio. Both included in the count
- `spec_audit_file` handles the 12 mechanical rules — 10 manual checks: declarative register, priming avoidance, saturation limit, positive-negative ratio, bridge constraints, output shape, hard-stop scope, ordering, ablation, enforcement
- `RUL.POSITIVE.NEGATIVE.RATIO` and `RUL.CONSTRAINT.SATURATION.LIMIT` set numeric thresholds. Count prohibitions and constraints explicitly — do not estimate
- Imperative register in system prompts creates language-dependent force — declarative register is universal (Imperative Interference 2026)

**Rules**

- Load PROT.LLM.SPECIFICATION via read-projection before every validation session. Training memory excluded — use read-projection instead
- Run `spec_audit_file` before manual checks — mechanical violations surface first
- Entity types with no behavioral instructions are exempt: terms, abstractions, raw data files
- Report format: per-file violations with section name, line number, and suggested fix
- Final output: pass/fail count and overall compliance score
