---
id: ILL.ILLUSTRATION.FILE
title: "Create Illustration File — Walkthrough Entity Protocol in Practice"
source: PROT.ILLUSTRATION.SCHEMA
summary: "Walkthrough of creating a new illustration file following PROT.ILLUSTRATION.SCHEMA — frontmatter, four-section body, illustrates linking, and sync."
illustration: "A new illustration file gets its frontmatter from the protocol schema table, body sections from the body convention, and illustrates from an entity ID check."
illustrates: [PROT.ILLUSTRATION.SCHEMA]
tags: illustration,walkthrough,protocol,creation,identity
related: [REF.SCHEMA.JUNCTION.DISCRIMINATOR, SPEC.ENTITY.DISTINCTION.BOUNDARY]
---
## Rationale

`PROT.ILLUSTRATION.SCHEMA` defines the schema, body convention, and content rules for all illustration entities. This walkthrough creates a concrete illustration file by applying each protocol rule in sequence — from frontmatter through body sections to sync.

Files referenced:
- `.opencode/illustrations/ILL.NEW.EXAMPLE.md` — the file being created (this walkthrough uses a hypothetical new illustration as the example)
- `PROT.ILLUSTRATION.SCHEMA.md` — the protocol file
- `.opencode/_lib/sync.ts` — the sync engine that populates `illustration_entities` junction table

## Walkthrough

### Step 1: Write frontmatter from the schema table

The protocol defines 8 schema fields. Start with `id` and `title`:

```
---
id: ILL.NEW.EXAMPLE
title: "New Example — Descriptive Walkthrough Title"
```

Add `summary` — one sentence describing the walkthrough:
```
summary: "Walkthrough of applying a pattern to solve a concrete problem."
```

Add `illustration` — a single declarative statement describing the walkthrough:
```
illustration: "A new tool handler follows the read handler stack: transport calls handler, handler queries DB, formatter converts to text."
```

Add `illustrates` — at least one entity ID that must resolve via patlib:
```
illustrates: [NEX.LIB.STACK]
```

Add `tags` — comma-separated without spaces:
```
tags: lib,handler,walkthrough
```

Add `source` — always `assembler` for first-party illustrations.

### Step 2: Write the four required body sections

The protocol requires Context, Walkthrough, Key insight, and See also.

**Context** establishes prerequisites — what the reader needs to know:
```markdown
## Rationale

Before following this walkthrough, the reader should understand:
- The purity boundary concept (REF.LIB.PURITY.BOUNDARY)
- The handler pattern (NEX.LIB.STACK)
```

**Walkthrough** traces a concrete instance step by step, naming specific files and entities:
```markdown
## Walkthrough

### Step 1: Handler queries the DB

The searchEntities function in lib/mcp-query.ts builds a SQL query...
```

**Key insight** states one lesson:
```markdown
## Key insight

The handler pattern separates three concerns: transport wires, handler queries, formatter formats.
```

**See also** lists related entities with the illustrated entity first:
```markdown
## See also

- `NEX.LIB.STACK` — the pattern this illustrates
- `REF.LIB.PURITY.BOUNDARY` — purity boundary
```

### Step 3: Verify illustrates references

Every entity ID in `illustrates:` must exist in patlib. Run:
```
read-selection --type patterns --query NEX.LIB.STACK
```

If the entity exists, the reference is valid. Run `write-sync --type illustrations` to register the new file and populate the `illustration_entities` junction table.

### Step 4: Validate the file

The `audit-*` tools verify every illustration against the protocol:
- Frontmatter fields present and correctly formatted
- `illustrates:` resolves to valid entity IDs
- Body includes all four required sections
- ID-filename match

### Step 5: Query the relationship

Once synced, the junction table has one row:
```
INSERT INTO illustration_entities (illustration_id, entity_id, entity_type)
VALUES ('ILL.NEW.EXAMPLE', 'NEX.LIB.STACK', 'patterns');
```

Query via the `patlib_illustrations` MCP tool:
```
patlib_illustrations entity_id="NEX.LIB.STACK"
-- Returns: ILL.NEW.EXAMPLE → NEX.LIB.STACK
```

## Key insight

The protocol governs every aspect of an illustration — frontmatter schema, body structure, entity linking, validation. Applying each rule sequentially produces a valid illustration file that integrates with the sync engine and the junction table. The `illustration_entities` junction makes the `illustrates:` link queryable in both directions.

## See also

- `PROT.ILLUSTRATION.SCHEMA` — the protocol this illustrates
- `REF.SCHEMA.JUNCTION.DISCRIMINATOR` — polymorphic junction pattern powering `illustration_entities`
- `SPEC.ENTITY.DISTINCTION.BOUNDARY` — entity type boundary definitions
- `ILL.LIB.HANDLER.STACK` — concrete illustration created following this protocol
