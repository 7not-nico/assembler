---
id:               SAGEMATH.OBJECT
language:         SageMath
role:             object
title:            The element (value in a parent)
definition:       "An element is a Python instance modelling a mathematical element of a set. Every element in Sage has a parent"
sources:
  - section:      "SageMath 10.8 Reference Manual — Elements, Parents, and Categories: a primer §Elements, Parents, Categories"
    url:          https://doc.sagemath.org/html/en/reference/categories/sage/categories/primer.html#elements-parents-and-categories
  - section:      SageMath 10.8 Reference Manual — The coercion model
    url:          https://doc.sagemath.org/html/en/reference/coercion/sage/structure/coerce.html
  - section:      SageMath 10.8 Reference Manual — Category Framework §Category of elements
    url:          https://doc.sagemath.org/html/en/reference/categories/index.html
  - section:      SageMath 10.8 Reference Manual — Set of all objects of a given Python class
    url:          https://doc.sagemath.org/html/en/reference/sets/sage/sets/pythonclass.html
  - section:      SageMath 10.8 Tutorial — Programming §Lists, Tuples, and Sequences
    url:          https://doc.sagemath.org/html/en/tutorial/programming.html#lists-tuples-and-sequences
canonical:        ZZ(42), R([1,2,3]), 1/2, x^2 + 1
tags:             [element, value, mathematical-object, coercion, parent-relationship]
status:           draft
precedes:         []
---

## Object

The element — a Python instance modelling a mathematical value belonging to a parent. The Object is what actions operate on and what subjects produce.

### Elements belong to parents (§Elements, Parents, Categories)

> An element is a Python instance modelling a mathematical element of a set.

> Every element in Sage has a parent.

The Object always carries a reference to its Parent (the Subject). This relationship determines what operations are valid:

```python
sage: a = ZZ(42)
sage: a.parent()
Integer Ring

sage: x = QQ['x'].gen()
sage: x.parent()
Univariate Polynomial Ring in x over Rational Field

sage: (1/2).parent()
Rational Field
```

### Creating elements through their parent (§Elements, Parents, Categories)

> The standard idiom in Sage for creating elements is to create their parent, and then provide enough data to define the element:

```python
sage: R = PolynomialRing(ZZ, name='x')
sage: R([1,2,3])
3*x^2 + 2*x + 1
```

Elements can also be created through arithmetic on existing elements:

```python
sage: x = R.gen()
sage: 1 + 2*x + 3*x^2
3*x^2 + 2*x + 1
```

### Elements are not unique (§Elements, Parents, Categories)

> Unlike parents, elements in Sage are not necessarily unique:

```python
sage: ZZ(5040) is ZZ(5040)
False
```

Each evaluation produces a new Object instance. This differs from parents (Subjects) which maintain singleton identity.

### Elements have category-based methods (§A bit of help from abstract algebra)

An element's method resolution follows its parent's category hierarchy. Elements inherit generic methods from each category their parent belongs to:

```python
sage: i = 12
sage: type(i)
<class 'sage.rings.integer.Integer'>

sage: i._pow_.__module__
'sage.categories.semigroups'    # powering lives in Semigroups category
```

Demonstrating shared generic code through categories:

```python
sage: m = 3
sage: m^8 == m*m*m*m*m*m*m*m == ((m^2)^2)^2
True

sage: m = random_matrix(QQ, 4, algorithm='echelonizable',
....:                   rank=3, upper_bound=60)
sage: m^8 == m*m*m*m*m*m*m*m == ((m^2)^2)^2
True
```

Both integers and matrices share the same `_pow_` method from the semigroups category, even though their multiplication methods differ.

### Python-native elements via Set_PythonType (§Set of all objects of a given Python class)

> The elements of this set are not instances of Element; they are instances of the given class.

When a Python class is wrapped as a SageMath Parent via `Set_PythonType`, its elements are native Python instances, not SageMath Element subclasses:

```python
sage: from sage.sets.pythonclass import Set_PythonType
sage: S = Set_PythonType(list)
sage: S([1,2,3])
[1, 2, 3]               # plain list, not an Element subclass
sage: type(S([1,2,3]))
<... 'list'>

sage: T = Set_PythonType(int)
sage: int('1') in T
True
sage: Integer('1') in T
False                     # SageMath Integer is not Python int
```

The Object can be either a mathematical Element (with category-based methods) or a plain Python instance wrapped into a set parent — both carry the parent relationship.

### Sequence as parent-typed collection (§Lists, Tuples, and Sequences)

> All elements of a sequence have a common parent, called the sequences universe.

`Sequence` is a SageMath-specific list type that enforces parent homogeneity. Unlike Python lists (which hold arbitrary types), every element in a Sequence shares a common Parent:

```python
sage: v = Sequence([1,2,3,4/5])
sage: v.universe()
Rational Field            # all elements share this parent
sage: type(v[1])
<class 'sage.rings.rational.Rational'>

sage: V = QQ^3
sage: B = V.basis()
sage: B.universe()
Vector space of dimension 3 over Rational Field
sage: type(B)
<class 'sage.structure.sequence.Sequence_generic'>
```

The Sequence bridges Python's heterogeneous list with SageMath's parent-typed world. Each element in a Sequence is an Object whose Parent must match the Sequence's universe. This provides type homogeneity at the Parent level without requiring Python-level type uniformity.

### Elements have type determined by parent

The concrete Python type of an element encodes both the data structure and the category inheritance chain:

```python
sage: type(ZZ(42))
<class 'sage.rings.integer.Integer'>

sage: type(QQ['x,y'](1))
<class 'sage.rings.polynomial.multi_polynomial_libsingular.MPolynomial_libsingular'>
```

The type name reflects the `_with_category` dynamic class construction:

```python
sage: Permutations(4).an_element().__class__.mro()
[<class 'sage.combinat.permutation.StandardPermutations_n_with_category.element_class'>,
 <class 'sage.combinat.permutation.StandardPermutations_n.Element'>,
 <class 'sage.combinat.permutation.Permutation'>,
 ...,
 <class 'sage.categories.groups.Groups.element_class'>,
 <class 'sage.categories.monoids.Monoids.element_class'>,
 <class 'sage.categories.semigroups.Semigroups.element_class'>,
 ...]
```

## Summary

```
ZZ(42)              # element in integer ring
QQ['x']([1,2,3])    # element in polynomial ring
1/2                 # element in rational field
Matrix(ZZ, 2, 2)    # element in matrix space
elem.parent()       # every element knows its parent
elem._pow_.__module__  # methods come from category hierarchy
```
