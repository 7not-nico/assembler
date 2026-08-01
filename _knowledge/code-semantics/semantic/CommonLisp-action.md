---
id:               COMMONLISP.ACTION
language:         CommonLisp
role:             action
title:            The evaluation of a form
definition:       "Evaluation can be understood in terms of a model in which an interpreter recursively traverses a form performing each step of the computation as it goes"
sources:
  - section:      CLHS §3.1 Evaluation
    url:          https://www.lispworks.com/documentation/HyperSpec/Body/03_a.htm
  - section:      CLHS §3.1.2.1.2 Conses as Forms
    url:          https://www.lispworks.com/documentation/HyperSpec/Body/03_abab.htm
  - section:      CLHS §3.1.2.1.2.3 Function Forms
    url:          https://www.lispworks.com/documentation/HyperSpec/Body/03_abad.htm
  - section:      CLHS §3.1.2.1.1 Symbols as Forms
    url:          https://www.lispworks.com/documentation/HyperSpec/Body/03_abaa.htm
canonical:        (+ 1 2)
tags:             [evaluation, recursive-traversal, special-operator, macro, function-call]
status:           draft
precedes:         []
---

## Action

The evaluation of a form. Common Lisp evaluation recursively traverses an S-expression, dispatching on the form's category — symbol, compound form, or self-evaluating object. Compound forms are further classified as special forms, macro forms, function forms, or lambda forms.

### Symbol evaluation (§3.1.2.1.1)

A symbol as a form evaluates by looking up its value binding:

```lisp
x                   → value of variable x
t                   → T (constant, self-evaluating)
nil                 → NIL (constant, self-evaluating)
```

### Compound form classification (§3.1.2.1.2)

> A cons that is used as a form is called a compound form. If the car of that compound form is a symbol, that symbol is the name of an operator, and the form is either a special form, a macro form, or a function form.

The evaluator classifies the operator:

```lisp
(if x 1 2)          ; IF is a special operator
(defun f (x) x)     ; DEFUN is a macro
(+ 1 2)             ; + is a function
```

### Special forms (§3.1.2.1.2.1)

Special operators have unique evaluation rules defined by the language. They do not evaluate their arguments in the standard way:

```lisp
(if test then else)   ; evaluate test; if true, evaluate then, else else
(let ((x 1)) ...)     ; establish lexical bindings, evaluate body
(setq x 42)           ; set variable without evaluating the first argument
(quote (1 2))         ; return argument unevaluated
(lambda (x) x)        ; create function object without calling
progn                 ; evaluate forms in sequence, return last
the                   ; type declaration
tagbody               ; go tags and imperative jumps
```

### Macro forms (§3.1.2.1.2.2)

Macro forms are transformed before evaluation. The macro function receives the unevaluated form and produces a new form that is evaluated in its place:

```lisp
;; Macro call:
(defstruct point x y)
;; Expands to:
(progn
  (defstruct (point) (x) (y))
  ...)

;; Macro expansion happens at compile/load time
```

### Function forms (§3.1.2.1.2.3)

> If the operator is neither a special operator nor a macro name, it is assumed to be a function name (even if there is no definition for such a function).

Function call evaluation:
1. Evaluate the arguments (left to right) in the current environment
2. Look up the function binding of the operator
3. Apply the function to the argument values
4. Return the value(s)

```lisp
(+ 1 2)             ; 1. evaluate arguments → 1, 2
                    ; 2. look up function binding of +
                    ; 3. apply + to 1, 2
                    ; 4. return 3

(funcall #'+ 1 2)   ; explicit function call via funcall
(apply #'+ '(1 2))  ; apply function to argument list
```

### Lambda forms (§3.1.2.1.2.4)

> If the car of the compound form is not a symbol, then that car must be a lambda expression, in which case the compound form is a lambda form.

```lisp
((lambda (x) (+ x 1)) 2)
; car is a lambda expression → create function, apply to argument 2
; → returns 3
```

### Evaluation environment

> A Common Lisp system evaluates forms with respect to lexical, dynamic, and global environments.

```lisp
(let ((x 1))               ; lexical environment
  (list x (eval 'x)))       ; eval uses the dynamic/global environment
                             ; not the lexical one (by default)
```

`eval` evaluates a form from scratch in the current dynamic and global environments, but not the lexical environment.

## Summary

```
42                    ; self-evaluating → Object
x                     ; symbol → variable reference
(if t 'a 'b)          ; special form — unique evaluation rules
(defmacro m ...)      ; macro form — transform then evaluate
(+ 1 2)               ; function form — evaluate args, apply function
((lambda (x) x) 42)   ; lambda form — create and apply
(funcall #'f a)       ; explicit function application
(eval form)           ; programmatic evaluation
```
