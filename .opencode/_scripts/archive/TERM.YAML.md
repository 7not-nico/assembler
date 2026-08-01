**YAML (YAML Ain't Markup Language, recursive acronym)** — a human-friendly, cross-language, Unicode-based data serialization language designed around three native data structure kinds: **sequences** (ordered lists), **mappings** (unordered key-value associations), and **scalars** (opaque Unicode data with typed tags). Current spec is YAML 1.2.2 (Oct 2021, no normative changes from 1.2). YAML 1.2 (2009) made JSON a strict subset and removed problematic implicit typing from 1.1. Processing spans three stages: **representation** (tagged node graph), **serialization** (ordered tree with aliases for shared nodes), **presentation** (human-friendly text stream with styles, indentation, comments). Widely used for configuration files, data exchange, and — in AMANDA systems — YAML frontmatter/backmatter in markdown entity files.

---
id: TERM.YAML
title: YAML (YAML Ain't Markup Language, recursive acronym)
source: CON.PREPEND
tags: [yaml, data-serialization, configuration, frontmatter, specification, markup]
related: []
reference:
  - title: YAML 1.2.2 Specification
    url: https://yaml.org/spec/1.2.2/
  - title: YAML.org — official home
    url: https://yaml.org/
  - title: js-yaml — YAML 1.2 parser/writer for JavaScript
    url: https://github.com/nodeca/js-yaml
  - title: js-yaml v4 to v5 Migration Guide
    url: https://github.com/nodeca/js-yaml/blob/master/docs/migrate_v4_to_v5.md
---
