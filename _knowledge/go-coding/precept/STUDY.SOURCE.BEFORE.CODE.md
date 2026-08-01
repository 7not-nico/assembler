# STUDY.SOURCE.BEFORE.CODE — study official documentation before writing code

Before writing or modifying any calculator variant or test script, study the relevant official documentation. The Go Spec is the authoritative source for Go semantics. Ruby docs are the authoritative source for test script behavior.

## Scope

Applies to all code in this project:
- Go calculator variants — study Go Spec for the relevant feature
- Ruby test scripts — study Ruby docs for IO, process spawning, regex
- Reference files — study then write, never speculate

## Procedure

1. Identify which feature or concept the code depends on

2. Navigate to the official documentation using Playwright MCP:
   ```
   playwright_browser_navigate(url)
   playwright_browser_evaluate to extract section body
   ```

3. Extract the exact spec text that defines the behavior

4. Write the reference file (atomic, one concept per file) into `reference/` or `reference/ruby-refs/`

5. Only after the reference file exists, write or modify the code

## Source before code chain

```
identify feature → navigate to spec → extract text → write reference → write code or script
```

## Reference locations

```
reference/              — Go Spec semantics (GO.SUBJECT, GO.OBJECT, GO.ACTION)
reference/ruby-refs/    — Ruby-specific reference for test scripts
```

## Composes with

- SOURCE.DOCS.PLAYWRIGHT — sourcing real docs via Playwright MCP
- REFERENCE.ATOMIC.SOURCE — reference files are atomic with source citations
- WRITE.SCRIPT.RUBY — test script conventions
