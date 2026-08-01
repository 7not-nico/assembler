# Go Spec — Subject, Object, Action

Real spec text sourced via Playwright MCP from `https://go.dev/ref/spec`.

## Subject — The variable

```
Source: Go Spec §Variables
URL:    https://go.dev/ref/spec#Variables
```

> A variable is a storage location for holding a value. The set of permissible values is determined by the variable's type.

## Object — The value

```
Source: Go Spec §Types
URL:    https://go.dev/ref/spec#Types
```

> A type determines a set of values together with operations and methods specific to those values.

### Zero value

```
Source: Go Spec §The zero value
URL:    https://go.dev/ref/spec#The_zero_value
```

> When storage is allocated for a variable... and no explicit initialization is provided, the variable or value is given a default value. Each element of such a variable or value is set to the zero value for its type: `false` for booleans, `0` for numeric types, `""` for strings, and `nil` for pointers, functions, interfaces, slices, channels, and maps.

## Action — The statement and expression

### Expressions

```
Source: Go Spec §Expressions
URL:    https://go.dev/ref/spec#Expressions
```

> An expression specifies the computation of a value by applying operators and functions to operands.

### Statements

```
Source: Go Spec §Statements
URL:    https://go.dev/ref/spec#Statements
```

> Statements control execution.

### Go statements

```
Source: Go Spec §Go statements
URL:    https://go.dev/ref/spec#Go_statements
```

> A "go" statement starts the execution of a function call as an independent concurrent thread of control, or goroutine, within the same address space.

### Select statements

```
Source: Go Spec §Select statements
URL:    https://go.dev/ref/spec#Select_statements
```

> A "select" statement chooses which of a set of possible send or receive operations will proceed.
