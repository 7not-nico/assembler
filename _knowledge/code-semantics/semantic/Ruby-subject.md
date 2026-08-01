---
id:               RUBY.SUBJECT
language:         Ruby
role:             subject
title:            The receiver
definition:       "Calling a method sends a message to an object so it can perform some work. self is the default receiver. To specify a receiver use . or ::"
sources:
  - section:      Ruby 4.1 Calling Methods §Receiver
    url:          https://docs.ruby-lang.org/en/master/syntax/calling_methods_rdoc.html#receiver
  - section:      Ruby 3.4 Assignment
    url:          https://docs.ruby-lang.org/en/3.4/syntax/assignment_rdoc.html
  - section:      Ruby 4.1 Calling Methods §Chaining
    url:          https://docs.ruby-lang.org/en/master/syntax/calling_methods_rdoc.html#chaining-method-calls
  - section:      Ruby 4.1 Calling Methods §Safe Navigation
    url:          https://docs.ruby-lang.org/en/master/syntax/calling_methods_rdoc.html#safe-navigation-operator
  - section:      Ruby 3.4 Modules and Classes §Scope
    url:          https://docs.ruby-lang.org/en/3.4/syntax/modules_and_classes_rdoc.html#scope
  - section:      Ruby 3.4 Modules and Classes §Singleton Classes
    url:          https://docs.ruby-lang.org/en/3.4/syntax/modules_and_classes_rdoc.html#singleton-classes
  - section:      Ruby 3.4 Miscellaneous §defined?
    url:          https://docs.ruby-lang.org/en/3.4/syntax/miscellaneous_rdoc.html#defined?
canonical:        obj.method()
tags:             [receiver, self, message-target, object, state-carrier, singleton-class]
status:           draft
precedes:         [RUBY.OBJECT, RUBY.ACTION]
---

## Subject

The receiver. Every Ruby method call targets a receiver — the object that receives the message and performs the work. The receiver carries state across method calls.

### Receiver as default (§Calling Methods)

> `self` is the default receiver. If you don't specify any receiver `self` will be used. To specify a receiver use `.`:

```
my_object.my_method
```

> Calling a method sends a message to an object so it can perform some work.

The Subject is the object that receives the message. When no explicit receiver exists, `self` fills the role.

### Receiver forms

```
obj.method()          // explicit receiver via .
obj::method()         // explicit receiver via :: (rare)
method()              // implicit receiver: self
obj.method1.method2   // chaining: each return value becomes next receiver
obj&.method           // safe navigation: skip if receiver is nil
```

### Chained receivers (§Chaining)

> You can "chain" method calls by immediately following one method call with another.

Each method call in a chain returns a new object that becomes the Subject for the next call. The Subject transforms across the chain.

```
a = [:foo, 'bar', 2]
a1 = [:baz, nil, :bam, nil]
a2 = a.append(*a1).compact
# a.append(*a1) returns a new Array → becomes Subject of .compact
```

### Safe navigation subject (§Safe Navigation)

> `&.`, called "safe navigation operator", allows to skip method call when receiver is `nil`.

The Subject may be absent (`nil`). Safe navigation short-circuits dispatch rather than raising an error.

```
"Python is fascinating!".match(REGEX)&.values_at(1, 2)  # => nil, no error
```

### State carrier (§Assignment)

The Subject holds state across method calls. Ruby provides four variable kinds:

```ruby
local      = 1     # scope-local, created by assignment
@instance  = 2     # per-object, shared across methods of same object
@@class    = 3     # shared across class, subclasses, and instances
$global    = 4     # accessible everywhere
```

> Instance variables are shared across all methods for the same object.

> Class variables are shared between a class, its subclasses and its instances.

> Global variables are accessible everywhere.

### Assignment creates local subject (§Assignment)

> Assignment creates a local variable if the variable was not previously referenced.

The simplest Subject is a local variable created by assignment. Once assigned-to, the name becomes a local variable for the rest of the scope.

```ruby
v = 5                    # Subject created by assignment
v                        # Subject referenced — no method call
```

### Self context shifts (§Modules and Classes)

> `self` refers to the object that defines the current scope. `self` will change when entering a different method or when defining a new module.

At the top level, `self` is the "main" object — an instance of `Object`:

```ruby
puts self    # => main
self.class   # => Object
```

Inside a class or module definition, `self` is the class or module itself. Inside an instance method, `self` is the receiver instance.

```ruby
class C
  puts self    # => C (the class object)
  def m
    self       # => the instance
  end
end
```

### Singleton class (§Singleton Classes)

> The singleton class (also known as the metaclass or eigenclass) of an object is a class that holds methods for only that instance.

Every object can have its own singleton class, making the Subject unique:

```ruby
o = Object.new
def o.my_method
  1 + 1
end
# my_method lives in o's singleton class, not in Object
```

> You can access the singleton class of an object using `class << object`:

```ruby
class << o
  def my_method
    1 + 1
  end
end
```

The singleton class sits between the object and its real class in the method lookup chain. Methods defined with `def self.method` inside a class body define class methods by opening the class's singleton class.

### Checking subject existence (§defined?)

> `defined?` is a keyword that returns a string describing its argument.

`defined?` returns a description of what the expression refers to, or `nil` if it is not defined. This checks whether a Subject name exists before using it:

```ruby
defined?(RUBY_VERSION)    # => "constant"
defined?(UNDEFINED)       # => nil
defined?(@instance_var)   # => "instance-variable" or nil
defined?(local)           # => "local-variable" or nil
```

## Summary

```
receiver.method(args)    → receiver is Subject (. or ::)
method(args)             → self is Subject (implicit)
a.m1.m2                  → a returns new Subject for m2
obj&.method              → Subject may be nil, skip if so
@x = 1                   → instance variable persists per Subject scope
class << o               → o's singleton class opens
defined? x               → checks if Subject exists
```
