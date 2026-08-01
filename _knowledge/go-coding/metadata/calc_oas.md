# calc_oas.go — all comments

Total comments: 29

## Header

- L1: ── Variant: OAS ── object → action → subject ────────────
- L2: 
- L3: Semantic map:
- L4: object:  right operand entered first (transient value)
- L5: GO.OBJECT: typed float64 value — the non-accumulator operand
- L6: 
- L7: action:  operator symbol
- L8: GO.ACTION: selects expression kind
- L9: 
- L10: subject: left operand (accumulator storage)
- L11: GO.SUBJECT: variable holding running total
- L12: 
- L13: Syntax: 3 + 5
- L14: object(3) → action(+) → subject(5) → new subject(8)
- L15: Reading: "3 plus 5" — object, operator, subject.
- L16: 
- L17: Semantically distinct from SAO:
- L18: SAO: subject + object — 5 is accumulator, 3 is operand
- L19: OAS: object + subject — 3 is operand, 5 is accumulator
- L20: The Subject (persistent) and Object (transient) roles are swapped.
- L21: 
- L22: Usage:
- L23: go run . oas
- L24: ─────────────────────────────────────────────────────────
- L37: runOAS — shell: object → action → subject.

## Body

- L46: GO.OBJECT: transient operand first
- L52: GO.ACTION: operator symbol — selects evaluation rule
- L58: GO.SUBJECT: accumulator — persistent storage
- L64: GO.ACTION: expression evaluation