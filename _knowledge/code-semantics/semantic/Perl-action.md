---
id:               PERL.ACTION
language:         Perl
role:             action
title:            The operator and function
definition:       "Perl operators have the following associativity and precedence, listed from highest precedence to lowest. With very few exceptions, these all operate on scalar values only, not array values"
sources:
  - section:      Perl 5.44 perlop §Operator Precedence
    url:          https://perldoc.perl.org/perlop#Operator-Precedence-and-Associativity
  - section:      Perl 5.44 perlsyn §Compound Statements
    url:          https://perldoc.perl.org/perlsyn#Compound-Statements
  - section:      Perl 5.44 perlsyn §Loop Control
    url:          https://perldoc.perl.org/perlsyn#Loop-Control
  - section:      Perl 5.44 perldata §Context
    url:          https://perldoc.perl.org/perldata#Context
  - section:      Perl 5.44 perlfunc
    url:          https://perldoc.perl.org/perlfunc
  - section:      Perl 5.44 perlsub
    url:          https://perldoc.perl.org/perlsub
canonical:        $x + $y
tags:             [operator, function, precedence, control-flow, context]
status:           draft
precedes:         []
---

## Action

The operator and function. Perl actions are operators (arithmetic, string, logical, comparison, assignment) and built-in functions. Every action evaluates its arguments in a context determined by the action itself, and returns a value whose interpretation depends on the calling context.

### Operator precedence (§perlop)

> Perl operators have the following associativity and precedence, listed from highest precedence to lowest. Operators borrowed from C keep the same precedence relationship with each other.

Precedence from highest to lowest:

```
left    terms and list operators (leftward)
left    ->
nonassoc  ++ --
right   **
right   ! ~ unary + unary -
left    =~ !~
left    * / % x
left    + - .
left    << >>
nonassoc  named unary operators
nonassoc  < > <= >= lt gt le ge
nonassoc  == != <=> eq ne cmp ~~
left    &
left    | ^
left    &&
left    ||
nonassoc  ..  ...
right   ?:
right   = += -= *= etc.
left    , =>
nonassoc  list operators (rightward)
right   not
left    and
left    or xor
```

> A TERM has the highest precedence in Perl. They include variables, quote and quote-like operators, any expression in parentheses, and any function whose arguments are parenthesized.

### Operators are overloaded by operand type

Perl operators dispatch differently based on their argument types:

```perl
$x + $y           # numeric addition
$x . $y           # string concatenation
$x x $y           # string repetition (or array replication)
$x <=> $y         # numeric comparison (spaceship) — returns -1, 0, 1
$x cmp $y         # string comparison
```

### Assignment as action

> The scalar assignment operator returns its left operand, i.e. the scalar assigned to. Unlike in C, it produces a valid lvalue.

```perl
$x = 42           # assignment returns $x (42), usable as lvalue
$x += 5           # combined assignment operators (+=, -=, .=, etc.)
```

> Combined assignment operators can only operate on scalars, whereas the ordinary assignment operator can assign to arrays, hashes, lists and even references.

### Binding operators

> If no string is specified via the `=~` or `!~` operator, the `$_` string is searched.

```perl
$string =~ /pattern/     # pattern match against $string
$string !~ /pattern/     # negated pattern match
/pattern/                # matches against $_ (default Subject)
```

### Context-sensitive return values

The same action returns different values depending on context:

```perl
($count) = $string =~ /(\d)/g;    # list context: returns all matches
$count  = $string =~ /(\d)/g;     # scalar context: returns true/false
```

> In list context, it returns a list of the substrings matched. In scalar context, each execution of m//g finds the next match, returning true if it matches, and false if there is no further match.

### Compound statements as actions (§perlsyn)

> A Perl script consists of a sequence of declarations and statements.

```perl
if (EXPR) { ... } elsif (EXPR) { ... } else { ... }
unless (EXPR) { ... } else { ... }
while (EXPR) { ... } continue { ... }
until (EXPR) { ... }
for (init; test; inc) { ... }
foreach VAR (LIST) { ... }
```

> The foreach loop iterates over a normal list value and sets the variable VAR to be each element of the list in turn. If VAR is omitted, `$_` is set to each value.

### Statement modifiers

> Any simple statement may optionally be followed by a SINGLE modifier, just before the terminating semicolon (or block ending).

```perl
statement if EXPR;
statement unless EXPR;
statement while EXPR;
statement until EXPR;
statement foreach EXPR;
```

### Loop control (§perlsyn Loop Control)

> The `next` command is like the continue statement in C; it starts the next iteration of the loop.

> The `last` command is like the break statement in C (as used in loops); it immediately exits the loop in question.

> The `redo` command restarts the loop block without evaluating the conditional again.

```perl
LINE: while (<STDIN>) {
    next LINE if /^#/;        # skip comment lines
    last LINE if /^__END__/;  # exit loop
    redo if /^$/;             # restart iteration for blank lines
}
```

Labels (like `LINE:`) allow loop control to target specific enclosing loops.

### Subroutine call as action (§perlsub)

> The Perl model for function call and return values is simple: all functions are passed as parameters one single flat list of scalars, and all functions likewise return to their caller one single flat list of scalars. Any arrays or hashes in these call and return lists will collapse, losing their identities.

Subroutine calls receive a flat list of scalar Objects and return a flat list of scalar Objects:

```perl
sub max {
    my ($a, $b) = @_;     # @_ is the flat argument list
    return $a > $b ? $a : $b;
}

$result = max(3, 7);      # action: call with two scalars, returns one scalar
```

> When using a signature, the signature is a parenthesised list that goes immediately before the block. It populates the signature variables from the list of arguments that were passed.

```perl
sub greet ($name, $greeting = "Hello") {
    print "$greeting, $name!\n";
}
```

Signatures declare lexical variables populated from the argument list. Default values are evaluated at call time.

### Argument passing: @_ and context

Inside a subroutine, `@_` is the array containing the passed arguments. The subroutine's return value depends on calling context:

```perl
sub get_list { return qw(a b c) }
@items = get_list();     # list context: returns all three items
$count = get_list();     # scalar context: returns last element ('c')
```

### Built-in function semantics (§perlfunc)

> Any function in the list below may be used either with or without parentheses around its arguments. (The syntax descriptions omit the parentheses.) If you use parentheses, the simple but occasionally surprising rule is this: It looks like a function, therefore it is a function, and precedence doesn't matter. Otherwise it's a list operator or unary operator, and precedence does matter.

Parentheses change how Perl parses the action — with parens, it's a function with highest precedence; without, it's a list operator whose precedence depends on context:

```perl
print (1 + 2) * 3;    # parens: prints 3, then multiplies result (void) * 3
print 1 + 2 * 3;      # no parens: prints 7 (list operator precedence)
```

> There is no rule that relates the behavior of an expression in list context to its behavior in scalar context, or vice versa. It might do two totally different things. Each operator and function decides which sort of value would be most appropriate to return in scalar context.

The same function name represents different actions depending on calling context:

```perl
@lines = <STDIN>;      # list context: read all lines
$line  = <STDIN>;      # scalar context: read one line
$count = () = <STDIN>; # list context via empty list assignment, then scalar count
```

> For functions that can be used in either a scalar or list context, nonabortive failure is generally indicated in scalar context by returning the undefined value, and in list context by returning the empty list.

```perl
$result = get_something();   # failure → undef
@result = get_something();   # failure → ()
```

### Variable interpolation as action

Double-quoted strings interpolate variables and expressions — this is a built-in action that expands Subjects into string Objects:

```perl
$name = "World";
print "Hello, $name!\n";       # interpolates $name → "Hello, World!"
print "2 + 2 = @{[2+2]}\n";   # expression interpolation via @{[...]}
```

## Summary

```
$x + $y             # arithmetic action
$x . $y             # string concatenation action
$x =~ /pat/         # pattern match action
$x <=> $y           # comparison action (returns -1, 0, 1)
if (EXPR) { ... }   # conditional action
while (EXPR) { ... } # loop action
next LABEL           # loop control action
last LABEL           # loop exit action
```
