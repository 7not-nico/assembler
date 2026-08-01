---
id:               GO.ACTION
language:         Go
role:             action
title:            The statement and expression
definition:       An expression specifies the computation of a value by applying operators and functions to operands — statements control execution
sources:
  - section:      Go Spec §Expressions
    url:          https://go.dev/ref/spec#Expressions
  - section:      Go Spec §Statements
    url:          https://go.dev/ref/spec#Statements
  - section:      Go Spec §Go statements
    url:          https://go.dev/ref/spec#Go_statements
  - section:      Go Spec §Defer statements
    url:          https://go.dev/ref/spec#Defer_statements
  - section:      Go Spec §Select statements
    url:          https://go.dev/ref/spec#Select_statements
  - section:      Go Spec §Order of evaluation
    url:          https://go.dev/ref/spec#Order_of_evaluation
  - section:      Go Spec §Program execution
    url:          https://go.dev/ref/spec#Program_execution
canonical:        x = 42
tags:             [statement, expression, goroutine, control-flow, defer, evaluation-order]
status:           draft
precedes:         []
---

## Action

The statement and expression. Go splits execution into two categories: **expressions** compute values by applying operators and functions to operands; **statements** control execution flow. Go adds three concurrent action forms beyond traditional control flow: `go` (goroutine launch), `defer` (delayed invocation), and `select` (channel communication rendezvous).

### Core definition — expressions (§Expressions)

> An expression specifies the computation of a value by applying operators and functions to operands.

Expressions are the value-producing Actions. Every expression evaluates to a typed value. Operands are literals, identifiers, or parenthesized sub-expressions:

```go
42                        // literal expression: integer value
x + 1                     // operator expression: add
f(2)                      // call expression: function invocation
a[i]                      // index expression: element access
<-ch                      // receive expression: channel value
```

### Core definition — statements (§Statements)

> Statements control execution.

Statements sequence, branch, loop, and synchronize. The statement grammar defines every control action:

```
Statement = Declaration | LabeledStmt | SimpleStmt |
            GoStmt | ReturnStmt | BreakStmt | ContinueStmt | GotoStmt |
            FallthroughStmt | Block | IfStmt | SwitchStmt | SelectStmt |
            ForStmt | DeferStmt .

SimpleStmt = EmptyStmt | ExpressionStmt | SendStmt | IncDecStmt |
             Assignment | ShortVarDecl .
```

```go
x = 42                     // assignment statement: write to Subject
if x > 0 { return }        // if statement: conditional branch
for i := 0; i < n; i++ { } // for statement: iteration
switch x {                 // switch statement: multi-way branch
case 1:  fmt.Println("one")
default: fmt.Println("other")
}
```

### Order of evaluation (§Order of evaluation)

> All function calls, method calls, receive operations, and binary logical operations are evaluated in lexical left-to-right order.

Evaluation order is partially specified — function calls, receives, and logical operators are left-to-right, but evaluation of operands within an expression relative to each other is not fully specified:

```go
y[f()], ok = g(z || h(), i()+x[j()], <-c), k()
// calls execute in order: f(), h() (if z false), i(), j(), <-c, g(), k()
// order of x indexing and y evaluation relative to these is not specified
```

### Goroutine launch — `go` (§Go statements)

> A "go" statement starts the execution of a function call as an independent concurrent thread of control, or goroutine, within the same address space.

`go` forks execution into a new goroutine. The caller does not wait for completion. The new goroutine shares all Subjects (variables) with the caller:

```go
go Server()                    // starts Server() concurrently
go func(c chan<- bool) {       // starts closure as goroutine
    for { sleep(10); c <- true }
}(c)
```

Goroutines execute independently. Program exit does not wait for non-main goroutines to complete.

### Deferred invocation — `defer` (§Defer statements)

> A "defer" statement invokes a function whose execution is deferred to the moment the surrounding function returns, either because the surrounding function executed a return statement, reached the end of its function body, or because the corresponding goroutine is panicking.
>
> Deferred functions are invoked immediately before the surrounding function returns, in the reverse order they were deferred.

`defer` schedules an Action to execute at function exit, in LIFO order. The function's arguments are evaluated at the `defer` site, not at execution time:

```go
func readFile(name string) error {
    f, err := os.Open(name)
    if err != nil { return err }
    defer f.Close()              // deferred Action: runs on return
    // use f ...
}                                // f.Close() executes here
```

### Channel communication — `select` (§Select statements)

> A "select" statement chooses which of a set of possible send or receive operations will proceed.

`select` is the concurrent rendezvous Action. It blocks until one of the channel operations can proceed:

```go
select {
case msg := <-ch1:            // receive from ch1 — Action when data arrives
    fmt.Println(msg)
case ch2 <- 42:               // send to ch2 — Action when ch2 is ready
    fmt.Println("sent")
default:                       // immediate — Action when no channel ready
    fmt.Println("no comm")
}
```

### Action kinds

```go
x = 42                        // assignment: write to mutable Subject
x + 1                         // expression: compute value
if x > 0 { return }           // if: conditional branch
for i := 0; i < 5; i++ { }   // for: iteration
switch x { case 1: ... }     // switch: multi-way branch
go f()                        // go: concurrent goroutine launch
defer f.Close()               // defer: delayed invocation on return
select { case <-ch: ... }    // select: channel rendezvous
return x                      // return: exit with value
<-ch                          // receive: channel read
ch <- v                       // send: channel write
```

## Cycle

```go
var counter int                // Action: declaration — Subject created
for i := 0; i < 100; i++ {    // Action: for loop — iteration
    go func() {                // Action: goroutine launch
        counter++              // Action: increment — concurrent write
    }()
}
time.Sleep(time.Second)        // Action: sleep — wait
fmt.Println(counter)           // Action: call — read Subject, produce output
```

Every Go program reduces to this cycle: variable declaration creates a Subject, statements sequence execution, expressions compute values, and goroutines fork independent concurrent Actions sharing the same Subject space.
