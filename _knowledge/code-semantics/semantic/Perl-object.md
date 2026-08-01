---
id:               PERL.OBJECT
language:         Perl
role:             object
title:            The value in context
definition:       "All data in Perl is a scalar, an array of scalars, or a hash of scalars. A scalar may contain one single value in any of three different flavors: a number, a string, or a reference"
sources:
  - section:      Perl 5.44 perldata §Scalar values
    url:          https://perldoc.perl.org/perldata#Scalar-values
  - section:      Perl 5.44 perldata §Context
    url:          https://perldoc.perl.org/perldata#Context
  - section:      Perl 5.44 perldata §List value constructors
    url:          https://perldoc.perl.org/perldata#List-value-constructors
  - section:      Perl 5.44 perlop §Operator Precedence
    url:          https://perldoc.perl.org/perlop#Operator-Precedence-and-Associativity
canonical:        42
tags:             [value, context, scalar, list, number, string, reference]
status:           draft
precedes:         []
---

## Object

The value in context. Perl passes and returns values whose interpretation depends on the context in which they are evaluated — scalar context (expecting a single item) or list context (expecting multiple items). Every value is a scalar, an array of scalars, or a hash of scalars.

### Scalar values (§perldata Scalar values)

> All data in Perl is a scalar, an array of scalars, or a hash of scalars. A scalar may contain one single value in any of three different flavors: a number, a string, or a reference.

> Scalars aren't necessarily one thing or another. There's no place to declare a scalar variable to be of type "string", type "number", type "reference", or anything else. Because of the automatic conversion of scalars, operations that return scalars don't need to care whether their caller is looking for a string, a number, or a reference.

```perl
42                  # numeric scalar value
"hello"             # string scalar value
\@array             # reference scalar value
undef               # undefined scalar value
```

### Context-sensitive evaluation (§perldata Context)

> The interpretation of operations and values in Perl sometimes depends on the requirements of the context around the operation or value. There are two major contexts: list and scalar. Certain operations return list values in contexts wanting a list, and scalar values otherwise.

> Assignment is a little bit special in that it uses its left argument to determine the context for the right argument. Assignment to a scalar evaluates the right-hand side in scalar context, while assignment to an array or hash evaluates the right-hand side in list context.

```perl
$count = @array;        # scalar context: $count gets length (Object = number)
@items = @array;        # list context: @items gets all elements (Object = list)
```

### List value constructors (§perldata List value constructors)

> In a context not requiring a list value, the value of what appears to be a list literal is simply the value of the final element, as with the C comma operator.

```perl
@foo = ('cc', '-E', $bar);    # list context: entire list assigned
$foo = ('cc', '-E', $bar);    # scalar context: $foo gets $bar's value
```

> LISTs do automatic interpolation of sublists. When a LIST is evaluated, each element of the list is evaluated in list context, and the resulting list value is interpolated into LIST just as if each individual element were a member of LIST. Thus arrays and hashes lose their identity in a LIST.

```perl
@combined = (@foo, @bar, &some_sub(), %glarch);
# Arrays and hashes are flattened — their elements become part of a single list
```

### Boolean context

> A scalar value is interpreted as FALSE in the Boolean sense if it is undefined, the null string or the number 0 (or its string equivalent, "0"), and TRUE if it is anything else.

```perl
if ($value) { ... }    # Boolean context: undef, "", "0", 0 are false
```

### Void context

> void context just means the value has been discarded, such as a statement containing only `$x;`

```perl
42;                     # void context: value computed then discarded
```

### References as objects (§perlref)

A reference is a scalar value that points to another data structure. References are Object values that can be stored, passed, and dereferenced:

```perl
$scalar_ref  = \$x;              # reference to scalar
$array_ref   = \@array;          # reference to array
$hash_ref    = \%hash;           # reference to hash
$sub_ref     = \&subroutine;     # reference to subroutine
$anon_array  = [1, 2, 3];        # anonymous array reference (Object)
$anon_hash   = {key => 'val'};   # anonymous hash reference (Object)
```

Dereferencing recovers the underlying Subject from a reference Object:

```perl
$$scalar_ref                    # dereference scalar ref
$array_ref->[0]                 # dereference array ref
$hash_ref->{'key'}              # dereference hash ref
$sub_ref->(@args)               # dereference subroutine ref
```

References are strongly-typed, uncastable pointers with builtin reference-counting and destructor invocation. They are the mechanism for creating complex data structures and passing values by reference.

### Operators produce objects (§perlop)

Operators in Perl operate mostly on scalar values. The Object is the value produced by an operator expression:

```perl
$x + $y                 # Object is numeric sum
$x . $y                 # Object is concatenated string
$x <=> $y               # Object is -1, 0, or 1 (spaceship)
$x =~ /pattern/         # Object is true/false in scalar context
```

The `||` and `//` operators return the last value evaluated, not a boolean:

```perl
$home = $ENV{HOME} // $ENV{LOGDIR} // "default";
# Object is the first defined value
```

## Summary

```
42                      # numeric scalar Object
"string"                # string scalar Object
\@array                 # reference Object
$count = @array         # scalar context: Object is array length
@items = @array         # list context: Object is array elements
($a, $b) = @array       # list assignment: Object is number of elements
$x + $y                 # operator produces numeric Object
$x . $y                 # operator produces string Object
```
