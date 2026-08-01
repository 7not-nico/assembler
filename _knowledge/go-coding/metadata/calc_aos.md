# calc_aos.go — all comments

Total comments: 23

## Header

- L1: ── Variant: AOS ── action → object → subject (Polish) ───
- L2: 
- L3: Semantic map:
- L4: action:  operator chosen first (evaluation rule)
- L5: GO.ACTION: selects expression kind before any operand
- L6: 
- L7: object:  operand entered one at a time (fold-left)
- L8: GO.OBJECT: typed float64 value folded into subject
- L9: 
- L10: subject: running total, updated per application
- L11: GO.SUBJECT: variable carrying accumulated state
- L12: 
- L13: Syntax: + 5 3
- L14: action(+) → object₁(5) → [subject=5] → object₂(3) → [action: 5+3=8]
- L15: 
- L16: Usage:
- L17: go run . aos
- L18: ─────────────────────────────────────────────────────────
- L31: runAOS — shell: action → object → subject (Polish).

## Body

- L40: GO.ACTION: operator first — selects evaluation rule
- L46: GO.SUBJECT: starts nil, first object becomes initial subject
- L51: GO.OBJECT: operand entered one at a time
- L61: GO.ACTION: expression evaluation — fold object into subject