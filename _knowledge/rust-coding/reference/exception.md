# Exception

Documented overrides to conventions.md and rules.md.

## `non_upper_case_globals`

**File**: `fixtures/01-vars.rs`

**Convention**: Constants use PascalCase — `MaxPoints`, `ThreeHours`.

**Rust lint**: Rust reserves `SCREAMING_SNAKE_CASE` for `const` items. Without override, `rustc` emits `warning: constant MaxPoints should have an upper case name`.

**Override**: `#[allow(non_upper_case_globals)]` on the const declaration.

**Rationale**: Project convention (PascalCase constants, no verbs, no underscores) conflicts with Rust lint. Suppress lint, keep convention. Documented in conventions.md §Exceptions → Lint overrides.

## `execute`

**File**: `.opencode/tools/embed-entity.ts`, `.opencode/tools/search-semantic.ts`

**Convention**: Methods use two words, camelCase, action verb — `computeScore`, `makeUnit`.

**API constraint**: `@opencode-ai/plugin` requires tool callback named `execute` (one word, verb).

**Override**: Named `execute` as required by the plugin API.

**Rationale**: External API constraint cannot be renamed. API names are out of our naming scope.

## `pipeline`

**File**: `.opencode/_lib/embed.ts`

**API**: `@xenova/transformers` exports `pipeline` function.

**Convention**: Imported names are exempt from naming convention. Import aliasing adds indirection.

**Override**: Use `pipeline` as exported by the library.

## `camelCase` imported names

**Files**: `.opencode/_lib/embed.ts`, `.opencode/tools/embed-entity.ts`, `.opencode/tools/search-semantic.ts`

**Convention**: Functions use one word, singular concrete noun, lower.

**API**: Node/Bun built-in names (`existsSync`, `join`, `dirname`) and library exports (`pipeline`) use JavaScript `camelCase` and multi-word names.

**Override**: Imported names retain their original casing.

## `_` bare underscore

**File**: `fixtures/01-vars.rs`, `fixtures/01-control.rs`

**Convention**: No underscore prefix (`_name`). Variable names must be one word.

**Pattern**: `let _ = expr` uses bare underscore pattern — not a variable name, not a prefix.

**Override**: `let _` is the allowed form for suppressing unused-value warnings. The `_` is a pattern, not a binding. No name is created.
