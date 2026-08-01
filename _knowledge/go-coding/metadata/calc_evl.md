# calc_evl.go — all comments

Total comments: 9

## Header

- L13: OBJECT — a thunk: delayed computation returning a value.
- L14: GO.OBJECT §Function literals: closures capture surrounding scope.
- L17: lit — OBJECT: wraps an immediate value as a thunk.

## Body

- L22: bin — OBJECT: thunk combinator from calc.Operator.
- L23: GO.ACTION: expression evaluation deferred until forced.
- L36: thunkBin — ACTION: dispatch table mapping op symbol to thunk combinator.
- L37: GO.OBJECT: function values map operator symbol to combinator.
- L46: SUBJECT — the EVL state: current thunk and named thunk store.
- L62: GO.ACTION: function dispatch — no switch, table lookup