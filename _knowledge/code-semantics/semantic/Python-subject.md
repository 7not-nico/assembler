---
id:               PYTHON.SUBJECT
language:         Python
role:             subject
title:            The name in a namespace
definition:       "Names refer to objects. Names are introduced by name binding operations. Each assignment or import statement occurs within a block defined by a class or function definition or at the module level"
sources:
  - section:      Python 3.14 §4.2 Naming and Binding
    url:          https://docs.python.org/3/reference/executionmodel.html#naming-and-binding
  - section:      Python 3.14 §4.1 Structure of a Program
    url:          https://docs.python.org/3/reference/executionmodel.html#structure-of-a-program
  - section:      Python 3.14 §4.4 Runtime Components
    url:          https://docs.python.org/3/reference/executionmodel.html#runtime-components
  - section:      Python 3.14 §4.4.2 Python Runtime Model
    url:          https://docs.python.org/3/reference/executionmodel.html#python-runtime-model
canonical:        x = 42
tags:             [name, namespace, scope, binding, frame]
status:           draft
precedes:         [PYTHON.OBJECT, PYTHON.ACTION]
---

## Subject

The name in a namespace. Python names are references bound to objects within a scope. The namespace — a mapping from names to objects — carries state between statements.

### Names refer to objects (§4.2)

> Names refer to objects. Names are introduced by name binding operations.

A name is a Subject that refers to an Object (a value). Assignment creates or rebinds a name:

```python
x = 42            # name 'x' bound to object 42
x = 'hello'       # name 'x' rebound to different object
```

### Binding constructs (§4.2.1)

> The following constructs bind names: formal parameters to functions, class definitions, function definitions, assignment expressions, targets in assignments, for loop header, after as in a with statement, except clause, import statements.

```python
def f(x): ...        # 'f' and 'x' are bound
class C: ...         # 'C' is bound
x = 1                # 'x' is bound
for i in range(10):  # 'i' is bound in the loop
import math          # 'math' is bound
```

### Frames and blocks (§4.1)

> A Python program is constructed from code blocks. A block is a piece of Python program text that is executed as a unit. The following are blocks: a module, a function body, and a class definition.

> A code block is executed in an execution frame. A frame contains some administrative information and determines where and how execution continues after the code block's execution has completed.

Each function call creates a new frame — a new namespace Subject:

```python
def outer():
    x = 1          # x in outer's frame
    def inner():
        y = 2      # y in inner's frame; x is free variable
    return inner
```

### Runtime layers as subject containers (§4.4)

> Python's execution model does not operate in a vacuum. It runs on a host machine and through that host's runtime environment.

> The process, as the data part, is the execution context in which the program runs. It mostly consists of the set of resources assigned to the program by the host, including memory, signals, file handles, sockets, and environment variables.

> Each interpreter completely encapsulates all of the non-process-global, non-thread-specific state needed for the Python runtime to work. Notably, the interpreter's state persists between uses. It includes fundamental data like `sys.modules`.

> The thread state includes the current raised exception and the thread's Python call stack.

The Subject is layered. The process holds global resources. The interpreter holds module-level state. The thread state holds the current call stack. A Python name resolves within this layered context:

```
host machine → process → interpreter → thread state → frame → name
```

### Scopes and resolution (§4.2.2)

> A scope defines the visibility of a name within a block. If a local variable is defined in a block, its scope includes that block.

> When a name is used in a code block, it is resolved using the nearest enclosing scope.

```python
x = 'global'
def f():
    x = 'local'    # binds x in f's scope
    print(x)       # resolves to local 'x'
f()                # prints 'local'
print(x)           # prints 'global'
```

The Subject is resolved through the scope chain: local → enclosing → global → builtins. Assignment binds in the current scope unless declared `global` or `nonlocal`.

## Summary

```
x = 42            # name 'x' bound to object 42 in current scope
def f(): ...      # name 'f' bound to function object
import math       # name 'math' bound to module object
for i in xs: ...  # name 'i' bound per iteration
nonlocal x        # rebinds in enclosing scope
global x          # rebinds in module scope
```
