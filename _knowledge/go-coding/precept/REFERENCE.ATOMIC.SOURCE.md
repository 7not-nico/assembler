# REFERENCE.ATOMIC.SOURCE — reference files are atomic and cite their source

Each file in `reference/` covers one semantic concept, one Go feature, or one spec section. Every spec quotation includes its source URL and section name.

## Atomic rule

One file per concept. No file covers more than one Go Spec section or one semantic role.

```
reference/subject-variable.md         — GO.SUBJECT only
reference/object-type-value.md        — GO.OBJECT only
reference/action-expression-statement.md — GO.ACTION only
reference/type-assertion.md           — type assertions only
reference/defer-statement.md          — defer statements only
reference/channel-types.md            — channel types only
reference/function-literal.md         — function literals only
```

## Source citation format

Every spec quotation uses this header:

```
Source: Go Spec §SectionName
URL:    https://go.dev/ref/spec#Section_name
```

The URL is the exact anchor link to the spec section.

## Sourcing procedure

1. Use Playwright MCP to navigate to the spec URL
2. Use `browser_evaluate` with `document.getElementById()` to extract the section body text
3. Verify the extracted text matches the published spec
4. Write the reference file with the exact citation header

## Composes with

- SOURCE.DOCS.PLAYWRIGHT — sourcing real docs via Playwright
- STORE.REFERENCE.KNOWLEDGE — reference directory conventions
- TEST.CALCULATOR.VARIANT — tests reference semantic claims
