# Type system

ZScript types form a hybrid value/reference system. The Types chapter (ch015) enumerates the full surface.

## Type families

```text
Numeric     integer types, floating-point types
String-like String, name types
Boolean     boolean types
Color       color types
Vector      vector types
Containers  fixed-array, dynamic-array, map
Reference   class-reference, native-pointer
Read-only   read-only types
```

## Reference semantics

- `@`-prefixed names mark native pointers to objects, as opposed to objects placed directly in structure data
- Class-reference types hold object identity; native-pointer types escape into engine memory
- Read-only types propagate const-ness through the type graph

## Inference

The `let` type defers resolution to the compiler. `let` appears rarely in the API surface — explicit types dominate the reference.

## Literal surface

Integer, floating-point, string, name, boolean, null, color, and vector literals each carry their own syntax in the Expressions chapter (ch008).
