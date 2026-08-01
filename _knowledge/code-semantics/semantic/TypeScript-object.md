---
id:               TYPESCRIPT.OBJECT
language:         TypeScript
role:             object
title:            The type and value
definition:       "TypeScript has three very commonly used primitives: string, number, and boolean. Each has a corresponding type in TypeScript. These are the same names you'd see if you used the JavaScript typeof operator"
sources:
  - section:      TypeScript Handbook Everyday Types
    url:          https://www.typescriptlang.org/docs/handbook/2/everyday-types.html
  - section:      TypeScript Handbook Creating Types from Types
    url:          https://www.typescriptlang.org/docs/handbook/2/types-from-types.html
  - section:      TypeScript Do's and Don'ts §General Types
    url:          https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html#general-types
  - section:      TypeScript Handbook Symbols
    url:          https://www.typescriptlang.org/docs/handbook/symbols.html
  - section:      TypeScript Handbook Enums
    url:          https://www.typescriptlang.org/docs/handbook/enums.html
  - section:      ECMAScript 2027 §6.1 Language Types
    url:          https://tc39.es/ecma262/#sec-ecmascript-language-types
canonical:        42
tags:             [type, value, primitive, union, generic, interface]
status:           draft
precedes:         []
---

## Object

The type and value. TypeScript operates on two layers of Objects: runtime values (identical to ECMAScript) and compile-time types. Every runtime value has a static type in TypeScript.

### Runtime values (§JS)

Runtime Objects are ECMAScript language values — unchanged from JavaScript:

```typescript
42              // runtime: number value
"hello"         // runtime: string value
true            // runtime: boolean value
{}              // runtime: object value
```

### Primitive types (not boxed types)

> TypeScript has three very commonly used primitives: string, number, and boolean. Each has a corresponding type in TypeScript.

> Don't ever use the types Number, String, Boolean, Symbol, or Object. These types refer to non-primitive boxed objects that are almost never used appropriately in JavaScript code.

> Do use the types number, string, boolean, and symbol.

```typescript
let s: string = "hello";   // correct: primitive string
let n: number = 42;        // correct: primitive number
let b: boolean = true;     // correct: primitive boolean

let s2: String = "hello";  // wrong: boxed String object
let n2: Number = 42;       // wrong: boxed Number object
```

Use `object` (lowercase) for non-primitive types instead of `Object`.

```typescript
let s: string = "hello";   // string type
let n: number = 42;        // number type
let b: boolean = true;     // boolean type
```

### Object types

```typescript
interface Person {
    name: string;
    age: number;
}

type Point = {
    x: number;
    y: number;
};

// Structural typing: { name: string; age: number } matches Person
```

### Union and intersection types

```typescript
type Status = 'idle' | 'loading' | 'error';  // union of literal types
type Result = number | string;                // union
type Named = Person & { id: number };         // intersection
```

### Array and tuple types

```typescript
let arr: number[] = [1, 2, 3];      // array type
let tuple: [string, number] = ['a', 1];  // tuple type
```

### Generic types

```typescript
type Box<T> = { value: T };         // generic type
type Pair<T, U> = [T, U];          // multi-parameter generic
type Nullable<T> = T | null;       // generic with union
```

### Enum type

> Enums are one of the few features TypeScript has which is not a type-level extension of JavaScript. Enums allow a developer to define a set of named constants.

Enums create both a type (the enum) and runtime values (named constants):

```typescript
enum Direction {
    Up = 1,       // initializer
    Down,         // auto-incremented: 2
    Left,         // 3
    Right,        // 4
}

let dir: Direction = Direction.Up;
```

> TypeScript provides both numeric and string-based enums.

```typescript
enum Direction {
    Up = "UP",    // string enum: each member must be constant-initialized
    Down = "DOWN",
}
```

> There is a special subset of constant enum members: union enums and enum member types.

When all enum members are literal values, each member also acts as a type:

```typescript
enum ShapeKind {
    Circle, Square,
}

interface Circle {
    kind: ShapeKind.Circle;  // enum member as type
    radius: number;
}
```

### Symbol type

> Starting with ECMAScript 2015, symbol is a primitive data type, just like number and string. symbol values are created by calling the Symbol constructor.

> Symbols are immutable, and unique.

```typescript
let sym1 = Symbol();              // symbol type
let sym2 = Symbol("key");         // symbol with description
sym2 === Symbol("key");           // false — each Symbol is unique
```

> `unique symbol` is a subtype of symbol, and are produced only from calling Symbol() or Symbol.for(), or from explicit type annotations.

```typescript
declare const sym1: unique symbol;  // unique literal symbol type
class C {
    static readonly MySymbol: unique symbol = Symbol();
}
```

Well-known symbols represent internal language behaviors:

```typescript
Symbol.iterator     // for-of protocol
Symbol.hasInstance  // instanceof behavior
Symbol.match        // String.prototype.match behavior
Symbol.toPrimitive  // type coercion protocol
```

### Type-level Object operations

Types can be constructed from other types:

```typescript
type Keys = keyof Person;           // "name" | "age" (index type)
type NameType = Person['name'];    // string (indexed access)
type Partial<T> = { [K in keyof T]?: T[K] };  // mapped type
type IsString<T> = T extends string ? true : false;  // conditional type
```

## Summary

```
"hello"           // runtime: string; compile: string type
42                // runtime: number; compile: number type
true              // runtime: boolean; compile: boolean type
{ name: "A" }     // runtime: object; compile: interface/type
number[]           // array type
[string, number]   // tuple type
'idle' | 'loading' // union type (literal)
T extends U ? X : Y  // conditional type
```
