---
id:               SAGEMATH.SUBJECT
language:         SageMath
role:             subject
title:            The parent (mathematical structure)
definition:       "A parent is a Python instance modelling a set of mathematical elements together with its additional (algebraic) structure"
sources:
  - section:      "SageMath 10.8 Reference Manual — Elements, Parents, and Categories: a primer §Elements, Parents, Categories"
    url:          https://doc.sagemath.org/html/en/reference/categories/sage/categories/primer.html#elements-parents-and-categories
  - section:      SageMath 10.8 Reference Manual — The coercion model
    url:          https://doc.sagemath.org/html/en/reference/coercion/sage/structure/coerce.html
  - section:      SageMath 10.8 Reference Manual — Category Framework
    url:          https://doc.sagemath.org/html/en/reference/categories/index.html
  - section:      SageMath 10.8 Reference Manual — Set of all objects of a given Python class
    url:          https://doc.sagemath.org/html/en/reference/sets/sage/sets/pythonclass.html
canonical:        ZZ, QQ['x,y'], GL(2, ZZ)
tags:             [parent, set, algebraic-structure, ring, field, group, category]
status:           draft
precedes:         [SAGEMATH.OBJECT, SAGEMATH.ACTION]
---

## Subject

The parent — a Python instance modelling a mathematical set endowed with algebraic structure. The Parent carries the mathematical context in which elements exist. It is the Subject that performs or receives actions.

### Parent as a mathematical set (§Elements, Parents, Categories)

> A parent is a Python instance modelling a set of mathematical elements together with its additional (algebraic) structure.

> Examples include the ring of integers, the group \( S_3 \), the set of prime numbers, the set of linear maps between two given vector spaces, and a given finite semigroup.

> These sets are often equipped with additional structure: the set of all integers forms a ring. The main way of encoding this information is specifying which categories a parent belongs to.

The Parent is the Subject — it is the entity that carries mathematical state. Every element belongs to exactly one parent:

```python
sage: ZZ
Integer Ring
sage: QQ['x,y']
Multivariate Polynomial Ring in x, y over Rational Field
sage: GL(2, ZZ)
General Linear Group of degree 2 over Integer Ring
```

### Uniqueness of parents (§Elements, Parents, Categories)

> For a given model, there should be a unique instance in Sage representing that parent:

```python
sage: IntegerRing() is IntegerRing()
True
```

A parent is a singleton — unlike elements, only one instance exists per mathematical model. This uniqueness makes the Parent a stable Subject.

### Parents belong to categories (§Elements, Parents, Categories)

> Every parent belongs to a collection of categories.

> It is completely possible to have different Python instances modelling the same set of elements. For example, one might want to consider the ring of integers, or the poset of integers under their standard order, or the poset of integers under divisibility.

Different Subjects can model the same raw set under different algebraic structures:

```python
sage: ZZ.category()
Join of Category of Dedekind domains and Category of euclidean domains ...
sage: ZZ.categories()
[Join of Category of Dedekind domains ..., Category of Dedekind domains,
 Category of euclidean domains, Category of principal ideal domains, ...]
```

### Parallel class hierarchy for parents (§Dynamic hierarchy of classes)

> We have seen that the hierarchy of classes for parents and elements is parallel to the hierarchy of categories:

```
Groups().parent_class → Monoids().parent_class → Semigroups().parent_class → ...
```

The Parent Subject participates in a class hierarchy that mirrors the mathematical category hierarchy. This is dynamically constructed from `super_categories()`:

```python
sage: Groups().parent_class.__bases__
(<class 'sage.categories.monoids.Monoids.parent_class'>, ...)
```

### Python types as parents (§Set of all objects of a given Python class)

> `Set_PythonType(typ)` — Return the (unique) Parent that represents the set of Python objects of a specified type.

> The elements of this set are not instances of Element; they are instances of the given class.

SageMath wraps Python types into the Parent framework, bridging Python's type system into mathematical sets:

```python
sage: from sage.sets.pythonclass import Set_PythonType
sage: Set_PythonType(list)
Set of Python objects of class 'list'
sage: Set_PythonType(list) is Set_PythonType(list)
True                      # unique parent — singleton
sage: S = Set_PythonType(tuple)
sage: S([1,2,3])
(1, 2, 3)                 # creates an element of this parent
sage: S.category()
Category of infinite sets # the parent knows its categories
```

Even plain Python types become SageMath Subjects — they carry mathematical category structure and create elements.

### Parents can act on other parents (§The coercion model)

> The coercion model manages how elements of one parent get related to elements of another.

> Parents can specify how they act on or are acted upon by other parents.

A Subject can define actions on other Subjects. For example, ZZ acts on polynomials by scalar multiplication:

```python
sage: P = ZZ['x']
sage: P.get_action(ZZ)
Right scalar multiplication by Integer Ring on Univariate Polynomial Ring in x over Integer Ring
```

## Summary

```
ZZ                            # parent: integer ring
QQ['x,y']                     # parent: multivariate polynomial ring
GL(2, ZZ)                     # parent: general linear group
EllipticCurve('37a')          # parent: elliptic curve
IntegerRing() is IntegerRing()  # true — parents are unique
ZZ.category()                 # parent knows its categories
P.get_action(ZZ)              # parent defines actions on other parents
```
