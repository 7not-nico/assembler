# NO.TABLES.USE.CODEBLOCKS — replace markdown tables with code blocks

Markdown tables are prohibited in all files. Use code blocks with tabular formatting instead.

## Prohibited

```
| Field | Meaning |
|-------|---------|
| `[[Type]]` | normal, break, continue, return, throw |
| `[[Value]]` | the value produced |
```

## Required

```
`[[Type]]` — normal, break, continue, return, throw
`[[Value]]` — the value produced
`[[Target]]` — the label target
```

Code blocks preserve column alignment without markdown table syntax. Lists with hyphens also work for key-value pairs.

## Rationale

Markdown tables render inconsistently across viewers. Code blocks render uniformly. For structured data where alignment matters, use a code block with fixed-width formatting.

Composes with: DISCRIMINATE.FORMAT.PRECEPT
