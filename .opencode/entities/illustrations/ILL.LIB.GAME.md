---
id: ILL.LIB.GAME
title: "FormatGame — Pure Formatting Separated from I/O"
source: PROT.LIB.CONTRACT
summary: "Walkthrough of a pure format function that receives database rows as parameters and returns formatted strings, keeping I/O in the caller."
illustration: "A pure format function receives database rows as parameters and returns formatted strings — the caller opens the DB, queries, and passes results."
illustrates: [REF.LIB.DEPENDENCY, REF.LIB.DEPENDENCY.DIRECTION]
tags: lib,module,purity,format,walkthrough
related: [REF.LIB.PURITY.BOUNDARY, ILL.LIB.ENSURE.IO]
---
## Rationale

A lib module needs to format a game record for display. The game data comes from a SQLite database. To keep the format function testable and pure, the database query lives in the caller. The format function receives a row object and returns a string.

## Walkthrough

1. The impure caller opens the SQLite database, executes a `SELECT` query, and retrieves a `GameRow` object.

2. The caller calls `formatGame(game)` — a pure function that takes a `GameRow` parameter and returns a formatted `string`.

3. Inside `formatGame`, the function constructs the output string from the row fields. It imports only from other pure modules or builtins. Database access excluded.

```
// Imports: none or other pure modules
// exports: formatGame, formatEmulatorDetail
// purity: pure
// depends-on: none

export function formatGame(game: GameRow): string {
  return `${game.name} (${game.year}) — ${game.platform}`
}
```

4. Testing the function requires no database setup. The test creates a `GameRow` object inline and asserts the return value matches expectations.

```
const row = { name: 'Super Mario', year: 1985, platform: 'NES' }
const result = formatGame(row)
assertEquals(result, 'Super Mario (1985) — NES')
```

## Key insight

The pure function signature `formatGame(game: GameRow): string` is a complete contract. It accepts structured data, returns a string, and has zero side effects. Every value it needs arrives as a parameter — it opens no connections, reads no files, accesses no globals.

## See also

- `REF.LIB.DEPENDENCY` — allowance matrix and concrete examples
- `REF.LIB.DEPENDENCY.DIRECTION` — abstract direction rules
- `ILL.LIB.ENSURE.IO` — impure wrapper walkthrough
- `REF.LIB.PURITY.BOUNDARY` — layer categorization and checklist
