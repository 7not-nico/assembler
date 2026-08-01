---
id:               C.ACTION
language:         C
role:             action
title:            The statement
definition:       A statement specifies an action to be performed
sources:
  - section:      ISO/IEC 9899:1999 §6.8 Statements and blocks
    url:          https://c0x.shape-of-code.com/6.8.html
  - section:      ISO/IEC 9899:1999 §6.5 Expressions
    url:          https://c0x.shape-of-code.com/6.5.html
  - section:      ISO/IEC 9899:1999 §6.5.16 Assignment operators
    url:          https://c0x.shape-of-code.com/6.5.16.html
canonical:        x = 42;
tags:             [statement, operator, expression, side-effect]
status:           draft
precedes:         []
---

## Action

The statement or expression evaluation. The C standard states it directly — a statement is an action.

### Core definition (§6.8)

> 1697 A statement specifies an action to be performed.
>
> 1698 Except as indicated, statements are executed in sequence.
>
> 1699 A block allows a set of declarations and statements to be grouped into one syntactic unit.

The action operates on the Subject (lvalue) and consumes the Object (rvalue). It transforms state through side effects.

### Statement grammar (§6.8)

```
statement:
    labeled-statement      (case, default, label:)
    compound-statement     (block { declaration statement })
    expression-statement   (expr ;)
    selection-statement    (if (expr) stmt [else stmt], switch)
    iteration-statement    (while, do, for)
    jump-statement         (goto, continue, break, return)
```

### Expression evaluation (§6.5)

> 933 An expression is a sequence of operators and operands that specifies computation of a value, or that designates an object or a function, or that generates side effects, or that performs a combination thereof.

Expressions are the finest-grained action. Each operator (arithmetic, relational, bitwise, etc.) defines a specific transformation. Sub-expressions group by precedence and associativity (§6.5 ¶936-948).

### Assignment action (§6.5.16)

> 1279 An assignment operator shall have a modifiable lvalue as its left operand.
>
> 1280 An assignment operator stores a value in the object designated by the left operand.
>
> 1283 The side effect of updating the stored value of the left operand shall occur between the previous and the next sequence point.

Assignment is the canonical Action: it takes a Subject (lvalue) and Object (rvalue), and produces a side effect (state change).

### Action kinds

```c
x = 42;            // expression statement: assignment Action
if (x > 0)         // selection statement: conditional Action
while (n--)        // iteration statement: looping Action
{ int a; a = 1; }  // compound statement: block Action (sequential composition)
return x;          // jump statement: exit Action
label: x = 0;      // labeled statement: target for goto Action
```

### Execution and side effects (§5.1.2.3)

> 184 Evaluation of an expression may produce side effects.
>
> 183 Accessing a volatile object, modifying an object, modifying a file, or calling a function that does any of those operations are all side effects, which are changes in the state of the execution environment.

The Action transforms the Subject's state. The Object arrives (rvalue), the Action applies (operator/statement), the Subject changes (side effect). Sequence points separate actions — between them, the order of side effects from subexpressions is unspecified (§5.1.2.3 ¶185, §6.5 ¶937).

## Cycle

```c
int acc = 0;        // declaration: Subject created

while (1) {         // Action: iteration
    int val;        // declaration: Subject created (automatic)
    scanf("%d", &val); // Action: I/O function call

    if (val > 0)         // Action: conditional
        acc = acc + val; // Action: add → new Subject state
}
```

Every C program reduces to this cycle: Subject carries forward, Object arrives and departs, Action transforms.
