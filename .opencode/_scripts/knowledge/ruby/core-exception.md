# Ruby Exception

`Exception` is the root of Ruby's error hierarchy. Subclasses indicate specific error types.

## Hierarchy

```
Exception
├── NoMemoryError
├── ScriptError
│   ├── LoadError
│   ├── NotImplementedError
│   └── SyntaxError
├── SecurityError
├── SignalException
│   └── Interrupt
├── StandardError          ← default rescue catches these
│   ├── ArgumentError
│   │   └── UncaughtThrowError
│   ├── EncodingError
│   ├── FiberError
│   ├── IOError
│   │   └── EOFError
│   ├── IndexError
│   │   ├── KeyError
│   │   └── StopIteration
│   │       └── ClosedQueueError
│   ├── LocalJumpError
│   ├── NameError
│   │   └── NoMethodError
│   ├── RangeError
│   │   └── FloatDomainError
│   ├── RegexpError
│   ├── RuntimeError
│   ├── SystemCallError   ← Errno::* subclasses
│   ├── ThreadError
│   ├── TypeError
│   └── ZeroDivisionError
├── SystemExit
├── SystemStackError
└── fatal                 ← cannot rescue
```

## Key behavior

```ruby
rescue ArgumentError => e  # rescues ArgumentError and subclasses
rescue StandardError       # default — rescues most common errors
rescue Exception           # catches ALL (rarely correct)
```

## Official docs

<https://docs.ruby-lang.org/en/3.4/Exception.html>
