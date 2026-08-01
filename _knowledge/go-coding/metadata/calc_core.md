# calc/core.go — all comments

Total comments: 14

## Header

- L9: Operator — binary function value.
- L10: GO.OBJECT: functions are first-class values in Go.
- L13: Operators — function table, extensible without touching Apply.
- L14: GO.ACTION: each entry is an expression evaluation.
- L28: Apply — pure: delegates to the Operators function table.

## Body

- L37: Compose — higher-order: combines two operators into a pipeline.
- L38: f then g applied to (a, b) then (mid, b).
- L49: ParseValue — pure: parses string to float64.
- L54: Token — a parsed unit: number or operator.
- L60: Scan — pure: tokenizes an infix expression string.
- L98: Evaluate — pure: evaluates an infix expression string left-to-right.
- L135: Reduce — pure: folds operator list over operand list.
- L136: subject starts at 0.0 (zero value). Each action updates it.
- L149: IsOperator — pure: returns true if s is a known operator.