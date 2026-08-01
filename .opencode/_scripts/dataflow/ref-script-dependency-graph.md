# Script Dependency Graph

## Dependency direction

`_rb/` modules are pure leaves. `r*` scripts import from `_rb/` only. No `r*` script imports another `r*` script.

```
_rb/loader.rb       (stdlib requires, no project deps)
     ▲
     │
_rb/paths.rb        (depends on loader)
     ▲
     │
_rb/frontmatter.rb  (depends on loader)
     ▲
     │
_rb/report.rb       (depends on loader)
     ▲
     │
_rb/rings.rb        (depends on loader)
     ▲
     │
     ├─── r1-dry-check.rb           (paths + frontmatter + report)
     ├─── r1-group-count.rb         (paths + frontmatter + report + rings)
     ├─── r2-entity-classify.rb     (paths + frontmatter + report)
     ├─── r2-id-pattern.rb          (paths + frontmatter + report)
     ├─── r2-source-validate.rb     (paths + frontmatter + report + rings)
     ├─── r2-related-validate.rb    (paths + frontmatter + report + rings)
     ├─── r2-protocol-refs.rb       (paths + frontmatter + report + rings)
     ├─── r2-illustration-targets.rb (paths + frontmatter + report + rings)
     ├─── r2-maxim-audit.rb         (paths + frontmatter + report)
     ├─── r2-protocol-audit.rb      (paths + frontmatter + report)
     ├─── r2-pattern-audit.rb       (paths + frontmatter + report)
     ├─── r3-ref-validate.rb        (paths + frontmatter + report)
     ├─── r4-entity-count.rb        (paths + frontmatter + report)
     └─── r4-frontmatter-dump.rb    (paths + frontmatter)
```

## Module exports

| Module | Exports | Used by |
|--------|---------|---------|
| `loader` | (side effects) | all |
| `paths` | `EntityTypes`, `EntityGlob`, `ROOT`, `RULES`, `COMMANDS` | all |
| `frontmatter` | `ParseFrontmatter`, `ParseBackmatter`, `ParseAll`, `NormalizeTags` | all |
| `report` | `Table`, `List` | all except r4-frontmatter-dump |
| `rings` | `RingGroups`, `TypeToRing`, `GroupRings`, `PrefixToType` | r1-group-count, r2-source-validate, r2-related-validate, r2-protocol-refs, r2-illustration-targets |

## Adding a new script

1. Determine code ring (1–7) from MAX.CODE.LAYERS.
2. `require_relative` the `_rb/` modules you need.
3. Use `EntityTypes` + `EntityGlob` to discover files.
4. Use `ParseAll` to parse frontmatter.
5. Use `TypeToRing` if you need ring-aware validation.
6. Use `Table` to format structured output.
