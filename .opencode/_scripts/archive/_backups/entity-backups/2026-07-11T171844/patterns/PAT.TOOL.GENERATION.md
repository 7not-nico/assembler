---
id: PAT.TOOL.GENERATION
title: Tool Generation from Schema — Manifests-Drive Operational Tools
source: assembler
summary: Operational tools are generated from manifests and schema, not hand-crafted
principle: Every DB-backed project derives its operational tools (lib, write-sync, read-selection, read-projection, read-validate) from its domain, entities, and properties manifests via a deterministic scaffolding process
enforcement: Convention
tags: [tooling, scaffolding, schema, manifest, generation, bootstrap]
patterns: [PAT.GENERATED.COMPLIANCE, PAT.PLUGIN.IPC.TOOL, PAT.SHARED.LIB, PAT.TOOLCLASS]
terms: []
status: draft
priority: 4
---

Every DB-backed project derives its operational tools (lib, write-sync, read-selection, read-projection, read-validate) from its domain, entities, and properties manifests via a deterministic scaffolding process.

## Context

Bootstrapping a DB-backed project involves defining what the project captures (domain), what entities it tracks (entities), and how those entities are structured (properties/schema). The final step — generating the tools that populate, query, and validate the database — is mechanical and should follow from the earlier definitions. Hand-crafting these tools duplicates knowledge already encoded in manifests and violates DRY.

The `bootstrap-db` skill covers steps 1–3 (domain → entities → properties). The `scaffold-tools` skill covers step 4 (tools). The pipeline is sequential and additive: each step consumes the previous step's manifest.

## Rules

- Step order is fixed: domain → entities → properties → tools. Never skip or reorder.
- Each step writes its manifest to `.opencode/manifests/{step}.md` before the next step begins.
- Step 4 (tools) is optional — schema-only projects may stop at properties.
- When step 4 runs, it consumes three inputs: entities manifest, properties manifest, and db.sql schema.
- Generated tools must satisfy all constraints in PAT.GENERATED.COMPLIANCE.
- The scaffolding process is deterministic — same manifests produce identical tools every run.
- Entity routing uses the ID prefix convention — the first segment of the dot-separated ID maps to the table name.

## Applicability

Any AMANDA project that uses the bootstrap-db pipeline. Not intended for projects without a database backend or projects where tools are hand-crafted by convention.

## See also

- PAT.GENERATED.COMPLIANCE — constraints every generated tool must satisfy
- PAT.PLUGIN.IPC.TOOL — plugin IPC pattern that generated tools must follow
- PAT.SHARED.LIB — lib path convention for generated lib/db.ts
- PAT.TOOLCLASS — // @toolclass annotation for generated tools
- `bootstrap-db` skill — pipeline steps 1–3
- `scaffold-tools` skill — pipeline step 4 implementation
