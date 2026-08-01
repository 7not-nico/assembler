# Function literal — anonymous function value

```
Source: Go Spec §Function literals
URL:    https://go.dev/ref/spec#Function_literals
```

A function literal represents an anonymous function. Function literals cannot declare type parameters.

```
FunctionLit = "func" Signature FunctionBody .
```

A function literal can be assigned to a variable or invoked directly.

```
f := func(x, y int) int { return x + y }
func(ch chan int) { ch <- ACK }(replyChan)
```

Function literals are closures: they may refer to variables defined in a surrounding function. Those variables are then shared between the surrounding function and the function literal, and they survive as long as they are accessible.
