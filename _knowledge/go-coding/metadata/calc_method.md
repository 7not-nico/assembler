# calc_method.go — all comments

Total comments: 53

## Header

- L1: ── Variant: MTH ── subject.action(object) ───────────────
- L2: 
- L3: Go semantic map:
- L4: subject: Accumulator struct wrapping float64
- L5: GO.SUBJECT: struct variable with typed fields
- L6: GO.SUBJECT §Structured variables: "Structured variables of struct types
- L7: have fields that may be addressed individually"
- L8: 
- L9: object: float64 argument passed to method
- L10: GO.OBJECT: value argument in method call
- L11: 
- L12: action: method dispatch — receiver.method(args)
- L13: GO.ACTION (expression): call expression — function/method invocation
- L14: GO.SPEC §Expressions: "A method call is a call expression with a receiver"
- L15: GO.ACTION (assignment): subject = result — new value to storage
- L16: 
- L17: Flow:
- L18: subject → .action(object) → new subject
- L19: subject.add(3) reads as:
- L20: receiver subject   →  method add     →  argument 3  →  return Accumulator
- L21: (GO.SUBJECT)          (GO.ACTION)       (GO.OBJECT)     (new GO.OBJECT)
- L22: 
- L23: Usage:
- L24: go run . method
- L25: ─────────────────────────────────────────────────────────
- L39: Accumulator — a numeric Subject with method-bound Actions.
- L40: GO.SUBJECT: struct variable with typed field.
- L41: GO.SUBJECT §Structured variables: "Structured variables of struct types
- L42: have elements and fields that may be addressed individually."
- L47: add — GO.ACTION: method call expression.
- L48: subject.add(object) → new subject.
- L49: GO.SPEC §Expressions: call expression with receiver.

## Body

- L51: GO.ACTION: binary expression s.value + object
- L55: subtract — GO.ACTION: method call expression.
- L60: multiply — GO.ACTION: method call expression.
- L65: divide — GO.ACTION: method call expression with error return.
- L67: GO.ACTION: if statement — conditional guard
- L74: power — GO.ACTION: method call expression wrapping math.Pow.
- L76: GO.ACTION: function call expression math.Pow(a, b)
- L80: MethodDispatch — holds scanner and method dispatch table.
- L86: subject — reads initial Accumulator value.
- L106: object — reads method argument.
- L126: action — reads method name for dispatch.
- L144: runMethod — main loop: subject.action(object).
- L161: GO.SUBJECT: Accumulator variable initialization
- L167: GO.ACTION: for statement — iteration
- L174: GO.OBJECT: method argument value
- L180: GO.ACTION: call expression — method dispatch
- L181: receiver.method(args) evaluates:
- L182: receiver = subject (GO.SUBJECT)
- L183: method   = add/subtract/... (GO.ACTION: expression)
- L184: args     = obj (GO.OBJECT)
- L192: GO.ACTION: assignment statement — write to mutable Subject