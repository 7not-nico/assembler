# read-maxims-protocols — Design Grounding

**Purpose** — prerequisite before every design or implementation decision.

## Procedure

1. Read all maxims — `.opencode/entities/maxims/` — system philosophy, guiding aphorisms
2. Read all protocols — `.opencode/entities/protocols/` — technical contracts, schema, enforcement
3. Read instruction-writing rules — `RUL.DECLARATIVE.OVER.IMPERATIVE`, `RUL.AVOID.NEGATION.PRIMING`, `RUL.CONSTRAINT.SATURATION.LIMIT`, `RUL.POSITIVE.NEGATIVE.RATIO`, `RUL.BRIDGE.CONSTRAINT`, `RUL.OUTPUT.SHAPE.SPECIFICATION`
4. Proceed — all subsequent decisions already grounded

## Execution Order

```text
maxims (Ring 0 philosophy)
  ↓
protocols (technical contracts)
  ↓
rules (constraint management)
```

## Recovery

- Session context lost mid-task → re-read maxims, then protocols, then rules
- Instruction-writing rules conditional: load only when authoring LLM-facing instructions
- Entity-only tasks (term declaration, pattern audit) exempt from instruction-writing rules
