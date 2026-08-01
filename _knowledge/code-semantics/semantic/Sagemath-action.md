---
id:               SAGEMATH.ACTION
language:         SageMath
role:             action
title:            The category dispatch and coercion
definition:       "The coercion model manages how elements of one parent get related to elements of another. It first looks for an action corresponding to op, and failing that, it tries to coerce x and y into a common parent and calls op on them"
sources:
  - section:      SageMath 10.8 Reference Manual — The coercion model
    url:          https://doc.sagemath.org/html/en/reference/coercion/sage/structure/coerce.html
  - section:      "SageMath 10.8 Reference Manual — Elements, Parents, and Categories: a primer §Elements, Parents, Categories"
    url:          https://doc.sagemath.org/html/en/reference/categories/sage/categories/primer.html#elements-parents-and-categories
  - section:      SageMath 10.8 Reference Manual — Dynamic hierarchy of classes
    url:          https://doc.sagemath.org/html/en/reference/categories/sage/categories/primer.html#dynamic-hierarchy-of-classes
  - section:      SageMath 10.8 Tutorial — Programming §Loading and Attaching Sage files
    url:          https://doc.sagemath.org/html/en/tutorial/programming.html#loading-and-attaching-sage-files
  - section:      SageMath 10.8 Tutorial — Programming §Creating Compiled Code
    url:          https://doc.sagemath.org/html/en/tutorial/programming.html#creating-compiled-code
canonical:        a + b, m^8, cm.bin_op(x, y, op), cm.canonical_coercion(x, y)
tags:             [coercion, category-dispatch, action, binary-operation, method-resolution]
status:           draft
precedes:         []
---

## Action

The category-based method dispatch and coercion model — SageMath's semantic action. Three tiers operate: (1) Python runtime actions inherited from Python, (2) category-based method dispatch through the dynamic class hierarchy, (3) coercion for arithmetic between elements with distinct parents.

### Coercion model manages cross-parent operations (§The coercion model)

> The coercion model manages how elements of one parent get related to elements of another. For example, the integer 2 can canonically be viewed as an element of the rational numbers.

> The most prominent role of the coercion model is to make sense of binary operations between elements that have distinct parents. It does this by finding a parent where both elements make sense, and doing the operation there.

The Action of SageMath is not just element-level arithmetic — it is the system's ability to find common mathematical ground for operations:

```python
sage: a = 1/2; a.parent()
Rational Field
sage: b = ZZ['x'].gen(); b.parent()
Univariate Polynomial Ring in x over Integer Ring
sage: a + b
x + 1/2
sage: (a + b).parent()
Univariate Polynomial Ring in x over Rational Field
```

The rational 1/2 and the integer polynomial x are coerced into a common parent — polynomials over QQ — and the operation executes there.

### bin_op: the core action dispatch (§bin_op)

> It first looks for an action corresponding to op, and failing that, it tries to coerce x and y into a common parent and calls op on them.

> If it cannot make sense of the operation, a TypeError is raised.

```python
sage: cm = sage.structure.element.get_coercion_model()
sage: cm.bin_op(1/2, 5, operator.mul)
5/2
```

The coercion model's `bin_op` is the fundamental action engine for binary operations:

```
bin_op(x, y, op)
  → discover_action(x.parent, y.parent, op)  # check for actions
    → find_action (e.g. scalar multiplication, group action)
  → canonical_coercion(x, y)                 # find common parent
    → find coercion maps f: S→Z, g: R→Z
    → return f(x), g(y) in common parent Z
  → op(f(x), g(y))                           # execute in common parent
```

### Actions are distinct from coercion (§The coercion model)

> Some arithmetic operations (such as multiplication) can indicate an action rather than arithmetic in a common parent.

```python
sage: E = EllipticCurve('37a')
sage: P = E(0,0)
sage: 5*P
(1/4 : -5/8 : 1)
```

Here the integer 5 acts on the elliptic curve point P via the additive group law — no coercion needed because ZZ acts on E.

### Coercions are implicit; conversions are explicit (§The coercion model)

> Coercions are canonical (possibly modulo a finite number of deterministic choices) morphisms, and the set of all coercions between all parents forms a commuting diagram.

> Conversions try to construct an element out of their input if at all possible... Conversions are always explicitly invoked, and never used by the coercion model to resolve binary operations.

```
Coercion:  QQ(2)          # implicit: ZZ → QQ (canonical)
Conversion: ZZ('123')     # explicit: string → integer (may fail)
```

### Dynamic category class hierarchy (§Dynamic hierarchy of classes)

> The hierarchy of classes for parents and elements is parallel to the hierarchy of categories.

Action dispatch follows the dynamically-constructed method resolution order based on categories:

```python
sage: Groups().element_class.mro()
[<class 'sage.categories.groups.Groups.element_class'>,
 <class 'sage.categories.monoids.Monoids.element_class'>,
 <class 'sage.categories.semigroups.Semigroups.element_class'>,
 ...]
```

Each category contributes `ParentMethods` and `ElementMethods`:

```python
class Groups(Category):
    def super_categories(self):
        return [Monoids(), ...]
    class ParentMethods:
        # generic methods for all groups
    class ElementMethods:
        # generic methods for all group elements
```

When `m^8` is called, Python's normal MRO finds `_pow_` inherited from `Semigroups.element_class` — a single generic implementation serving integers, matrices, and all semigroup elements.

### Preparsing syntactic layer (§Loading and Attaching Sage files)

> When Sage loads example.sage it converts it to Python, which is then executed by the Python interpreter. This conversion is minimal; it mainly involves wrapping integer literals in Integer(), floating point literals in RealNumber(), replacing ^'s by **'s, and replacing e.g., R.2 by R.gen(2).

SageMath applies a source-to-source transformation before Python evaluation. The preparser wraps raw literals into SageMath types, making every literal an Object with a Parent:

```
.sage file → Preparser → .sage.py → Python runtime → Coercion model → Result
```

```python
# example.sage input:
print("Hello World")
print(2^3)

# generated example.sage.py:
print("Hello World")
print(Integer(2)**Integer(3))
```

Three transformations occur:
- `2` → `Integer(2)` — bare integer literal wrapped in SageMath Integer
- `^` → `**` — SageMath uses `^` for exponentiation (Python uses `^` for XOR)
- `R.2` → `R.gen(2)` — shorthand generator access

This preparsing is implemented in `sage/misc/interpreter.py`. It applies to `.sage` files loaded via `load()` or `attach()`, and to code entered at the interactive prompt.

### Compiled code path: .spyx files (§Creating Compiled Code)

> NO Sage preparsing is applied to spyx files, e.g., 1/3 will result in 0 in a spyx file instead of the rational number 1/3.

`.spyx` files bypass the SageMath preparser entirely. They are compiled to C via Cython and execute in the C runtime:

```
.spyx file → Cython compilation → C runtime → raw C types (no preparser, no coercion)
```

```python
# test.spyx — no Integer() wrapping, no ^ substitution
cdef extern from "test.c":
    int add_one(int n)

def test(n):
    return add_one(n)
```

SageMath has two action paths:
- **`.sage` path**: Preparser → Python → Coercion model — full SageMath semantic model applies
- **`.spyx` path**: Cython → C — raw computation without mathematical type wrapping

The `.spyx` path is an escape hatch to C-level performance. SageMath semantics (Integer types, coercion, category dispatch) do not apply unless explicitly imported via `sage.all`.

### Inherited Python runtime actions

SageMath runs on the Python runtime. All Python actions — assignment, control flow, function calls, exception handling — are inherited as the base action layer:

```python
sage: for p in primes(100):        # Python loop action
....:     if p % 4 == 1:           # Python conditional action
....:         print(p)             # Python function call action
```

### Comparisons use coercion model

> When comparing objects of different types in Sage, in most cases Sage tries to find a canonical coercion of both objects to a common parent. If successful, the comparison is performed between the coerced objects; if not successful, the objects are considered not equal.

The coercion model covers comparison operators (`==`, `<`, `>`, `<=`, `>=`) not just arithmetic:

```python
sage: GF(5)(1) == QQ(1)
False              # no canonical map Q → F5
sage: GF(5)(1) == ZZ(1)
True               # canonical map Z → F5 exists
sage: ZZ(1) == QQ(1)
True               # canonical map Z → Q exists
```

This extends `bin_op` to cover all binary operations, not only arithmetic ones.

### common_parent: n-ary parent resolution (§common_parent)

> Compute a common parent for all the inputs.

```python
sage: cm.common_parent(ZZ, QQ, RR)
Real Field with 53 bits of precision

sage: cm.common_parent(ZZ['x,y'], QQ['y,z'])
Multivariate Polynomial Ring in x, y, z over Rational Field
```

### canonical_coercion: pair coercion (§canonical_coercion)

> Given two elements x and y, with parents S and R respectively, find a common parent Z such that there are coercions f: S→Z and g: R→Z and return f(x), g(y), which will have the same parent.

```python
sage: cm.canonical_coercion(mod(2, 10), 17)
(2, 7)

sage: x, y = cm.canonical_coercion(1/2, matrix(ZZ, 2, 2, range(4)))
sage: parent(x) is parent(y)
True
```

## Summary

```
a + b                 # action: coerce to common parent, then op
5 * E([0,0])          # action: group action (no coercion needed)
cm.bin_op(x, y, op)   # action: full coercion model dispatch
cm.canonical_coercion(x, y)  # action: find common parent
m^8                   # action: category-dispatch to _pow_ in Semigroups
```
