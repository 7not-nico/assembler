---
id: PAT.FRONTMATTER.COLON.QUOTING
title: Quote Colons — YAML Frontmatter Values Containing Colons
source: AMANDA cross-project
summary: "YAML interprets colons as mapping key delimiters. Any frontmatter field value containing a colon (e.g., statement, summary, description, body previews) must be double-quoted to prevent parse errors — required by js-yaml 5.x strict YAML 1.2 parsing, which raises YAMLException on unexpected colons."
principle: "Frontmatter values containing colons must be quoted to prevent YAML parse errors."
enforcement: Convention
tags: [yaml, frontmatter, parsing, convention, quoting]
patterns: [PAT.DRY, PAT.ENTITY-TYPE-ROUTING]
terms: [TERM.YAML]
status: active
priority: 4
---

YAML's block mapping syntax treats `:` as a key-value delimiter. Unquoted values containing colons — especially in `statement`, `summary`, `description`, or `notes` fields — produce parse errors in strict YAML 1.2 parsers. js-yaml 5.x raises `YAMLException: bad indentation of a mapping entry` at the position of the unexpected colon, with a caret pointing at the character after the colon.

## Context

js-yaml v5 uses YAML 1.2 `CORE_SCHEMA` by default, which enforces strict YAML 1.2 parsing rules. YAML 1.2 requires that a colon in a block scalar value must be followed by whitespace or end-of-line to be treated as a mapping key delimiter — but the parser context determines whether the colon is a key separator or part of the value. When a colon appears inside an unquoted plain scalar in a mapping value position, the parser interprets it as starting a nested mapping, expecting proper indentation for the key's value.

Example that fails:

```yaml
statement: A category consists of: (1) objects
```

The colon after `of` triggers the parser to expect a mapping value. Fix:

```yaml
statement: "A category consists of: (1) objects"
```

js-yaml v4 (which used a more lenient YAML 1.1 parser) often accepted unquoted colons in practice. v5 does not.

## Rules

1. **Double-quote any frontmatter field** whose value may contain `:` — typically `statement`, `summary`, `description`, `notes`, `body` previews
2. **Single quotes also work** but don't escape `\n`, `\t`, or `\x` sequences — use double quotes when the value uses backslash escapes
3. **Inline YAML arrays** (`sources: [REF.FOO, REF.BAR]`) do not need quoting — brackets and commas delimit the value
4. **Test by syncing** — `write-sync` will fail on unparseable frontmatter. Run `read-validate` after any edit.

## Applicability

Every AMANDA project using YAML frontmatter or backmatter — patlib (patterns/terms/skills), category-theory, ludoteca, medcodes, bitacora, and all subprojects. Any project that upgraded js-yaml from v4 to v5 must audit existing frontmatter for unquoted colons.

## See also

- TERM.YAML
- PAT.DRY
- PAT.ENTITY-TYPE-ROUTING
