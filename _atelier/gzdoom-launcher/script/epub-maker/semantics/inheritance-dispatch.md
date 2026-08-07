# Inheritance and dispatch

ZScript subclasses engine classes; virtual dispatch carries the API. Term-frequency scan over 126 chapters: static 27, virtual 15, native 11, override 6, abstract 4, final 4.

## Dispatch modifiers

```text
virtual   overrideable method; default dispatch mechanism
override  redefines a virtual method
abstract  marks engine base classes; no instantiation
final     blocks further overriding
static    class-level state; pervasive across the API
```

## Member structure

- Class definitions (ch005): flags, contents, property definitions, flag definitions, default blocks, state blocks
- Member declarations (ch010): declaration flags, examples
- Method definitions (ch011): argument lists, declaration flags, action scopes

## Native boundary

- `native` (11 chapters) marks C++-backed classes
- Scripts subclass native classes and override their virtuals
- Action scopes attach to methods — they define which actor states may invoke a method

## Statics

Static class-methods and class state appear in 27 chapters — the engine exposes factory and lookup APIs statically, mirroring the class-reference type family.
