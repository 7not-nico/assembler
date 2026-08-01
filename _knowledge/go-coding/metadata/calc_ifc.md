# calc_ifc.go — all comments

Total comments: 16

## Header

- L13: OBJECT — an interface value holding a (type, value) pair.
- L14: GO.OBJECT §Interface: "an interface value holds a (type, value) pair."
- L15: Declared at top of file — values flow through the computation.
- L18: SUBJECT — the accumulator as a struct.
- L19: Declared after OBJECT — storage location receiving values.
- L24: parseObject — OBJECT: parse a string into an interface value.
- L25: GO.OBJECT §Types: int64 and float64 are distinct typed values.

## Body

- L36: action — ACTION: read operator symbol or "=" print command.
- L37: IFC statement structure: subject → action → object.
- L64: SUBJECT: read until valid or exit.
- L79: GO.ACTION: type switch — dispatch by concrete type
- L93: ACTION: read operator until valid or exit.
- L103: OBJECT: read operand until valid or exit.
- L113: GO.ACTION: type switch — extract concrete numeric value
- L114: GO.OBJECT §Interface: "interface value holds (type, value) pair"
- L126: GO.ACTION: expression evaluation through shared functional core