# Type assertion — extracting concrete type from interface

```
Source: Go Spec §Type assertions
URL:    https://go.dev/ref/spec#Type_assertions
```

For an expression x of interface type, but not a type parameter, and a type T, the primary expression `x.(T)` asserts that x is not nil and that the value stored in x is of type T. The notation `x.(T)` is called a type assertion.

More precisely, if T is not an interface type, `x.(T)` asserts that the dynamic type of x is identical to the type T. In this case, T must implement the (interface) type of x; otherwise the type assertion is invalid since it is not possible for x to store a value of type T. If T is an interface type, `x.(T)` asserts that the dynamic type of x implements the interface T.

If the type assertion holds, the value of the expression is the value stored in x and its type is T. If the type assertion is false, a run-time panic occurs.

A type assertion used in an assignment statement or initialization of the special form:

```
v, ok = x.(T)
v, ok := x.(T)
var v, ok = x.(T)
var v, ok interface{} = x.(T)
```

```
Source: Go Spec §Type switches
URL:    https://go.dev/ref/spec#Type_switches
```

A type switch compares types rather than values. It is marked by a special switch expression that has the form of a type assertion using the keyword `type`:

```
switch i := x.(type) {
case nil:     printString("x is nil")
case int:     printInt(i)
case float64: printFloat64(i)
default:      printString("don't know the type")
}
```
