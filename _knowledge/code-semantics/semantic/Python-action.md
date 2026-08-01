---
id:               PYTHON.ACTION
language:         Python
role:             action
title:            The statement and expression
definition:       "A block is a piece of Python program text that is executed as a unit. A code block is executed in an execution frame. A frame determines where and how execution continues after the code block's execution has completed"
sources:
  - section:      Python 3.14 §4.1 Structure of a Program
    url:          https://docs.python.org/3/reference/executionmodel.html#structure-of-a-program
  - section:      Python 3.14 §4.2 Naming and Binding
    url:          https://docs.python.org/3/reference/executionmodel.html#naming-and-binding
  - section:      Python 3.14 §4.3 Exceptions
    url:          https://docs.python.org/3/reference/executionmodel.html#exceptions
canonical:        x = 42
tags:             [statement, expression, frame, control-flow, exception]
status:           draft
precedes:         []
---

## Action

The statement and expression. Python programs execute as sequences of statements within code blocks. An expression evaluates to a value (an Object). A statement performs an action — binding names, controlling flow, or managing context.

### Code blocks as action units (§4.1)

> A Python program is constructed from code blocks. A block is a piece of Python program text that is executed as a unit. The following are blocks: a module, a function body, and a class definition.

> A code block is executed in an execution frame. A frame contains some administrative information and determines where and how execution continues after the code block's execution has completed.

Execution proceeds statement by statement within a frame. When a function is called, a new frame is pushed; when it returns, the frame is popped.

### Assignment as action

Assignment binds a name (Subject) to an object (Object) in the current scope:

```python
x = 42                    # simple assignment binds name to object
x = y = 0                 # chained assignment: both x and y bound
x += 1                    # augmented assignment: x = x + 1
a, b = 1, 2               # unpacking assignment
```

### Control flow as action

Conditional execution:

```python
if x > 0:
    print("positive")
elif x == 0:
    print("zero")
else:
    print("negative")
```

Iteration:

```python
for i in range(10):       # iterate over iterable
    print(i)

while x > 0:              # loop while condition is true
    x -= 1
```

> Targets that are identifiers in a for loop header bind the name each iteration.

### Function call as action

Function calls push a new execution frame and execute the function body:

```python
def f(x, y):
    return x + y

result = f(3, 4)          # call: evaluate f, evaluate 3 and 4,
                          # push frame, bind x=3 y=4,
                          # execute body, pop frame, bind result
```

Built-in functions are also actions — `len(x)`, `type(x)`, `print(x)`, etc.

### Exception handling as action (§4.3)

> Python uses the "termination" model of error handling: an exception handler can find out what happened and continue execution at an outer level, but it cannot repair the cause of the error and retry the failing operation.

```python
try:
    result = risky_operation()
except ValueError as e:
    print(f"caught: {e}")
except (TypeError, RuntimeError):
    print("type or runtime error")
else:
    print("no exception")
finally:
    print("always runs")
```

`raise` is the action that triggers exception handling:

```python
raise ValueError("invalid value")
```

### Context managers as action

The `with` statement manages setup and teardown actions:

```python
with open("file.txt") as f:   # __enter__ on open, __exit__ on close
    content = f.read()
```

### Expression evaluation as action

Expressions evaluate to values. Common expressions:

```python
42 + 1                # arithmetic expression → 43
"hello " + "world"    # string expression → "hello world"
x if cond else y      # conditional expression
[x * 2 for x in xs]   # list comprehension
lambda x: x + 1       # lambda expression → function object
```

## Summary

```
x = 42                # assignment action
if cond: ...          # conditional action
for i in xs: ...      # iteration action
f(args)               # function call action (pushes frame)
raise ValueError()    # exception action
with open(f) as fh:   # context manager action
[x*2 for x in xs]     # comprehension expression
```
