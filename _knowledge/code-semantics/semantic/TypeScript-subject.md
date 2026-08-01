---
id:               TYPESCRIPT.SUBJECT
language:         TypeScript
role:             subject
title:            The typing environment
definition:       "TypeScript extends JavaScript by adding types to the language. TypeScript's runtime is JavaScript: the execution context carries this, scope, and closures"
sources:
  - section:      TypeScript Handbook Everyday Types
    url:          https://www.typescriptlang.org/docs/handbook/2/everyday-types.html
  - section:      TypeScript Handbook Type Inference
    url:          https://www.typescriptlang.org/docs/handbook/2/type-inference.html
  - section:      TypeScript Handbook Namespaces and Modules
    url:          https://www.typescriptlang.org/docs/handbook/namespaces-and-modules.html
  - section:      ECMAScript 2027 §9.4 Execution Contexts
    url:          https://tc39.es/ecma262/#sec-execution-contexts
canonical:        "const x: number = 42"
tags:             [typing-environment, type-scope, module, generic-constraint]
status:           draft
precedes:         [TYPESCRIPT.OBJECT, TYPESCRIPT.ACTION]
---

## Subject

The typing environment. TypeScript adds a static type system to JavaScript's runtime. Every value in JavaScript has a corresponding type in TypeScript. The typing environment — a compile-time scope of type definitions, interfaces, and generic constraints — determines what types are visible and how they relate.

### Runtime Subject: execution context (§JS)

JavaScript's execution context is the runtime Subject. TypeScript inherits it unchanged — `this`, closures, scope chain:

```typescript
function f(this: MyType) {
    // execution context with this: MyType
}
```

### Compile-time Subject: type environment

TypeScript adds compile-time bindings for types:

```typescript
interface User {        // binds User in type environment
    name: string;
    age: number;
}

type Status = 'active' | 'inactive';  // binds Status

const x: User = { name: 'Alice', age: 30 };
//                          ^ type environment resolves User
```

### Module scope as subject boundary (§Namespaces and Modules)

> Modules can contain both code and declarations. Modules provide for better code reuse, stronger isolation and better tooling support for bundling.

> For Node.js applications, modules are the default and we recommended modules over namespaces in modern code.

Modules define the scope of the typing environment. Each module is a separate Subject boundary — its exported types and values are only visible to importers:

```typescript
// a.ts — module scope A
export interface Config { timeout: number }

// b.ts — module scope B
import { Config } from './a';
// typing environment now includes Config from A
```

### Generic type parameters as scoped subjects

Generic parameters introduce bindings into a local type environment:

```typescript
function identity<T>(arg: T): T {
    // T is bound in the generic's type environment
    return arg;
}

class Box<T> {
    // T is in scope for all members
    value: T;
    constructor(v: T) { this.value = v; }
}
```

### Namespaces as named subject containers

> Namespaces are a TypeScript-specific way to organize code. Namespaces are simply named JavaScript objects in the global namespace.

Namespaces wrap multiple related Subjects into a single named container:

```typescript
namespace Geometry {
    export interface Point { x: number; y: number; }
    export function distance(a: Point, b: Point): number {
        return Math.sqrt((b.x - a.x) ** 2 + (b.y - a.y) ** 2);
    }
}

const p: Geometry.Point = { x: 1, y: 2 };
Geometry.distance(p, { x: 4, y: 6 });
```

Unlike modules, namespaces span files and can be concatenated. They are JavaScript objects at runtime, making them a lighter Subject boundary.

### Declaration merging extends the subject

Multiple declarations with the same name merge into one Subject:

```typescript
interface User { name: string }
interface User { age: number }  // merges: User has both name and age
```

## Summary

```
const x: T            // runtime: execution context; compile: type env
interface I { ... }   // binds type in compile-time environment
type T = ...          // binds type alias
<T>                    // generic parameter: local type binding
import type { X }     // imports type into current scope
module M { ... }      // module scope boundary
```
