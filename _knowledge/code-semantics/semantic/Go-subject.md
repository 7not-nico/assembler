---
id:               GO.SUBJECT
language:         Go
role:             subject
title:            The variable
definition:       A variable is a storage location for holding a value. The set of permissible values is determined by the variable's type
sources:
  - section:      Go Spec §Variables
    url:          https://go.dev/ref/spec#Variables
  - section:      Go Spec §Address operators
    url:          https://go.dev/ref/spec#Address_operators
  - section:      Go Spec §Program execution
    url:          https://go.dev/ref/spec#Program_execution
  - section:      Go Spec §Short variable declarations
    url:          https://go.dev/ref/spec#Short_variable_declarations
canonical:        var x int; x = 42
tags:             [variable, storage-location, addressable, static-type, dynamic-type]
status:           draft
precedes:         [GO.OBJECT, GO.ACTION]
---

## Subject

The variable. A named or anonymous storage location with a static type and, for interface variables, a dynamic type. Go variables are garbage-collected — no ownership model, no borrow checker. Multiple references to the same variable coexist freely. The blank identifier `_` is a special variable that discards assigned values.

### Core definition (§Variables)

> A variable is a storage location for holding a value. The set of permissible values is determined by the variable's type.

A declaration creates a named variable. The `new` function or taking the address of a composite literal creates an anonymous variable accessible through a pointer:

```go
var x int                // named variable, storage location
p := new(int)            // anonymous variable through pointer
q := &Point{2, 3}        // anonymous variable through composite literal address
```

### Static and dynamic type (§Variables)

> The static type (or just type) of a variable is the type given in its declaration, the type provided in the `new` call or composite literal, or the type of an element of a structured variable. Variables of interface type also have a distinct dynamic type, which is the (non-interface) type of the value assigned to the variable at run time.

The Subject carries a static type fixed at compile time. For interface variables, the Subject also carries a dynamic type that can change during execution — the variable holds the value's concrete type alongside the value itself:

```go
var x interface{}  // x is nil, static type interface{}
x = 42             // x has dynamic type int
x = "hello"        // x has dynamic type string — dynamic type changed
```

### Structured variables (§Variables)

> Structured variables of array, slice, and struct types have elements and fields that may be addressed individually. Each such element acts like a variable.

A structured variable is a compound Subject. Each field or element is itself a variable:

```go
var a [3]int           // array: 3 variables in contiguous storage
type S struct { x, y int }
var s S                // struct: field x is a variable, field y is a variable
```

### Addressability (§Address operators)

> For an operand x of type T, the address operation `&x` generates a pointer of type `*T` to x. The operand must be addressable, that is, either a variable, pointer indirection, or slice indexing operation; or a field selector of an addressable struct operand; or an array indexing operation of an addressable array. As an exception to the addressability requirement, x may also be a (possibly parenthesized) composite literal.

Not every Subject is addressable. Addressability gates `&` and assignment to struct fields in maps. The addressable forms are a subset of all expressions:

```go
var x int               // variable: addressable
&x                      // OK
var m map[string]int
m["k"] = 1              // OK (assignment)
// p := &m["k"]         // ERROR: map element not addressable
```

### The blank identifier (§Blank identifier)

> The blank identifier is represented by the underscore character `_`. It serves as an anonymous placeholder instead of a regular (non-blank) identifier and has special meaning in declarations, as an operand, and in assignment statements.

The blank identifier is a write-only Subject. It receives a value but the value is discarded:

```go
x, _ := f()              // _ discards the second return value
```

### Goroutines share Subjects (§Program execution)

> When that function invocation returns, the program exits. It does not wait for other (non-main) goroutines to complete.

Multiple goroutines share the same Subject. No ownership restricts access — synchronization is manual through channels or mutexes:

```go
var counter int                   // shared Subject across goroutines
go func() { counter++ }()         // goroutine reads and writes counter
go func() { counter++ }()         // another goroutine — data race without sync
```

### Subject forms

```go
var x int                // declaration: named variable
x = 42                   // assignment: write to variable
p := new(T)              // short declaration: anonymous variable through pointer
*p = 10                  // pointer indirection: variable through *T
a[i] = 5                 // index: array element acts as variable
s.field = 'a'            // field: struct field acts as variable
_ = f()                  // blank identifier: discard value
var wg sync.WaitGroup    // shared Subject across goroutines
```

## Summary

```
var x int                // named variable Subject
x = 42                   // Subject receives value
p := new(T)              // anonymous Subject via pointer
a[i]                     // indexed Subject (array element)
s.field                  // field Subject (struct field)
_                        // blank Subject (write-only)
interface{}              // Subject with static + dynamic type
goroutines               // Subjects shared across concurrent Actions
```
