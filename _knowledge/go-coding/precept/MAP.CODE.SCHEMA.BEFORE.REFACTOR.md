# MAP.CODE.SCHEMA.BEFORE.REFACTOR — map code into a schema file before programmatic refactors

Before running any programmatic refactoring script, create a `.sql` schema file that maps the current code structure. The schema captures what exists so refactoring scripts can be precise and safe.

## Procedure

1. Survey the target files — list all files, their sizes, their key patterns
2. Create a `.sql` schema file (or `.md` if SQL is inappropriate) in `reference/` that documents:
   - File list and line counts
   - Import blocks per file
   - Operator switch locations (file, line, variable names)
   - Function map declarations (file, line, variable name)
   - Pattern variations (indentation depth, variable naming)
3. Run the schema file to verify it matches the current state
4. Only then write the refactoring script

## Schema format

Use SQL comments to document each pattern:

```sql
-- schema/calc-refactor.sql
-- Maps the current code structure before refactoring.

-- Files and their operator patterns
-- calc_aso.go:    switch op at line 90, vars {op, subject, object}
-- calc_oas.go:    switch op at line 95, vars {op, subject, object}
-- calc_osa.go:    switch op at line 88, vars {op, subject, object}

-- Import blocks
-- calc_aso.go imports: bufio, fmt, os, strconv, strings, calc, lib
-- calc_oas.go imports: bufio, fmt, os, strconv, strings, calc, lib
```

## Why

- Automated refactors easily corrupt syntax when indentation or variable naming varies
- A schema documents the exact patterns the script must match
- Running the schema before the script catches variant patterns that would break the script
- The schema serves as a todo list: which files are done, which remain

## Composes with

- REFACTOR.INCREMENTAL.VERIFY — refactor one concern per phase
- STUDY.SOURCE.BEFORE.CODE — study before writing code
- REFERENCE.ATOMIC.SOURCE — reference files are atomic with source citations
