**Metadata Field Noun** — field names are single nouns. Each metadata field uses a single-word noun identifier. Compound concepts decompose into separate single-noun fields rather than joining words with underscores.

## Rule

Every metadata name in entity `.md` files is a single noun. Examples of valid field names: `id`, `title`, `source`, `tags`, `related`, `reference`, `status`, `summary`, `group`, `ring`, `naming`.

## Counterexamples

- `ring_group` → use `group`
- `ring_layer` → use `ring`
- `naming_convention` → use `naming`
- `state_profile` → use `profile`

## Scope

Entity backmatter fields only. Frontmatter fields (patterns, protocols) are governed by their own conventions. Code-level variables and TypeScript/Ruby identifiers are exempt — this rule covers only YAML metadata keys in entity backmatter.

---
id: SPEC.METADATA.FIELD.NOUN
title: Metadata Field Noun — Backmatter Field Names Are Single Nouns
source: assembler
summary: "Backmatter field names in entity files are single-word nouns. Compound concepts decompose into separate single-noun fields rather than using underscore-joined phrases."
specifies: Single-noun field name convention for backmatter
tags: [metadata, field, naming, convention, specification, identity]
status: active
---
