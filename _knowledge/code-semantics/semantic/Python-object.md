---
id:               PYTHON.OBJECT
language:         Python
role:             object
title:            The object with identity, type, and value
definition:       "Objects are Python's abstraction for data. All data in a Python program is represented by objects or by relations between objects. Every object has an identity, a type and a value"
sources:
  - section:      Python 3.14 §3.1 Objects, Values, and Types
    url:          https://docs.python.org/3/reference/datamodel.html#objects-values-and-types
  - section:      Python 3.14 §3.3 Special Method Names
    url:          https://docs.python.org/3/reference/datamodel.html#special-method-names
canonical:        42
tags:             [object, identity, type, value, mutable, immutable]
status:           draft
precedes:         []
---

## Object

The object with identity, type, and value. Everything in Python is an object — numbers, strings, functions, classes, even code itself. Every object carries its identity (unchangeable), type (unchangeable), and value (possibly changeable).

### Objects as data (§3.1)

> Objects are Python's abstraction for data. All data in a Python program is represented by objects or by relations between objects. Even code is represented by objects.

> Every object has an identity, a type and a value. An object's identity never changes once it has been created; you may think of it as the object's address in memory.

```python
id(42)            # identity: unique integer (memory address in CPython)
type(42)          # type: <class 'int'>
42                # value: the integer 42
```

### Type determines operations

> An object's type determines the operations that the object supports (e.g., "does it have a length?") and also defines the possible values for objects of that type.

Types are defined through classes. The operations an Object supports are determined by its type's special methods:

```python
len(x)            # calls x.__len__()
x + y             # calls x.__add__(y)
str(x)            # calls x.__str__()
x[key]            # calls x.__getitem__(key)
```

### Mutable vs immutable

> Objects whose value can change are said to be mutable; objects whose value is unchangeable once they are created are called immutable.

```python
# Immutable objects
x = 42            # int — cannot change value
s = "hello"       # str — cannot change characters
t = (1, 2)        # tuple — cannot change elements

# Mutable objects
lst = [1, 2]      # list — can append, modify elements
d = {'a': 1}      # dict — can add, remove keys
s = {1, 2}        # set — can add, remove elements
```

### Object lifetime

> Objects are never explicitly destroyed; however, when they become unreachable they may be garbage-collected.

Python uses reference counting (plus cycle detection) to manage Object lifetimes. An Object lives as long as some name (Subject) refers to it.

### Special methods as object capabilities (§3.3)

The Python data model defines special methods that determine how an object behaves in various contexts:

```python
__add__, __sub__      # arithmetic operations
__getitem__, __setitem__  # indexing operations
__call__              # callable objects (functions)
__iter__, __next__    # iteration protocol
__enter__, __exit__   # context manager protocol
__bool__, __len__     # truthiness testing
```

## Summary

```
42                # int Object (immutable)
"hello"           # str Object (immutable)
[1, 2]            # list Object (mutable)
{'a': 1}          # dict Object (mutable)
lambda x: x + 1   # function Object (callable)
type(x)           # type Object (determines operations)
id(x)             # identity (unchangeable)
```
