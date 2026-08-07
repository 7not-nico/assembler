# Control flow

ZScript statements and expressions (ch008, ch012) form a C-like core with language-specific extensions.

## Statement surface

```text
C-like             compound, expression, if, switch, for/while/do-while,
                   continue/break/return, local variable
ZScript-specific   multi-assignment, null statement
```

## Expression surface

```text
primary, postfix, unary, binary, assignment, ternary
vector and color literal expressions
lazy boolean expressions — short-circuit evaluation
type-comparison expressions
signed-difference expressions
scope expressions — resolution against scope state
concatenation, arithmetic, comparison, logical
```

## Notable extensions

- Multi-assignment statements bind several targets in one statement
- Lazy-boolean semantics defer evaluation; side effects in later operands may not run
- Scope expressions couple evaluation to the active object scope
