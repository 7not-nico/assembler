---
id: PROT.SCHEMA.FORMAT
title: "Seed File Format Convention — Bulk INSERT, Indent, Normalization"
source: NEX.SCHEMA.PIPELINE
related: []
summary: "Seed files use a single INSERT per table/column signature with uniform indent and normalized field values. Auto-corrected on file save by automatic hooks."
protocol: "Seed file per table uses a single INSERT statement per unique table and column signature. Value tuples within a VALUES block use uniform indentation. String fields governed by normalization rules apply canonical form. Normalization runs automatically on file save. Mutation mode is declared by filename prefix, separate from the INSERT verb inside the file."
enforcement: Sealed
status: active
priority: 3
tags: [schema, seed, format, convention, normalization]
---

Every seed SQL file follows a single-statement structure with uniform formatting. Auto-correction applies on file save.

## Protocol

1. **Single INSERT per signature** — seed file per table uses exactly one `INSERT` statement per unique table and column signature. Additional statements targeting the same signature merge into the existing block.
2. **Uniform value indent** — value tuples within a `VALUES` block use the same indent width. Mixed indentation within a block normalizes to the convention standard width.
3. **Canonical field values** — string fields governed by normalization rules apply canonical form. Normalization scope is per-column and declared in the column definition.
4. **Auto-correction on save** — normalization runs automatically on opencode editor saves via `file.edited` plugin hook. For agent Write/Bash tool edits, register a companion `tool.execute.after` handler. For any-source detection, use `fs.watch` at the MCP server level. Batch correction with dry-run preview is available as an invocable tool.
5. **Mutation mode by prefix** — filename prefix declares the mutation strategy. Prefix-verb mismatch: excluded. Align verb to prefix.

6. **Optional organelle declaration block** — seed files may declare an organelle header block per `REF.SCHEMA.SEED.ORGANELLE`. The block identifies the file as a compartment with membrane type, registration identity, and channel dependencies. The block is optional and non-normative — absence means execution, validation, and auto-correction proceed unchanged. When present, the block precedes all SQL statements as the first content after any encoding or metadata comments.

## Gotchas

- Different insert modes for same table in one file: Keep each mode in its own group per mutation strategy protocol (INSERT OR REPLACE and INSERT OR IGNORE targeting same table)
- Multi-line tuples spanning more than one line: Skip normalization for that block (Value block contains content lines after the tuple start)
- Normalizer changes string in non-governed column: Scope normalization by column only (Normalization rule matches a string from an unlisted column)
- Prefix declares append and file uses REPLACE: Align verb to prefix per mutation strategy protocol (00- prefix with INSERT OR REPLACE verb)
- Organelle block channel target missing: Block is documentary — valid. If documenting intent, reference an existing seed file. Cross-check during code review (`target:` value in organelle block references non-existent seed file)
- DDL file declares outgoing channel: DDL is the root — it depends on no other seed file. Remove the channel block or leave empty (`00-ddl.sql` has a `channel:` block with a target)

## Enforcement

File-edited hooks run normalization rules on every seed file save. A dedicated audit tool scans seed directories and flags prefix-verb mismatches automatically. Each normalization operation is also invocable via tool with batch and dry-run flags.

## Applicability

All `.sql` files in `schemas/seeds/` directories within AMANDA subprojects.

## See also

- `REF.SCHEMA.SEED.MUTATION` — seed file mutation strategy
- `REF.SCHEMA.FOLDER` — schema folder structure
- `REF.LIB.MUTATION.STRATEGY` — append vs upsert at table level
- `REF.SCHEMA.SEED.ORGANELLE` — organelle declaration block convention for seed files
- `REF.META.COMPARTMENT.SPECIALIZATION` — compartment model that the organelle block implements
