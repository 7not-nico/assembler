# calc_osa.go — all comments

Total comments: 24

## Header

- L1: ── Variant: OSA ── object → subject → action ────────────
- L2: 
- L3: Semantic map:
- L4: object:  operand entered first (topic of computation)
- L5: GO.OBJECT: typed float64 value — what the action will process
- L6: 
- L7: subject: accumulator (storage location)
- L8: GO.SUBJECT: variable holding running total
- L9: 
- L10: action:  operator applied last
- L11: GO.ACTION: expression evaluation using object and subject
- L12: 
- L13: Syntax: 3 5 +
- L14: object(3) → subject(5) → action(+) → new subject(8)
- L15: Reading: "3 and 5, add them" — topic-comment structure.
- L16: 
- L17: Usage:
- L18: go run . osa
- L19: ─────────────────────────────────────────────────────────
- L32: runOSA — shell: object → subject → action.

## Body

- L41: GO.OBJECT: operand first — value to be processed
- L47: GO.SUBJECT: accumulator — storage for running total
- L53: GO.ACTION: operator — selects evaluation rule
- L59: GO.ACTION: expression evaluation