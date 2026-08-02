---
id: REF.SCHEMA.QUOTING
title: Quote Colons — YAML Frontmatter Values Containing Colons
source: PROT.SCHEMA.AUGMENT
summary: "YAML interprets colons as mapping key delimiters. Any frontmatter field value containing a colon must be double-quoted to prevent parse errors."
ref: "Frontmatter values containing colons must be quoted to prevent YAML parse errors."
related: []
tags: [yaml, frontmatter, parsing, convention, quoting]
---

YAML block mapping syntax treats `:` as a key-value delimiter. Unquoted values containing colons — especially in `statement`, `summary`, `description`, or `notes` fields — produce parse errors in strict YAML 1.2 parsers.

## Rules

1. **Double-quote any frontmatter field** whose value may contain `:` — typically `statement`, `summary`, `description`, `notes`, `body` previews
2. **Single quotes also work** — double quotes support backslash escape sequences (`\n`, `\t`, `\x`). Use double quotes when the value uses backslash escapes.
3. **Inline YAML arrays use bracket delimiters** — unquoted brackets and commas delimit the value correctly.
4. **Test by syncing** — sync will fail on unparseable frontmatter. Run validation after any edit.

## Applicability

Every AMANDA project using YAML frontmatter or backmatter. Any project that upgraded from YAML 1.1 to strict YAML 1.2 must audit existing frontmatter for unquoted colons.

## See also

- `ILL.SCHEMA.COLON.FIX` — walkthrough of diagnosing and fixing an unquoted colon
- `IDENTITY.YAML`
- `MAX.CODE.DRY.PRINCIPLE`
- `SPEC.ENTITY.ROUTING.TABLE`
