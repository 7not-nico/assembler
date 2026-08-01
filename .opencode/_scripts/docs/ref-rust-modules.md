# Rust Library Modules — Reference

## Ring topology per `SPEC.CODE.RING.TOPOLOGY`

### Ring 0 — Pure (no I/O, no side effects)

| Module | Exports | Description |
|--------|---------|-------------|
| `r0_frontmatter.rs` | `Frontmatter`, `parseFrontmatter`, `parseBackmatter`, `parseMetadata` | YAML frontmatter/backmatter parser |
| `r0_rings.rs` | `RingInfo`, `_RingGroups`, `_TypeToRing`, `typeToRing`, `allRings` | Ring topology (5 groups, 14 rings) |
| `r0_patlib.rs` | `_PatlibIdRe`, `_PrefixToType`, `idPrefix`, `idToType`, `idToRingInfo`, `sourceToRingInfo` | PATLIB entity ID prefix routing (26 prefixes) |
| `r0_validate.rs` | `FieldRules`, `checkRequired`, `checkField` | Field type/enum/pattern validation |
| `r0_violation.rs` | `Fault`, `reportFaults`, `runAudit` | Audit fault formatting + closure-based iteration |
| `r0_report.rs` | `formatTable`, `formatList` | Table and list text formatters |
| `r0_bench.rs` | `Stopwatch` (start, elapsed, finish) | Duration measurement |

### Ring 2 — Local read (entity files)

| Module | Exports | Description |
|--------|---------|-------------|
| `r2_paths.rs` | `_Root`, `_Entities`, `entityGlob`, `entityFiles`, `entityTypes` | Entity directory discovery via WalkDir |
| `r2_entity.rs` | `EntityEntry`, `loadEntities`, `loadAllEntities` | Entity file loading + frontmatter parsing |
| `r2_check_id_match.rs` | `checkIdMatch` | Filename vs frontmatter `id:` match |
| `r2_check_ring_match.rs` | `checkRingMatch` | ID prefix vs directory type validation |
| `r2_check_source.rs` | `checkSource` | Source field entity ID resolution |
| `r2_check_precedes.rs` | `checkPrecedes` | Precedes targets + Tortoise-Hare cycle detection |
| `r2_check_stale_refs.rs` | `checkStaleRefs` | Regex scan all `.md` for dead entity references |

## CLI reference

```
_scripts/rs list [type]      # List entity types or entities of a type
_scripts/rs count            # Count entities per type
_scripts/rs check <check>    # Run an entity integrity check
_scripts/rs rings            # Show ring topology
```

### Check subcommands

| Command | Original Ruby script | What it does |
|---------|--------------------|-------------|
| `check id-match` | `r1-entity-id-match.rb` | Frontmatter `id:` must match filename |
| `check ring-match` | `r1-entity-ring-validate.rb` | ID prefix must match directory type |
| `check source` | `r1-source-validate.rb` | `source:` field must resolve to existing entity |
| `check precedes` | `r1-entity-precedes-check.rb` | Precedes targets exist + cycle detection |
| `check stale-refs` | `r2-stale-ref-check.rb` | Regex scan all `.md` for dead entity references |

### Ruby scripts delegating to Rust (6 of 48)

| Script | Delegates to |
|--------|-------------|
| `r1-protocol-audit.rb` | `exec rs audit protocols` |
| `r1-maxim-audit.rb` | `exec rs audit maxims` |
| `r1-illustration-audit.rb` | `exec rs audit illustrations` |
| `r1-nexus-audit.rb` | `exec rs audit nexus` |
| `r1-pattern-audit.rb` | `exec rs audit patterns` |
| `r1-person-audit.rb` | `exec rs audit persons` |

## Naming conventions (Rust)

| Category | Convention | Example |
|----------|-----------|---------|
| Structs | PascalCase + singular abstract noun | `Frontmatter`, `Fault`, `EntityEntry`, `Stopwatch` |
| Functions | camelCase + action verb + singular concrete noun | `checkIdMatch`, `loadEntities`, `parseFrontmatter` |
| Variables | `_camelCase` | `_faults`, `_entry`, `_fileStem` |
| Constants | `_PascalCase` | `_PatlibIdRe`, `_PrefixToType`, `_RingGroups` |
| Gerunds | Prohibited | No `-ing` identifiers |
| Derived nouns | Prohibited | No `-tion`, `-ment`, `-er`, `-or`, `-ance`, `-ence` suffixes |

## Crate structure

```
_scripts/
├── _rs/            # Library crate (assembler-scripts)
│   ├── Cargo.toml
│   └── src/
│       ├── lib.rs
│       ├── r0_*.rs          # 7 pure modules
│       ├── r2_*.rs          # 2 utility + 5 check modules
│       └── bin/
│           └── rust_lint.rs # Custom convention linter
├── _bin/           # CLI crate (assembler-cli)
│   ├── Cargo.toml
│   └── src/
│       └── main.rs          # clap CLI with 4+5 subcommands
└── rs              # Shell wrapper → _bin/target/release/assembler-cli
```

## Build

```bash
cd _scripts/_rs && cargo build --release
cd _scripts/_bin && cargo build --release
```
