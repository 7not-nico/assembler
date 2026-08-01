---
id:               RUBY.OBJECT
language:         Ruby
role:             object
title:            The argument
definition:       "There are three types of arguments when sending a message — positional, keyword (or named), and the block argument. All arguments in ruby are passed by reference and are not lazily evaluated"
sources:
  - section:      Ruby 4.1 Calling Methods §Arguments
    url:          https://docs.ruby-lang.org/en/master/syntax/calling_methods_rdoc.html#arguments
  - section:      Ruby 4.1 Calling Methods §Positional Arguments
    url:          https://docs.ruby-lang.org/en/master/syntax/calling_methods_rdoc.html#positional-arguments
  - section:      Ruby 4.1 Calling Methods §Keyword Arguments
    url:          https://docs.ruby-lang.org/en/master/syntax/calling_methods_rdoc.html#keyword-arguments
  - section:      Ruby 4.1 Calling Methods §Block Argument
    url:          https://docs.ruby-lang.org/en/master/syntax/calling_methods_rdoc.html#block-argument
  - section:      Ruby 4.1 Calling Methods §Unpacking Positional Arguments
    url:          https://docs.ruby-lang.org/en/master/syntax/calling_methods_rdoc.html#unpacking-positional-arguments
  - section:      Ruby 4.1 Calling Methods §Proc to Block Conversion
    url:          https://docs.ruby-lang.org/en/master/syntax/calling_methods_rdoc.html#proc-to-block-conversion
  - section:      Ruby 3.4 Control Expressions §Modifier Statements
    url:          https://docs.ruby-lang.org/en/3.4/syntax/control_expressions_rdoc.html#modifier-statements
  - section:      Ruby 3.4 Precedence
    url:          https://docs.ruby-lang.org/en/3.4/syntax/precedence_rdoc.html
canonical:        "my_method(1, '2', key: value) { |x| x }"
tags:             [argument, positional, keyword, block, splat, pass-by-reference]
status:           draft
precedes:         []
---

## Object

The argument. Every Ruby method call may carry arguments — values passed to the method for the duration of the call. Ruby supports three argument types: positional, keyword, and block.

### Three argument types (§Arguments)

> There are three types of arguments when sending a message, the positional arguments, keyword (or named) arguments and the block argument. Each message sent may use one, two or all types of arguments, but the arguments must be supplied in this order.

```
my_method(1, '2', :three)              # positional
my_method(keyword1: value1)            # keyword
my_method do ... end                   # block
my_method(1, key: val) { |x| x }      # all three together
```

### Pass-by-reference (§Arguments)

> All arguments in ruby are passed by reference and are not lazily evaluated.

The Object is a reference to a value. The method receives the same object, not a copy. Mutations inside the method affect the caller's object.

### Positional arguments (§Positional Arguments)

> The positional arguments for the message follow the method name.

```ruby
my_method(argument1, argument2)
my_method argument1, argument2          # parentheses optional
```

Positional arguments map to method parameters in declaration order. Extra or missing positional arguments raise `ArgumentError`.

### Default positional arguments (§Default Positional Arguments)

> When the method defines default arguments you do not need to supply all the arguments to the method. Ruby will fill in the missing arguments in-order.

```ruby
def my_method(a, b = 2, c = 3, d)
  [a, b, c, d]
end

my_method(1, 4)       # => [1, 2, 3, 4]
my_method(1, 5, 6)    # => [1, 5, 3, 6]
```

Ruby fills missing arguments from the rightmost required parameter inward. Default-valued parameters in the middle receive their defaults when skipped.

### Keyword arguments (§Keyword Arguments)

> Keyword arguments follow any positional arguments and are separated by commas like positional arguments.

```ruby
my_method(positional1, keyword1: value1, keyword2: value2)
```

Keyword arguments may appear in any order. Missing keywords use method-defined defaults. Unknown keywords raise `ArgumentError` unless the method accepts `**` arbitrary keywords.

```ruby
def my_method(first: 1, second: 2, third: 3)
  [first, second, third]
end

my_method(third: 5, first: 3)    # => [3, 2, 5]
```

### Block argument (§Block Argument)

> The block argument sends a closure from the calling scope to the method. The block argument is always last when sending a message to a method.

```ruby
my_method do |argument1, argument2|
  # block body
end

my_method { |arg| arg * 2 }
```

A block is a closure — it captures local variables from the calling scope. Blocks may declare block-local arguments after `;` to isolate variables.

### Unpacking positional arguments with splat (§Unpacking Positional Arguments)

> You can turn an Array into an argument list with `*` (or splat) operator.

```ruby
arguments = [1, 2, 3]
my_method(*arguments)            # => my_method(1, 2, 3)
my_method(1, *arguments)         # combine with positional

# Splat works on any object responding to #to_a
class Name
  def initialize(name) @name = name end
  def to_a = @name.split(' ')
end
name = Name.new('Jane Doe')
p(*name)                         # prints: "Jane" "Doe"
```

### Unpacking keyword arguments with double splat (§Unpacking Keyword Arguments)

> You can turn a Hash into keyword arguments with the `**` (keyword splat) operator.

```ruby
arguments = { first: 3, second: 4, third: 5 }
my_method(**arguments)           # => my_method(first: 3, second: 4, third: 5)
my_method(third: 5, **arguments) # combine with explicit keywords
```

### Proc to block conversion (§Proc to Block Conversion)

> You can convert a proc or lambda to a block argument with the `&` (block conversion) operator.

```ruby
argument = proc { |a| puts "#{a.inspect} was yielded" }
my_method(&argument)
```

The `&` operator captures the block as a Proc parameter, or converts a Proc to a block at the call site.

### Modifier statements are not expressions (§Control Expressions)

> Ruby's grammar differentiates between statements and expressions. All expressions are statements (an expression is a type of statement), but not all statements are expressions.

Modifier forms of `if`, `unless`, `while`, `until`, and `rescue` are statements but not expressions. They cannot be used where an expression is expected — such as method arguments:

```ruby
puts(1 if true)    # => SyntaxError (modifier if is not an expression)
puts((1 if true))  # => 1 (wrapped in parentheses to create expression)
puts (1 if true)   # => 1 (space before paren — parses as method call with expr)
```

The Object slot at a call site only accepts expressions. Modifier statements must be wrapped in parentheses to become valid objects.

### Precedence shapes argument evaluation (§Precedence)

Ruby operator precedence determines how expressions that serve as Objects are grouped. From highest to lowest: `!` `~` unary `+` `**` unary `-` `*` `/` `%` `+` `-` `<<` `>>` `&` `|` `^` `>` `>=` `<` `<=` `<=>` `==` `===` `!=` `=~` `!~` `&&` `||` `..` `...` `? :` modifier-rescue `=` `+=` etc. `defined?` `not` `or` `and` modifier-if/modifier-unless/modifier-while/modifier-until `{ }` blocks

```ruby
a + b * c    # b * c evaluated first: Objects are (a) and (b * c)
a || b && c  # b && c evaluated first: Objects are (a) and (b && c)
```

Operator methods (`+`, `*`, `==`, etc.) are themselves method dispatches. The Object on the right side of an operator is always evaluated before the operator method is called.

## Summary

```
my_method(arg1, arg2)           # positional objects
my_method(key: val)             # keyword objects
my_method { block }             # block object (closure)
my_method(*arr)                 # splat: Array → positional objects
my_method(**hash)               # double splat: Hash → keyword objects
my_method(&proc)                # block conversion: Proc → block
```
