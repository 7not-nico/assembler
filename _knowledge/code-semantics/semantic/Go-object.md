---
id:               GO.OBJECT
language:         Go
role:             object
title:            The value
definition:       A type determines a set of values together with operations and methods specific to those values
sources:
  - section:      Go Spec §Types
    url:          https://go.dev/ref/spec#Types
  - section:      Go Spec §Properties of types and values
    url:          https://go.dev/ref/spec#Properties_of_types_and_values
  - section:      Go Spec §Constants
    url:          https://go.dev/ref/spec#Constants
  - section:      Go Spec §The zero value
    url:          https://go.dev/ref/spec#The_zero_value
canonical:        42
tags:             [value, type, zero-value, boolean, numeric, string, struct, slice, map, interface]
status:           draft
precedes:         []
---

## Object

The value. A typed quantity belonging to a set defined by its type. Every value has a type that determines legal operations and the interpretation of its in-memory representation. Go values are explicitly initialized — every variable starts at its zero value when no explicit initializer is given.

### Core definition (§Types)

> A type determines a set of values together with operations and methods specific to those values.

The type is the schema of the Object. The same bit pattern `0x41` is the integer `65` or the value `'A'` depending on its type:

```go
var b byte = 65          // byte value 65
var c rune = 'A'         // rune value 65 ('A')
var s string = "A"       // string value "A"
```

### Type categories (§Types)

> Predeclared types, defined types, and type parameters are called named types.

Go's type system categorizes values into:

```go
true, false              // bool: Boolean truth values
42, 3.14, 1+2i           // numeric: integer, float, complex
'a', "hello"             // rune, string
[3]int{1, 2, 3}          // array: fixed-length sequence
[]int{1, 2}              // slice: variable-length view into array
struct { x, y int }      // struct: named fields
&T{1, 2}                 // pointer: address of a variable
func(int) int            // function: callable value
interface{ ... }         // interface: abstract behavior
map[string]int{}         // map: key-value association
chan int                 // channel: synchronized communication
```

### The zero value (§The zero value)

> When storage is allocated for a variable, either through a declaration or a call of `new`, or when a new value is created through a composite literal or a call of `make` and no explicit initializer is given, the variable or value is given a default value. Each element of such a variable or value is set to the zero value for its type: `false` for booleans, `0` for numeric types, `""` for strings, and `nil` for pointers, functions, interfaces, slices, channels, and maps.

Every Object has a guaranteed initial state. Zero values eliminate uninitialized memory:

```go
var x int                // x = 0
var s string             // s = ""
var p *int               // p = nil
var sl []int             // sl = nil (len 0, cap 0)
var m map[string]int     // m = nil
```

### Constants (§Constants)

> There are boolean constants, rune constants, integer constants, floating-point constants, complex constants, and string constants. Rune, integer, floating-point, and complex constants are collectively called numeric constants.

A constant value is an Object known at compile time. Numeric constants have arbitrary precision and are representable only when assigned to a variable of specific type:

```go
const Pi = 3.141592653589793238462643383279502884197
const Truth = true
const MaxUint = ^uint(0)          // compile-time computed
```

### Interfaces as value containers (§Properties of types and values)

An interface value holds a pair: the concrete value and its type. The Object is a (type, value) pair:

```go
var v interface{} = 42
// v: (int, 42)
v = "hello"
// v: (string, "hello")
var nilInterface interface{} = nil
// v: (nil, nil)
```

The underlying concrete value is extracted through a type assertion:

```go
n := v.(int)             // asserts v holds int, panics if not
s, ok := v.(string)      // safe assertion: ok = false if wrong type
```

### Object forms

```go
42                       // literal: untyped integer constant
3.14                     // literal: untyped floating constant
"hello"                  // literal: string
true                     // literal: bool
[3]int{1, 2, 3}          // composite literal: array value
[]int{1, 2}              // composite literal: slice value
struct{x, y int}{1, 2}   // composite literal: struct value
nil                      // zero value: pointer, slice, map, channel, interface, function
make([]int, 10)          // runtime allocation: slice value
new(T)                   // runtime allocation: pointer to zero T
f()                      // function call: return value(s)
```

## Summary

```
42                       // numeric Object: int
"hello"                  // string Object: string
true                     // boolean Object: bool
[3]int{1,2,3}            // array Object: [3]int
{1, 2}                   // struct Object: struct{x,y int}
nil                      // zero Object: nil for pointer/slice/map/chan/iface/func
(int, 42)                // interface Object: (dynamic_type, concrete_value)
const Pi = 3.14          // compile-time Object: arbitrary precision
```
