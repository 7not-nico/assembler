# calc_stk.go — all comments

Total comments: 35

## Header

- L1: ── Variant: STK ── stack-based (Forth-style) ───────────
- L2: 
- L3: Go semantic map:
- L4: subject: stack as []float64 slice
- L5: GO.SUBJECT: dynamic slice — LIFO data structure carrying all state
- L6: FORTH.SUBJECT: "Forth carries all state on a LIFO data stack"
- L7: 
- L8: object: value pushed onto stack
- L9: GO.OBJECT: typed float64 value pushed as stack cell
- L10: FORTH.OBJECT: stack cell value
- L11: 
- L12: action: word execution — operator consumes from stack, leaves result
- L13: GO.ACTION: expression evaluation via operator words
- L14: FORTH.ACTION: "word execution" — consumes from stack, leaves result
- L15: 
- L16: Syntax:
- L17: 1 2 + .       → 3        push 1, push 2, add, print top
- L18: 5 3 - .       → 2
- L19: 3 4 + 2 * .   → 14
- L20: 
- L21: Usage:
- L22: go run . stk
- L23: ─────────────────────────────────────────────────────────
- L38: runSTK — main loop: stack-based evaluation.

## Body

- L42: GO.SUBJECT: stack as dynamic slice — LIFO storage
- L43: GO.SUBJECT §Structured variables: slice elements individually addressable
- L68: GO.ACTION: word execution — consumes stack, produces result
- L73: Peek without popping yet — validate first
- L77: GO.ACTION: if statement — guard division by zero
- L83: GO.SUBJECT: pop both — validation passed
- L87: GO.ACTION: expression evaluation
- L94: GO.OBJECT: push result back onto subject
- L98: GO.ACTION: dot word — inspect top of stack
- L106: GO.ACTION: reset subject
- L111: GO.OBJECT: parse as numeric value, push onto subject