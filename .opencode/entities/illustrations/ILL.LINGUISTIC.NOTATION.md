---
id: ILL.LINGUISTIC.NOTATION
title: "Lambda Linguistics Walkthrough — Converting Prose to subject.verb"
source: PROT.LINGUISTIC.NOTATION
summary: "Walkthrough of converting procedural prose into lambda notation — subject.verb chains, domain-zero anaphora, and gapping."
illustration: "A procedural instruction in prose gets converted step by step into lambda notation, demonstrating dot-separated action chains, anaphora, and gapping."
illustrates: [PROT.LINGUISTIC.NOTATION]
tags: convention,notation,walkthrough,lambda,linguistics
related: [COG.LINGUISTIC.LAMBDA.NOTATION]
---
## Rationale

Prose descriptions of actions waste tokens and obscure intent. Lambda notation compresses actions to `subject.verb` pairs — `db.query → file.write` replaces "The database query runs and then writes to a file" — reducing token count while preserving meaning. It applies across all AMANDA agent instructions, rules, and commands where action brevity is desired.

A procedural instruction for setting up a database migration arrives in full prose. The agent converts it to lambda notation, demonstrating single-action references, chains, anaphora, and gapping.

## Walkthrough

### Step 1: Identify the actions

Original prose:

> The agent reads the schema file, then writes the migration to the database, validates the schema, and logs the result.

Each action maps to a `subject.verb` pair. The subject is `agent` throughout — domain-zero anaphora applies from the second action onward.

### Step 2: Convert to lambda notation

> `agent.schema.read → .migration.write → .schema.validate → .log`

The first action establishes the subject. Subsequent actions drop the repeated domain per domain-zero anaphora.

### Step 3: Apply gapping

When the same verb repeats across parallel clauses, omit the second occurrence:

Prose:

> The database creates the table, the config creates the indexes.

Lambda with gapping:

> `db.table.create → config.indexes`

The repeated verb `create` drops in the second clause.

### Step 4: Combine chains

A longer instruction with branching:

> First, the database connects and reads the schema. Then, if valid, the migration writes the changes and logs the result. If invalid, the agent halts with an error.

Lambda chain:

> `db.connect → db.schema.read → { valid: migration.write → migration.log | invalid: agent.halt }`

Branches use `{ condition: path | else: path }` notation.

### Step 5: Verify single convention

The final instruction stays entirely in lambda notation — no mixing prose and lambda within the same action reference.

## Key insight

Lambda notation compresses multi-step instructions into a single line the agent scans in one pass. The subject stays consistent via domain-zero anaphora; repeated verbs drop via gapping. The result is a complete workflow expressed in fewer tokens than its prose equivalent.

## See also

- `PROT.LINGUISTIC.NOTATION` — the lambda notation pattern this illustrates
- `COG.LINGUISTIC.LAMBDA.NOTATION` — definition of lambda-linguistics
- `rules/domain-zero-anaphora.md` — dropping repeated domains in chains
- `rules/gapping.md` — omitting repeated verbs in parallel clauses
