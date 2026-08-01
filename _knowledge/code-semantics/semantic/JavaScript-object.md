---
id:               JAVASCRIPT.OBJECT
language:         JavaScript
role:             object
title:            The ECMAScript language value
definition:       "An ECMAScript language type corresponds to values that are directly manipulated by an ECMAScript programmer. The ECMAScript language types are Undefined, Null, Boolean, String, Symbol, Number, BigInt, and Object"
sources:
  - section:      ECMAScript 2027 §6.1 ECMAScript Language Types
    url:          https://tc39.es/ecma262/#sec-ecmascript-language-types
  - section:      ECMAScript 2027 §6.2 ECMAScript Specification Types
    url:          https://tc39.es/ecma262/#sec-ecmascript-specification-types
canonical:        42
tags:             [value, type, primitive, object, number, string, boolean]
status:           draft
precedes:         []
---

## Object

The ECMAScript language value. Every expression evaluates to a value of one of the 8 language types: Undefined, Null, Boolean, String, Symbol, Number, BigInt, or Object.

### Language types (§6.1)

> The ECMAScript language types are Undefined, Null, Boolean, String, Symbol, Number, BigInt, and Object. An ECMAScript language value is a value that is characterized by an ECMAScript language type.

Primitive types:

```javascript
undefined       // Undefined type — single value: undefined
null            // Null type — single value: null
true, false     // Boolean type — logical values
42              // Number type — IEEE 754-2019 double precision
"hello"         // String type — sequence of 16-bit code units
42n             // BigInt type — arbitrary precision integer
Symbol('id')    // Symbol type — unique, immutable identifier
```

Object type:

```javascript
{}              // ordinary object
[]              // Array — exotic object with indexed properties
/x/             // RegExp — exotic object
function() {}   // Callable object
new Date()      // Date exotic object
```

### Object properties

Objects are collections of properties. Each property has a key (String or Symbol) and attributes (Writable, Enumerable, Configurable):

```javascript
const obj = {
    x: 1,                    // data property
    get y() { return 2; },   // accessor property
    [Symbol('s')]: 3         // symbol-keyed property
};
```

### Type coercion

Values are automatically coerced between types depending on context:

```javascript
42 + "1"           // → "421" (number coerced to string)
"42" - 1           // → 41 (string coerced to number)
if ("hello") {}    // → true (string coerced to boolean)
```

### Specification types (§6.2)

In addition to language types, the specification uses internal types to describe runtime semantics:

- **List** — ordered sequence of values
- **Record** — named fields
- **Set** — unordered collection
- **Completion Record** — represents the result of evaluation (type, value, target)
- **Property Descriptor** — attribute set for a property
- **Environment Record** — scope binding management

### Ordinary vs exotic objects

Most objects are ordinary — they follow default behavior for internal methods. Exotic objects override one or more internal methods:

```javascript
// Array — exotic: overrides [[DefineOwnProperty]]
const arr = [1, 2];
arr.length = 1;    // automatically deletes arr[1]

// Bound function — exotic: overrides [[Call]]
const bound = f.bind(this);

// Proxy — exotic: traps internal methods via handler
const proxy = new Proxy(target, handler);
```

## Summary

```
undefined         // Undefined type
null              // Null type
42                // Number type
"hello"           // String type
{}                // Object type — property collection
true              // Boolean type
42n               // BigInt type
Symbol('id')      // Symbol type (unique)
```
