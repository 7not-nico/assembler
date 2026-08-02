---
id: PAT.TOOL.GENERATION
Title: "Tool Generation from Schema — Manifests Drive Operational Tools"
Source: assembler
Related: []
Summary: "Operational tools are generated from manifests and schema through a deterministic process."
Protocol: "Every DB-backed project derives its operational tools (lib, write-sync, read-selection, read-projection, read-validate) from its domain, entities, and properties manifests via a deterministic scaffolding process."
Enforcement: Convention
Status: draft
Priority: 4
Tags: [tooling, scaffolding, schema, manifest, generation, bootstrap]
---

Every DB-backed project derives its operational tools from manifests and schema via a deterministic scaffolding process.

## Protocol

1. **Follow fixed step order** — domain → entities → properties → tools. Each step consumes the previous step's manifest.
2. **Write manifest after each step** — each step writes its manifest to `.opencode/manifests/{step}.md` before the next step begins.
3. **Stop at properties for schema-only projects** — step 4 (tools) is optional. Projects without operational tools skip tool generation.
4. **Consume three inputs at step 4** — entities manifest, properties manifest, and `db.sql` schema. All three are required for tool generation.
5. **Generate tools that satisfy all generated compliance constraints** — each generated tool must pass `PROT.TOOL.GENERATION.COMPLIANCE` checks.
6. **Keep the scaffolding process deterministic** — same manifests produce identical tools every run.
7. **Use ID prefix for entity routing** — the first segment of the dot-separated ID maps to the table name per `SPEC.ENTITY.ROUTING.TABLE`.

## Rationale

- Bootstrapping a DB-backed project involves defining what the project captures (domain), what entities it tracks (entities), and how they are structured (properties/schema)
- The final step — generating tools — is mechanical and should follow from earlier definitions
- Hand-crafting tools duplicates knowledge already encoded in manifests and violates DRY
- Deterministic scaffolding means manifests are the single source of truth — tools are derived, authored from manifests

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Tool generation skips a step | Manifests for a previous step absent | Run all prior steps in order — each step depends on the previous step's manifest |
| Generated tool fails compliance audit | Tool generated while `audit-tool` reports violations | Regenerate with PROT.TOOL.GENERATION.COMPLIANCE enforcement. Generated tools must pass the same audit as hand-written tools |
| Hand-crafted tool when generation exists | Tool matches a generated tool pattern while written manually | Regenerate from manifests — hand-crafting duplicates knowledge already encoded in manifests |
| Entity routing mismatch in generated tool | Generated tool uses wrong table name for an entity prefix | Use ID prefix routing from SPEC.ENTITY.ROUTING.TABLE — the first segment maps to the table name |

## Enforcement

`audit-tool` verifies generated tools against the six compliance constraints. The scaffolding tool is responsible for generating compliant output; the audit tool verifies it. Run `audit-tool` after each generation.

## Applicability

Any AMANDA project that uses the bootstrap-db pipeline. Excluded for projects without a database backend or projects where tools are hand-crafted by convention.

## See also

- `PROT.TOOL.GENERATION.COMPLIANCE` — constraints every generated tool must satisfy
- `PROT.TOOL.DEFINITION` — Custom IPC Tool pattern that generated tools must follow
- `PROT.TOOL.AUTOMATON` — `// @toolclass` annotation for generated tools
- `PROT.LIB.DIRECTORY.LAYER` — lib path convention for generated `lib/db.ts`
- `SPEC.ENTITY.ROUTING.TABLE` — ID prefix routing for entity tables
- `bootstrap-db` skill — pipeline steps 1–3
- `scaffold-tools` skill — pipeline step 4 implementation
