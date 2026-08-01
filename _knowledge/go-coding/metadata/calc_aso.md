# calc_aso.go — all comments

Total comments: 24

## Header

- L1: ── Variant: ASO ── action → subject → object ────────────
- L2: 
- L3: Semantic map:
- L4: action:  operator symbol chosen first
- L5: GO.ACTION: selects expression kind before any operand
- L6: 
- L7: subject: left operand (accumulator variable)
- L8: GO.SUBJECT: storage location for running total
- L9: 
- L10: object: right operand (input value)
- L11: GO.OBJECT: typed float64 value applied to subject
- L12: 
- L13: Syntax: + 5 3
- L14: action(+) → subject(5) → object(3) → new subject(8)
- L15: Reading: "add 5 and 3" — action leads sentence.
- L16: 
- L17: Usage:
- L18: go run . aso
- L19: ─────────────────────────────────────────────────────────
- L32: runASO — shell: action → subject → object.

## Body

- L41: GO.ACTION: operator first — selects evaluation rule
- L47: GO.SUBJECT: left operand — initializes accumulator
- L53: GO.OBJECT: right operand — transient value
- L59: GO.ACTION: expression evaluation