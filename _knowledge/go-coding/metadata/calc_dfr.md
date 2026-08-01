# calc_dfr.go — all comments

Total comments: 7

## Header

- L13: OBJECT — one deferred step: operator and operand value.
- L14: Declared at top of file — values flow through the computation.
- L20: SUBJECT — the accumulator variable.
- L21: Declared after OBJECT — storage location receiving values.

## Body

- L33: OBJECT: collect a batch of operand steps
- L74: ACTION: deferred LIFO execution via function dispatch.
- L75: SUBJECT (acc) captured by reference; OBJECT (val) by value.