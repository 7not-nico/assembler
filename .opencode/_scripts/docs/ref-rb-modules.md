# `_rb/` Modules Reference

All modules are at code ring 1 (PURE) — pure lambdas, no I/O, no side effects.

| Module | Exports | Depends on | Used by |
|--------|---------|------------|---------|
| `loader.rb` | stdlib requires | — | all |
| `paths.rb` | EntityTypes, EntityGlob, ROOT, ExternalTypes | loader | all |
| `frontmatter.rb` | ParseFrontmatter, ParseBackmatter, ParseMetadata, ParseAll | loader | all |
| `report.rb` | Table, List | loader | all |
| `rings.rb` | TypeToRing, RingGroups | loader | 5 scripts |
| `validate.rb` | CheckField, CheckRequired | loader | 7 audit scripts |
| `schema_db.rb` | SeedDB, QueryFields, LogRun | loader + sqlite3 | 7 audit scripts |
| `entity.rb` | LoadAllEntities, LoadEntities | loader + paths + frontmatter | 8 scripts |
| `violation.rb` | ReportViolations | loader + report | 7 audit scripts |

## Exports

### loader.rb
```ruby
require "json"
require "yaml"
require "pathname"
```

### paths.rb
```ruby
EntityTypes    # array of entity type directory names under .opencode/entities/
EntityGlob     # ->(type) glob string for **/*.md in that type's directory
ExternalTypes  # ->() array of ["rules", "commands"] if those directories exist
```

### frontmatter.rb
```ruby
ParseFrontmatter  # ->(text) hash or nil — YAML between --- markers at file start
ParseBackmatter   # ->(text) hash or nil — YAML between --- markers at file end
ParseMetadata     # ->(text) tries frontmatter first, falls back to backmatter
NormalizeTags     # ->(fm) ensures tags is array, not comma string
ParseAll          # ->(texts, filenames) array of {file:, id:, type:, ...}
```

### report.rb
```ruby
Table  # ->(rows, headers) formatted string with pipe-separated columns
List   # ->(items) bulleted list string
```

### rings.rb
```ruby
TypeToRing   # ->(type_name) {group:, ring:, name:} or nil
RingGroups   # hash: {encyclopedic: {0 => {types:, name:}, ...}, architectonic: ..., chronicle: ...}
```

### validate.rb
```ruby
CheckField     # ->(value, rules) array of violation strings (empty = pass)
CheckRequired  # ->(fm, field_name) nil if present, else "required field absent"

# rules hash: {type: "string"|"integer"|"array", enum:, pattern:, min_length:, minimum:}
```

### schema_db.rb
```ruby
SeedDB      # ->(db?) creates/opens schemas.db, runs DDL + seeds, returns db handle
QueryFields # ->(db, type_id) array of [name, required, type, enum, pattern, min, max]
LogRun      # ->(db, script, passed, violations_count) INSERT into schema_runs

DB_PATH = File.join(__dir__, "..", "schema", "schemas.db")
SQL_DIR  = File.join(__dir__, "..", "schema")
```

### entity.rb
```ruby
LoadAllEntities  # ->() parses ALL entity .md files across all types
LoadEntities     # ->(type) parses .md files for a single entity type
```

### violation.rb
```ruby
ReportViolations  # ->(violations, label, sublabel) "ok — ..." or formatted table
```

## Dependency graph

```
loader → paths → frontmatter → report → rings → validate → schema_db
                                                      ↕        ↕
                                                    entity → violation
                                                       ↓        ↓
                                                     r*.rb scripts
```

All `_rb/` modules export lambdas only. No `_rb/` module imports another `_rb/` module — they are independent silos that `r*.rb` scripts compose.
