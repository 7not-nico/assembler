---
id:               PERL.SUBJECT
language:         Perl
role:             subject
title:            The variable with sigil
definition:       "Scalar values are always named with the sigil '$', even when referring to a scalar that is part of an array or a hash. The '$' symbol works semantically like the English word 'the' in that it indicates a single value is expected"
sources:
  - section:      Perl 5.44 perldata §Variable names
    url:          https://perldoc.perl.org/perldata#Variable-names
  - section:      Perl 5.44 perldata §Context
    url:          https://perldoc.perl.org/perldata#Context
  - section:      Perl 5.44 perldata §Scalar values
    url:          https://perldoc.perl.org/perldata#Scalar-values
  - section:      Perl 5.44 perlsyn §Foreach loop
    url:          https://perldoc.perl.org/perlsyn#Foreach-Loop
  - section:      Perl 5.44 perlvar §General variables
    url:          https://perldoc.perl.org/perlvar#General-variables
  - section:      Perl 5.44 perlsub
    url:          https://perldoc.perl.org/perlsub
canonical:        $scalar = 42
tags:             [sigil, variable, scalar, array, hash, default-subject]
status:           draft
precedes:         [PERL.OBJECT, PERL.ACTION]
---

## Subject

The variable with sigil. Perl has three built-in data types — scalars (`$`), arrays of scalars (`@`), and hashes of scalars (`%`). Each is identified by its sigil, which acts as a type marker telling the reader what sort of value is expected.

### Variable names (§perldata Variable names)

> Perl has three built-in data types: scalars, arrays of scalars, and associative arrays of scalars, known as "hashes". A scalar is a single string, number, or a reference to something.

> Values are usually referred to by name, or through a named reference. The first character of the name tells you to what sort of data structure it refers. This character is called a "sigil".

```
$scalar          # a single value
@array           # multiple values indexed by number
%hash            # key-value pairs indexed by string
```

### Sigil semantics

> Scalar values are always named with the sigil `$`, even when referring to a scalar that is part of an array or a hash. The `$` symbol works semantically like the English word "the" in that it indicates a single value is expected.

> Entire arrays (and slices of arrays and hashes) are denoted by the sigil `@`, which works much as the word "these" or "those" does in English, in that it indicates multiple values are expected.

The sigil is not part of the variable name — it changes to indicate what is expected from the expression:

```perl
$days            # the scalar value "days"
@days            # the entire array ($days[0], $days[1], ...)
$days[28]        # the 29th element of @array (still $, single value)
$days{'Feb'}     # the 'Feb' value from %hash
%days{'Feb'}     # key/value slice returning ('Feb' => value)
```

### Default subject: $_

Perl has a default variable `$_` that serves as the implicit Subject for many operations:

```perl
foreach (@items) {
    print               # prints $_ by default
}
while (<STDIN>) {       # reads into $_ by default
    print if /pattern/  # matches against $_ by default
}
```

When no explicit variable is provided, many built-in operations default to `$_` as the Subject.

### Context determines value interpretation (§perldata Context)

> The interpretation of operations and values in Perl sometimes depends on the requirements of the context around the operation or value. There are two major contexts: list and scalar.

Assignment uses its left argument to determine context for the right argument:

```perl
$foo = @array;    # scalar context: $foo gets length of @array
@bar = @array;    # list context: @bar gets all elements of @array
```

An array in scalar context returns its length. A hash in scalar context returns false if empty. This is Perl's context-sensitive evaluation — the same Subject produces different values depending on the context in which it is used.

### Default subject: $_ (§perlvar)

> The default input and pattern-searching space. The following pairs are equivalent:

```perl
while (<STDIN>) { print; }     # $_ is implicit
while ($_ = <STDIN>) { print $_; }  # explicit form

/pattern/                      # matches against $_
$_ =~ /pattern/                # explicit form
```

`$_` is the implicit Subject for many Perl operations: pattern matching, file input, `foreach` iteration, `print`. When no explicit Subject is given, these operations default to `$_`.

> The `foreach` loop iterates over a normal list value and sets the variable VAR to be each element of the list in turn. If VAR is omitted, `$_` is set to each value.

### Predefined variables as subjects (§perlvar)

Perl provides many special variables that serve as built-in Subjects carrying global state:

```perl
$!              # system error code/message
$?              # child process exit status
$@              # eval error message
$0              # program name
$[              # array base index (default 0)
$]              # Perl version
$#array         # last index of @array
```

These are Subjects set by the runtime and readable by the program. They carry state across actions.

## Summary

```
$scalar           # Subject — single value (sigil $)
@array            # Subject — multiple indexed values (sigil @)
%hash             # Subject — key-value pairs (sigil %)
$_                # default Subject for many built-in operations
$foo = @array     # Subject context determines meaning (length vs list)
```
