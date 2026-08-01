---
id:               COMMONLISP.SUBJECT
language:         CommonLisp
role:             subject
title:            The form
definition:       "Evaluation can be understood in terms of a model in which an interpreter recursively traverses a form performing each step of the computation as it goes. Forms fall into three categories: symbols, conses, and self-evaluating objects"
sources:
  - section:      CLHS §3.1 Evaluation
    url:          https://www.lispworks.com/documentation/HyperSpec/Body/03_a.htm
  - section:      CLHS §3.1.2.1 Form Evaluation
    url:          https://www.lispworks.com/documentation/HyperSpec/Body/03_aba.htm
  - section:      CLHS §3.1.2.1.2 Conses as Forms
    url:          https://www.lispworks.com/documentation/HyperSpec/Body/03_abab.htm
  - section:      CL New Reference §3.1.1 Introduction to Environments
    url:          https://lisp-docs.github.io/cl-language-reference/chap-3/d-b-evaluation
canonical:        (f x y)
tags:             [form, s-expression, symbol, cons, special-form, macro, lambda]
status:           draft
precedes:         [COMMONLISP.OBJECT, COMMONLISP.ACTION]
---

## Subject

The form. In Common Lisp, code and data share the same representation — S-expressions. Every piece of code is a form: a symbol, a cons (list), or a self-evaluating object. The evaluator recursively traverses forms, and the lexical environment binds names to values.

### Forms are S-expressions (§3.1)

> Evaluation can be understood in terms of a model in which an interpreter recursively traverses a form performing each step of the computation as it goes.

> Forms fall into three categories: symbols, conses, and self-evaluating objects.

```
42                  ; self-evaluating Object → Subject = 42
x                   ; symbol Subject → resolved in environment
(f x y)             ; cons Subject → compound form
```

### Symbols as forms (§3.1.2.1.1)

A symbol used as a form evaluates to the value of the variable it names in the current lexical environment, or to the symbol itself if it names a constant:

```lisp
(setq x 42)          ; establish binding
x                    ; evaluates to 42 (variable reference)
t                    ; evaluates to T (self-evaluating constant)
nil                  ; evaluates to NIL (self-evaluating constant)
```

### Conses as compound forms (§3.1.2.1.2)

> A cons that is used as a form is called a compound form. If the car of that compound form is a symbol, that symbol is the name of an operator, and the form is either a special form, a macro form, or a function form, depending on the function binding of the operator.

```lisp
(if test then else)   ; special form — operator IF
(defun f (x) x)       ; macro form — operator DEFUN
(+ x y)               ; function form — operator +
((lambda (x) x) 42)   ; lambda form — car is lambda expression
```

### Environments and namespaces (§3.1.1)

> A binding is an association between a name and that which the name denotes. Bindings are established in a lexical environment or a dynamic environment by particular special operators.

> An environment is a set of bindings and other information used during evaluation (e.g., to associate meanings with names).

> Bindings in an environment are partitioned into namespaces. A single name can simultaneously have more than one associated binding per environment, but can have only one associated binding per namespace.

Common Lisp is a Lisp-2 — each name can have separate bindings in different namespaces. A symbol has both a value (variable) and a function binding:

```lisp
(setq x 42)           ; binds value namespace
(defun x (y) y)       ; binds function namespace
x                     ; → 42 (value binding)
(x 1)                 ; → 1 (function binding, not value)
```

Three types of environment:

> The global environment contains bindings with both indefinite scope and indefinite extent — bindings of dynamic variables, functions, macros, type names.

> A dynamic environment contains bindings whose duration is bounded by points of establishment and disestablishment — bindings for dynamic variables, active catch tags, unwind-protect points, active handlers and restarts.

> A lexical environment contains information having lexical scope — bindings of lexical variables, symbol macros, block tags, go tags.

The Subject is evaluated within an environment that provides binding context:

```lisp
(let ((x 1) (y 2))    ; lexical environment: x=1, y=2
  (+ x y))            ; evaluated in that environment

(defvar *g* 42)       ; global environment: dynamic variable
(proclaim '(special *x*))  ; dynamic environment declaration
```

## Summary

```
42                    ; self-evaluating form → itself
x                     ; symbol form → variable value
(f x y)               ; compound form → operator F applied to args
(if t 'a 'b)          ; special form — IF
(defmacro m (x) ...)  ; macro form — DEFMACRO
(lambda (x) x)        ; lambda form — function object
```
