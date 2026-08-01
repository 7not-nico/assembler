**Folder Word Class** — folder names split into two classes: independent instantiators and compound aggregators. An instantiator word names a single performed artifact; each occurrence is one instance of its action. An aggregator word names a container or category; it holds heterogeneous items and no single action produces it.

## Rule

- Independent instantiator — the word names a single performed artifact. Each file in the folder is one instance of the implied action: `report/` holds written reports, `schema/` holds defined schemas, `script/` holds executed scripts. Naming uses the singular form. The noun is concrete — it names the artifact itself.
- Compound aggregator — the word names a container or category. The folder holds heterogeneous items under one collective name: `bitacora/` holds the whole record, `knowledge/` holds domain corpora, `templates/` holds bootstrap sets. The noun is abstract — it names the container, never the artifacts inside.
- Noun class follows word class — an instantiator uses a concrete noun (`report`, `schema`, `script`, `todo`); an aggregator uses an abstract noun (`knowledge`, `bitacora`, `codex`, `depot`, `trove`, `atelier`). A pluralized concrete noun marks a naming violation — `code-dives`, `assets`, `findings`, `projects` fail the aggregator class because they name many artifacts, not a container; their derived containers `codex`, `depot`, `trove`, `atelier` pass it.

## Classification tests

- **Action test** — one verb completes the word. `report` → written; `schema` → defined; `script` → executed. A word with a completing verb is an instantiator; a word without one is an aggregator.
- **Container test** — the word answers what it holds. A word that names its contents rather than its action confirms the aggregator class.
- **Plurality test** — one `{word}` exists as a file. `report`, `schema`, `script` pass; `bitacora`, `knowledge` fail — they name collections, never single files.

The action test decides first; the container test confirms; the plurality test verifies.

## Applicability

All directory naming in the workspace: project scaffolds, template layers, record areas, and entity directories. The distinction governs `report/` (singular instantiator) vs `bitacora/` (aggregator) and every similar folder pair.

---
id: SPEC.NAMING.WORD.CLASS
title: Folder Word Class — Independent Instantiator vs Compound Aggregator
source: assembler
summary: "Folder names split into independent instantiators (report, schema, script — each file is one performed action) and compound aggregators (bitacora, knowledge, templates — containers of heterogeneous items). The action test, container test, and plurality test decide the class."
specifies: Word-class classification for folder naming
tags: [naming, folder, classification, instantiator, aggregator, specification]
status: active
---
