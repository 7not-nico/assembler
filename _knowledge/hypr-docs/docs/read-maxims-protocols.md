---
name: read-maxims-protocols
description: Use this skill when starting any task — it reads all maxims then all protocols then relevant rules to ground decisions in the full system philosophy, contract surface, and constraint management principles
state-profile: stateless
related: ["RUL.QUERY.PATLIB.CONTEXT", "RUL.DECLARATIVE.OVER.IMPERATIVE", "RUL.AVOID.NEGATION.PRIMING", "RUL.CONSTRAINT.SATURATION.LIMIT", "RUL.POSITIVE.NEGATIVE.RATIO", "RUL.BRIDGE.CONSTRAINT", "RUL.OUTPUT.SHAPE.SPECIFICATION"]
---

**Procedure**

1. **Read all maxims** — `.opencode/entities/maxims/` — grounds every decision in the system's guiding aphorisms. Maxims encode universal principles (entity ontology, knowledge classification, DRY, orthogonality, etc.) that apply session-wide.

2. **Read all protocols** — `.opencode/entities/protocols/` — grounds every technical decision in the system's contract surface. Protocols define schema, enforcement rules, and boundaries for every entity type and tool class.

3. **Read relevant instruction-writing rules** — RUL.DECLARATIVE.OVER.IMPERATIVE, RUL.AVOID.NEGATION.PRIMING, RUL.CONSTRAINT.SATURATION.LIMIT, RUL.POSITIVE.NEGATIVE.RATIO, RUL.BRIDGE.CONSTRAINT, RUL.OUTPUT.SHAPE.SPECIFICATION — grounds LLM-facing instructions in mechanistic evidence for constraint capacity, register, ratio, conflict resolution, and output shape.

4. **Proceed with task** — all subsequent decisions are already grounded. Re-read only when context is lost or when switching to a domain not covered by the initial read.

**Gotchas**

- **Protocols read before maxims** — execution order reversed. Read maxims first (Ring 0 philosophy), then protocols (contracts), then rules (constraint management)
- **Only maxims or only protocols read** — one type skipped entirely. Read all three: maxims ground philosophy, protocols define contracts, rules set instruction-writing constraints
- **Session context lost mid-task** — working memory reset without re-read. Re-read maxims, then protocols, then rules — do not rely on training memory
- **Skill applied after task started** — read invoked mid-execution. Apply this skill before any task — it is a prerequisite
- **Instruction-writing rules skipped for non-instruction tasks** — rules apply only when LLM-facing instructions are authored. Entity-only tasks (term declaration, pattern audit) exempt

**Rules**

- Session-level, resets per session — read maxims first, then protocols, then instruction-writing rules
- Maxims first (philosophy), protocols second (contracts), rules third (constraint management)
- Re-read recovery when working memory resets mid-session
- Applies before ANY task — not just ML declaration
- Instruction-writing rules are conditional: load only when task involves authoring or editing LLM-facing instructions
