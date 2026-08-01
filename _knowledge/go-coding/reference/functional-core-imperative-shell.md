# Functional Core, Imperative Shell

Architectural pattern that pushes side effects to the edges and keeps business logic pure. Originally from Gary Bernhardt's Boundaries talk at Destroy All Software.

## Core principle

> "Push all the logic and data manipulation into immutable objects, and confine every side effect, every mutable reference, and every interaction with the outside world to a thin outer shell."

Split code into two parts:

```
Functional Core: pure functions only
  - no I/O, no side effects, no state mutation
  - takes data in, returns data out
  - deterministic — same input always same output
  - testable without mocks

Imperative Shell: handles all I/O
  - reads input, calls core, prints output
  - manages loops, stdin/stdout, errors
  - thin — no business logic, only orchestration
```

## The dependency rule

```
Shell can call Core.
Core cannot call Shell.
Core is unaware Shell exists.
```

## In Go

Source: https://github.com/acneto/functional-core

Go is a natural fit for FC/IS:
- functions return values and errors cleanly
- immutability approximated with value passing (not pointers)
- no exceptions — errors are values returned from pure functions
- interface types for dependency injection at the shell boundary

### Core pattern

```
// calc/core.go — pure functions only
package calc

// Apply — pure: takes operator and operands, returns result.
// No I/O, no side effects, no state.
func Apply(op string, a, b float64) (float64, error) {
    switch op {
    case "+": return a + b, nil
    case "/":
        if b == 0 { return 0, fmt.Errorf("division by zero") }
        return a / b, nil
    ...
    }
}
```

### Shell pattern

```
// main.go — imperative shell
package main

func runSOA() {
    // I/O only
    subject := readFloat("subject? ")
    for {
        op := readOp("action? ")
        object := readFloat("object? ")
        // call pure core — no logic in shell
        result, err := calc.Apply(op, subject, object)
        if err != nil { fmt.Println(err); continue }
        subject = result
        fmt.Println("= " + stripZero(subject))
    }
}
```

## Why

- **Testability** — pure functions unit-tested without mocks
- **Maintainability** — business logic not tangled with I/O
- **Reusability** — same core works for CLI, HTTP, GUI
- **Modularity** — changing I/O (CLI → web) does not touch core

## Sources

- Gary Bernhardt, Boundaries (Destroy All Software)
  https://www.destroyallsoftware.com/talks/boundaries
- Functional Core, Imperative Shell (Destroy All Software)
  https://www.destroyallsoftware.com/screencasts/catalog/functional-core-imperative-shell
- GitHub: acneto/functional-core (Go example)
  https://github.com/acneto/functional-core
- Simplify Your Code: Functional Core, Imperative Shell (Google Testing Blog)
  https://testing.googleblog.com/2025/10/simplify-your-code-functional-core.html
