# GO.SUBJECT — The variable

```
Source: Go Spec §Variables
URL:    https://go.dev/ref/spec#Variables
```

A variable is a storage location for holding a value. The set of permissible values is determined by the variable's type.

```
Source: Go Spec §Address operators
URL:    https://go.dev/ref/spec#Address_operators
```

For an operand x of type T, the address operation &x generates a pointer of type *T to x. The operand must be addressable, that is, either a variable, pointer indirection, or slice indexing operation; or a field selector of an addressable struct operand; or an array indexing operation of an addressable array.

```
Source: Go Spec §Short variable declarations
URL:    https://go.dev/ref/spec#Short_variable_declarations
```

A short variable declaration uses the syntax `:=` and declares one or more variables. Unlike regular variable declarations, short variable declarations infer the type from the initialization expression.
