source: SPEC.CODE.ELEMENT.NAME (.opencode/entities/specifications/)

## Noun classes

Concrete noun — a physical, sensorily-perceivable entity. Denotes a specific, observable thing. Used for function and variable names.

Abstract noun — a concept, category, or relation. Not sensorily-perceivable. Denotes what a thing is. Used for struct names.

## Element rules

Struct — one word, singular abstract noun, Upper. Names the concept, not the instance. `Processor`, `Repository`, `Engine`.

Function — one word, singular concrete noun, lower. Names a specific, observable thing the function operates on or returns. `data`, `socket`, `buffer`, `key`, `handle`.

Method — two words, camelCase: optional subject noun + agentive (verb root + `{vowel}r`). `entryParser`, `streamValidator`. One word when subject dropped: `parser`. For our conventions: methods inlined as free functions instead.

Variable — one word, singular concrete descriptor, lower. No verbs. Declared at file top. `index`, `count`, `path`, `label`.

Constant — one word, singular abstract descriptor, Upper (PascalCase). No verbs. `MaxRetry`, `BufferSize`, `Timeout`.

## Agentive suffix rules

`-er` — Germanic/common verbs: parse→Parser, compile→Compiler, build→Builder, encode→Encoder

`-or` — Latinate verbs: validate→Validator, process→Processor, connect→Connector, compute→Computer

`-ier` — verbs ending in -y: copy→Copier, amplify→Amplifier

## Prohibitions

Prohibition on Gerund (-ing) — `dataParsing` nominalizes verb as ongoing action, not agent.

Prohibition on Non-agentive derived noun (-tion, -ment, -ance, -ion) — `dataValidation`, `dataManagement`. Agentive suffix `{vowel}r` is the only permitted derived noun form.

Prohibition on Imperative (verb-led) — `parseData` reads as command, not capability. Method describes, not commands.

Prohibition on Bare infinitive (no suffix) — `dataParse` uses verb root without agentive suffix.

Prohibition Plural agentive — `dataParsers` forces agentive to plural.

Prohibition onThree or more words — `dataStreamParser` exceeds two-word limit for methods.

Prohibition on Snake case — `data_parser` violates camelCase requirement for methods.

Prohibition Article prefix — `theDataParser` introduces determiners in identifiers.

## Derivation order (outer→inner)

1. Struct (abstract noun) — "What concept owns this domain?"
2. Function (concrete noun) — "What concrete thing exists in this domain?"
3. Method (subject + agentive) — "What action on what subject?"

## Shadowing prevention

Method subject noun must differ from every existing function name. Two exits when subject equals function name:

Change subject — `entryParser`. Pick a different concrete noun.

Drop subject — `parser`. Omit noun. Struct receiver supplies context.

Case difference prevents struct/function collision: Struct `Data` + function `data` — safe.
