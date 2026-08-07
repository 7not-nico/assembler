# ZScript semantics — inference files

Atomic files record inferences from the ZDoom docs epub (`ZScript.epub`, launcher root). Each file carries one topic; the index maps each topic to its source chapter.

## Files

```text
language-model.md          VM interpretation, grammar, tokenization    ch004, ch009
type-system.md             value/reference hybrid, containers, inference ch015
inheritance-dispatch.md    virtual dispatch, static, modifiers, native  ch005, ch010, ch011
memory-model.md            GC, Destroy, pointers, scoping               ch003, ch015, ch027
control-flow.md            statements, expressions, literals            ch008, ch012
api-scale.md               API breadth, platform implication            ch016–ch126
```

## Evidence basis

```text
term-frequency scan over 126 chapter files:
  static 27 | virtual 15 | scope 13 | null 13 | native 11 | pointer 8 | override 6 | final 4 | abstract 4 | garbage 3
full-text reads of the language-core chapters (ch004–ch015)
7z t archive test: 133 files, 215,267 B compressed, 1,026,367 B uncompressed
```
