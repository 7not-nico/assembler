---
id:               JAVA.ACTION
language:         Java
role:             action
title:            The statement with normal/abrupt completion
definition:       Every statement has a normal mode of execution in which certain computational steps are carried out
sources:
  - section:      JLS §14 Blocks, Statements, and Patterns
    url:          https://docs.oracle.com/en/java/javase/26/docs/specs/jls/jls-14.html
  - section:      JLS §14.1 Normal and Abrupt Completion of Statements
    url:          https://docs.oracle.com/en/java/javase/26/docs/specs/jls/jls-14.html#jls-14.1
  - section:      JLS §15.12.4 Run-Time Evaluation of Method Invocation
    url:          https://docs.oracle.com/en/java/javase/26/docs/specs/jls/jls-15.html#jls-15.12.4
canonical:        obj.calc(x, y)
tags:             [statement, method-invocation, normal-completion, abrupt-completion]
status:           draft
precedes:         []
---

## Action

The statement or expression. Java actions execute in a defined sequence with normal/abrupt completion semantics. Every action either completes normally (all steps carried out) or abruptly (terminated early for a reason).

### Statement completion (JLS §14.1)

> Every statement has a normal mode of execution in which certain computational steps are carried out. If all the steps are carried out as described, with no indication of abrupt completion, the statement is said to complete normally.

> If such an event occurs, then execution of one or more statements may be terminated before all steps of their normal mode of execution have completed; such statements are said to complete abruptly. An abrupt completion always has an associated reason: `break`, `continue` (with/without label), `return` (with/without value), `throw` (with a given value), or `yield` (with a given value).

```java
x = 42;                 // action: expression statement — completes normally
if (x > 0) y = 1;       // action: conditional selection
return x;               // action: abrupt completion with return reason
throw new E();          // action: abrupt completion with throw reason
```

### Block execution (JLS §14.2)

> A block is executed by executing each of the local variable declaration statements and other statements in order from first to last (left to right). If all of these block statements complete normally, then the block completes normally. If any of these block statements complete abruptly for any reason, then the block completes abruptly for the same reason.

```java
{                        // action: block — sequential
    int a = 1;           // action: local variable declaration
    int b = 2;           // action: local variable declaration
    int c = a + b;       // action: expression statement
}                        // block completes normally
```

### Statement kinds (JLS §14.5)

The Action grammar includes:

```
Statement:
    Block                          // sequential composition
    EmptyStatement                 // no-op
    ExpressionStatement            // evaluate expression, discard result
    AssertStatement                // guarded assertion
    SwitchStatement                // multi-way branch
    DoStatement | WhileStatement   // iteration (post-test, pre-test)
    ForStatement                   // iteration (counter)
    BreakStatement                 // abrupt: exit enclosing block
    ContinueStatement              // abrupt: continue enclosing loop
    ReturnStatement                // abrupt: return from method
    SynchronizedStatement          // monitor enter/exit
    ThrowStatement                 // abrupt: throw exception
    TryStatement                   // exception handling
    YieldStatement                 // abrupt: yield from switch expression
    LabeledStatement               // target for break/continue
    IfThenStatement                // conditional
```

### Method invocation (JLS §15.12.4)

> At run time, method invocation requires five steps. First, a target reference may be computed. Second, the argument expressions are evaluated. Third, the accessibility of the method to be invoked is checked. Fourth, the actual code for the method to be executed is located. Fifth, a new activation frame is created, synchronization is performed if necessary, and control is transferred to the method code.

```java
obj.calc(x, y)    // action: method invocation
// 1. target reference = obj
// 2. evaluate arguments: x → value, y → value
// 3. check accessibility (public/protected/private)
// 4. locate method (virtual dispatch via vtable)
// 5. create frame, transfer control
```

## Summary

```
statement           → action = sequential, conditional, or iterative
expression          → action = evaluate to value (or void)
method call         → action = 5-step invocation (target, args, access, locate, frame)
block               → action = sequential composition of substatements
control transfer    → action = abrupt completion (break/continue/return/throw/yield)
```

Action is what happens when Subject meets Object. The statement executes, the expression evaluates, the method invokes. Each action completes normally or abruptly, carrying the reason upward through enclosing blocks.
