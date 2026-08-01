---
id: ILL.SCHEMA.FIX
title: "Colon Fix — YAML Parse Error Resolution"
source: PROT.SCHEMA.AUGMENT
summary: "Walkthrough of diagnosing and fixing a YAML parse error from an unquoted colon in frontmatter."
illustration: "A term file's summary field contains a colon. write-sync fails with a YAML parse error. Double-quoting the summary value resolves the issue."
illustrates: [REF.SCHEMA.COLON.QUOTING]
tags: schema,yaml,colon,walkthrough,parse,error,quoting
related: [REF.META.NAMING.SCHEMA]
---
## Rationale

YAML 1.2 parsers enforce strict rules. An unquoted colon in a mapping value triggers a parse error — the parser interprets it as starting a nested mapping. Double-quoting the value declares the entire content as a scalar, eliminating the ambiguity.

A term file has a `summary:` field with a colon in the value. Running `write-sync` or `read-validate` fails with a `YAMLException: bad indentation of a mapping entry`. The error points at the character after the colon.

## Walkthrough

1. The following frontmatter fails because the colon in `"a category consists of: (1) objects"` after `of` triggers the parser to expect a nested mapping value.

```yaml
statement: A category consists of: (1) objects
```

2. The js-yaml 5.x parser reads the colon after `of` as a mapping key delimiter. It expects proper indentation for the key's value. The error message includes a caret pointing at the character after the unexpected colon.

```
YAMLException: bad indentation of a mapping entry at line 2, column 34:
    statement: A category consists of: (1) objects
                                     ^
```

3. Fix by double-quoting the entire value. The parser treats the quoted string as a scalar, bypassing colon detection within the quotes.

```yaml
statement: "A category consists of: (1) objects"
```

4. Single quotes also work but do not escape `\n`, `\t`, or `\x` sequences. Use double quotes when the value uses backslash escapes.

5. Test the fix by running `write-sync` or `read-validate`. The command completes without a parse error.

## Key insight

The colon inside an unquoted YAML value creates ambiguity — the parser cannot distinguish between a value containing a colon and a mapping key delimiter. Quoting removes the ambiguity by declaring the entire value as a scalar. Any frontmatter field whose value may contain `:` needs quotes — typically `statement`, `summary`, `description`, and `notes`.

## See also

- `REF.SCHEMA.COLON.QUOTING` — YAML colon quoting pattern
- `REF.META.NAMING.SCHEMA` — naming convention and frontmatter format
