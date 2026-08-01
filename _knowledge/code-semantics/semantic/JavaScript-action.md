---
id:               JAVASCRIPT.ACTION
language:         JavaScript
role:             action
title:            The evaluation of a parse node
definition:       "All references to the running execution context denote the running execution context of the surrounding agent. The running execution context is always the top element of the execution context stack"
sources:
  - section:      ECMAScript 2027 §9.4 Execution Contexts
    url:          https://tc39.es/ecma262/#sec-execution-contexts
  - section:      ECMAScript 2027 §8 Syntax-Directed Operations
    url:          https://tc39.es/ecma262/#sec-syntax-directed-operations
  - section:      ECMAScript 2027 §6.2.3 Completion Records
    url:          https://tc39.es/ecma262/#sec-completion-records
canonical:        x + y
tags:             [evaluation, completion-record, statement, expression]
status:           draft
precedes:         []
---

## Action

The evaluation of a parse node. ECMAScript evaluation proceeds by applying syntax-directed algorithms to parse tree nodes. Each evaluation produces a Completion Record that indicates normal completion, abrupt completion (return, throw, break, continue), or the value produced.

### Syntax-directed operations (§8)

ECMAScript specifies the behavior of each production as a set of algorithms. Evaluation is the process of applying these algorithms to the parse tree:

```
// Example: Evaluating an AdditiveExpression
AdditiveExpression : AdditiveExpression + MultiplicativeExpression
1. Let lref be ? Evaluation of AdditiveExpression.
2. Let lval be ? GetValue(lref).
3. Let rref be ? Evaluation of MultiplicativeExpression.
4. Let rval be ? GetValue(rref).
5. Let lnum be ? ToNumber(lval).
6. Let rnum be ? ToNumber(rval).
7. Return the result of applying the addition operation to lnum and rnum.
```

### Completion Records (§6.2.3)

> The Completion Record is a specification type used to explain the runtime propagation of values and control flow.

Each evaluation returns a Completion Record with three fields:

```
[[Type]]   — normal, break, continue, return, throw
[[Value]]  — the value produced (if normal/return/throw)
[[Target]] — the label target (if break/continue)
```

```javascript
// In specification terms:
x + y                // → Completion { [[Type]]: normal, [[Value]]: result }
throw e              // → Completion { [[Type]]: throw, [[Value]]: e }
return x             // → Completion { [[Type]]: return, [[Value]]: x }
```

### Expression evaluation

Expressions are evaluated recursively. Each inner expression produces a value that becomes the Object for the outer evaluation:

```javascript
1 + 2 * 3            // 2 * 3 evaluates first → 6, then 1 + 6 → 7
f(x)(y)              // f evaluates to a function, x evaluates to argument,
                     // f(x) evaluates to another function, y evaluates to argument
a ? b : c            // conditional evaluation: only b or c evaluated
```

### Statement evaluation

Statements are actions that typically modify the execution context or control flow:

```javascript
let x = 1;           // binds x in LexicalEnvironment → normal completion
if (x > 0) { ... }   // conditional → may branch
for (let i = 0; ...)  // iteration → creates binding per iteration
try { ... } catch { }  // exception handling → captures thrown completions
function f() {}      // function declaration → binds in VariableEnvironment
```

### Call expression as action

> A new execution context is created whenever control is transferred from the executable code associated with the currently running execution context to executable code that is not associated with that execution context.

Function calls push a new execution context, evaluate arguments in the caller's context, then transfer control:

```javascript
f(a, b)
// 1. Evaluate f → get callable object
// 2. Evaluate a → get value
// 3. Evaluate b → get value
// 4. Create new execution context
// 5. Bind this and arguments
// 6. Execute f's body
// 7. Pop context, return Completion value
```

### Abrupt completions

Abrupt completions propagate up the evaluation stack until caught or until they reach the outermost execution context:

```javascript
function inner() {
    return 42;         // Completion { [[Type]]: return, [[Value]]: 42 }
}
function outer() {
    const x = inner(); // captures the return completion value
    return x + 1;
}
```

## Summary

```
x + y                 // expression evaluation → normal completion
return x              // → return completion (abrupt)
throw e               // → throw completion (abrupt)
break label           // → break completion (abrupt, with target)
f(args)               // call: push context → evaluate → pop → completion
if (x) { ... }        // conditional: normal or abrupt
try { ... } catch {}  // catches throw completions
```
