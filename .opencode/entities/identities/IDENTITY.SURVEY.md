**Survey** — a project-local directory holding non-write analysis scripts that inspect current state before migrations, refactors, or other operations. Each survey workflow gets its own `{qualifier}-{subject}/` subfolder with scripts using a shared prefix. Survey scripts are read-only — they analyze and report but never write.

---
id: IDENTITY.SURVEY
title: Survey — Self-Defining Project Analysis Entity
source: IDENTITY.KNOWLEDGE
group: project-local
ring: ~
naming: survey/{qualifier}-{subject}/{prefix}NN-{name}.rb
tags: survey,identity,project,convention,analysis
related: [IDENTITY.KNOWLEDGE]
reference:
  - title: scripts/survey/ — canonical exemplar
    url: https://opencode.ai/docs
  - title: PROT.KNOWLEDGE.DIRECTORY.SCHEMA — analogous directory protocol
    url: https://opencode.ai/docs
---
