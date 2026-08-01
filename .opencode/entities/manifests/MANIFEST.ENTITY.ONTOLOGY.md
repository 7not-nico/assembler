**Entity Ontology** — entities have four natures. The runtime morphs entities by interpreting their nature. Objects are passive data that live in entities.

## Natures

- **Encyclopedia** — defines cognitive boundaries and its aspects, marks where knowledge ends.
- **Protocol** — foundational description of what an entity is, declares the ground rules.
- **Pattern** — specifies how the runtime morphs an entity, a model to follow.
- **Nexus** — binds morphisms into compositions, a binding point.

## Rules

- Objects - passive, never act and can be null.
- Objects live in entities.
- The nature of an entity is morphed by a Runtime.
- The runtime interacts with entity files and acts upon them.
- Runtimes are imperative or inferential; `Bun`, `Deepseekv4`.
- Morphisms project in a given form by the Runtime.
- Imperative is programmatic;
- Inferential is derived;
- Any tool is a morphism — an imperative shell around a functional core.
- Morphisms internal objects are separated and categorized by function. This is known as the functional core.
- Object interaction within the functional core use purity protocol annotations. `// purity:` declares I/O classification. `// depends-on:` declares which internal objects the core requires and which require it.
- Entities are discovered through semantic and keyword search against patlib.db.
- Morphisms are given new meaning through composition.
- Composition never inherits morphism properties.
- Illustrations provide rationale and walkthrough instances of a morphism or a composition.
- Entities declare objects.
- Patterns state morphism.
- Protocols state facets about objects.
- Nexus describes composition.
- Composition types split into guided and not guided.
- Guided compositions subdivides into direct and undirect.
- Commands sequence the chain. Skills guide without explicit intent .
- Not guided compositions: LLM queries patlib.db through keyword (FTS5) and semantic (vector) search → finds passive objects outside morphisms (Encyclopedia aspects, protocol descriptions, pattern descriptions) → reads them to discover available morphisms and understand how they compose → selects morphisms and composes their imperative shells.
- Orchestration is the act of reasoning about composition — not an entity type, an activity.
- Composition direction: the outer entity cites the entity it composes with. The inner entity never declares outward composition references. Composition direction flows outer→inner.

## Applicability

All patlib entity classification decisions. A protocol describes an entity. A pattern describes a morphism (imperative shell + functional core, inference). A nexus describes a composition of entities and morphism. Commands are guided direct composition. Skills are guided undirect composition.

---
id: MANIFEST.ENTITY.ONTOLOGY
title: Entity Ontology — Nature, Morphism, Composition
source: assembler
summary: "Entities have four natures: Term (conceptual boundary), Protocol (foundational description), Pattern (model for morphism), Nexus (binding of morphisms). A runtime morphs entities by interpreting their nature. Objects are passive data that live in entities."
tags: [ontology, entity-type, morphism, composition, orchestration, architecture, specification]
status: active
---
