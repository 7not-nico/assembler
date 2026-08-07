# Language model

ZScript is an interpreted, object-oriented scripting language for the GZDoom engine. It runs in a virtual machine like ACS but skips bytecode compilation. The engine reads ZScript source files directly.

## Grammar formality

The Fundamentals chapter (ch009) specifies the language formally. Lexical elements parse in a maximal-munch fashion:

```text
Input       Parse result
>>>         one token
>> >=       two tokens
.....       ... then ..
.. ...      .. then ...
```

## Token classes

```text
Keyword, Identifier
IntegerLiteral, FloatingPointLiteral, StringLiteral, NameLiteral
Symbol
Comments: // line, /* */ block, #region region
```

## Identifier rules

```text
IdentifierStartCharacter — letters a–z, A–Z, underscore
IdentifierCharacter      — start character plus digits 0–9
Identifiers delimit on whitespace or non-identifier characters
```

## VM positioning

The docs describe ZScript as "the most powerful Doom modding tool since plainly editing the source code." The VM is "far more complex" than ACS because the language uses object-oriented structure and skips bytecode. Benefits and detriments both stem from source-file interpretation.
