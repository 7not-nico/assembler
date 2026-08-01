# GO.OBJECT — The value and its type

```
Source: Go Spec §Types
URL:    https://go.dev/ref/spec#Types
```

A type determines a set of values together with operations and methods specific to those values.

```
Source: Go Spec §The zero value
URL:    https://go.dev/ref/spec#The_zero_value
```

When storage is allocated for a variable, either through a declaration or a call of new, or when a new value is created, either through a composite literal or a call of make, and no explicit initialization is provided, the variable or value is given a default value. Each element of such a variable or value is set to the zero value for its type: false for booleans, 0 for numeric types, "" for strings, and nil for pointers, functions, interfaces, slices, channels, and maps.

```
Source: Go Spec §Constants
URL:    https://go.dev/ref/spec#Constants
```

There are boolean constants, rune constants, integer constants, floating-point constants, complex constants, and string constants. Rune, integer, floating-point, and complex constants are collectively called numeric constants.
