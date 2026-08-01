# FRONTMATTER.ROLE.FILE — YAML frontmatter for semantic role files

```yaml
---
id:               LANGUAGE.ROLE
language:         Language
role:             subject | object | action
title:            The concept
definition:       Spec paragraph defining the role.
sources:
  - section:      Spec Section Name
    url:          https://official-docs.example/section
canonical:        example.code()
tags:             [keyword1, keyword2]
status:           draft | review | stable
precedes:         [LANGUAGE.OBJECT, LANGUAGE.ACTION]
---
```

**id** — `LANGUAGE.ROLE`. Uppercase, dot separator. No hyphens.
Example: `C.SUBJECT`, `JAVA.OBJECT`, `RUBY.ACTION`.

**language** — Language name. Title case. `C`, `Java`, `Ruby`.

**role** — One of: `subject`, `object`, `action`. Lowercase.

**title** — Noun phrase. One line. `The receiver`, `The lvalue`, `The argument`.

**definition** — Spec quote. Present tense. Traces to cited source paragraph.

**sources** — List of `section` + `url`. Official spec only.

**canonical** — Simplest code example. No surrounding context.
`obj.method()`, `int x; x = 42`, `my_method(1, '2', key: value)`.

**tags** — JSON array. `[receiver, self, message-target]`. Unquoted lists prohibited.

**status** — `draft`, `review`, or `stable`.

**precedes** — Role IDs this role precedes. Dot format. Matches target `id` values.
`[C.OBJECT, C.ACTION]`, `[RUBY.OBJECT, RUBY.ACTION]`, or `[]`.
