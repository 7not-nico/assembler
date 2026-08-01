# calc_sao.go — all comments

Total comments: 46

## Header

- L1: ── Variant: SAO ── subject → action → object (infix) ────
- L2: 
- L3: Go semantic map:
- L4: subject: accumulator (float64 variable)
- L5: GO.SUBJECT: storage location, static type float64
- L6: 
- L7: action: operator symbol
- L8: GO.ACTION: selects expression kind (+, -, *, /, **)
- L9: 
- L10: object: operand value
- L11: GO.OBJECT: typed float64 value from input
- L12: 
- L13: Syntax:  5 + 3
- L14: subject(5) → action(+) → object(3) → new subject(8)
- L15: 
- L16: This is the standard infix notation. The expression is parsed as a single
- L17: line from input, tokenized, then evaluated left-to-right.
- L18: 
- L19: GO.ACTION §Order of evaluation: "All function calls... are evaluated in
- L20: lexical left-to-right order."
- L21: 
- L22: Usage:
- L23: go run . sao "5 + 3"
- L24: go run . sao "2 + 3 * 4"
- L25: go run . sao (interactive REPL)
- L26: ─────────────────────────────────────────────────────────
- L41: SAO — infix evaluation domain.
- L44: token — a scanned unit from the input expression.
- L45: GO.OBJECT: struct value holding kind and literal.
- L51: scan — tokenizes infix expression string.
- L52: GO.ACTION: program text → token stream (lexical analysis).
- L53: Each token is a GO.OBJECT (typed struct value).

## Body

- L76: operator
- L92: evaluate — parses and evaluates infix expression.
- L93: Flow: subject → action → object → new subject → action → object → ...
- L94: 
- L95: GO.ACTION: expression evaluation with left-to-right ordering.
- L102: GO.SUBJECT: first number is the initial accumulator
- L112: GO.ACTION: for loop — sequential evaluation
- L114: GO.ACTION: operator (binary expression kind)
- L121: GO.OBJECT: operand value
- L131: GO.ACTION: expression evaluation
- L137: subject is now the new accumulator for next iteration
- L143: runSAO — main entry: CLI arg or interactive REPL.
- L146: GO.ACTION: expression evaluation from CLI argument
- L158: Interactive REPL