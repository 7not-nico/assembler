---
id: REF.META.REGISTRY
title: "Rename Registry — Historical ID Corrections"
source: PROT.META.IDENTITY
related: [PROT.META.NAMING.SCHEMA, PROT.META.NAMING.SCHEMA]
summary: "Historical record of all entity renames — protocol IDs corrected for convention violations, pattern domain additions, prefix migrations from PAT to MAX, and exemption precedents."
ref: "Every renamed entity documents its original ID, the violation detected, and the corrected ID. The registry serves as the authoritative mapping from old to current IDs across the patlib ecosystem."
tags: [meta, naming, rename, registry, migration]
---

Historical record of all entity renames across patlib. Protocol corrections, pattern domain additions, prefix migrations, and exempt terms.

## Protocol renames

| Current | Violation | Renamed |
|---------|-----------|---------|
| `PROT.LIB.CONTRACT.AUTOENFORCE` | Verb compound (`AUTOENFORCE`) | `PROT.PLUGIN.LIFECYCLE` |
| `PROT.META.GUIDED.COMPOSITION` | Adjective modifier (`GUIDED` modifies `COMPOSITION`) | `PROT.META.COMPOSITION` |
| `PROT.TOOL.CUSTOM.IPC` | Abbreviation (`IPC` as abbreviation) | `PROT.TOOL.DEFINITION` |
| `PROT.LIB.GOTCHAS` | Slang (`GOTCHAS`) + missing SUBJECT | `PROT.LIB.CONTRACT.VIOLATIONS` |
| `PROT.LIB.DEPENDENCY.PLANE` | Jargon mismatch (`PLANE` for node_modules symlinks) | `PROT.TOOL.NODE_MODULES.SHARED` |
| `PROT.LIB.SHARED.STRUCTURE` | Verb modifier (`SHARED`) | `PROT.LIB.DIRECTORY.LAYER` |
| `PROT.LIB.NAMING` | Generic aspect | `PROT.LIB.DOMAIN.PREFIX` |
| `PROT.META.ENTITY.PATTERN.VS.PROTOCOL` | Abbreviation (`VS`) | `PROT.META.ENTITY.DISTINCTION` |
| `SPEC.ENTITY.DISTINCTION.BOUNDARY` | Entity type migration (PROT → SPEC) | `PROT.META.ENTITY.DISTINCTION` |
| `PROT.SCHEMA.TEMPORAL.PRECISION` | Adjective modifier (`TEMPORAL`) | `PROT.SCHEMA.DATE.PRECISION` |
| `PROT.SCHEMA.DB.OWNERSHIP` | Abbreviation (`DB`) | `PROT.SCHEMA.DATABASE.OWNERSHIP` |
| `PROT.PLUGIN.WRITEONLY` | Verb compound (`WRITEONLY`) | `PAT.PLUGIN.DIRECTION` |
| `PROT.TOOL.GENERATED.COMPLIANCE` | Verb form (`GENERATED`) | `PROT.TOOL.GENERATION.COMPLIANCE` |
| `PROT.TOOL.MCP.AUTODISCOVER` | Verb form (`AUTODISCOVER`) | `PROT.TOOL.DISCOVERY` |
| `PROT.MCP.CONCURRENT.DISPATCH` | Adjective modifier (`CONCURRENT`) | `PAT.MCP.DISPATCH.SEMAPHORE` |
| `PROT.TOOL.SCHEMA.DEFAULTS` | Plural (`DEFAULTS`) | `PROT.TOOL.DEFINITION` |
| `PROT.META.META.TOON.ORCHESTRATION` | Repeated DOMAIN (`META.META`) | `NEX.META.TOON.ORCHESTRATION` |

## Pattern renames

| Current | Violation | Renamed |
|---------|-----------|---------|
| `PAT.DEPSYNC` | Abbreviation (`SYNC` for SYNCHRONIZATION) | `PAT.DEPENDENCY.SYNC.RESOLVE` |
| `PAT.ASSEMBLER.ARCHITECTURE` | Wrong domain (`ASSEMBLER` absent from canonical set) | `PROT.META.PROJECT.TOPOLOGY` |
| `PAT.DOMAIN.CONTAINER` | Missing DOMAIN | `PROT.META.DOMAIN.DIRECTORY` |
| `PAT.ENTITY.LIFECYCLE` | Missing DOMAIN | `PAT.META.ENTITY.LIFECYCLE` |
| `PAT.ENTITY.SCOPE.ROOT` | Missing DOMAIN | `PROT.META.ENTITY.ROOT` |
| `PAT.DECISION.FRAMEWORK` | Missing DOMAIN | `NEX.META.DECISION.CANVAS` |
| `PAT.PROPOSE.WORKFLOW` | Missing DOMAIN | `NEX.META.ENTITY.PROPOSAL` |
| `PAT.BIVALENT.ENTITY` | Adjective modifier (`BIVALENT`) | `PROT.META.ENTITY.DUALITY` |
| `PAT.INHERENT.VS.ASCRIBED` | Abbreviation (`VS`) | `PROT.PROVENANCE.CLASSIFICATION` |
| `PAT.ACTIVATION.MODEL` | Missing DOMAIN | `PAT.META.LAYER.TRIGGER` |
| `PAT.SQLITE.PARAM.BINDING` | Wrong domain (`SQLITE` excluded from canonical set) | `PROT.TOOL.DEFINITION` |
| `PAT.FRONTMATTER.COLON.QUOTING` | Wrong domain (`FRONTMATTER` excluded from canonical set) | `PROT.SCHEMA.COLON.QUOTING` |
| `PAT.SEED.DRIVEN.INIT` | Verb compound (`DRIVEN`) | `PAT.SCHEMA.SEED.RELOAD` |
| `PAT.SCHEMA.PLUGIN.UTILS` | Abbreviation (`UTILS` for UTILITIES) | `PROT.SCHEMA.PLUGIN.BOILERPLATE` |
| `PAT.RESEARCH.PIPELINE` | Missing DOMAIN | `NEX.INVESTIGATION.PIPELINE.STAGE` |
| `PAT.AUDIT.PROCEDURE` | Missing DOMAIN | `NEX.TOOL.AUDIT.SEQUENCE` |
| `PAT.STRATUM` | Missing DOMAIN | `PROT.META.DATA.STRATUM` |
| `PAT.THOUGHT` | Single concept, missing DOMAIN | `NEX.META.SKILL.INDEX` |
| `PAT.OPENCODE.THOUGHT` | Wrong domain + adjective modifier | `NEX.META.SKILL.INDEX` |
| `NEX.META.SKILL.INDEX` | Entity type reclassification (nexus → protocol) | `PROT.META.SKILL.INDEX` |
| `PAT.TOON.ORCHESTRATION` | Missing DOMAIN | `NEX.META.TOON.ORCHESTRATION` |
| `PAT.META.META.TOON.ORCHESTRATION` | Repeated DOMAIN (`META.META`) | `NEX.META.TOON.ORCHESTRATION` |
| `PAT.POLYMORPHIC.JUNCTION` | Adjective modifier (`POLYMORPHIC`) | `PROT.SCHEMA.JUNCTION.DISCRIMINATOR` |
| `PAT.UMBRELLA.TERMS` | Missing DOMAIN | `PROT.TERM.SCHEMA` |
| `PAT.LOOKUP.TABLE` | Generic aspect (`TABLE`) | `PROT.SCHEMA.SEED.REFERENCE` |
| `PAT.LAMBDA.LINGUISTICS` | Wrong domain (`LAMBDA` absent from canonical set) | `PROT.LINGUISTIC.NOTATION` |
| `PAT.ADDITIVE.MIGRATION` | Adjective modifier (`ADDITIVE`) | `PROT.SCHEMA.AUGMENT` |
| `PAT.GUIDED.COMPOSITION` | Adjective modifier (`GUIDED`) | `PROT.META.COMPOSITION` — pattern consolidated into protocol; separate pattern file excluded |

## Prefix renames (PAT → MAX)

| Current | Violation | Renamed |
|---------|-----------|---------|
| `PAT.PROGRAMMING.DELIBERATELY` | Advice/mantra, structural pattern label excluded | `MAX.PROGRAMMING.DELIBERATELY.PRACTICE` |
| `PAT.REFACTOR.EARLY.OFTEN` | Advice/mantra, structural pattern label excluded | `MAX.REFACTOR.EARLY.OFTEN` |
| `PAT.CATALYST.FOR.CHANGE` | Advice/mantra, structural pattern label excluded | `MAX.CATALYST.FOR.CHANGE` |
| `PAT.PROTOTYPE.TO.LEARN` | Advice/mantra, structural pattern label excluded | `MAX.PROTOTYPE.TO.LEARN` |
| `PAT.BROKEN.WINDOW` | Maxim, structural pattern label excluded | `MAX.BROKEN.WINDOW.CASCADE` |

## Exempt

Established terms of art that predate the naming convention and carry unambiguous meaning:

| ID | Reason |
|----|--------|
| `PAT.DRY` | Universal principle — single authoritative representation per project |
| `PAT.ORTHOGONALITY` | Domain concept — component independence |
| `PAT.TRACER.BULLETS.PRACTICE` | Established software technique |

These remain under `PAT.` prefix by precedent. New additions following the same pattern require documented justification.

## Application

When a naming check fails per PROT.META.NAMING.SCHEMA application sequence step 5, consult this registry for the canonical renamed ID. Add new renames here with the detected violation and corrected ID.

## See also

- `ILL.META.RENAME.REGISTRY` — rename lookup walkthrough — stale ID resolution
- `PROT.META.NAMING.SCHEMA` — naming rules and valid examples
- `PROT.META.NAMING.SCHEMA` — naming protocol with prefix, domain, subject, aspect rules
- `PROT.META.DOMAIN` — canonical domain set
