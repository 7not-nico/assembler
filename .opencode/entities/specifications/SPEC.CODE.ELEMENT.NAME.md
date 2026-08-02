**Code Element Name** — each element type follows one name convention. The convention sets noun class (abstract or concrete), element order, and agentive suffix pattern.

## Noun classification

Code element names resolve into two noun classes.

**Abstract noun** — a concept, category, or relation; not sensorily-perceivable. Denotes what a thing *is*.

**Concrete noun** — a physical, sensorily-perceivable entity. Denotes a specific, observable thing.

## Element rules

### Struct / Class

One word, singular abstract noun, Upper case (PascalCase). Names the concept, not the instance.

- Valid: `Processor`, `Repository`, `Factory`, `Registry`, `Engine`, `Pipeline`, `Context`, `Driver`
- Invalid: `Processors` (plural), `data_handler` (snake_case, concrete noun), `processor` (lowercase)

### Function

One word, singular concrete noun, lowercase. Names a specific, observable thing the function operates on or returns.

- Valid: `data`, `socket`, `buffer`, `key`, `handle`, `pool`, `record`, `item`
- Invalid: `processData` (two words, verb-led), `processor` (agentive noun), `Parser` (Upper case)

### Method

One or two words, camelCase. When two words: first word is an optional concrete noun (the subject matter), second word is an agentive noun from verb root + `{vowel}r` suffix — names "one who performs the action" on that subject. When one word: agentive noun alone — subject is implicit in the struct receiver.

**Pattern:** `[subjectNoun] + agentiveNoun`

**Subject noun omitted when:** the concrete noun equals an existing function name (shadow prevention). The struct receiver provides the implied subject context.

**Agentive suffix `{vowel}r`** — the verb root plus a vowel (`a`, `e`, `i`, `o`, `u`, `y`) followed by `r`:

- `-er` — Germanic/common verbs: `parse→Parser`, `compile→Compiler`, `render→Renderer`, `build→Builder`, `encode→Encoder`, `decode→Decoder`, `cache→Cacher`
- `-or` — Latinate verbs: `validate→Validator`, `process→Processor`, `connect→Connector`, `inspect→Inspector`, `aggregate→Aggregator`, `compute→Computer`
- `-ar` — limited set: `lie→Liar`
- `-ier` — verbs ending in `-y`: `copy→Copier`, `deny→Denier`, `amplify→Amplifier`
- `-yer` — limited set: `say→Sayer`, `pay→Payer`

Valid (two words): `entryParser`, `streamValidator`, `socketConnector`, `bufferCompiler`, `keyBuilder`, `poolInspector`

Valid (one word, subject dropped): `parser`, `validator`, `connector`, `compiler`, `builder`, `inspector`

Invalid: `parseData` (verb-led imperative), `dataParsing` (gerund), `dataValidation` (non-agentive derived noun), `dataParse` (bare infinitive, no agentive suffix), `dataParsers` (plural agentive)

### Variable

One word, singular concrete descriptor, lowercase. No verbs. The declaration sits at file top.

- Valid: `index`, `count`, `handle`, `path`, `label`, `limit`, `port`, `size`
- Invalid: `counter` (agentive noun), `itemList` (two words), `theIndex` (article prefix), `getIndex` (verb prefix)

### Constant

One word, singular abstract descriptor, Upper case (PascalCase). No verbs.

- Valid: `MaxRetry`, `BufferSize`, `DefaultPort`, `Timeout`, `BaseUrl`
- Invalid: `MAX_RETRY_COUNT` (snake_case, multiple words), `retry_max` (lowercase), `maxRetry` (camelCase)

## Derivation order

Elements derive in outer→inner priority order. Outer concepts precede inner concrete references.

- Step 1 — Struct (abstract noun): "What concept owns this domain?"
- Step 2 — Function (concrete noun): "What concrete thing exists in this domain?"
- Step 3 — Method ([subject] + agentive {vowel}r): "What action on what subject?"

Struct establishes the domain. Function establishes a concrete noun within that domain — a claim on that word. Method subject noun must differ from every existing function name, or drop the subject entirely.

When function name equals intended subject noun, two exits:

- **Change subject** — `entryParser`. Pick a different concrete noun
- **Drop subject** — `parser`. Omit noun. Struct receiver supplies context

```
Struct:     Data            (abstract — data management domain)
Function:   record          (concrete — a unit within data domain)
Method:     entryParser     (subject "entry" ≠ function "record")
Method:     parser          (subject dropped — "data" implied by struct)
```

Function `record` publishes claim on that noun. Method avoids the claim — it picks `entry` or drops the subject entirely. `Data.parser()` reads as "data parser" — subject implied by receiver type.

## Shadow prevention

A shadow occurs when a method's first segment (concrete noun) matches an existing function name. Method first segment must differ from every function name.

Two exits when intended subject noun equals a function name:

- **Change subject:** Function `data` + method `recordParser` — safe. First segment `record` ≠ function `data`
- **Drop subject:** Function `data` + method `parser` — safe. No first segment to collide

Shadow examples:

- Function `data` + method `dataParser` — **shadow**. First segment `data` equals function `data`
- Function `stream` + method `streamValidator` — **shadow**. First segment `stream` equals function `stream`
- Function `record` + method `recordParser` — **shadow**. First segment `record` equals function `record`

Safe examples:

- Function `data` + method `entryParser` — safe. First segment `entry` ≠ `data`
- Function `stream` + method `recordParser` — safe. First segment `record` ≠ `stream`
- Function `record` + method `parser` — safe. Subject dropped entirely

Struct uses Upper case; function uses lowercase. Case difference prevents struct/function collision.

- Struct `Data` + function `data` — safe. Case differs
- Struct `Socket` + function `socket` — safe. Case differs

Methods at minimum one word (when subject dropped) or two words (when subject present). The agentive suffix (`-er`, `-or`, etc.) guarantees the final word is never a bare concrete noun.

## Prohibitions

- **Gerund (`-ing`)** — `dataParsing` nominalizes verb as ongoing action, not agent
- **Non-agentive derived noun (`-tion`, `-ment`, `-ance`, `-ion`)** — `dataValidation`, `dataManagement`, `dataConnection` use suffixes other than `{vowel}r`
- **Imperative (verb-led)** — `parseData` reads as command, not struct capability. Method describes, not commands.
- **Bare infinitive (no suffix)** — `dataParse` uses verb root without agentive suffix — no agent, no role descriptor
- **Plural agentive** — `dataParsers` forces agentive noun to plural
- **Three or more words** — `dataStreamParser` exceeds two-word limit
- **Snake case** — `data_parser` violates camelCase requirement for methods
- **Article prefix** — `theDataParser` introduces determiners in identifiers

## Exception

Agentive nouns from verb root + `{vowel}r` suffix constitute the sole derived noun class that code element names allow. All other derived nouns remain prohibited.

## Applicability

All code elements across all language layers: Rust (struct, fn, method), TypeScript (class, function, method), Ruby (method), Bash (function).

---
id: SPEC.CODE.ELEMENT.NAME
title: Code Element Name — Naming Convention by Element Type
source: assembler
summary: "Code elements name by noun class: structs use abstract nouns (Upper), functions use concrete nouns (lowercase), methods use optional subject noun + agentive {vowel}r suffix (camelCase). First segment must differ from function names or drop subject entirely."
specifies: Naming convention for struct, function, method, variable, and constant code elements
tags: [code, naming, convention, element, noun, specification]
status: active
---
