---
id: ILL.SCHEMA.BINDING
title: "SQLite Binding Walkthrough — Finding and Fixing Misplaced Parameters"
source: PROT.SCHEMA.AUGMENT
summary: "Walkthrough of diagnosing a bun:sqlite parameter binding bug — params passed to db.query() instead of .all()/.get()/.run()."
illustration: "A query returns zero results because parameters bind to db.query() instead of .all(). The agent traces the issue to the bun:sqlite API signature, moves parameters to the result method, and verifies correct results."
illustrates: [PROT.TOOL.DEFINITION]
tags: sqlite,database,walkthrough,binding,query,debug
related: [CON.SQLITE.REFERENCES, CON.SQLITE.STORAGE.CLASSES]
---
## Rationale

bun:sqlite differs from better-sqlite3: parameters bind to the result method (`.all()`, `.get()`, `.run()`), not to the query preparation call (`.query()`). Passing bindings to `.query()` is a no-op — extra arguments are silently discarded, producing empty results or runtime errors with no warning.

A query produces empty results despite correct SQL. Running the same SQL in the SQLite shell returns the expected row. The agent traces the issue to a parameter binding method mismatch.

## Walkthrough

### Step 1: Identify the bug

The original code passes parameters to `db.query()`:

```
const game = db.query('SELECT * FROM games WHERE id = ?', gameId).get()
```

`db.query()` accepts only the SQL string. The second argument `gameId` is silently discarded. The `?` placeholder remains unbound.

### Step 2: Verify the API signature

bun:sqlite's `db.query()` signature: `query(sql: string): Statement`. Parameters bind to the result method: `.all(bindings)`, `.get(bindings)`, `.run(bindings)`.

### Step 3: Move parameters to the result method

The fix moves `gameId` to `.get()`:

```
const game = db.query('SELECT * FROM games WHERE id = ?').get(gameId)
```

Now the `?` placeholder binds to `gameId` at execution time. The query returns the expected row.

### Step 4: Handle multiple placeholders

A query with multiple placeholders passes them as separate arguments to the result method:

```
const rows = db.query('SELECT * FROM games WHERE year > ? AND genre = ?').all(2000, 'RPG')
```

Each argument corresponds to one `?` placeholder in order.

### Step 5: Handle array bindings

When bindings come from an array, spread the array:

```
const ids = ['GAME.001', 'GAME.002', 'GAME.003']
const rows = db.query('SELECT * FROM games WHERE id IN (?, ?, ?)').all(...ids)
```

### Step 6: Verify the fix

After moving parameters to `.all()`, `.get()`, or `.run()`, the query returns correct results. The agent confirms by comparing with a direct SQLite shell execution.

## Key insight

The binding location is the most common bun:sqlite bug — the API silently discards extra arguments to `db.query()`. Parameters touch only `.all()`, `.get()`, or `.run()`. `db.query()` handles the SQL string. The fix is always the same: move bindings one method call to the right.

## See also

- `PROT.TOOL.DEFINITION` — the binding convention pattern this illustrates
- `CON.SQLITE.REFERENCES` — SQLite language reference
- `CON.SQLITE.STORAGE.CLASSES` — SQLite storage classes
