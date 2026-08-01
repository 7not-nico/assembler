# STORE.CODE.COMMENTS.METADATA — code comments live in metadata/, exported programmatically

All function documentation comments live in `metadata/` as structured files. Code files carry minimal inline comments. A Ruby script exports the comments from code into metadata files, keeping the two in sync.

## Layout

```
metadata/
├── calc_core.md       — comments for calc/core.go functions
├── lib_input.md       — comments for lib/input.go functions
├── calc_soa.md        — comments for calc_soa.go functions
├── calc_sao.md        — comments for calc_sao.go functions
└── ...                — one file per source file
```

## Procedure

1. Write the source code with standard Go doc comments above each function
2. Run the export script to extract comments into metadata/
3. The export script parses:
   - Function name
   - Doc comment (lines above `func`)
   - Semantic annotations (GO.SUBJECT, GO.OBJECT, GO.ACTION)
   - Line number, signature
4. Metadata files are the documentation source — reference them instead of reading code comments

## Why

- Code comments are scattered; metadata centralizes documentation
- Semantic annotations (GO.SUBJECT/OBJECT/ACTION) belong in the semantic map, not repeated in code
- Export keeps documentation in sync with code — no drift
- The schema file (MAP.CODE.SCHEMA.BEFORE.REFACTOR) can use metadata to plan refactors

## Composes with

- SCRIPT.IGNORE.COMMENTS — refactoring scripts strip comments before matching
- MAP.CODE.SCHEMA.BEFORE.REFACTOR — schema maps code before refactoring
- REFACTOR.INCREMENTAL.VERIFY — one concern per phase
