---
id: PROT.ML.SCHEMA
title: ML Identity — Machine Learning Entity Protocol
source: NEX.META.PROPOSAL
summary: "Defines the ml/ directory and ML.* entity type — schema, body convention, enforcement, and relationship to other entity types."
protocol: "An ML entity defines a machine learning algorithm, architecture, or technique — Encyclopedic Ring 3. Location: ml/ML.*.md with ML.* ID prefix. source points to a CON.* or COG.* inner-ring entity. type, paradigm, subfield, and category place the technique within the ML field of knowledge. related connects to other ML.* entities horizontally."
enforcement: Sealed
tags: [ml, machine-learning, entity-type, algorithm, architecture, technique]
status: active
priority: 2
---

The ML domain holds machine learning entities that describe algorithms, architectures, methods, tasks, metrics, and paradigms within machine learning. ML entities answer *what method*. Cognitions answer *what domain*. Concepts answer *what idea*. Definitions answer *what thing*. Terms answer *what label*.

## Protocol

### Schema

Every ML file requires eleven backmatter fields: `id` (required, `ML.{NAME}` uppercase dot-separated), `title` (required, human-readable name), `source` (required, CON.* or COG.* ID — the concept or cognition this ML entity belongs to), `precedes` (optional, entity ID array — other ML.* IDs this technique builds on), `type` (required, kind: `architecture`, `algorithm`, `method`, `task`, `metric`, `paradigm`), `paradigm` (required, learning paradigm: `supervised`, `unsupervised`, `reinforcement`, `self-supervised`, `semi-supervised`), `subfield` (required, ML subfield: `deep-learning`, `ensemble-methods`, `probabilistic-ml`, `optimization`, `representation-learning`, `reinforcement-learning`), `category` (required, technique category: `sparse-computation`, `gating`, `attention`, `regularization`, `representation-learning`, `ensemble`, `optimization`, `generative`, `discriminative`, `metric-learning`), `tags` (required, comma-separated, no spaces), `related` (optional, entity ID array — other ML.* IDs only), `reference` (required, array of `{title, url}`; minimum 3).

### Body convention

First line: `**{Title}** — {1-3 sentence description}`. Optional subsections follow.

### Content rules

- `type`: required — one of the defined kind values
- `paradigm`: required — the learning paradigm(s) the technique operates under
- `subfield`: required — the ML subfield(s) the entity belongs to
- `category`: required — the technique category for classification
- Tags: comma-separated — spaces excluded
- References: minimum 3 authoritative sources with URL+title
- Related: limited to other ML.* IDs — horizontal layer only
- `source`: valid CON.* or COG.* ID — vector points to containing concept or cognition
- `precedes`: technique lineage from outer to inner — which prior ML techniques this builds on (empty if leaf)
- Body defines the technique — no historical timeline, no code examples, no model-specific references beyond core definition
- Sync: name-to-name into an `ml` table — DB cache, file is source of truth

## Gotchas

- source absent or invalid: source must be a valid CON.* or COG.* ID — the concept or cognition above (source field missing or contains non-CON/COG value)
- source points to entity below this ring: source must point inward (CON.* or COG.*) (source field contains ML.*, TERM.*, or BIO.* ID)
- related links to non-ML entities: related is horizontal — link only to other ML.* IDs (related array contains CON.*, COG.*, or TERM.* IDs)
- type missing or invalid: Add valid type: architecture, algorithm, method, task, metric, paradigm (type field absent or contains non-standard value)
- paradigm missing or invalid: Add valid paradigm (paradigm field absent or contains non-standard value)
- Body contains historical timeline: Body defines the technique — historical provenance belongs in reference ("introduced by", "pioneered by", "first proposed")
- Body contains code or model names: Body defines the concept — implementations belong in illustrations (Specific implementation names, code snippets)
- Less than 3 references: Add authoritative sources — papers, textbooks, surveys (`reference:` array length < 3)
- Tags contain spaces: Replace with hyphenated form: `deep-learning` (`tags: deep, learning` with space)
- ID field mismatches filename: Match filename prefix to id value (File named `ML.FOO.md`; id field value: `ML.BAR`)

## Enforcement

`read-validate` verifies every ML file against this protocol: backmatter fields present and correctly formatted, minimum 3 references, tag format compliance, body starts with bold-title convention, no historical phrases in body.

## Applicability

All ML entities in `.opencode/ml/`. The protocol applies to root-level entities only.

## See also

- `SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY` — groups, layers, vector rules
- `PROT.COGNITION.SCHEMA` — cognition entity protocol
- `PROT.CONCEPT.SCHEMA` — concept entity protocol
- `PROT.TERM.SCHEMA` — term entity protocol
- `SPEC.ENTITY.ROUTING.TABLE` — ID prefix convention for all entity types
- `REF.META.REFERENCE.AUTHORITY` — reference source hierarchy by entity type
