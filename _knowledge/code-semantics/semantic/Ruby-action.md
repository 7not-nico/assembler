---
id:               RUBY.ACTION
language:         Ruby
role:             action
title:            The method dispatch
definition:       "When you send a message, Ruby looks up the method that matches the name of the message for the receiver. Methods are stored in classes and modules so method lookup walks these, not the objects themselves"
sources:
  - section:      Ruby 4.1 Calling Methods §Method Lookup
    url:          https://docs.ruby-lang.org/en/master/syntax/calling_methods_rdoc.html#method-lookup
  - section:      Ruby 3.4 Methods
    url:          https://docs.ruby-lang.org/en/3.4/syntax/methods_rdoc.html
  - section:      Ruby 3.4 Operators
    url:          https://docs.ruby-lang.org/en/3.4/syntax/operators_rdoc.html
  - section:      Ruby 4.1 Calling Methods §Receiver
    url:          https://docs.ruby-lang.org/en/master/syntax/calling_methods_rdoc.html#receiver
  - section:      Ruby 3.4 Control Expressions
    url:          https://docs.ruby-lang.org/en/3.4/syntax/control_expressions_rdoc.html
  - section:      Ruby 3.4 Modules and Classes §Visibility
    url:          https://docs.ruby-lang.org/en/3.4/syntax/modules_and_classes_rdoc.html#visibility
  - section:      Ruby 3.4 Modules and Classes §Inheritance
    url:          https://docs.ruby-lang.org/en/3.4/syntax/modules_and_classes_rdoc.html#inheritance
  - section:      Ruby 3.4 Exceptions
    url:          https://docs.ruby-lang.org/en/3.4/syntax/exceptions_rdoc.html
  - section:      Ruby 3.4 Pattern Matching
    url:          https://docs.ruby-lang.org/en/3.4/syntax/pattern_matching_rdoc.html
  - section:      Ruby 3.4 Precedence
    url:          https://docs.ruby-lang.org/en/3.4/syntax/precedence_rdoc.html
  - section:      Ruby 3.4 Miscellaneous
    url:          https://docs.ruby-lang.org/en/3.4/syntax/miscellaneous_rdoc.html
canonical:        obj.method(args)
tags:             [dispatch, method-lookup, message-send, method-missing, operator]
status:           draft
precedes:         []
---

## Action

The method dispatch. Ruby sends a message to a receiver, which triggers method lookup. The Action is the dispatch itself — the transition from message to method body.

### Method lookup chain (§Method Lookup)

> When you send a message, Ruby looks up the method that matches the name of the message for the receiver. Methods are stored in classes and modules so method lookup walks these, not the objects themselves.

> Here is the order of method lookup for the receiver's class or module R:
> 1. The prepended modules of R in reverse order
> 2. For a matching method in R
> 3. The included modules of R in reverse order
>
> If R is a class with a superclass, this is repeated with R's superclass until a method is found.

```
receiver.method(args)

Lookup order:
  prepended modules (reverse)
  → receiver's class
  → included modules (reverse)
  → superclass (repeat from prepended modules)
  → ... until BasicObject
```

### Method lookup stops at first match

> Once a match is found method lookup stops.

Dispatch is single-dispatch — the receiver's class determines the method selected. The first method found in the ancestor chain is invoked.

### method_missing fallback

> If no match is found this repeats from the beginning, but looking for `method_missing`. The default `method_missing` is `BasicObject#method_missing` which raises a `NameError` when invoked.

Dispatch failure triggers a second lookup for `method_missing`. This enables dynamic method handling:

```ruby
class DynamicResponder
  def method_missing(name, *args)
    puts "you called #{name} with #{args}"
  end
end

obj = DynamicResponder.new
obj.any_method(1, 2, 3)
# prints: "you called any_method with [1, 2, 3]"
```

### Explicit dispatch via send

```ruby
receiver.send(:method_name, args)   # explicit dispatch
receiver.public_send(:method_name)  # respects visibility
```

`send` bypasses method visibility. `public_send` respects it. Both trigger the same method lookup chain as `.` syntax.

### Method definition (§Methods)

> A method definition consists of the `def` keyword, a method name, the body of the method, `return` value and the `end` keyword.

```ruby
def method_name(arg1, arg2)
  # body
  return_value
end
```

> By default, a method returns the last expression that was evaluated in the body of the method. The `return` keyword can be used to make it explicit that a method returns a value.

### Operators as actions (§Operators)

> In Ruby, operators such as `+`, are defined as methods on the class.
> Ruby objects can define or overload their own implementation for most operators.

```ruby
class Foo < String
  def +(str)
    self.concat(str).concat("another string")
  end
end

foobar = Foo.new("test ")
puts foobar + "baz "
# prints: "test baz another string"
```

> When using an operator, it's the expression on the left-hand side of the operation that specifies the behavior.

```ruby
'a' * 3   # => "aaa"
3 * 'a'   # TypeError — left operand defines behavior
```

### Logical operators are not methods

> Logical operators are not methods, and therefore cannot be redefined/overloaded. They are tokenized at a lower level.

```ruby
true && 9 && "string"          # => "string" (short-circuits at falsey)
false || nil || "string"       # => "string" (short-circuits at truthy)
```

`&&`, `||`, `and`, `or` are syntactic actions, not method dispatches.

### Control flow actions (§Control Expressions)

> Ruby has a variety of ways to control execution. All the expressions described here return a value.

Every control flow construct is an Action — it determines which expression evaluates next. All return a value.

```ruby
# Conditional dispatch
if test then expression end        # executes expression if test is truthy
unless test then expression end    # executes expression if test is falsey
test ? expr_true : expr_false      # ternary — returns one of two expressions

# Multi-branch dispatch
case expr
when pattern then body             # pattern matching via ===
when pattern1, pattern2 then body  # multiple patterns per branch
else body
end

# Pattern matching (Ruby 2.7+)
case expr; in pattern => var then body; else body; end
```

> The result value of an `if` expression is the last value executed in the expression.

> Once a condition matches, the `if` expression is complete and no further tests will be performed.

### Loop actions (while/until/for)

```ruby
while condition do body end        # loop while condition is truthy
until condition do body end        # loop while condition is falsey
for value in collection do body end # iterate via each
```

> The result of a `while` loop is `nil` unless `break` is used to supply a value.

> The `for` loop is similar to using each, but does not create a new variable scope.

Modifier loops run the body before checking condition:

```ruby
begin
  body
end while condition               # runs body at least once
```

### Flow interruption (break/next/redo)

`break` — exit a block or loop early. Accepts a value that becomes the expression result:

```ruby
result = [1, 2, 3].each do |value|
  break value * 2 if value.even?  # => result = 4
end
```

`next` — skip the rest of the current iteration. Accepts a value for the block result:

```ruby
result = [1, 2, 3].map do |value|
  next if value.even?             # => [2, nil, 6]
  value * 2
end
```

`redo` — redo the current iteration without checking the condition again:

```ruby
result = []
while result.length < 10 do
  result << result.length
  redo if result.last.even?
  result << result.length + 1
end
```

### Non-local control flow (throw/catch)

> `throw` and `catch` are used to implement non-local control flow in Ruby. They operate similarly to exceptions, allowing control to pass directly from the place where `throw` is called to the place where the matching `catch` is called.

> They are implemented as `Kernel` methods, not as keywords.

```ruby
def search(n)
  throw :found, n if n == 42
  search(n + 1)
end

result = catch(:found) do
  search(1)
  :not_found
end
# => 42
```

The first argument is the tag (matched by `catch`). The second argument is the return value. Unlike exceptions, `throw`/`catch` is designed for *expected* control flow changes — using an unhandled tag raises `UncaughtThrowError`.

### Program lifecycle actions (BEGIN/END)

`BEGIN` — registers a block to run before program execution:

```ruby
BEGIN { puts "initializing" }
```

`END` — registers a block to run at program exit:

```ruby
END { puts "shutting down" }
```

These are not method dispatches. They are hook Actions triggered by the runtime lifecycle.

### Method manipulation (alias/undef)

`alias` — creates a new name for an existing method or global variable:

```ruby
alias new_name old_name
alias :new_name :old_name
```

> You may use `alias` in any scope.

`undef` — prevents the current class from responding to the named method:

```ruby
undef my_method
undef :my_method
undef method1, method2
```

### Visibility constraints on dispatch

Ruby has three method visibilities that constrain which Actions are allowed:

`public` — default. Callable from any object with the correct receiver.

`protected` — callable only when the sender inherits from the defining class.

`private` — callable only from inside the owner class without an explicit receiver, or with a literal `self` receiver:

```ruby
class A
  def m; 1; end
  private :m
end

a = A.new
a.m              # NoMethodError (private)
a.send(:m)       # 1 — send bypasses visibility
```

### Super delegation

`super` — dispatches to the same method name in the superclass chain:

```ruby
class A; def m; 1; end; end
class B < A
  def m; 2 + super; end   # super dispatches to A#m
end
B.new.m  # => 3
```

> When used without any arguments `super` uses the arguments given to the subclass method. To send no arguments use `super()`.

### Dispatch forms

```ruby
obj.method(args)              # dot syntax
obj::method(args)             # :: syntax (rare)
method(args)                  # implicit self
obj.method                    # getter (no args)
obj.method = val              # setter syntax
obj + other                   # operator method
obj[arg]                      # element reference
obj[arg] = val                # element assignment
obj.send(:m, args)            # explicit dispatch
```

## Summary

```
receiver.method(args)    → lookup R's class chain → invoke or method_missing
receiver + other         → receiver.+ (operator as method)
obj.send(:m)             → same lookup, bypasses visibility
true && false            → short-circuit, not a method dispatch
```
