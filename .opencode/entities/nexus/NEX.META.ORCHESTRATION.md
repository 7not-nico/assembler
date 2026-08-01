---
id: NEX.META.ORCHESTRATION
title: "TOON Orchestration Workflow — Temporal Batch Entity Creation"
source: assembler
summary: Research writes to a temporal file; a consumer reads and batch-creates entities. The file handoff separates read phases from write phases — ad-hoc entity creation outside this flow is excluded.
composition: Research collects data via read-only tools and writes a temporal file. A write-only consumer reads the file, decodes it, and batch-creates entities in dependency order. Errors isolate per item; processing continues. A dry-run mode validates without writing. All batch entity creation routes through this orchestration flow.
enforcement: Convention
status: active
priority: 3
tags: [orchestration, workflow, entity-creation, separation-of-concerns, batch]
---

Research phase, temporal file handoff,
Creation phase. Read and write are separated by an intermediate artifact.

## Protocol

1. **Research-before-write** — all discovery completes before any write
   operation. The agent queries read-only sources, collects findings,
   and writes them to a temporal file. No write executes during
   research.

2. **Temporal file handoff** — findings are written to a file in a
   well-known directory. The file uses a token-efficient serialization
   format with deterministic decode. The file is the single artifact
   passed between phases.

3. **Consumer processes in dependency order** — a write-only consumer
   reads the temporal file, decodes it, and processes sections in a
   fixed order. Earlier sections produce entities that later sections
   may reference. The order guarantees referential integrity within
   a single batch.

4. **Error isolation** — each item has its own error boundary. A
   failure in one item stops only that item. Errors are
   collected per section and reported in aggregate.

5. **Idempotent operations** — all creation operations use upsert
   semantics. Re-running the same file produces the same final state
   without duplication.

6. **Dry run validates before write** — a validation mode parses the
   temporal file without executing any write operations. The agent
   reviews the preview before committing.

7. **Ad-hoc creation excluded** — all batch entity creation routes
   through this orchestration flow. Direct creation calls bypassing
   the temporal handoff violate this protocol.

## Rationale

- Separating research from creation prevents partial writes mid-research
  and produces a reviewable artifact before any mutation
- Token-efficient serialization reduces token cost for LLM-generated
  batch files while preserving deterministic round-trip
- Dependency ordering prevents integrity failures when entities in
  the same batch reference each other
- Error isolation ensures a single bad entry stops only itself,
  leaving the rest of the batch intact
- Idempotency makes re-runs safe for incremental additions
