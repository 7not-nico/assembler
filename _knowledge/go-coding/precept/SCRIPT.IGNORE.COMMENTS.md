# SCRIPT.IGNORE.COMMENTS — refactoring scripts must ignore comments during pattern matching

When matching code patterns for programmatic refactoring, exclude comment lines from match criteria. Comments change during refactoring (updated doc strings, removed `// GO.ACTION` annotations) and cause false negatives.

## Rule

No refactoring script matches on text that appears inside `//` or `/* */` comments. Match only on actual code: variable declarations, switch statements, function definitions.

## Implementation

```ruby
# Before matching, strip comments from a working copy
code = content.gsub(%r{//.*$}, "")  # remove line comments
code = code.gsub(%r{/\*.*?\*/}m, "")  # remove block comments
# Then match patterns against `code`, but write edits to `content`
```

## Why

- GO.ACTION and GO.SUBJECT annotations inside comments change frequently
- Scripts that match on `// GO.ACTION:` annotations break when annotations are updated
- Code patterns (switch, case, return, assignment) stay stable across refactoring phases

## Example

Instead of matching:
```
switch op {
case "+":
    subject = subject + object  // GO.ACTION: binary expression
```

Match against the code-stripped version:
```
switch op {
case "+":
    subject = subject + object
```

## Composes with

- MAP.CODE.SCHEMA.BEFORE.REFACTOR — schema before refactoring
- REFACTOR.INCREMENTAL.VERIFY — one concern per phase, verify after each
