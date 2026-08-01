---
id:               JAVASCRIPT.SUBJECT
language:         JavaScript
role:             subject
title:            The execution context
definition:       "An execution context is a specification device that is used to track the runtime evaluation of code by an ECMAScript implementation. At any point in time, there is at most one execution context per agent that is actually executing code"
sources:
  - section:      ECMAScript 2027 §9.4 Execution Contexts
    url:          https://tc39.es/ecma262/#sec-execution-contexts
  - section:      ECMAScript 2027 §9.1 Agent
    url:          https://tc39.es/ecma262/#sec-agent
canonical:        this
tags:             [execution-context, this, environment, scope, stack]
status:           draft
precedes:         [JAVASCRIPT.OBJECT, JAVASCRIPT.ACTION]
---

## Subject

The execution context. ECMAScript tracks runtime evaluation through execution contexts organized on a stack. The running execution context carries `this`, lexical scope, variable bindings, and the active function.

### Execution context stack (§9.4)

> An execution context is a specification device that is used to track the runtime evaluation of code by an ECMAScript implementation.

> The execution context stack is used to track execution contexts. The running execution context is always the top element of this stack. A new execution context is created whenever control is transferred from the executable code associated with the currently running execution context to executable code that is not associated with that execution context.

Each function call pushes a new execution context onto the stack. When the function returns, its context is popped:

```javascript
function a() {
    let x = 1;       // execution context A: x = 1
    b();             // push context B
}                    // pop context B, back to A
function b() {
    let y = 2;       // execution context B: y = 2
}
a();                 // push context A
```

### State components (§9.4)

> An execution context contains whatever implementation specific state is necessary to track the execution progress of its associated code.

All execution contexts have:
- **code evaluation state** — suspend/resume progress
- **Function** — the function object being evaluated (or null for Script/Module)
- **Realm** — the Realm Record providing access to ECMAScript resources
- **ScriptOrModule** — the originating script or module

ECMAScript code execution contexts also have:
- **LexicalEnvironment** — identifies the Environment Record for resolving identifier references
- **VariableEnvironment** — identifies the Environment Record for variable declarations

### `this` binding

The `this` value is determined by how the execution context is established:

```javascript
obj.method()         // this = obj in the new context
method()             // this = global (or undefined in strict mode)
new Constructor()    // this = newly created instance
arrow()              // this = enclosing context's this (lexical)
```

### Agent and realm (§9.1)

An agent is a self-contained execution environment with its own execution context stack. A Realm Record encapsulates the set of intrinsic objects and global environment for a given execution context.

```javascript
// Each realm has its own intrinsics (Array, Object, Function, etc.)
// Realm 1: window (browser) or global (Node.js)
// Realm 2: iframe → different realm, different intrinsics
```

## Summary

```
function f() { ... }  // call pushes new execution context
this                  // binding determined by call site
x = 1                 // binds in VariableEnvironment
let x = 1             // binds in LexicalEnvironment
new C()               // new context with fresh this
```
