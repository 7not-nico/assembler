# SOURCE.DOCS.PLAYWRIGHT — source real documentation using Playwright MCP

Reference knowledge is sourced from official documentation via Playwright MCP browser automation. No speculative or cached knowledge replaces a live spec reading.

## Procedure

1. Navigate to the official documentation URL using `playwright_browser_navigate`
2. Extract the section body using `playwright_browser_evaluate` with `document.getElementById()`
3. Verify the extracted text matches the published spec
4. Write the reference file with source URL and section name
5. Only after extraction, write or update code

## Primary extraction method

Use `browser_evaluate` to extract section text directly:

```
() => {
  const el = document.getElementById('Section_name');
  if (!el) return 'not found';
  let next = el.nextElementSibling;
  let text = '';
  for (let i = 0; i < 10 && next; i++) {
    text += next.textContent + '\n';
    next = next.nextElementSibling;
  }
  return text;
}
```

Use `browser_find` for locating specific text within a page (cheaper than full snapshot).

## Sources by topic

### Go Spec

```
Variables         https://go.dev/ref/spec#Variables
Types             https://go.dev/ref/spec#Types
Expressions       https://go.dev/ref/spec#Expressions
Statements        https://go.dev/ref/spec#Statements
Go statements     https://go.dev/ref/spec#Go_statements
Defer statements  https://go.dev/ref/spec#Defer_statements
Select statements https://go.dev/ref/spec#Select_statements
Type assertions   https://go.dev/ref/spec#Type_assertions
Function literals https://go.dev/ref/spec#Function_literals
Channel types     https://go.dev/ref/spec#Channel_types
The zero value    https://go.dev/ref/spec#The_zero_value
```

### Ruby docs

```
Ruby core  https://docs.ruby-lang.org/en/3.4/
Kernel#system  https://docs.ruby-lang.org/en/3.4/Kernel.html#method-i-system
IO.popen      https://docs.ruby-lang.org/en/3.4/IO.html#method-c-popen
```

## Composes with

- STORE.REFERENCE.KNOWLEDGE — reference files store the extracted knowledge
- REFERENCE.ATOMIC.SOURCE — reference files are atomic with source citations
- STUDY.SOURCE.BEFORE.CODE — study before writing
