---
id:               TYPESCRIPT.ACTION
language:         TypeScript
role:             action
title:            The type check and transpilation
definition:       "TypeScript tries to automatically infer the types in your code. For the most part you don't need to explicitly learn the rules of inference. TypeScript allows you to specify the types of both the input and output values of functions"
sources:
  - section:      TypeScript Handbook Everyday Types
    url:          https://www.typescriptlang.org/docs/handbook/2/everyday-types.html
  - section:      TypeScript Handbook Type Inference
    url:          https://www.typescriptlang.org/docs/handbook/type-inference.html
  - section:      TypeScript Handbook Narrowing
    url:          https://www.typescriptlang.org/docs/handbook/2/narrowing.html
  - section:      ECMAScript 2027 §8 Syntax-Directed Operations
    url:          https://tc39.es/ecma262/#sec-syntax-directed-operations
  - section:      TypeScript Handbook Iterators and Generators
    url:          https://www.typescriptlang.org/docs/handbook/iterators-and-generators.html
canonical:        "const x: number = 42"
tags:             [type-check, inference, narrowing, transpilation, erasure]
status:           draft
precedes:         []
---

## Action

The type check and transpilation. TypeScript performs two actions at different times: compile-time type checking (verify type safety) and compile-time type erasure (emit JavaScript). JavaScript's runtime evaluation (ECMAScript §8) remains the final execution step.

### Type annotation action

> TypeScript allows you to specify the types of both the input and output values of functions.

Type annotations constrain the Object that a Subject can hold:

```typescript
let x: number = 42;      // annotate: x must hold a number
function f(a: string): number { return a.length; }
// parameter a: string, return value: number
```

### Type inference action

> TypeScript tries to automatically infer the types in your code. Wherever possible, TypeScript tries to automatically infer the types in your code.

Inference determines types from values without explicit annotations. Three inference mechanisms:

**Basic inference** — from initializers, parameter defaults, return expressions:

```typescript
let x = 3;               // inferred: number
function f(a = "hello") { return a.length; }
// a inferred: string, return inferred: number
```

**Best common type** — from multiple expressions to find a compatible type:

```typescript
let x = [0, 1, null];               // inferred: (number | null)[]
// Best common type algorithm picks the type compatible with all candidates

let zoo = [new Rhino(), new Elephant(), new Snake()];
// inferred: (Rhino | Elephant | Snake)[]  (no supertype found)
let zoo2: Animal[] = [new Rhino(), new Elephant(), new Snake()];
// explicit annotation gives the common type
```

**Contextual typing** — type implied by location, not value:

```typescript
window.onmousedown = function(mouseEvent) {
    console.log(mouseEvent.button);  // mouseEvent inferred as MouseEvent
};

window.onscroll = function(uiEvent) {
    console.log(uiEvent.button);    // Error: UIEvent has no button
};
```

> Contextual typing occurs when the type of an expression is implied by its location. Common cases include arguments to function calls, right hand sides of assignments, type assertions, members of object and array literals, and return statements.

```typescript
let x = 42;              // inferred: number
let y = "hello";         // inferred: string
const z = { a: 1, b: 2 };  // inferred: { a: number; b: number }
```

### Type narrowing action

Narrowing refines types within control flow based on runtime checks:

```typescript
function process(value: string | string[]) {
    if (typeof value === 'string') {
        // narrowed: value is string
        console.log(value.toUpperCase());
    } else {
        // narrowed: value is string[]
        console.log(value.join(', '));
    }
}
```

Narrowing actions include: `typeof`, `instanceof`, `in`, equality checks, discriminated unions.

### Overload resolution action

> Don't put more general overloads before more specific overloads. TypeScript chooses the first matching overload when resolving function calls.

Overloads are resolved in declaration order — the first match wins:

```typescript
// Correct: specific → general
declare function fn(x: HTMLDivElement): string;
declare function fn(x: HTMLElement): number;
declare function fn(x: unknown): unknown;

// Wrong: general first shadows specific
declare function fn(x: unknown): unknown;    // catches everything
declare function fn(x: HTMLDivElement): string;  // never reached
```

### Structural type checking action

TypeScript checks structural compatibility — shapes must match, not names:

```typescript
interface A { x: number }
interface B { x: number }

let a: A = { x: 1 };
let b: B = a;              // OK: same structure
```

### Generic instantiation action

When a generic function is called, type arguments are inferred or provided:

```typescript
function identity<T>(arg: T): T { return arg; }

let x = identity(42);      // T inferred as number
let y = identity<string>("hello");  // T explicitly string
```

### Iteration protocol action

> An object is deemed iterable if it has an implementation for the Symbol.iterator property. `Iterable` is a type we can use if we want to take in types listed above which are iterable.

> for..of loops over an iterable object, invoking the Symbol.iterator property on the object.

TypeScript types the iteration protocol — `for..of` type-checks against `Iterable<T>`:

```typescript
function toArray<X>(xs: Iterable<X>): X[] {
    return [...xs];     // Iterable<X> provides Symbol.iterator
}

let list = [4, 5, 6];
for (let i of list) {   // i inferred as number
    console.log(i);
}
```

> for..in returns a list of keys on the object being iterated, whereas for..of returns a list of values.

```typescript
for (let i in list) {   // i inferred as string (keys "0", "1", "2")
    console.log(i);
}
```

### Type erasure action

TypeScript removes type annotations and checks at emit time:

```typescript
// TypeScript source:
const greet = (name: string): string => `Hello ${name}`;

// Emitted JavaScript:
const greet = (name) => `Hello ${name}`;
```

The emitted JS then runs through the standard ECMAScript evaluation Action.

## Summary

```
let x: number = 42       // annotation action
let x = 42               // inference action
typeof x === 'string'    // narrowing action
interface A { x: number }  // structural type definition
identity<T>(x: T): T     // generic instantiation action
// → type erasure → JS    // transpilation action
```
